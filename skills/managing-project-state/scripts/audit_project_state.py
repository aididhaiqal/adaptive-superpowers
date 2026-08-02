#!/usr/bin/env python3
"""Audit repository instructions and optional managed project-state transitions."""

from __future__ import annotations

import argparse
from collections import defaultdict
import json
import os
from pathlib import Path
import re
import subprocess
import sys
from typing import Dict, Iterable, List, Mapping, Optional, Sequence, Tuple


DEFAULT_PROTECTED = {"queued", "active", "blocked", "future-watch"}
BASE_STATES = DEFAULT_PROTECTED | {"completed"}
EVIDENCE_COLUMNS = {
    "implemented",
    "tested",
    "committed",
    "pushed",
    "merged",
    "deployed",
    "runtime_verified",
}
REQUIRED_COLUMNS = {"id", "state", "priority", "disposition", "authority"} | EVIDENCE_COLUMNS
INSTRUCTION_NAMES = {
    "AGENTS.md",
    "AGENTS.override.md",
    "CLAUDE.md",
    "CLAUDE.local.md",
    "GEMINI.md",
    "copilot-instructions.md",
}
IGNORED_DIRS = {".git", ".hg", ".svn", ".venv", ".worktrees", "build", "dist", "node_modules", "target", "vendor"}
SECRET_PATTERNS = [
    re.compile(r"gh[pousr]_[A-Za-z0-9]{20,}"),
    re.compile(r"AKIA[0-9A-Z]{16}"),
    re.compile(r"-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----"),
    re.compile(r"(?i)\b(?:api[_-]?key|password|secret|token)\s*[:=]\s*[^\s`]{8,}"),
]
UNSAFE_PATTERNS = [
    re.compile(r"\brm\s+-[^\n]*r[^\n]*f\b|\brm\s+-[^\n]*f[^\n]*r\b"),
    re.compile(r"\bgit\s+reset\s+--hard\b"),
    re.compile(r"\bcurl\b[^\n|]*\|\s*(?:ba)?sh\b"),
    re.compile(r"\bchmod\s+777\b"),
    re.compile(r"(?i)\bdisable\s+(?:all\s+)?(?:safety|safeguards|approvals|sandbox)\b"),
]
PLACEHOLDER = re.compile(r"(?i)(?:^\s*(?:[-*]\s*)?(?:TODO|FIXME)\s*:|\[\s*(?:TODO|FIXME|placeholder)[^]]*\])")
PRIORITY_RANK = {"critical": 4, "high": 3, "medium": 2, "low": 1}


def finding(rule: str, severity: str, path: str, message: str, line: int = 1) -> Dict[str, object]:
    return {"rule": rule, "severity": severity, "path": path, "line": line, "message": message}


def relative(path: Path, root: Path) -> str:
    return path.relative_to(root).as_posix()


def resolve_inside(root: Path, value: str) -> Path:
    candidate = (root / value).resolve()
    try:
        candidate.relative_to(root)
    except ValueError as error:
        raise ValueError(f"path escapes repository root: {value}") from error
    return candidate


def discover_instruction_files(root: Path) -> List[Path]:
    found: List[Path] = []
    for directory, subdirectories, filenames in os.walk(root):
        subdirectories[:] = sorted(name for name in subdirectories if name not in IGNORED_DIRS)
        base = Path(directory)
        for name in sorted(filenames):
            path = base / name
            if name in INSTRUCTION_NAMES or ".claude/rules" in path.as_posix() and name.endswith(".md"):
                found.append(path)
    return sorted(found, key=lambda item: relative(item, root))


def normalized_rule(line: str) -> str:
    value = re.sub(r"^\s*(?:[-*+]\s+|\d+[.)]\s+)", "", line).strip()
    value = re.sub(r"\s+", " ", value).casefold()
    if len(value) < 12 or value.startswith(("#", "```", "@")):
        return ""
    return value


