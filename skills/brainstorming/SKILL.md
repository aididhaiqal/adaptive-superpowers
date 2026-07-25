---
name: brainstorming
description: "Resolve ambiguous work before implementation when interpretations materially change scope, architecture, or consequential outcomes; skip precise tasks."
---

# Brainstorming

Scale depth to decision consequence. Skip repository-answerable questions.

1. Inspect enough context to identify the goal, constraints, acceptance criteria, and safe assumptions.
2. When one unanswered user decision controls the direction, ask one focused question before proposing a detailed design or implementing the affected behavior. Unrelated safe inspection may continue.
3. For other ambiguity, ask when the answer would materially change the result; otherwise state the assumption you are making.
4. Recommend one approach. Include alternatives only when they are genuinely viable and materially different, and explain the relevant trade-offs.
5. Describe the smallest sufficient design: ownership, interfaces, data flow, failure behavior, and verification.
6. Reconcile the design with all core outcomes promised in the conversation. Any exclusion or deferral that weakens a core outcome requires explicit approval.

For complex work:

- **Must deliver**
- **Explicitly deferred**
- **Open decisions**
- **Acceptance**

Material adjacent suggestions need evidence and stay optional, non-authorizing.
Do not use reversibility, configuration, defaults, or parallel branches to choose a consequential outcome without approval.

Stop brainstorming once consequential decisions and acceptance are clear. Pass the chosen approach, assumptions, approved deferrals, and acceptance to implementation. Use durable planning only when independently triggered.
