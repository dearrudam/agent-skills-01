# Step 02: High-Level Technical Design

## Objective

Produce approved high-level design aligned to Step 01, including exploration outcomes formalized into Step 01 and Step 99 when required.

## Gate + Resume Checks

- Require Step 01 complete.
- For existing codebases, require Step 99 complete and current.
- Accept a persisted Step 99 completed during exploration only after validating that it still reflects the current codebase and applies to the approved Step 01 scope.
- Reject skip-ahead to implementation/tests.
- Reject inconsistent journal states.

## Draft Output

Load `templates/02-high-level-technical-design.md` before drafting the artifact.

Use `00-exploration-summary.md` only as non-binding context for rationale, alternatives, assumptions, and candidate technical ideas. Approved numbered artifacts override it.

If Step 99 was completed before Step 01, verify that its saved context still fits the approved Step 01 scope before drafting Step 02. If it does not, stop and route back to Step 99 for update or rerun.

Trace approved Step 01 requirements, including formalized exploration outcomes, into architecture, responsibilities, data flow, security/observability, trade-offs, and high-level test scenarios.

Wait for approval.

## Approval Protocol

- Save or update artifacts only after explicit approval.
- On rejection, requested changes, hold, or ambiguous approval, do not persist progress; clarify or wait.
- If writes are unavailable, stop and report the limitation.

## Save Flow After Approval

1. Save only Step 02 content to the resolved workflow directory as `02-high-level-technical-design.md`; for new workflows, this is `.sldd/specs/<feature-name>/02-high-level-technical-design.md`.
2. Mark `02-high-level-design` as `complete` in journal-only `_spec-journal.json` with the artifact link.
3. Ask whether to continue to the next step or hold.

For legacy or user-provided workflow paths, save and update progress in the resolved directory instead.

## Response Format

1. Gate and resume check result
2. Draft summary with required Step 02 headings
3. Approval request
4. Continue/hold prompt
