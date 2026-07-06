# Step 02: Scaffold Children

## Objective

Create approved child feature workflow drafts from a completed workflow-set plan.

## Gate + Resume Checks

- Require parent journal `kind: "workflow-set"`.
- Require `01-workflow-set-plan` complete.
- Require explicit approval to scaffold children after the plan is complete.
- Scaffold all proposed children in the approved plan, or create none when preflight validation fails.
- Do not mark child Step 01 (`01-product-intent`) complete.
- Do not overwrite existing workflow artifacts without explicit approval.

If the user approves scaffold while `01-workflow-set-plan` is still pending,
stop and ask whether to complete the workflow-set plan first. Do not route to
Step 02 or create child files until the plan is complete.

## Preflight Validation

Before writing child files, verify:

- Every proposed child has a stable `name`, `title`, `kind`, and scope.
- New child feature names use `-feature` unless the user approved a custom name.
- Child names are unique.
- Predecessors refer to known child workflows or existing local workflow journals.
- No predecessor cycles exist.
- Target child directories are checked for availability; filesystem collisions or unsafe overwrite risks are handled by Conflict Rules.
- Each child has enough information for a self-contained Step 01 draft.

If validation fails, create no children, report all issues, and route back to `01-workflow-set-plan` revision.

Preflight failures that indicate an invalid plan, missing child metadata, duplicate child names, predecessor cycles, or unresolved predecessor references must create no children, update no scaffold state, keep `02-scaffold-children` pending, and route back to `01-workflow-set-plan`.

## Scaffold Output

For each child, create:

```text
.sldd/specs/<child-name>/
  _spec-journal.json
  01-product-intent-specification.md
```

Use `templates/01-product-intent-from-workflow-set.md` for the child Step 01 draft.

Each child `01-product-intent` step must be `pending` and include `origin.type: "workflow-set-scaffold"`.

## Conflict Rules

On name collision, missing origin metadata, unsafe overwrite risk, or inconsistent existing child state:

- Stop before overwriting anything.
- Treat the issue as a scaffold conflict, not a successful child creation.
- Record parent scaffold state `conflict` with a concise reason only after explicit user approval to record the conflict.
- Ask the user to resolve by keeping existing files, renaming, revising the plan, or explicitly approving a safe update.
- Do not mark `02-scaffold-children` complete unless every proposed child is either created successfully or explicitly recorded as an accepted conflict.

## Save Flow After Scaffold

1. Create child Step 01 draft content.
2. Create child `_spec-journal.json` with `name`, `kind: "feature"`, `steps["01-product-intent"]`, and concrete predecessor journal paths.
3. Update parent child scaffold state to `created` only after child files exist.
4. Update parent child scaffold state to `conflict` only for conflicts the user explicitly accepted for recording.
5. Mark `02-scaffold-children` complete only when every proposed child is either created successfully or explicitly recorded as an accepted conflict.
6. Do not persist child execution progress in the parent journal.

## Response Format

1. Gate and validation result
2. Children created or conflicts recorded
3. Journal update summary
4. Continue/hold prompt
