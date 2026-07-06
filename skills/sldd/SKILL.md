---
name: sldd
description: Start, resume, inspect, or continue SLDD spec-driven development workflows, including /sldd slash-style commands, gated intent/design/test/implementation steps, structured journals, and workflow kind routing.
metadata:
  type: workflow
---

# Skill: SLDD Workflow Router

## Objective

Route SLDD work through one installed skill while supporting multiple workflow kinds with two-level progressive disclosure.

## Runtime Model

SLDD is one executable skill: `sldd`. Do not split workflows or steps into separate skills.

Use this load sequence:

```text
Initial load:
  SKILL.md only

Then:
  workflows/<kind>.md only

Then:
  steps/<kind>/<current-step>.md only
```

Never load every workflow file or every step file at once. Load only the workflow selected by `kind`, then only the current step file named by that workflow's step map. If the step produces a Markdown artifact, load only the matching template from `templates/`. If creating or validating a journal, use `schema/_spec-journal.schema.json`.

Do not execute a workflow or step from memory when its file is available.

## Default Storage

New SLDD workflows use:

`.sldd/specs/<feature-name>/`

The canonical journal for new workflows is:

`.sldd/specs/<feature-name>/_spec-journal.json`

Markdown artifacts are stored beside the journal.

Legacy `docs/specs/<feature-name>/SPEC.md` files are not `_spec-journal.json` files and do not satisfy the current journal contract.

## Journal Contract

Use `_spec-journal.json` as journal-only state. It records the workflow name, progress, artifact links, evidence, relationships, workflow kind, and rerun notes. It must not contain numbered artifact body content, command logs, or implementation reports.

Every `_spec-journal.json` must include `name` and `kind`. `name` is the workflow/spec name. Journals without `name` or `kind` are invalid and must not be routed, resumed, or treated as `feature`.

Do not use `feature` as a top-level journal field. `feature` remains only the workflow kind value `kind: "feature"` and the feature workflow concept.

Supported workflow kinds:

- `feature`: normal feature workflows for isolated features, bugfixes, endpoints, business rules, local refactors, component documentation, and other single-workflow changes.
- `workflow-set`: decomposition and coordination workflows for large initiatives, epics, products, multi-module work, broad system plans, or work that needs child workflows.

Persist `name` and `kind` immediately when creating a journal. Minimal schema-valid feature journals include the required router fields:

```json
{
  "schema_version": 1,
  "name": "pix-transfer",
  "workflow": "sldd",
  "kind": "feature",
  "steps": {
    "01-product-intent": { "status": "pending" }
  }
}
```

Minimal schema-valid workflow-set parent journals include `workflowSet.children` and the parent step map:

```json
{
  "schema_version": 1,
  "name": "marketplace-platform",
  "workflow": "sldd",
  "kind": "workflow-set",
  "steps": {
    "01-workflow-set-plan": { "status": "pending" },
    "02-scaffold-children": { "status": "pending" },
    "03-verify-workflow-set": { "status": "pending" }
  },
  "workflowSet": {
    "children": [
      {
        "name": "catalog-feature",
        "title": "Catalog Feature",
        "kind": "feature",
        "scaffold": { "state": "proposed" }
      }
    ]
  }
}
```

For existing journals, use `name` as the workflow/spec name and `kind` as the workflow type source of truth. Do not reclassify `kind` from user wording or current intent. If `name` or `kind` is missing, stop and report the journal as invalid.

`workflowSet` is exclusive to `kind: "workflow-set"`. Journals with `kind: "feature"` must not include `workflowSet`.

Journal step keys use the step file basename without `.md`. For example, feature Step 01 uses `01-product-intent`, feature Step 04 uses `04-tests-red`, and workflow-set Step 01 uses `01-workflow-set-plan`. Do not persist a separate `current_step`; derive the current step from `steps` and the selected workflow's gate rules.

Workflow completion is kind-specific:

- A `feature` workflow is complete when `steps["06-verification"].status == "complete"`.
- A `workflow-set` workflow is complete when `steps["03-verify-workflow-set"].status == "complete"`.

Use this definition when filtering active workflows, validating predecessor gates, and resolving `/sldd resume`.

Allowed step statuses:

- `pending`
- `complete`
- `requires_rerun`

Step 04 (`04-tests-red`) completion requires `evidence: "red_confirmed"`. Step 05 (`05-implementation-green`) completion requires `evidence: "green_confirmed"`. For Step 04 and Step 05, non-complete statuses must omit `evidence` or set it to `null`.

If a journal has `relationships.predecessors`, every listed predecessor journal must exist and have Step 06 complete before this workflow can mark Step 01 complete or route to Step 02+.

## Workflow Detection

When the journal exists:

