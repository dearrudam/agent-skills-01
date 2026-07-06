# Step 03: Verify Workflow-Set

## Objective

Verify workflow-set coordination consistency after planning and scaffolding.

## Gate + Resume Checks

- Require parent journal `name` and `kind: "workflow-set"`.
- Require `01-workflow-set-plan` complete.
- Require `02-scaffold-children` complete, or require the user to explicitly accept recorded conflicts before verification can complete.
- Do not require child workflows to complete Step 01 (`01-product-intent`) or Step 06 (`06-verification`).
- Do not create a dedicated verification artifact in the first version.

## Verification Checks

Confirm:

- The parent journal exists and has `name` and `kind: "workflow-set"`.
- `01-workflow-set-plan.md` exists and reflects the approved decomposition.
- Parent child entries use scaffold states `proposed`, `created`, or `conflict`.
- Created child journals exist.
- Created child journals have `name` and `kind: "feature"`.
- Created child `01-product-intent` entries are pending unless independently approved by the child workflow later.
- Created child `01-product-intent` entries include `origin.type: "workflow-set-scaffold"`.
- Conflict child entries have an explicit reason and represent accepted non-creation, not successful scaffold.
- Child predecessor paths are stored in child journals.
- The parent does not persist child execution progress.

Accepted conflicts are coordination states, not successful child creation. Verification may complete with accepted conflicts only when the user explicitly accepts that those children were not scaffolded and the parent should preserve the conflict state for later resolution.

## Approval Protocol

- Report verification results in the conversation.
- Update the journal only after verification succeeds or after the user explicitly accepts recorded conflicts.
- On mismatch, stale plan, missing child file, or unsafe state, stop and route to the relevant workflow-set step.

## Save Flow After Verification

1. Mark `03-verify-workflow-set` complete in `_spec-journal.json`.
2. Add concise journal notes for accepted conflicts or verification evidence.
3. Do not write a separate verification report artifact.

## Response Format

1. Gate and verification result
2. Coordination consistency summary
3. Journal update summary
4. Next safe actions
