# Workflow: Feature

## Objective

Run the normal SLDD feature workflow for isolated features, bugfixes, endpoints, local refactors, component documentation, and other single-workflow changes.

## Flow

```text
88-exploration (optional) -> 00-navigation -> 01-product-intent -> 99-codebase-context when needed -> 02-high-level-design -> 03-low-level-design -> 04-tests-red -> 05-implementation-green -> 06-verification
```

The formal feature gate order is:

```text
01-product-intent -> 99-codebase-context -> 02-high-level-design -> 03-low-level-design -> 04-tests-red -> 05-implementation-green -> 06-verification
```

Step 99 is required before Step 02 for existing codebases. It may run during Step 88 when brownfield context is needed. Step 99 completion requires an approved and saved `existing-codebase-understanding.md` artifact.

## Step Files

Load exactly one file from this map after this workflow has selected the current step:

| Step ID | File | Purpose |
|---|---|---|
| `88-exploration` | `steps/feature/88-exploration.md` | Explore rough ideas before Step 01 |
| `00-navigation` | `steps/feature/00-navigation.md` | Inspect state and route |
| `01-product-intent` | `steps/feature/01-product-intent.md` | Product intent and acceptance criteria |
| `99-codebase-context` | `steps/feature/99-codebase-context.md` | Existing-codebase context |
| `02-high-level-design` | `steps/feature/02-high-level-design.md` | High-level technical design |
| `03-low-level-design` | `steps/feature/03-low-level-design.md` | Low-level design and version policy |
| `04-tests-red` | `steps/feature/04-tests-red.md` | Tests-first Red phase |
| `05-implementation-green` | `steps/feature/05-implementation-green.md` | Minimal Green implementation |
| `06-verification` | `steps/feature/06-verification.md` | Verification and Go/No-Go |

## Template Map

Load only the template needed by the selected step:

| Artifact | Template |
|---|---|
| `00-exploration-summary.md` | `templates/00-exploration-summary.md` |
| `01-product-intent-specification.md` | `templates/01-product-intent-specification.md` |
| `existing-codebase-understanding.md` | `templates/existing-codebase-understanding.md` |
| `02-high-level-technical-design.md` | `templates/02-high-level-technical-design.md` |
| `03-low-level-design-and-version-policy.md` | `templates/03-low-level-design-and-version-policy.md` |
| `06-verification-and-feedback-report.md` | `templates/06-verification-and-feedback-report.md` |

## Gate Rules

- No implementation prompts or code changes before Step 01, Step 02, and Step 03 are approved.
- For existing codebases, Step 99 must be complete and current before Step 02.
- For any workflow with `relationships.predecessors`, every predecessor journal must exist and have Step 06 complete before Step 01 may be marked complete or Step 02+ may be loaded.
- If any predecessor is missing or incomplete, keep Step 01 and any drafted Step 99 context pending, preserve artifact links as drafts, record the predecessor-gate reason, and route to the predecessor instead of advancing.
- Step 04 must stay Red-only.
- Step 03 must identify mandatory architecture decisions that constrain Step 04, Step 05, and Step 06.
- Step 04 must define tests or checks for every mandatory Step 03 architecture decision.
- Step 05 must make the minimum production changes needed to pass Step 04 tests, must not modify Step 04 tests, and must follow applicable repository or context-provided agent instructions.
- Step 05 must satisfy every mandatory Step 03 architecture decision before `green_confirmed`; unapproved substitutes, fakes, in-memory implementations, opaque-token replacements, demo-only mechanisms, or local-only fallbacks are violations.
- Step 06 must produce a decision-by-decision architecture compliance matrix. Any violated mandatory decision forces No-Go.
- Child workflows scaffolded from a workflow-set are normal feature workflows. They start with `01-product-intent` pending and `origin.type: "workflow-set-scaffold"`.

## Completion Rule

This kind of workflow is complete when `steps["06-verification"].status == "complete"`.

## Resume Rules

1. Resolve the requested workflow and journal path from user input, current context, or available specs.
2. Prefer `.sldd/specs/<feature-name>/_spec-journal.json`.
3. Require existing `_spec-journal.json` files to include `name` and `kind: "feature"`; journals without `name` or `kind` are invalid.
4. Reject journals that use top-level `feature` as the workflow name field.
5. Reject `kind: "feature"` journals that include top-level `workflowSet`.
6. Validate that referenced Markdown artifacts exist.
7. Validate predecessor completion when `relationships.predecessors` exists.
8. Detect out-of-order completions or missing prerequisites.
9. For Step 99, validate freshness and relevance before reuse.
10. For Step 04 and Step 05, re-evaluate repository state and relevant test results before trusting journal evidence.
11. Load only the required feature step file.

If predecessor validation fails, stop and route the user to the incomplete predecessor workflow. If journal, artifacts, repository state, or test results conflict, stop and ask for direction before writing or routing forward.

## Completed-Step Reruns

If the target step is already `complete`, stop before loading the step and ask the user to choose:

1. Run it again only.
2. Run it again and mark later completed steps as `requires_rerun`.
3. Do nothing.

For option 1, run the step only after explicit confirmation and record a journal-only note if the target step changes without downstream invalidation. For option 2, after the target step completes through its normal approval or confirmation flow, mark later completed steps in gate order as `requires_rerun`.

When invalidating Step 04 or Step 05, clear `evidence`; keep any existing `artifact` link as a historical reference.

## Response Format

1. Resolved feature workflow and journal
2. Completed steps and validation result
3. Violations or conflicts, if any
4. Loaded feature step file and reason
5. Next action or approval request