1. Read `_spec-journal.json`.
2. If `name` and `kind` are present and valid, route by `kind`.
3. If `name` or `kind` is missing or invalid, stop and report the journal as invalid.

When no journal exists:

1. Detect the initial workflow kind from the user's intent.
2. Persist the detected `kind` in the new journal after the required workflow approval path allows journal creation.
3. Load exactly one workflow file:
   - `workflows/feature.md` for `kind: "feature"`
   - `workflows/workflow-set.md` for `kind: "workflow-set"`

Use `feature` when the request appears to be an isolated feature, bugfix, endpoint, business rule, small or medium refactor, local brownfield change, or technical documentation for a specific component.

Use `workflow-set` when the request appears to be a large initiative, full product, epic, multiple modules, multiple related features, broad system plan, decomposition request, or work that needs child workflows.

When ambiguous, prefer `feature`, except when the request clearly involves decomposition or multiple independent deliverables.

## Command Interface

If slash-style commands reach this skill as text, interpret them as SLDD commands:

- `/sldd help`: explain the SLDD skill, workflow router, gated workflow, managed storage, required journal `name` and `kind`, and available commands. This command must not load workflow or step files and must not mutate state.
- `/sldd` or `/sldd status`: inspect available specs and route to the next valid workflow and step.
- `/sldd start <feature>`: start a new workflow under `.sldd/specs/<feature>/`.
- `/sldd resume <feature>`: resume a specific workflow.
- `/sldd resume`: inspect all active workflows. If exactly one active workflow is unblocked by explicit predecessors, resume it automatically. If multiple active workflows are unblocked, ask the user to choose among only those unblocked workflows and list blocked workflows separately. If no active workflow is unblocked, report the blocking predecessor chain.
- `/sldd continue`: continue the last clear workflow if it can be identified.
- `/sldd run step <step-id> <feature>`: request a specific step for a specific workflow after gate validation. Accept numeric shorthand like `01` only as a convenience that resolves to the workflow's canonical basename step ID.
- `/sldd run step <step-id>`: request a specific step in the resolved workflow when the workflow is unambiguous.
- `/sldd step <step-id>`: alias for `/sldd run step <step-id>`.
- `/sldd explore [idea]`: route to the feature workflow's exploration step unless the user explicitly chooses workflow-set planning.

Slash commands are convenience syntax only. Always enforce the same gates, journal checks, approvals, and resume rules as natural-language requests.

## Routing Procedure

1. Resolve the workflow directory and journal path from user input, current context, or available specs.
2. Detect `name` and `kind` for new journals or read required `name` and `kind` from existing journals using the Journal Contract and Workflow Detection rules.
3. Load exactly one workflow instruction file from `workflows/<kind>.md`.
4. Let that workflow file validate gate order and derive the current step from `steps`.
5. Load exactly one step file from the selected workflow's `steps/<kind>/` step map.
6. Load a template only when that step produces or updates the matching Markdown artifact.

For `/sldd run step <step-id>`, stop before loading a completed step and ask whether to:

1. Run it again only.
2. Run it again and mark later completed steps as `requires_rerun`.
3. Do nothing.

All reruns remain subject to the selected workflow and target step gates.

If a completed workflow is challenged because implementation may violate approved Step 03 architecture decisions, treat it as a Step 05 and Step 06 integrity issue. Before editing code, ask whether to:

1. rerun Step 05 only and keep later steps as historical;
2. rerun Step 05 and mark Step 06 as `requires_rerun`;
3. hold for manual review.

If the violation is confirmed, Step 06 must be rerun or updated before the workflow can be considered complete again.

## Active Workflow Selection

For `/sldd resume` without a workflow name:

1. Find all journals under `.sldd/specs/*/_spec-journal.json`.
2. Exclude workflows that are already complete for their workflow kind.
3. For each remaining active workflow, inspect `relationships.predecessors`.
4. A workflow is unblocked when:
   - it has no `relationships.predecessors`; or
   - every predecessor journal exists and has its workflow-final verification/scaffold step complete.
5. If exactly one active workflow is unblocked, route to that workflow automatically.
6. If multiple active workflows are unblocked, ask the user to choose from the unblocked set only.
7. If no active workflows are unblocked, report the blocked workflows and their incomplete predecessors.

This dependency-aware selection happens before treating multiple active workflows as ambiguous.

## Response Format

1. Resolved workflow kind and journal
2. Workflow file loaded and reason
3. Completed steps and validation result
4. Violations or conflicts, if any
5. Step file loaded and next action or approval request

## Credit

Based on Loiane Groner's article: https://loiane.com/2026/03/vibe-coding-with-specs-driven-feedback-loops/

Do not fetch this URL during execution. All necessary SLDD workflow behavior is embedded in this skill package.