def audit_instructions(files: Sequence[Path], root: Path) -> List[Dict[str, object]]:
    findings: List[Dict[str, object]] = []
    occurrences: Dict[str, List[Tuple[str, int]]] = defaultdict(list)
    for path in files:
        rel = relative(path, root)
        if path.is_symlink():
            findings.append(finding("instruction-symlink", "warning", rel, "Symlinked instruction file was not read."))
            continue
        text = path.read_text(encoding="utf-8", errors="replace")
        if not text.strip():
            findings.append(finding("empty-instruction", "warning", rel, "Instruction file is empty."))
            continue
        if path.stat().st_size > 32768:
            findings.append(finding("instruction-size", "warning", rel, "Instruction file exceeds 32 KiB."))
        for number, line in enumerate(text.splitlines(), start=1):
            if PLACEHOLDER.search(line):
                findings.append(finding("placeholder", "warning", rel, "Unresolved placeholder text.", number))
            if any(pattern.search(line) for pattern in SECRET_PATTERNS):
                findings.append(finding("possible-secret", "warning", rel, "Possible secret; value suppressed.", number))
            if any(pattern.search(line) for pattern in UNSAFE_PATTERNS):
                findings.append(finding("unsafe-directive", "warning", rel, "Potentially unsafe directive.", number))
            normalized = normalized_rule(line)
            if normalized:
                occurrences[normalized].append((rel, number))
    for locations in occurrences.values():
        files_with_rule = sorted({path for path, _ in locations})
        if len(files_with_rule) > 1:
            path, line = locations[0]
            findings.append(
                finding("duplicate-instruction", "info", path, "Exact rule repeats across: " + ", ".join(files_with_rule), line)
            )
    return findings


def parse_scalar(value: str) -> object:
    value = value.strip()
    if value.startswith("[") and value.endswith("]"):
        inner = value[1:-1].strip()
        return [item.strip().strip("'\"") for item in inner.split(",") if item.strip()]
    if re.fullmatch(r"-?\d+", value):
        return int(value)
    return value.strip("'\"")


def parse_config(path: Path) -> Dict[str, object]:
    config: Dict[str, object] = {}
    for number, raw in enumerate(path.read_text(encoding="utf-8").splitlines(), start=1):
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if line.startswith(("-", " ")) or ":" not in line:
            raise ValueError(f"unsupported configuration syntax at line {number}")
        key, value = line.split(":", 1)
        config[key.strip()] = parse_scalar(value)
    return config


def normalize_header(value: str) -> str:
    return re.sub(r"[^a-z0-9]+", "_", value.strip().casefold()).strip("_")


def parse_markdown_ledger(text: str) -> Tuple[List[Dict[str, str]], set]:
    lines = text.splitlines()
    for index, line in enumerate(lines[:-1]):
        if not line.lstrip().startswith("|") or "id" not in line.casefold() or "state" not in line.casefold():
            continue
        separator = lines[index + 1]
        if not separator.lstrip().startswith("|") or "---" not in separator:
            continue
        headers = [normalize_header(cell) for cell in line.strip().strip("|").split("|")]
        rows: List[Dict[str, str]] = []
        for row_line in lines[index + 2 :]:
            if not row_line.lstrip().startswith("|"):
                break
            values = [cell.strip() for cell in row_line.strip().strip("|").split("|")]
            if len(values) != len(headers):
                continue
            rows.append(dict(zip(headers, values)))
        return rows, set(headers)
    return [], set()


def yes(value: str) -> bool:
    return value.strip().casefold() in {"yes", "true", "pass", "passed", "verified"}


def completion_evidenced(item: Mapping[str, str]) -> bool:
    return yes(item.get("implemented", "")) and yes(item.get("tested", ""))


def forward_transition(before: Mapping[str, str], after: Mapping[str, str]) -> bool:
    old = before.get("state", "").casefold()
    new = after.get("state", "").casefold()
    if old == new:
        return True
    if old == "future-watch" and new in {"queued", "active"}:
        return bool(after.get("disposition", ""))
    if old == "queued" and new == "active":
        return True
    if old == "active" and new == "blocked":
        return bool(after.get("disposition", ""))
    if old == "blocked" and new == "active":
        return bool(after.get("disposition", ""))
    if old in {"active", "blocked"} and new == "completed":
        return completion_evidenced(after)
    return False


def priority_decreased(before: str, after: str) -> bool:
    old = before.strip().casefold()
    new = after.strip().casefold()
    if old == new:
        return False
    if old in PRIORITY_RANK and new in PRIORITY_RANK:
        return PRIORITY_RANK[new] < PRIORITY_RANK[old]
    return True


