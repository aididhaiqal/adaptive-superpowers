#!/usr/bin/env python3
"""Read-only on-disk comparison; never loads a plugin or runs its code."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import sys

NAME = "adaptive-superpowers"
ROOT = Path(__file__).resolve().parents[1]
IGNORED = {"__pycache__", ".DS_Store", ".git"}


def reject_link(path):
    if path.is_symlink():
        raise ValueError(f"internal symlink requires inspection: {path}")


def read_bytes(path):
    reject_link(path)
    if not path.is_file():
        raise ValueError(f"not a readable regular file: {path}")
    return path.read_bytes()


def read_object(path):
    value = json.loads(read_bytes(path).decode("utf-8"))
    if not isinstance(value, dict):
        raise ValueError(f"expected a JSON object: {path}")
    return value


def version(root, host):
    path = root / f".{host}-plugin/plugin.json"
    reject_link(path.parent)
    reject_link(path)
    if not path.exists():
        return None
    manifest = read_object(path)
    if manifest.get("name") != NAME or not isinstance(manifest.get("version"), str):
        raise ValueError(f"invalid Adaptive manifest identity/version: {path}")
    if not manifest["version"].strip():
        raise ValueError(f"empty manifest version: {path}")
    return manifest["version"]


def file_map(directory, prefix, allow_root_link=False):
    """Hash regular files; do not execute scripts or traverse nested dir links."""
    result = {}
    if not allow_root_link:
        reject_link(directory)
    if not directory.exists():
        return result
    if not directory.is_dir():
        raise ValueError(f"not a directory: {directory}")
    directory = directory.resolve(strict=True)  # only Codex's top-level skill links are implicit
    for current, dirs, files in os.walk(directory, onerror=raise_error):
        dirs[:] = sorted(d for d in dirs if d not in IGNORED)
        for name in dirs:
            reject_link(Path(current) / name)
        for name in sorted(files):
            if name in IGNORED or name.endswith(".pyc"):
                continue
            path = Path(current) / name
            key = f"{prefix}/{path.relative_to(directory).as_posix()}"
            result[key] = hashlib.sha256(read_bytes(path)).hexdigest()
    return result


def raise_error(error):
    raise error


def skills_map(root, names, allow_skill_links=False):
    reject_link(root)
    result = {}
    for name in names:
        result.update(file_map(root / name, f"skills/{name}", allow_skill_links))
    return result


def skill_names(root):
    reject_link(root)
    if not root.is_dir():
        return []
    return sorted(p.name for p in root.iterdir() if p.is_dir())


def discover_claude(registry):
    data = read_object(registry)
    if data.get("version") != 2 or not isinstance(data.get("plugins"), dict):
        raise ValueError("unrecognized Claude registry; supply --claude-plugin PATH")
    matches = []
    for identity, entries in data["plugins"].items():
        if identity.split("@", 1)[0] != NAME:
            continue
        if not isinstance(entries, list) or any(not isinstance(e, dict) for e in entries):
            raise ValueError("invalid Claude registry entries; supply --claude-plugin PATH")
        matches.extend(entries)
    if len(matches) != 1:
        raise ValueError(f"found {len(matches)} Claude installations; supply --claude-plugin PATH")
    entry = matches[0]
    path = entry.get("installPath")
    if not isinstance(path, str) or not Path(path).is_absolute():
        raise ValueError("invalid Claude installPath; supply --claude-plugin PATH")
    return Path(path), entry.get("version")


def compare(host, args, expected, names, expected_version):
    registry_version = None
    if host == "codex":
        path = args.codex_skills.resolve()
        actual = skills_map(path, names, allow_skill_links=True)  # other user skills are not ours
        roots = set()
        for name in names:
            target = (path / name).resolve()
            if target.parent.name == "skills":
                roots.add(target.parent.parent)
            else:
                roots.add(None)
        installed_version = version(next(iter(roots)), host) if len(roots) == 1 and None not in roots else None
    else:
        path = args.claude_plugin
        if path is None:
            path, registry_version = discover_claude(args.claude_registry)
        path = path.resolve()  # explicitly selected plugin root
        actual = skills_map(path / "skills", skill_names(path / "skills"))
        actual.update(file_map(path / "hooks", "hooks"))
        installed_version = version(path, host)
        manifest = path / ".claude-plugin/plugin.json"
        if manifest.is_file():
            actual[".claude-plugin/plugin.json"] = hashlib.sha256(read_bytes(manifest)).hexdigest()

    missing = sorted(expected.keys() - actual.keys())
    unexpected = sorted(actual.keys() - expected.keys())
    changed = sorted(k for k in expected.keys() & actual.keys() if expected[k] != actual[k])
    content_match = not (missing or unexpected or changed)
    version_match = installed_version == expected_version if installed_version is not None else None
    registry_match = registry_version == installed_version if registry_version is not None else None
    status = "match"
    if not content_match or version_match is False or registry_match is False:
        status = "drift"
    elif version_match is None:
        status = "unknown"
    return {
        "host": host, "path": str(path), "status": status,
        "version": installed_version, "version_match": version_match,
        "registry_version": registry_version, "registry_version_match": registry_match,
        "content_match": content_match, "missing": missing,
        "unexpected": unexpected, "changed": changed,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", type=Path, default=ROOT, help="reference repository (default: this script's repo)")
    parser.add_argument("--host", choices=("all", "codex", "claude"), default="all")
    parser.add_argument("--codex-skills", type=Path, default=Path.home() / ".agents/skills",
                        help="user-link directory or explicit Codex plugin skills directory")
    parser.add_argument("--claude-plugin", type=Path, help="explicit plugin root; bypasses registry discovery")
    parser.add_argument("--claude-registry", type=Path,
                        default=Path(os.environ.get("CLAUDE_CONFIG_DIR", str(Path.home() / ".claude"))) / "plugins/installed_plugins.json")
    parser.add_argument("--json", action="store_true", help="machine-readable report (paths, never file contents)")
    args = parser.parse_args()
    args.source = args.source.resolve()
    report = {"source": {"path": str(args.source)}, "installations": [], "runtime_activation": "not_checked"}
    try:
        versions = [version(args.source, host) for host in ("codex", "claude")]
        if not versions[0] or versions[0] != versions[1]:
            raise ValueError("source Codex/Claude manifest versions must exist and agree")
        report["source"]["version"] = versions[0]
        names = skill_names(args.source / "skills")
        if not names or any(not (args.source / "skills" / n / "SKILL.md").is_file() for n in names):
            raise ValueError("source must contain a non-empty, valid skills tree")
        shared = skills_map(args.source / "skills", names)
        for host in ("codex", "claude") if args.host == "all" else (args.host,):
            try:
                expected = dict(shared)
                if host == "claude":
                    expected.update(file_map(args.source / "hooks", "hooks"))
                    manifest = args.source / ".claude-plugin/plugin.json"
                    expected[".claude-plugin/plugin.json"] = hashlib.sha256(read_bytes(manifest)).hexdigest()
                report["installations"].append(compare(host, args, expected, names, versions[0]))
            except (OSError, ValueError, RuntimeError) as error:
                report["installations"].append({"host": host, "status": "unknown", "error": str(error)})
    except (OSError, ValueError, RuntimeError) as error:
        report["error"] = str(error)

    if args.json:
        print(json.dumps(report, indent=2))
    else:
        print(f"Reference: {args.source} (version {report['source'].get('version', 'unknown')})")
        if "error" in report:
            print(f"UNKNOWN: {report['error']}")
        for item in report["installations"]:
            print(f"{item['host']}: {item['status'].upper()} — {item.get('path', item.get('error'))}")
            if "error" in item:
                continue
            print(f"  version: {item['version'] or 'unknown'}; content: {'match' if item['content_match'] else 'different'}")
            if item["registry_version_match"] is False:
                print("  registry version disagrees with installed manifest")
            for kind in ("missing", "changed", "unexpected"):
                values = item[kind]
                if values:
                    print(f"  {kind} ({len(values)}): {', '.join(values[:6])}" + (" ..." if len(values) > 6 else ""))
        print("On-disk snapshot only; enablement, other skill locations, and active-session loading are not checked. No files changed.")
    statuses = {i["status"] for i in report["installations"]}
    return 2 if "error" in report or "unknown" in statuses else 1 if "drift" in statuses else 0


if __name__ == "__main__":
    sys.exit(main())
