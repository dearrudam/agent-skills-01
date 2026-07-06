# Step 88: Spec Exploration and Clarification

## Objective

Help the user turn a rough idea into a clear, testable spec direction before formal SLDD Step 01 starts.

## Gate/Route Rules

- Keep exploration pre-Step-01 unless the user explicitly asks to formalize.
- Route to Step 01 when the idea is sufficiently clear.
- Recommend workflow-set planning before Step 01 when the idea has multiple capabilities, clear dependencies, parallelizable workstreams, or would create an oversized Step 01.
- Do not create workflow-set artifacts from exploration without explicit user approval.
- When invoked as `/sldd explore <idea>`, treat `<idea>` as the initial exploration seed and begin project-context intake plus clarification immediately.
- When invoked without an idea, ask for the rough idea first.
- Establish lightweight project context before asking idea-specific clarification questions.
- For existing codebases, inspect the current codebase when codebase understanding is needed to explore scope, constraints, risks, or alternatives.
- If brownfield exploration depends on reusable codebase context, route to Step 99 before formalizing Step 01.
- A persisted Step 99 completed during exploration may satisfy the later brownfield gate only after resume validation confirms it still matches the current codebase and approved Step 01 scope.
- Optional summaries default to `.sldd/specs/<feature-name>/00-exploration-summary.md` unless the user provides a path.
- `00-exploration-summary.md` is contextual memory only: it does not update `_spec-journal.json`, mark progress, or replace numbered artifacts.

## Exploration Stance

- Explore first, formalize later.
- Ask questions that clarify the problem, users, constraints, outcomes, risks, unknowns, and non-goals.
- Keep the conversation grounded in the actual repo and workflow when relevant.
- Use ASCII diagrams, comparison tables, and simple flow sketches when they make the shape of the problem easier to see.

## Project Context Intake

Before the clarification interview, establish enough project context to keep exploration grounded:

- Identify the target project, workflow, or repository context when it is known.
- Determine whether the work is greenfield, brownfield, or unclear.
- Check for an existing SLDD workflow, active spec, relevant README, local instructions, or obvious project conventions when available.
- Capture the domain, users, operational constraints, non-goals, and success signals that are already known from the user's request or project materials.
- If context is missing and cannot be inferred from the current workspace, ask one focused context question before continuing.
- If a context question can be answered by read-only inspection of the repository, inspect the repository instead of asking the user.
- Treat this intake as conversational context only. It does not create a journal, satisfy Step 99, or make binding requirements.
- When reusable brownfield context is needed for later design work, offer to route to Step 99 before formalizing Step 01.

## Inline Idea Handling

When the user provides idea text with `/sldd explore <idea>` or an equivalent natural-language exploration request:

- Use the provided text as the target idea to clarify.
- Do not ask the user to repeat the same idea unless it is empty or too ambiguous to start.
- Start by combining the idea with project context, then restate the target direction in clearer terms.
- End each meaningful turn with explicit choices: continue exploring, formalize into Step 01, save an optional `00-exploration-summary.md` after approval, route to Step 99 when codebase context is needed, or stop without saving.
- Treat "stop", "pause", "exit exploration", "do not continue", or equivalent language as a request to leave exploration without saving or routing unless the user also explicitly approves persistence.

## Clarification Interview Protocol

Drive exploration toward shared understanding that is ready for formal SLDD Step 01:

- Ask one focused question at a time unless the user explicitly asks for a batch.
- Follow the decision tree one dependency at a time: clarify prerequisite decisions before dependent decisions.
- For each question, provide a recommended answer or default assumption with brief rationale, then ask the user to accept, revise, or reject it.
- Prefer high-signal questions that improve Step 01 readiness over exhaustive questioning.
- If a question can be answered by read-only inspection of the current repository, inspect the repository instead of asking the user.
- Treat repository observations during Step 88 as conversational context only unless Step 99 is explicitly run, approved, and saved.
- Do not turn exploration into Step 02 or Step 03 design work; keep technical options as non-binding context until the formal workflow reaches those steps.
- Continue until the idea is clear enough to formalize, the user chooses to keep exploring, or the user exits without saving.

## When to Use

Use this step when the user:

