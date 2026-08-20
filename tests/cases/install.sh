#!/usr/bin/env bash
# Installation, cleanup and summary behavior of installSkills.

test_missing_target_directory_is_created() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" 'y
' --target "${fixture}/deeply/nested/target"
    assert_status 0
    assert_directory "${fixture}/deeply/nested/target"
    assert_symlink_to "${fixture}/deeply/nested/target/alpha" "${fixture}/skills/alpha"
}

test_symlink_install_reports_counters() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" 'y
' --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains 'Creating symbolic link'
    assert_stdout_contains '  link            alpha'
    assert_stdout_contains '  links created:       1'
    assert_stdout_contains '  copies created:      0'
    assert_stdout_contains 'Done.'
}

test_copy_install_creates_real_directory_tree() {
    local fixture
    fixture="$(new_fixture alpha)"
    mkdir -p "${fixture}/skills/alpha/references/deep"
    printf 'reference\n' >"${fixture}/skills/alpha/references/deep/notes.md"
    run_installer "${fixture}" 'y
' --copy --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains 'Copying skill files'
    assert_stdout_contains '  copy            alpha'
    assert_directory "${fixture}/target/alpha"
    assert_regular_file "${fixture}/target/alpha/SKILL.md"
    assert_file_content "${fixture}/target/alpha/references/deep/notes.md" 'reference'
    assert_stdout_contains '  links created:       0'
    assert_stdout_contains '  copies created:      1'
}

test_copies_are_independent_from_source() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" 'y
' --copy --target "${fixture}/target"
    assert_status 0
    printf '# changed\n' >"${fixture}/skills/alpha/SKILL.md"
    assert_file_content "${fixture}/target/alpha/SKILL.md" '# alpha'
}

test_previous_symlink_is_removed_before_install() {
    local fixture
    fixture="$(new_fixture alpha)"
    mkdir -p "${fixture}/target" "${fixture}/stale"
    ln -s "${fixture}/stale" "${fixture}/target/alpha"
    run_installer "${fixture}" 'y
' --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains '  remove symlink  alpha'
    assert_stdout_contains '  symlinks removed:    1'
    assert_symlink_to "${fixture}/target/alpha" "${fixture}/skills/alpha"
}

test_previous_directory_is_removed_recursively_before_install() {
    local fixture
    fixture="$(new_fixture alpha)"
    mkdir -p "${fixture}/target/alpha/references"
    printf 'old\n' >"${fixture}/target/alpha/references/old.md"
    run_installer "${fixture}" 'y
' --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains '  remove dir      alpha'
    assert_stdout_contains '  directories removed: 1'
    assert_symlink_to "${fixture}/target/alpha" "${fixture}/skills/alpha"
}

test_exact_previous_entries_are_removed_prefixed_entries_are_ignored() {
    local fixture
    fixture="$(new_fixture alpha)"
    mkdir -p "${fixture}/target/alpha-backup" "${fixture}/unrelated" "${fixture}/target/alphabet"
    ln -s "${fixture}/unrelated" "${fixture}/target/alpha-old"
    run_installer "${fixture}" 'y
' --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains '  none'
    assert_directory "${fixture}/target/alpha-backup"
    assert_symlink_to "${fixture}/target/alpha-old" "${fixture}/unrelated"
    assert_directory "${fixture}/target/alphabet"
    assert_symlink_to "${fixture}/target/alpha" "${fixture}/skills/alpha"
}

# A regular file occupying the exact skill name is reported as a skipped file, the
# symlink cannot be created, the skill is marked failed, and the summary exits 1.
test_previous_regular_file_is_skipped_and_marked_failed() {
    local fixture
    fixture="$(new_fixture alpha)"
    mkdir -p "${fixture}/target"
    printf 'not a skill\n' >"${fixture}/target/alpha"
    run_installer "${fixture}" 'y
' --target "${fixture}/target"
    assert_status 1
    assert_stdout_contains '  skip file       alpha'
    assert_stdout_contains '  skills failed:       1'
    assert_stderr_contains "skill 'alpha' was not installed"
    assert_stderr_contains 'cannot create symbolic link'
    assert_stderr_contains 'retry with --copy'
    assert_regular_file "${fixture}/target/alpha"
    assert_file_content "${fixture}/target/alpha" 'not a skill'
}

test_unrelated_target_entries_are_preserved() {
    local fixture
    fixture="$(new_fixture alpha)"
    mkdir -p "${fixture}/target/beta"
    printf 'keep\n' >"${fixture}/target/beta/SKILL.md"
    run_installer "${fixture}" 'y
' --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains '  none'
    assert_file_content "${fixture}/target/beta/SKILL.md" 'keep'
}

test_reinstall_is_idempotent() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" 'y
' --target "${fixture}/target"
    assert_status 0
    run_installer "${fixture}" 'y
' --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains '  remove symlink  alpha'
    assert_symlink_to "${fixture}/target/alpha" "${fixture}/skills/alpha"
}

test_switching_from_copy_to_symlink_replaces_the_entry() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" 'y
' --copy --target "${fixture}/target"
    assert_status 0
    assert_directory "${fixture}/target/alpha"
    run_installer "${fixture}" 'y
' --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains '  remove dir      alpha'
    assert_symlink_to "${fixture}/target/alpha" "${fixture}/skills/alpha"
}

test_summary_aggregates_multiple_skills() {
    local fixture
    fixture="$(new_fixture alpha beta gamma)"
    mkdir -p "${fixture}/target/alpha" "${fixture}/stale"
    ln -s "${fixture}/stale" "${fixture}/target/beta"
    run_installer "${fixture}" 'y
y
n
' --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains '  skills installed:    2'
    assert_stdout_contains '  skills skipped:      1'
    assert_stdout_contains '  skills failed:       0'
    assert_stdout_contains '  symlinks removed:    1'
    assert_stdout_contains '  directories removed: 1'
    assert_stdout_contains '  files skipped:       0'
    assert_stdout_contains '  links created:       2'
    assert_stdout_contains '  copies created:      0'
}
