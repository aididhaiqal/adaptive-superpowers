# Explorer Handoff

Use explorers for bounded, independent, read-only investigations whose intermediate searches, logs, or file reads would materially burden the parent context. Keep user decisions and coupled implementation with their owner. Follow [delegation.md](delegation.md); divide questions by independent evidence, not arbitrary file counts.

Give each explorer a precise question and repository root. Prohibit edits and destructive or external actions. Any permitted descendants inherit that read-only scope. Ask for targeted searches, a concise evidence-backed return with file and symbol references, and explicit uncertainties. Stop when evidence answers the question; do not broaden into a general architecture review.

Distinguish inspected code or configuration from commands and tests actually executed. Never claim runtime behavior from inspection alone. Mention at most one adjacent issue, and only when it materially affects the requested work.

Measure elapsed time in the parent; do not ask the explorer to estimate it.

If no explorer is available or current policy disallows one, inspect locally with the same bounded scope and evidence rules.