def git_text(root: Path, ref: str, path: str) -> str:
    if ref.startswith("-"):
        raise ValueError("revision names cannot begin with a hyphen")
    completed = subprocess.run(
        ["git", "show", f"{ref}:{path}"],
        cwd=root,
        check=False,
        capture_output=True,
        text=True,
    )
    if completed.returncode:
        raise ValueError(f"cannot read {path} at {ref}")
    return completed.stdout


def archived_with_disposition(root: Path, ref: str, archive: str, item_id: str) -> bool:
    listed = subprocess.run(
        ["git", "ls-tree", "-r", "--name-only", ref, "--", archive],
        cwd=root,
        check=False,
        capture_output=True,
        text=True,
    )
    if listed.returncode:
        return False
    for path in listed.stdout.splitlines():
        text = git_text(root, ref, path)
        if not re.search(
            rf"(?im)^\s*(?:[-*]\s*)?(?:\*\*)?ID(?:\*\*)?\s*:\s*`?{re.escape(item_id)}`?\s*$",
            text,
        ):
            continue
        if re.search(r"(?im)^\s*(?:[-*]\s*)?Disposition\s*:\s*\S", text) and re.search(
            r"(?im)^\s*(?:[-*]\s*)?Authority\s*:\s*\S", text
        ):
            return True
    return False


def discover_ledger_candidates(root: Path) -> List[Path]:
    candidates: List[Path] = []
    docs = root / "docs"
    if not docs.is_dir():
        return candidates
    names = {"progress.md", "current-progress.md", "current-progress-and-roadmap.md", "roadmap.md"}
    for path in docs.rglob("*.md"):
        if path.name.casefold() in names:
            candidates.append(path)
    return sorted(candidates, key=lambda item: relative(item, root))


def discover_instruction_ledgers(root: Path, files: Sequence[Path]) -> List[Path]:
    pointed: List[Path] = []
    root_files = {root / name for name in ("AGENTS.md", "AGENTS.override.md", "CLAUDE.md")}
    for instruction in files:
        if instruction not in root_files or instruction.is_symlink():
            continue
        text = instruction.read_text(encoding="utf-8", errors="replace")
        for line in text.splitlines():
            for match in re.finditer(r"`([^`]*(?:progress|roadmap|status)[^`]*\.md)`", line, flags=re.IGNORECASE):
                before = line[: match.start()]
                after = line[match.end() :]
                path_declared_canonical = re.match(
                    r"\s+(?:is|remains|serves\s+as)\s+(?:(?:the|a)\s+)?(?:only\s+)?canonical\b",
                    after,
                    flags=re.IGNORECASE,
                )
                canonical_declares_path = re.search(
                    r"\bcanonical\s+(?:progress\s+|project\s+)?(?:ledger|record|roadmap|status)\s*(?::|is)\s*$",
                    before,
                    flags=re.IGNORECASE,
                )
                if not path_declared_canonical and not canonical_declares_path:
                    continue
                value = match.group(1)
                try:
                    candidate = resolve_inside(root, value)
                except ValueError:
                    continue
                if candidate not in pointed:
                    pointed.append(candidate)
    return sorted(pointed, key=lambda item: relative(item, root))


