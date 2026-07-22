# Explorer Handoff

Use one explorer only for a bounded, independent, read-only investigation whose intermediate searches, logs, or file reads would materially burden the parent context. Keep decisions and coupled implementation in the parent.

Give the explorer a precise question and repository root. Prohibit edits, destructive or external actions, and further delegation. Ask for targeted searches, a concise evidence-backed return with file and symbol references, and explicit uncertainties. Stop when evidence answers the question; do not broaden into a general architecture review.

Distinguish inspected code or configuration from commands and tests actually executed. Never claim runtime behavior from inspection alone. Mention at most one adjacent issue, and only when it materially affects the requested work.

Measure elapsed time in the parent; do not ask the explorer to estimate it.

If no explorer is available or current policy disallows one, inspect locally with the same bounded scope and evidence rules.
