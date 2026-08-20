#!/usr/bin/env bash
# Confirmation prompt handling of installSkills.

test_lowercase_yes_word_is_accepted() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" 'yes
' --target "${fixture}/target"
    assert_status 0
    assert_symlink_to "${fixture}/target/alpha" "${fixture}/skills/alpha"
}

test_uppercase_answer_is_accepted() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" 'Y
' --target "${fixture}/target"
    assert_status 0
    assert_symlink_to "${fixture}/target/alpha" "${fixture}/skills/alpha"
}

test_padded_answer_is_accepted() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" '  YeS  
' --target "${fixture}/target"
    assert_status 0
    assert_symlink_to "${fixture}/target/alpha" "${fixture}/skills/alpha"
}

test_negative_answer_skips_skill() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" 'n
' --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains '  skip            alpha'
    assert_absent "${fixture}/target/alpha"
}

test_empty_answer_skips_skill() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" '
' --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains '  skip            alpha'
    assert_absent "${fixture}/target/alpha"
}

test_unrecognized_answer_skips_skill() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" 'maybe
' --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains '  skip            alpha'
    assert_absent "${fixture}/target/alpha"
}

test_closed_input_aborts_installation() {
    local fixture
    fixture="$(new_fixture alpha beta)"
    run_installer "${fixture}" '' --target "${fixture}/target"
    assert_status 1
    assert_stderr_contains "standard input closed before the prompt for skill 'alpha' was answered"
    assert_stderr_contains 'IllegalStateException'
    assert_absent "${fixture}/target/alpha"
    assert_absent "${fixture}/target/beta"
}

test_answers_are_applied_per_skill() {
    local fixture
    fixture="$(new_fixture alpha beta gamma)"
    run_installer "${fixture}" 'y
n
y
' --target "${fixture}/target"
    assert_status 0
    assert_symlink_to "${fixture}/target/alpha" "${fixture}/skills/alpha"
    assert_absent "${fixture}/target/beta"
    assert_symlink_to "${fixture}/target/gamma" "${fixture}/skills/gamma"
    assert_stdout_contains '  skills installed:    2'
    assert_stdout_contains '  skills skipped:      1'
}
