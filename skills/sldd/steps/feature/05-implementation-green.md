# Step 05: Minimal Green Implementation

## Objective

Implement the minimum production changes required to pass Step 04 tests without modifying tests, respecting approved Step 03 constraints, Step 01 requirements, repository instructions, and agentic instructions present in context. The minimal production changes MUST not replace an approved architectural mechanism with an in-memory, fake, or temporary implementation unless Step 03 explicitly allows it. Mark Step 05 complete after Green confirmation.

## Gate + Resume Checks

- Require Steps 01-04 complete.
- Load the approved Step 03 artifact and extract all `mandatory` architecture decisions before modifying production code.
- Refuse Step 05 execution if the Step 03 artifact does not identify mandatory architecture decisions clearly enough to distinguish required mechanisms from optional implementation details.
- Refuse Step 05 execution if Step 04 did not define a test or check strategy for each mandatory Step 03 architecture decision.
- Require Step 04 completion from `_spec-journal.json`, current failing test results, or continuous handoff from Step 04.
- For existing codebases, require Step 99 complete and current.
- Require repository instructions and agentic instructions present in context to be inspected and followed before implementation.
- Reject requests to modify tests or bypass Red/Green order.
- Reject inconsistent journal states.
- On interrupted resume, re-evaluate the journal, current files, and relevant test results before deciding whether Step 05 is pending or complete.

## Interrupted Workflow Resume Rules

- Always re-evaluate Step 04 and Step 05 on resume, even if `_spec-journal.json` or legacy `SPEC.md` marks one or both complete.
- Run the relevant Step 04 tests before modifying production code when the current state is not already clear.
- If the tests still fail, continue with the minimal implementation required to make them pass.
- If the tests already pass and test files were not modified after Step 04 completion, mark Step 05 complete with `status: "complete"` and `evidence: "green_confirmed"`.
- If Step 04 state is stale or ambiguous, re-run the relevant tests before implementation.
- If Step 04 tests appear to have been modified after Red confirmation, stop because test integrity may be compromised.
- If production implementation is partial, continue from the current state without reverting user changes.
- If journal state, file state, or test results conflict, stop and ask for direction before modifying files or progress.

## Execution Protocol

Execute Step 05 directly when Step 04 Red confirmation is approved, current failing tests are clear, Step 03 constraints are sufficient, and repository or context-provided agentic instructions have been inspected.

Implement only production changes required to pass existing Step 04 tests. If implementation requires new behavior, unclear architecture decisions, dependency changes, test changes, convention exceptions, or assumptions not approved by Step 03 and applicable repository or agentic instructions, stop and route back to Step 03 or ask for clarification instead of expanding scope.

Before editing production code, create an internal Architecture Guardrail Checklist from Step 03 with `Decision ID`, `Required mechanism`, `Fallback allowed?`, `Planned files`, and `Verification`. During implementation:

- Do not replace a mandatory mechanism with another mechanism.
- Do not use in-memory, fake, mock, opaque-token, local-map, filesystem, hardcoded, or demo-only substitutes unless Step 03 explicitly allows that substitute for the target environment.
- If the required mechanism cannot be implemented because of dependency, runtime, credential, network, database, container, or environment limits, stop and report the blocker. Do not implement an unapproved fallback.
- If the required mechanism can be implemented but cannot be fully tested locally, implement the approved mechanism and record the test limitation separately. Environment limitations do not authorize architectural substitution.

After implementation and verification, present passing evidence and repository state.

The execution snapshot must identify which Step 03 contracts, constraints, implementation steps, repository instructions, and context-provided agentic instructions were satisfied. Do not introduce behavior that is not required by Step 04 tests or approved by Step 03. Do not violate project-local conventions, architecture boundaries, file ownership rules, command restrictions, or agent instructions.

## Execution Output

Present:

- green-phase execution snapshot
- confirmation that tests were not modified

Use these required Step 05 snapshot headings:

- Production Files Changed
- Implementation Notes (Minimal Scope)
- Architecture Guardrail Compliance Matrix
- Repository and Agent Instruction Compliance
- Test Commands Executed
- Passing Results Summary
- Assumptions and Constraints
- Test Integrity Confirmation (No Test Modifications)

The `Architecture Guardrail Compliance Matrix` must list every mandatory Step 03 architecture decision with `Decision ID`, `Required mechanism`, `Implemented mechanism`, `Evidence files`, and `Status`. Allowed statuses are `satisfied`, `environment-blocked`, and `violated`. Step 05 must not be marked `green_confirmed` if any mandatory decision is `violated`. A mandatory decision may be `environment-blocked` only when the approved mechanism is implemented in production code, the blockage is limited to local verification infrastructure, no unapproved fallback was introduced, and remediation is recorded for Step 06.

## Approval Protocol

- Do not require a separate Step 05 execution approval when approved Step 01, Step 02, Step 03, and Step 04 artifacts clearly define the requirements, constraints, test failures, and implementation scope.
- Ask for explicit approval before modifying production code or running commands only when Step 05 detects ambiguity, scope expansion, missing applicable repository or agentic instructions, unclear commands, dependency changes, or convention exceptions.
- Do not require a separate approval after Green confirmation before updating `_spec-journal.json`.
- On rejection, requested changes, hold, or ambiguous approval, do not modify code, run, save, or route forward; clarify or wait.
- If writes are unavailable, stop and report the limitation.

## Verification

- Run tests and confirm previously failing tests pass.
- Record commands and results.

## Save Flow After Green Confirmation

1. Do not create a mandatory Step 05 report artifact.
2. Verify that every mandatory Step 03 architecture decision is marked `satisfied` or valid `environment-blocked` in the Architecture Guardrail Compliance Matrix.
3. Verify that no mandatory decision was substituted by an unapproved fallback, fake, mock, in-memory implementation, opaque token, or demo-only mechanism.
4. If any mandatory decision is blocked because the approved mechanism cannot be implemented, do not mark Step 05 as `green_confirmed`; route back to Step 03 for an approved degraded-mode decision or stop with a blocked response.
5. If implementation is complete but full verification is environment-blocked, Step 05 may be marked complete only when the approved mechanism is present in production code and all non-environment-blocked checks pass.
6. Update `_spec-journal.json` step `05-implementation-green` to `status: "complete"` and `evidence: "green_confirmed"`.
7. Keep `_spec-journal.json` journal-only; do not include logs, report body, or numbered artifact content.
8. Ask whether to continue to the next step or hold.

For legacy or user-provided workflow paths, update progress in the resolved journal instead.

## Response Format

### Execution Response

1. Gate and resume check result
2. Green-phase execution snapshot
3. Test integrity confirmation
4. Journal update summary
5. Continue/hold prompt

### Blocked Response

1. Gate and resume check result
2. Reason Step 05 cannot execute directly
3. Required clarification, approval, or route back to Step 03