def audit_ledger(
    root: Path,
    ledger_path: Optional[Path],
    config: Mapping[str, object],
    base_ref: Optional[str],
    head_ref: Optional[str],
) -> Tuple[List[Dict[str, object]], str, int]:
    findings: List[Dict[str, object]] = []
    if ledger_path is None:
        return findings, "not_evaluated", 0
    rel = relative(ledger_path, root)
    if not ledger_path.is_file():
        findings.append(finding("missing-ledger", "error", rel, "Configured ledger does not exist."))
        return findings, "not_evaluated", 0
    rows, headers = parse_markdown_ledger(ledger_path.read_text(encoding="utf-8", errors="replace"))
    missing = REQUIRED_COLUMNS - headers
    if missing:
        findings.append(finding("ledger-columns", "error", rel, "Missing managed columns: " + ", ".join(sorted(missing))))
    identifiers: set = set()
    completed = 0
    allowed = BASE_STATES | {str(item) for item in config.get("protected_states", [])}
    for number, item in enumerate(rows, start=3):
        item_id = item.get("id", "")
        state = item.get("state", "").casefold()
        if not item_id:
            findings.append(finding("missing-id", "error", rel, "Managed row has no stable ID.", number))
        elif item_id in identifiers:
            findings.append(finding("duplicate-id", "error", rel, f"Duplicate work-item ID: {item_id}", number))
        identifiers.add(item_id)
        if state not in allowed:
            findings.append(finding("invalid-state", "error", rel, f"Unsupported state for {item_id}.", number))
        if state == "completed":
            completed += 1
    limit = int(config.get("current_completed_limit", 10))
    if completed > limit:
        findings.append(finding("completed-limit", "warning", rel, f"Current completed rows {completed} exceed limit {limit}."))

    archive_value = str(config.get("archive", "docs/project-evidence"))
    archive_path = resolve_inside(root, archive_value)
    max_bytes = int(config.get("archive_entry_max_kib", 64)) * 1024
    if archive_path.is_dir():
        for path in archive_path.rglob("*"):
            if path.is_symlink():
                findings.append(finding("archive-symlink", "warning", relative(path, root), "Symlinked archive entry was not read."))
            elif path.is_file() and path.stat().st_size > max_bytes:
                findings.append(
                    finding("archive-size", "warning", relative(path, root), f"Archive entry exceeds {max_bytes // 1024} KiB.")
                )

    if bool(base_ref) != bool(head_ref):
        findings.append(finding("revision-pair", "error", rel, "Provide both --base-ref and --head-ref."))
        return findings, "not_evaluated", len(rows)
    if not base_ref or not head_ref:
        return findings, "not_evaluated", len(rows)

    before_rows, _ = parse_markdown_ledger(git_text(root, base_ref, rel))
    after_rows, _ = parse_markdown_ledger(git_text(root, head_ref, rel))
    before = {item.get("id", ""): item for item in before_rows if item.get("id")}
    after = {item.get("id", ""): item for item in after_rows if item.get("id")}
    protected = {str(item) for item in config.get("protected_states", DEFAULT_PROTECTED)}
    for item_id, old in before.items():
        if old.get("state", "").casefold() not in protected:
            continue
        new = after.get(item_id)
        if new is None:
            if not archived_with_disposition(root, head_ref, archive_value, item_id):
                findings.append(
                    finding("protected-transition", "error", rel, f"Protected item {item_id} was removed without archived disposition and authority.")
                )
            continue
        changed = not forward_transition(old, new) or priority_decreased(old.get("priority", ""), new.get("priority", ""))
        if changed and not (new.get("disposition", "").strip() and new.get("authority", "").strip()):
            findings.append(
                finding("protected-transition", "error", rel, f"Protected item {item_id} changed without disposition and authority.")
            )
    return findings, "evaluated", len(rows)


