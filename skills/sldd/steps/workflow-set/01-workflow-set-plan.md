# Step 01: Workflow-Set Plan

## Objective

Create or revise the parent workflow-set plan for a large idea that should be decomposed into independent child workflows.

## Gate + Resume Checks

- Require explicit approval before creating or updating workflow-set files.
- If no parent journal exists, allow this step to draft a new workflow-set plan and create the parent journal only after explicit user approval.
- If a parent journal exists, require `name` and `kind: "workflow-set"`.
- If an existing journal has no `name` or `kind`, stop and report it as invalid.
- If an existing journal has top-level `feature`, stop and report it as invalid.
- If an existing journal has `kind: "feature"`, stop and ask whether the user wants a different workflow-set name.
- If an existing journal has an unknown `kind`, stop and ask for correction.
- Do not create child workflows in this step.
- If the idea fits one feature workflow, recommend the normal Step 01 flow instead.

## Draft Output

Load `templates/01-workflow-set-plan.md` before drafting the artifact.

The plan must include the large idea, source inputs, decomposition rationale, proposed child workflows, child names, titles, kinds, scopes, predecessor relationships by name, all-or-nothing scaffold policy, and approval status.

## Plan Materialization Modes

Ask how to handle the plan:

1. Write it and mark it complete.
2. Write it as a draft and wait for review.
3. Do not write files yet.

Writing or completing the plan does not approve child scaffolding unless the user explicitly approves scaffold. Scaffold approval never substitutes for completing the plan; Step 02 may run only after `01-workflow-set-plan` is complete.

## Approval Protocol

- Save or update artifacts only after explicit approval.
- On rejection, requested changes, hold, or ambiguous approval, do not persist progress; clarify or wait.
- Do not infer approval to scaffold children from approval to write or complete the plan.
- If the user approves scaffold while the plan is still pending, ask whether to mark the plan complete first and keep Step 02 blocked until that completion is approved and saved.
- If writes are unavailable, stop and report the limitation.

## Save Flow After Approval

1. Create or update `.sldd/specs/<workflow-set-name>/01-workflow-set-plan.md`.
2. Create or update `_spec-journal.json` with `name` and `kind: "workflow-set"`.
3. When creating a new parent journal, initialize it with:
   - `name: "<workflow-set-name>"`
   - `kind: "workflow-set"`
   - `steps["01-workflow-set-plan"]`
   - `steps["02-scaffold-children"]`
   - `steps["03-verify-workflow-set"]`
   - `workflowSet.children` from the proposed plan, with scaffold state `proposed`
4. For write-complete mode, mark `01-workflow-set-plan` complete and keep `02-scaffold-children` pending.
5. For write-draft mode, keep `01-workflow-set-plan` pending.
6. For no-write mode, do not create or update files.
7. Ask whether to continue, revise, approve scaffold, or hold.

## Response Format

1. Gate and resume check result
2. Draft summary with required workflow-set plan headings
3. Materialization mode prompt
4. Approval request and continue/hold prompt