- Has a new feature idea and is not ready to write Step 01 yet.
- Wants help clarifying requirements, boundaries, constraints, or success criteria.
- Wants to compare possible spec directions before committing.
- Wants to explore how a new SLDD workflow should begin.
- Wants to reason about a spec in relation to an existing codebase and may need Step 99 later.

## Exploration Flow

1. Capture the inline idea seed or ask for a rough idea if none was provided.
2. Establish lightweight project context from the workspace, existing specs, repo materials, and the user's request.
3. Inspect the repository before asking any context or clarification question that the codebase can answer.
4. Restate the idea in your own words, grounded in the project context.
5. Identify what is known, what is assumed, and what is missing.
6. Ask one high-value question at a time, with a recommended answer or default assumption.
7. Map the important constraints, users, and outcomes as answers accumulate.
8. Compare candidate directions if more than one exists.
9. Call out risks, edge cases, and likely follow-up questions.
10. Decide whether the idea is ready for Step 01 or needs more exploration.
11. If decomposition is clearly useful, ask whether to switch to workflow-set planning instead of starting a normal Step 01.
12. Proactively offer `00-exploration-summary.md` before Step 01 when technical design ideas, complex alternatives, or refined constraints should be preserved for Step 02/03.

## Ground Rules

- Do not implement features.
- Do not write code.
- Do not jump into numbered SLDD artifacts unless the user explicitly asks to formalize a decision or begin Step 01.
- Downstream Steps 02-05 may follow only exploration details incorporated into the approved numbered artifact for that decision type; approved numbered artifacts override exploration notes.
- If the discussion reveals the work depends on an existing codebase, determine whether codebase understanding is needed now for exploration or later before Step 02.
- If the discussion reveals multiple independent capabilities or predecessor relationships, recommend workflow-set planning but wait for explicit approval before writing files.
- For brownfield work, ground exploration in the current codebase when relevant, but treat codebase observations as approved Step 99 context only if Step 99 is explicitly run, approved, and saved.
- If the user wants to start the formal workflow, route them to Step 01.

## Conversation Shape

Prefer concise but meaningful turns:

- Current understanding
- Project context
- Next question
- Candidate directions
- Key risks
- Suggested next step and exit choices

If the shape of the problem is still unclear, keep exploring. If it is clear enough, say so and hand off to Step 01.

## Approval Protocol

- Exploration outputs are conversational and are not saved as numbered SLDD artifacts by default.
- Proactively offer `00-exploration-summary.md` whenever exploration produces technical design ideas, architectural choices, complex alternatives, or non-obvious constraints.
- Load `templates/00-exploration-summary.md` before drafting a persisted summary.
- Save `00-exploration-summary.md` to the resolved workflow directory only after explicit approval; for new workflows, this is `.sldd/specs/<feature-name>/00-exploration-summary.md`.
- If the user asks to formalize outcomes, present the proposed formalization and wait for explicit approval before persisting any artifact.
- On rejection, requested changes, hold, or ambiguous approval, do not save or route forward; clarify or wait.
- When the user chooses to stop exploration, leave without saving, writing a journal, or routing forward unless a separate explicit approval says otherwise.
- If writes are unavailable, stop and report the limitation.
- Exploration decisions are not binding requirements until explicitly formalized and approved in Step 01 as product intent, acceptance criteria, scope boundaries, risks, assumptions, or success metrics.
- Technical design ideas are non-binding; carry them forward only as context, candidate options, assumptions to validate, or alternatives for Step 02/03.
- Do not treat unresolved exploration notes, rejected alternatives, or open questions as downstream requirements.

## Optional Exploration Summary

Use the summary only as contextual memory. Approved numbered artifacts define binding decisions:

- Step 01 defines product intent, accepted behavior, scope, risks, and success metrics.
- Step 02 defines high-level technical design.
- Step 03 defines low-level design, contracts, dependencies, and version policy.
- Step 04 defines tests derived from approved acceptance criteria and Step 03 scenarios.

## Output Format

1. Current understanding
2. Project context
3. Next question, including recommended answer or default assumption
4. Candidate directions
5. Key risks
6. Suggested next step and routing decision, including whether Step 99 is needed now, later, or not applicable
7. Summary recommendation: explicitly state if an `00-exploration-summary.md` is recommended to preserve technical memory
8. Exit choices: continue exploring, formalize Step 01, save summary after approval, route to Step 99 when needed, or stop without saving
