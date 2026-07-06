# Step 01: Product Intent Specification

## Objective

Define and validate product intent for downstream steps.

## Gate + Resume Checks

- Reject jump-ahead requests to design, tests, or implementation.
- If resuming from `_spec-journal.json` or legacy `SPEC.md`, reject invalid state where later steps are complete but Step 01 is not.
- Before creating a normal Step 01 for a new large idea, recommend workflow-set planning when decomposition clearly improves safety, clarity, or parallel execution.
- For any workflow with `relationships.predecessors`, verify every predecessor journal exists and has Step 06 complete before marking Step 01 complete.

## Draft Output

Load `templates/01-product-intent-specification.md` before drafting the artifact.

Use `00-exploration-summary.md` only as non-binding context for product intent, behavior, scope, risks, assumptions, and success metrics. Approved numbered artifacts override it.

Use an approved and saved Step 99 from brownfield exploration only as context for risks, assumptions, constraints, dependencies, and out-of-scope boundaries. Do not import architecture or implementation observations as product requirements unless explicitly approved as Step 01 decisions.

For a child workflow scaffolded from a workflow-set, use the existing Step 01 draft as the starting point. For any workflow with `relationships.predecessors`, do not mark Step 01 complete until every listed predecessor journal has Step 06 verification complete.

If any predecessor is missing or incomplete, Step 01 may be drafted, saved, reviewed, or revised, but it must remain `pending` with a `reason` explaining the predecessor gate. Do not route to Step 02+.

Wait for approval.

## Approval Protocol

- Save or update artifacts only after explicit approval.
- On rejection, requested changes, hold, or ambiguous approval, do not persist progress; clarify or wait.
- If writes are unavailable, stop and report the limitation.

## Save Flow After Approval

1. Save only Step 01 content to the resolved workflow directory as `01-product-intent-specification.md`; for new workflows, this is `.sldd/specs/<feature-name>/01-product-intent-specification.md`.
2. If `relationships.predecessors` exists and any predecessor is missing or incomplete, keep `01-product-intent` as `pending`, preserve the artifact link, set `reason` to the predecessor-gate explanation, and route to the incomplete predecessor instead of continuing.
3. Otherwise, mark `01-product-intent` as `complete` in journal-only `_spec-journal.json` with the artifact link.
4. Ask whether to continue to the next step or hold.

For legacy or user-provided workflow paths, save and update progress in the resolved directory instead.

## Response Format

1. Gate and resume check result
2. Draft summary with required Step 01 headings
3. Approval request
4. Continue/hold prompt
