# Workflow: Workflow-Set

## Objective

Plan and scaffold a set of related child feature workflows for large initiatives, epics, products, multi-module work, broad system plans, or requests that need decomposition.

## Flow

```text
01-workflow-set-plan -> 02-scaffold-children -> 03-verify-workflow-set
```

Workflow-set parents plan and scaffold child workflows. They do not execute children, approve child Step 01 (`01-product-intent`), enforce child implementation gates, or persist child execution progress.

## Step Files

Load exactly one file from this map after this workflow has selected the current step:

| Step | File | Purpose |
|---|---|---|
| 01-workflow-set-plan | `steps/workflow-set/01-workflow-set-plan.md` | Parent decomposition plan |
| 02-scaffold-children | `steps/workflow-set/02-scaffold-children.md` | Create approved child workflow drafts |
| 03-verify-workflow-set | `steps/workflow-set/03-verify-workflow-set.md` | Verify coordination consistency |

## Template Map

Load only the template needed by the selected step:

| Artifact | Template |
|---|---|
| `01-workflow-set-plan.md` | `templates/01-workflow-set-plan.md` |
| `01-product-intent-specification.md` from workflow-set scaffold | `templates/01-product-intent-from-workflow-set.md` |

## Gate Rules

- Workflow-set planning requires explicit approval.
- A new workflow-set parent journal may be created only after explicit approval.
- Existing journals without `name` or `kind` are invalid and must not be routed automatically.
- Existing journals with `kind: "feature"` stop the workflow-set path and require a different workflow-set name or explicit user direction.
- Child scaffolding requires `01-workflow-set-plan` complete and separate explicit scaffold approval.
- Scaffold is all-or-nothing for all proposed children in the approved plan.
- Child workflows scaffolded from a workflow-set are `feature` workflows.
- Scaffolded child `01-product-intent` entries must remain `pending` and include `origin.type: "workflow-set-scaffold"`.
- Parent journals must not persist child execution progress. Compute child progress by reading child journals when needed.

Workflow-set child scaffold states are only:

- `proposed`
- `created`
- `conflict`

These states describe materialization only, not child execution progress.

## Completion Rule

This kind of workflow is complete when `steps["03-verify-workflow-set"].status == "complete"`.

## Resume Rules

1. Resolve the workflow-set name and journal path from user input, current context, or available specs.
2. Require an existing parent journal to have `name` and `kind: "workflow-set"`.
3. Reject existing parent journals without `name` or `kind`.
4. Reject journals that use top-level `feature` as the workflow name field.
5. Require top-level `workflowSet` on workflow-set parent journals.
6. If the user explicitly approved creating a new workflow-set and no parent journal exists, route to `01-workflow-set-plan` instead of treating the missing journal as a resume failure.
7. Validate that referenced Markdown artifacts exist.
8. Resume pending parent workflow-set steps first.
9. If the parent is complete, compute a read-only child overview by reading child journals.
10. Do not write child progress to the parent journal.
11. Do not auto-select a child when multiple children are pending or actionable.
12. Load only the required workflow-set step file.

If journal, artifacts, scaffold state, child journal state, or filesystem state conflict, stop and ask for direction before writing or routing forward.

## Completed-Step Reruns

If the target workflow-set step is already `complete`, stop before loading the step and ask the user to choose:

1. Run it again only.
2. Run it again and mark later completed workflow-set steps as `requires_rerun`.
3. Do nothing.

For option 1, run the step only after explicit confirmation and record a journal-only note if the target step changes without downstream invalidation. For option 2, after the target step completes through its normal approval or confirmation flow, mark later completed workflow-set steps as `requires_rerun`.

## Response Format

1. Resolved workflow-set and journal
2. Parent step validation result
3. Child scaffold or child overview summary when relevant
4. Violations or conflicts, if any
5. Loaded workflow-set step file and next action
