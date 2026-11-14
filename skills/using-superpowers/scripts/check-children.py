#!/usr/bin/env python3
"""Prove the model and effort child agents actually ran at, from Claude Code transcripts.

Every api-request record carries what went on the wire: params.model and
params.output_config.effort. This reads them for a session and its native
subagents (<session>/subagents/*.jsonl) and compares each with the expected pair.

  check-children.py                          this session ($CLAUDE_CODE_SESSION_ID) and its native children
  check-children.py --marker <text>          ... only children whose transcript contains <text>
  check-children.py --delegate <text>        a T3 delegate: the session whose first user message holds <text>
                                             (never this session), checked against THIS session's pair
  check-children.py --session <id>           any session by id
  --expect-model <id> --expect-effort <lvl>  override the expected pair (the user named another)
  check-children.py --codex <text> --expect-model <id>
                                             a Codex delegate: the newest Codex session log whose first user
                                             message holds <text>, checked against the named model and this
                                             session's effort (or --expect-effort)
  --root <dir>                               transcripts root (default $CLAUDE_CONFIG_DIR/projects or ~/.claude/projects)
  --codex-home <dir>                         Codex home (default $CODEX_HOME or ~/.codex)

Claude Code transcripts and Codex session logs only; other hosts keep no such record here.

Exit codes: 0 every checked agent matches; 1 one differs; 2 nothing was checked or the
transcript was not found.
"""
import argparse
import collections
import glob
import json
import os
import sys
import time

ROOT = os.path.join(os.environ.get("CLAUDE_CONFIG_DIR") or os.path.expanduser("~/.claude"), "projects")


def find_session(sid):
    hits = glob.glob(os.path.join(ROOT, "*", sid + ".jsonl"))
    return hits[0] if hits else None


