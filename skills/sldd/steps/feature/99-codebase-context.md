# Step 99: Existing Codebase Understanding and Context Summary

## Objective

Capture and approve existing-codebase context for brownfield exploration and safe Step 02+ work.

## Gate + Resume Checks

- Required before Step 02 for existing codebases.
- May be run during Step 88 exploration when codebase understanding is needed to clarify scope, constraints, risks, or alternatives.
- Optional for greenfield projects.
- Do not mark Step 99 complete without explicit approval and a saved `existing-codebase-understanding.md` artifact.
- Conversational or unsaved Step 99 context is non-gating context only; it does not satisfy Step 02+ brownfield prerequisites.
- If resuming later, re-evaluate the current codebase before relying on any previous Step 99 summary.
- Reuse a previous Step 99 only if it still reflects the current codebase and approved Step 01 scope; update or rerun it if stale, incomplete, or scoped to a rejected exploration direction.
- Reject inconsistent journal states where Step 02+ is complete while Step 99 is required and incomplete.
- If `relationships.predecessors` exists and any predecessor is missing or incomplete, Step 99 may be drafted and saved as context, but must remain `pending` for gating purposes until Step 01 can complete after predecessor verification.

## Draft Output

Load `templates/existing-codebase-understanding.md` before drafting the artifact.

Wait for approval.

## Approval Protocol

- Save the artifact and mark Step 99 complete in `_spec-journal.json` only after explicit approval.
- On rejection, requested changes, hold, or ambiguous approval, do not persist progress; clarify or wait.
- If writes are unavailable, stop and report the limitation.

## Save Flow After Approval

1. Confirm that approval includes saving `existing-codebase-understanding.md` in the resolved workflow directory.
2. If persistence is approved, save `existing-codebase-understanding.md`.
3. If `relationships.predecessors` exists and any predecessor is missing or incomplete, keep Step 99 as `pending`, preserve the artifact link, set `reason` to the predecessor-gate explanation, and route to the incomplete predecessor instead of Step 02+.
4. Otherwise, mark Step 99 in journal-only `_spec-journal.json` with `status: "complete"` and the saved artifact link.
5. If persistence is not approved, do not save, do not mark Step 99 complete, and do not route to Step 02+; state that Step 99 remains incomplete until the artifact is saved and approved.
6. Ask whether to continue to the next step or hold.

For legacy or user-provided workflow paths, save and update progress in the resolved directory instead.

## Response Format

1. Gate and resume check result
2. Draft summary with required Step 99 headings
3. Persistence requirement for Step 99 completion
4. Approval request and continue/hold prompt
