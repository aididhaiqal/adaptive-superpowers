---
name: brainstorming
description: "Resolve ambiguous work before implementation when interpretations materially change scope, architecture, or consequential outcomes; skip precise tasks."
---

# Brainstorming

Scale depth to decision consequence. Skip precise tasks, approved specifications, mechanical changes, and repository-answerable questions. Dispatched agents follow bounded briefs and return material ambiguity to the parent; they do not restart brainstorming.

1. Inspect instructions, files, and behavior.
2. State the goal, constraints, acceptance, and safe assumptions.
3. Ask one focused question as soon as its answer materially changes the result; otherwise state a safe assumption.
4. Recommend one approach; include viable, different alternatives.
5. Describe the smallest useful design: ownership, interfaces, data flow, failure behavior, and verification.
6. Reconcile the design with all core outcomes promised in the conversation. Any exclusion or deferral that weakens a core outcome requires explicit approval.

For complex work, close scope:

- **Must deliver**
- **Explicitly deferred**
- **Open decisions**
- **Acceptance**

Material adjacent suggestions require evidence of improved viability, safety, or value; label them optional and non-authorizing.

Decompose independent subsystems only when it clarifies ownership. Pause for missing authority or consequential choices.

Stop brainstorming once consequential decisions and acceptance are clear. Pass the chosen approach, assumptions, approved deferrals, and acceptance to implementation. Use durable planning only when independently triggered.