def wire(path):
    seen = collections.Counter()
    try:
        with open(path, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                if '"api-request"' not in line:
                    continue
                try:
                    rec = json.loads(line)
                except ValueError:
                    continue
                if rec.get("type") != "api-request":
                    continue
                params = rec.get("params") or {}
                seen[(params.get("model"), (params.get("output_config") or {}).get("effort"))] += 1
    except OSError:
        pass
    return seen


def main_pair(path):
    w = wire(path)
    return w.most_common(1)[0][0] if w else (None, None)


def meta(path):
    try:
        with open(path[: -len(".jsonl")] + ".meta.json", encoding="utf-8") as fh:
            m = json.load(fh)
        return m.get("agentType", "?"), m.get("description", "")
    except (OSError, ValueError):
        return "?", ""


def contains(path, marker):
    try:
        with open(path, encoding="utf-8", errors="replace") as fh:
            return any(marker in line for line in fh)
    except OSError:
        return False


def first_user_texts(path, limit=3):
    out = []
    try:
        with open(path, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                if '"user"' not in line:
                    continue
                try:
                    rec = json.loads(line)
                except ValueError:
                    continue
                msg = rec.get("message")
                if rec.get("type") != "user" or not isinstance(msg, dict) or msg.get("role") != "user":
                    continue
                content = msg.get("content")
                if isinstance(content, list):
                    content = " ".join(c.get("text", "") for c in content if isinstance(c, dict))
                out.append(content or "")
                if len(out) >= limit:
                    break
    except OSError:
        pass
    return out


def created(path):
    """Timestamp of the transcript's first timestamped record (its session's start)."""
    try:
        with open(path, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                try:
                    ts = json.loads(line).get("timestamp")
                except ValueError:
                    continue
                if ts:
                    return ts
    except OSError:
        pass
    return ""


def codex_first_user_texts(path, limit=5):
    """The first user messages of a Codex session: user response items (how a T3-started session
    carries its brief) and user_message events; the injected AGENTS.md preamble counts as one."""
    out = []
    try:
        with open(path, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                if '"user' not in line:
                    continue
                try:
                    rec = json.loads(line)
                except ValueError:
                    continue
                payload = rec.get("payload") or {}
                if rec.get("type") == "event_msg" and payload.get("type") == "user_message":
                    out.append(str(payload.get("message") or ""))
                elif (rec.get("type") == "response_item" and payload.get("type") == "message"
                      and payload.get("role") == "user"):
                    out.append(" ".join(c.get("text", "") for c in payload.get("content") or []
                                        if isinstance(c, dict)))
                else:
                    continue
                if len(out) >= limit:
                    break
    except OSError:
        pass
    return out


def codex_wire(path):
    """(model, effort) of every turn, from the turn_context records Codex writes."""
    seen = collections.Counter()
    try:
        with open(path, encoding="utf-8", errors="replace") as fh:
            for line in fh:
                if '"turn_context"' not in line:
                    continue
                try:
                    rec = json.loads(line)
                except ValueError:
                    continue
                if rec.get("type") == "turn_context":
                    payload = rec.get("payload") or {}
                    seen[(payload.get("model"), payload.get("effort"))] += 1
    except OSError:
        pass
    return seen


def find_codex(marker, codex_home, since_hours):
    cutoff = time.time() - since_hours * 3600
    files = [f for f in glob.glob(os.path.join(codex_home, "sessions", "**", "rollout-*.jsonl"), recursive=True)
             if os.path.getmtime(f) >= cutoff]
    hits = [f for f in files if any(marker in t for t in codex_first_user_texts(f))]
    if not hits:
        return None
    hits.sort(key=created, reverse=True)
    if len(hits) > 1:
        print(f"note: {len(hits)} Codex sessions start with the marker; took the newest", file=sys.stderr)
    return hits[0]


def check_codex(a, me):
    codex_home = a.codex_home or os.environ.get("CODEX_HOME") or os.path.expanduser("~/.codex")
    if not a.expect_model:
        print("--codex needs --expect-model: another provider's model is always one the user named", file=sys.stderr)
        return 2
    mine = find_session(me) if me else None
    effort = a.expect_effort or (main_pair(mine)[1] if mine else None)
    if not effort:
        print("expected effort unknown: pass --expect-effort", file=sys.stderr)
        return 2
    target = find_codex(a.codex, codex_home, a.since_hours)
    if not target:
        print(f"no Codex session in the last {a.since_hours:g} h starts with a message holding {a.codex!r}", file=sys.stderr)
        return 2
    turns = codex_wire(target)
    print(f"codex {os.path.basename(target)[:-6]}  expected model={a.expect_model} effort={effort}")
    bad = 0
    for (model, eff), n in turns.items():
        ok = (model, eff) == (a.expect_model, effort)
        bad += 0 if ok else 1
        print(f"  delegate {'same' if ok else 'DIFFERS':7} model={model} effort={eff}  ({n} turns)")
    if not turns:
        print("result: NOTHING CHECKED (the log has no turn yet)")
        return 2
    print(f"result: {len(turns)} checked, " + ("all match" if bad == 0 else f"{bad} differ"))
    return 0 if bad == 0 else 1


def find_delegate(marker, exclude, since_hours):
    # A brief that starts a delegate quotes the delegate's marker, so the briefing session can
    # match too; the delegate is always created after it, so the newest-created match wins.
    cutoff = time.time() - since_hours * 3600
    files = [f for f in glob.glob(os.path.join(ROOT, "*", "*.jsonl")) if os.path.getmtime(f) >= cutoff]
    hits = [f for f in files
            if os.path.basename(f)[:-6] != exclude and any(marker in t for t in first_user_texts(f))]
    if not hits:
        return None
    hits.sort(key=created, reverse=True)
    if len(hits) > 1:
        others = ", ".join(os.path.basename(h)[:8] for h in hits[1:])
        print(f"note: {len(hits)} sessions start with the marker; took the newest, also: {others}", file=sys.stderr)
    return hits[0]


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--session")
    ap.add_argument("--marker")
    ap.add_argument("--delegate")
    ap.add_argument("--expect-model")
    ap.add_argument("--expect-effort")
    ap.add_argument("--since-hours", type=float, default=48)
    ap.add_argument("--root")
    ap.add_argument("--codex")
    ap.add_argument("--codex-home")
    a = ap.parse_args()
    global ROOT
    ROOT = a.root or ROOT

    me = os.environ.get("CLAUDE_CODE_SESSION_ID")
    if a.codex:
        return check_codex(a, me)
    if a.delegate:
        target = find_delegate(a.delegate, me, a.since_hours)
        if not target:
            print(f"no session in the last {a.since_hours:g} h starts with a message holding {a.delegate!r}", file=sys.stderr)
            return 2
    else:
        sid = a.session or me
        if not sid:
            print("no session id: pass --session (CLAUDE_CODE_SESSION_ID is unset)", file=sys.stderr)
            return 2
        target = find_session(sid)
        if not target:
            print(f"no transcript for session {sid} under {ROOT}", file=sys.stderr)
            return 2

    own = main_pair(target)
    if a.delegate:
        mine = find_session(me) if me else None
        expected = main_pair(mine) if mine else (None, None)
    else:
        expected = own
    expected = (a.expect_model or expected[0], a.expect_effort or expected[1])
    if None in expected:
        print("expected model/effort unknown: pass --expect-model and --expect-effort", file=sys.stderr)
        return 2

    checked = bad = 0
    print(f"session {os.path.basename(target)[:-6]}  expected model={expected[0]} effort={expected[1]}")
    if a.delegate:
        checked += 1
        ok = own == expected
        bad += 0 if ok else 1
        print(f"  delegate {'same' if ok else 'DIFFERS':7} model={own[0]} effort={own[1]}")
    else:
        print(f"  parent   model={own[0]} effort={own[1]}")

    sub = target[: -len(".jsonl")] + "/subagents"
    if os.path.isdir(sub):
        for f in sorted(os.listdir(sub), key=lambda s: os.path.getmtime(os.path.join(sub, s))):
            path = os.path.join(sub, f)
            if not f.endswith(".jsonl") or (a.marker and not contains(path, a.marker)):
                continue
            kind, desc = meta(path)
            for (model, effort), n in wire(path).items():
                checked += 1
                ok = (model, effort) == expected
                bad += 0 if ok else 1
                print(f"  child    {'same' if ok else 'DIFFERS':7} model={model} effort={effort}  type={kind} ({n} req) {desc[:60]}")

    if checked == 0:
        print("result: NOTHING CHECKED (no child matched; wrong session or marker?)")
        return 2
    print(f"result: {checked} checked, " + ("all match" if bad == 0 else f"{bad} differ"))
    return 0 if bad == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
