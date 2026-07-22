#!/usr/bin/env python3
import ast
from pathlib import Path


root = Path(__file__).resolve().parents[2]
readme = (root / "README.md").read_text()

expected = {
    "explorer.toml": {
        "name": "explorer",
        "model": "gpt-5.6-terra",
        "model_reasoning_effort": "high",
        "sandbox_mode": "read-only",
    },
    "feature-reviewer.toml": {
        "name": "feature_reviewer",
        "model": "gpt-5.6-terra",
        "model_reasoning_effort": "xhigh",
        "sandbox_mode": "read-only",
    },
    "final-reviewer.toml": {
        "name": "final_reviewer",
        "model": "gpt-5.6-sol",
        "model_reasoning_effort": "high",
        "sandbox_mode": "read-only",
    },
}


def agent_block(filename: str) -> str:
    marker = f"`~/.codex/agents/{filename}`"
    marker_index = readme.index(marker)
    fence_start = readme.index("```toml\n", marker_index) + len("```toml\n")
    fence_end = readme.index("\n```", fence_start)
    return readme[fence_start:fence_end]


def parse_block(filename: str, block: str) -> dict[str, str]:
    lines = block.splitlines()
    values: dict[str, str] = {}
    index = 0
    while index < len(lines):
        line = lines[index]
        if line == 'developer_instructions = """':
            index += 1
            instructions = []
            while index < len(lines) and lines[index] != '"""':
                instructions.append(lines[index])
                index += 1
            if index == len(lines) or not any(part.strip() for part in instructions):
                raise SystemExit(f"{filename}: invalid developer_instructions block")
            values["developer_instructions"] = "\n".join(instructions)
        else:
            try:
                key, raw_value = line.split(" = ", 1)
                value = ast.literal_eval(raw_value)
            except (ValueError, SyntaxError) as error:
                raise SystemExit(f"{filename}: invalid TOML assignment: {line}") from error
            if key in values or not isinstance(value, str):
                raise SystemExit(f"{filename}: invalid or duplicate key: {key}")
            values[key] = value
        index += 1
    return values


for filename, required in expected.items():
    parsed = parse_block(filename, agent_block(filename))
    for key, value in required.items():
        if parsed.get(key) != value:
            raise SystemExit(
                f"{filename}: expected {key}={value!r}, got {parsed.get(key)!r}"
            )
    if not parsed.get("description") or not parsed.get("developer_instructions"):
        raise SystemExit(f"{filename}: missing description or developer instructions")

print("README Codex agent blocks validated")
