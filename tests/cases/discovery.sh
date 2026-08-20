#!/usr/bin/env bash
# Skill discovery behavior of installSkills.

test_missing_skills_directory_fails() {
    local fixture
    fixture="$(new_fixture)"
    rmdir "${fixture}/skills"
    run_installer "${fixture}" '' --target "${fixture}/target"
    assert_status 1
    assert_stderr_contains "Error: skills source directory not found: ${fixture}/skills"
    assert_stderr_contains 'Place this script in the repository root before running it.'
    assert_absent "${fixture}/target"
}

test_empty_skills_directory_fails() {
    local fixture
    fixture="$(new_fixture)"
    run_installer "${fixture}" '' --target "${fixture}/target"
    assert_status 1
    assert_stderr_contains "Error: no skills found under: ${fixture}/skills"
    assert_stderr_contains 'Each skill directory must contain a SKILL.md file.'
}

test_directory_without_skill_file_is_not_a_skill() {
    local fixture
    fixture="$(new_fixture)"
    mkdir -p "${fixture}/skills/not-a-skill"
    printf 'notes\n' >"${fixture}/skills/not-a-skill/README.md"
    run_installer "${fixture}" '' --target "${fixture}/target"
    assert_status 1
    assert_stderr_contains 'Error: no skills found under:'
}

test_loose_files_in_skills_directory_are_ignored() {
    local fixture
    fixture="$(new_fixture alpha)"
    printf 'ignored\n' >"${fixture}/skills/SKILL.md"
    printf 'ignored\n' >"${fixture}/skills/notes.txt"
    run_installer "${fixture}" 'n
' --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains "Install skill 'alpha'? [y/N]"
    assert_stdout_missing "Install skill 'notes.txt'?"
    assert_stdout_contains '  skills skipped:      1'
}

test_skills_are_prompted_in_alphabetical_order() {
    local fixture
    fixture="$(new_fixture gamma alpha beta)"
    run_installer "${fixture}" 'n
n
n
' --target "${fixture}/target"
    assert_status 0
    assert_stdout_order \
        "Install skill 'alpha'?" \
        "Install skill 'beta'?" \
        "Install skill 'gamma'?"
    assert_stdout_contains '  skills skipped:      3'
}

test_nested_directory_without_skill_file_is_skipped_while_siblings_install() {
    local fixture
    fixture="$(new_fixture alpha)"
    mkdir -p "${fixture}/skills/incomplete/references"
    run_installer "${fixture}" 'y
' --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains "Install skill 'alpha'? [y/N]"
    assert_stdout_missing "Install skill 'incomplete'?"
    assert_symlink_to "${fixture}/target/alpha" "${fixture}/skills/alpha"
}