def parse_args(argv: Sequence[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", default=".", help="Repository root to inspect.")
    parser.add_argument("--ledger", help="Ledger path relative to root; overrides discovery for this run.")
    parser.add_argument("--base-ref", help="Git base revision for transition checks.")
    parser.add_argument("--head-ref", help="Git head revision for transition checks.")
    parser.add_argument("--format", choices=("text", "json"), default="text")
    parser.add_argument("--fail-on-errors", action="store_true")
    return parser.parse_args(argv)


def build_report(args: argparse.Namespace) -> Dict[str, object]:
    root = Path(args.root).expanduser().resolve()
    if not root.is_dir():
        raise ValueError(f"repository root is not a directory: {root}")
    instruction_files = discover_instruction_files(root)
    findings = audit_instructions(instruction_files, root)
    config_path = root / ".superpowers" / "project-state.yaml"
    config: Dict[str, object] = {}
    profile = "convention"
    if config_path.is_symlink():
        profile = "managed"
        findings.append(finding("config-symlink", "error", relative(config_path, root), "Managed configuration cannot be a symlink."))
    elif config_path.is_file():
        profile = "managed"
        try:
            config = parse_config(config_path)
        except ValueError as error:
            findings.append(finding("config-syntax", "error", relative(config_path, root), str(error)))
        required_config = {"version", "ledger", "archive", "protected_states", "current_completed_limit", "archive_entry_max_kib"}
        missing = required_config - set(config)
        if missing:
            findings.append(
                finding("config-fields", "error", relative(config_path, root), "Missing fields: " + ", ".join(sorted(missing)))
            )
        protected = {str(item) for item in config.get("protected_states", [])}
        if not DEFAULT_PROTECTED <= protected:
            findings.append(
                finding("protected-states", "error", relative(config_path, root), "Managed protection must include queued, active, blocked, and future-watch.")
            )
        if config.get("version") != 1:
            findings.append(finding("config-version", "error", relative(config_path, root), "Only configuration version 1 is supported."))
        for key in ("current_completed_limit", "archive_entry_max_kib"):
            value = config.get(key)
            if not isinstance(value, int) or value <= 0:
                findings.append(finding("config-limit", "error", relative(config_path, root), f"{key} must be a positive integer."))

    configured_ledger = str(config.get("ledger", "")) if config else ""
    if args.ledger and configured_ledger and Path(args.ledger).as_posix() != Path(configured_ledger).as_posix():
        findings.append(
            finding("ledger-override", "error", relative(config_path, root), "--ledger does not match managed configuration.")
        )
    ledger_source = "none"
    ledger_path: Optional[Path] = None
    if args.ledger:
        ledger_path = resolve_inside(root, args.ledger)
        ledger_source = "cli"
    elif configured_ledger:
        ledger_path = resolve_inside(root, configured_ledger)
        ledger_source = "config"
    else:
        pointed = discover_instruction_ledgers(root, instruction_files)
        if len(pointed) == 1:
            ledger_path = pointed[0]
            ledger_source = "instruction"
        elif len(pointed) > 1:
            findings.append(
                finding("ambiguous-ledger-pointer", "warning", "AGENTS.md", "Multiple canonical ledger pointers: " + ", ".join(relative(p, root) for p in pointed))
            )
        candidates = discover_ledger_candidates(root)
        if ledger_path is None and not pointed and len(candidates) == 1:
            ledger_path = candidates[0]
            ledger_source = "discovery"
        elif ledger_path is None and not pointed and len(candidates) > 1:
            findings.append(
                finding("duplicate-ledger", "warning", "docs", "Multiple candidate current ledgers: " + ", ".join(relative(p, root) for p in candidates))
            )

    if profile == "managed":
        ledger_findings, transition_check, item_count = audit_ledger(
            root, ledger_path, config, args.base_ref, args.head_ref
        )
        findings.extend(ledger_findings)
    else:
        transition_check = "not_evaluated"
        item_count = 0
        if ledger_path is not None and not ledger_path.is_file():
            findings.append(finding("missing-ledger", "error", relative(ledger_path, root), "Declared ledger does not exist."))

    severity = {
        level: sum(1 for item in findings if item["severity"] == level)
        for level in ("error", "warning", "info")
    }
    return {
        "root": str(root),
        "profile": profile,
        "ledger": relative(ledger_path, root) if ledger_path else None,
        "ledger_source": ledger_source,
        "transition_check": transition_check,
        "summary": {"items": item_count, "findings": len(findings), **severity},
        "findings": sorted(findings, key=lambda item: (str(item["path"]), int(item["line"]), str(item["rule"]))),
    }


def render_text(report: Mapping[str, object]) -> str:
    summary = report["summary"]
    lines = [
        f"profile: {report['profile']}",
        f"ledger: {report['ledger'] or '(none)'} ({report['ledger_source']})",
        f"transition check: {report['transition_check']}",
        f"findings: {summary['findings']} (errors {summary['error']}, warnings {summary['warning']}, info {summary['info']})",
    ]
    for item in report["findings"]:
        lines.append(f"{item['severity'].upper()} {item['rule']} {item['path']}:{item['line']} {item['message']}")
    return "\n".join(lines)


def main(argv: Sequence[str] = sys.argv[1:]) -> int:
    args = parse_args(argv)
    try:
        report = build_report(args)
    except (OSError, ValueError) as error:
        print(f"audit failed: {error}", file=sys.stderr)
        return 2
    if args.format == "json":
        print(json.dumps(report, indent=2, sort_keys=True))
    else:
        print(render_text(report))
    return 1 if args.fail_on_errors and report["summary"]["error"] else 0


if __name__ == "__main__":
    raise SystemExit(main())
