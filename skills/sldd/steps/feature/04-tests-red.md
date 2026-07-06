# Step 04: Tests First Red Phase

## Objective

Execute strict Red phase by creating tests first, proving they fail, and marking Step 04 complete after Red confirmation.

## Gate + Resume Checks

- Require Step 01, Step 02, and Step 03 complete.
- For existing codebases, require Step 99 complete and current.
- Reject skip-ahead requests to implementation.
- Reject inconsistent journal states.
- On interrupted resume, re-evaluate the journal, current files, and relevant test results before deciding whether Step 04 is pending, complete, or superseded.

## Interrupted Workflow Resume Rules

- Always re-evaluate Step 04 on resume, even if `_spec-journal.json` or legacy `SPEC.md` marks Step 04 complete.
- Inspect existing test files and production changes before writing anything.
- Run the relevant tests again when the current Red/Green state cannot be determined from files alone.
- If the relevant tests fail for the expected missing behavior, mark Step 04 complete with `status: "complete"` and `evidence: "red_confirmed"`.
- If the relevant tests already pass, infer that Step 05 may have been partially or fully executed; route to Step 05 or Step 06 based on journal state and current verification.
- If test changes, production changes, or journal state are ambiguous, stop and ask for direction before modifying files or progress.
- Never revert user changes while resuming. Work with the current state.

## Strict Red-Phase Contract

- Tests first; no production logic.
- Minimal stubbing: create only production files and signatures strictly required for the test to compile.
- Allowed stubs: method or function signatures and class structure only.
- Every stub method must immediately raise a runtime error or equivalent.
- No business logic, validation logic, placeholder return values, or delegating calls to other stubs.
- Every Step 04 test run must fail.
- Production file creation is limited to minimal stubs strictly required for tests to compile.

## Execution Protocol

Execute Step 04 directly when Step 01 acceptance criteria and Step 03 test scenarios are approved, clear, and sufficient.

Create only executable tests directly traceable to approved Step 01 acceptance criteria and Step 03 scenarios, including executable tests or verification checks for approved architectural constraints from Step 03, including persistence mechanism, security mechanism, serialization choice, and cross-module boundaries when those constraints are part of the approved design. Mandatory Step 03 architecture decisions require explicit Red-phase coverage through tests, build checks, dependency checks, configuration checks, contract checks, or documented environment-gated verification. If extra behavior, edge cases, test layers, assumptions, or non-obvious stubs are needed, stop and route back to Step 01 or Step 03 instead of expanding scope.

After execution, present failing-output evidence and repository state. This conversational snapshot may continue directly to Step 05.

Use these required Step 04 snapshot headings:

- Test Files Created
- Acceptance Criteria -> Tests Mapping
- Test Commands Executed
- Failing Results Summary
- Red-Phase Confirmation

## Required Evidence

- Acceptance criteria and Step 03 test scenarios -> tests mapping
- Coverage of the Step 03 Test Scenario Catalog
- Traceability from approved Step 01 behavior and Step 03 test scenarios into concrete tests
- Use `00-exploration-summary.md` only as non-binding context; do not create tests from summary-only decisions
- At least one approved or directly implied edge case per criterion
- Exact test commands
- Failing output summary
- Explicit Red confirmation
- Mandatory Architecture Decision Coverage: for every `mandatory` decision from Step 03, include at least one executable test, build check, dependency check, configuration check, contract test, or documented environment-gated verification. The Red-phase snapshot must include a table with `Decision ID`, `Required mechanism`, `Test/check file or command`, and `Expected Red reason`.

Step 04 must not be marked `red_confirmed` if any mandatory Step 03 architecture decision lacks a test or check strategy, unless Step 03 explicitly marks that decision as not testable in this workflow and provides an approved manual verification method.

If an edge case requires new behavior or assumptions, stop and route back to Step 01 or Step 03.

## Approval Protocol

- Do not require a separate Step 04 execution approval when approved Step 01, Step 02, and Step 03 artifacts clearly define the acceptance criteria, constraints, and test scenarios.
- Ask for explicit approval before writing tests or running commands only when Step 04 detects ambiguity, scope expansion, missing test scenarios, unclear commands, or non-obvious minimal stubbing needs.
- If the user requested continuous execution from Step 04 to Step 05, route directly to Step 05 after Red confirmation without asking for another approval between the steps.
- On rejection, requested changes, hold, or ambiguous approval, do not write, run, save, or route forward; clarify or wait.
- If writes are unavailable, stop and report the limitation.

## Save Flow After Red Confirmation

1. Do not create a mandatory Step 04 report artifact.
2. Update `_spec-journal.json` step `04-tests-red` to `status: "complete"` and `evidence: "red_confirmed"`.
3. Keep `_spec-journal.json` journal-only; do not include logs, report body, or numbered artifact content.
4. If continuous Step 04 -> Step 05 execution was requested, route directly to Step 05.
5. Otherwise, ask whether to continue to the next step or hold.

For legacy or user-provided workflow paths, update progress in the resolved journal instead.

## Response Format

### Execution Response

1. Gate and resume check result
2. Red-phase execution snapshot
3. Journal update summary
4. Continue/hold prompt, unless continuous Step 04 -> Step 05 execution was already requested

### Blocked Response

1. Gate and resume check result
2. Reason Step 04 cannot execute directly
3. Required clarification, approval, or route back to Step 01 or Step 03
