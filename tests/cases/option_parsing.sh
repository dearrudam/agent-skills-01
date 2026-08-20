#!/usr/bin/env bash
# Option parsing behavior of installSkills.

test_version_option_prints_script_name_and_version() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" '' --version
    assert_status 0
    assert_stdout_contains 'installSkills '
    assert_stdout_missing 'Skills development install'
}

test_short_version_option_is_supported() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" '' -version
    assert_status 0
    assert_stdout_contains 'installSkills '
}

test_help_option_prints_usage() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" '' --help
    assert_status 0
    assert_stdout_contains 'Usage: installSkills [--copy] [--target DIR] [--help] [--version]'
    assert_stdout_contains '--copy        Copy the skill files instead of creating symbolic links.'
    assert_stdout_contains '.agents/skills'
    assert_stdout_missing 'Skills development install'
}

test_short_help_option_is_supported() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" '' -h
    assert_status 0
    assert_stdout_contains 'Usage: installSkills'
}

test_help_takes_precedence_over_earlier_options() {
    local fixture target
    fixture="$(new_fixture alpha)"
    target="${fixture}/target"
    run_installer "${fixture}" '' --copy --target "${target}" --help
    assert_status 0
    assert_stdout_contains 'Usage: installSkills'
    assert_absent "${target}"
}

test_help_wins_over_version_when_listed_first() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" '' --help --version
    assert_status 0
    assert_stdout_contains 'Usage: installSkills'
}

test_unknown_option_fails_with_usage_on_stderr() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" '' --bogus
    assert_status 2
    assert_stderr_contains 'Error: unknown option or argument: --bogus'
    assert_stderr_contains 'Usage: installSkills'
    assert_stdout_empty
}

test_positional_argument_is_rejected() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" '' alpha
    assert_status 2
    assert_stderr_contains 'Error: unknown option or argument: alpha'
}

test_target_without_value_is_rejected() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" '' --target
    assert_status 2
    assert_stderr_contains 'Error: --target requires a directory path.'
}

test_target_followed_by_option_is_rejected() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" '' --target --copy
    assert_status 2
    assert_stderr_contains 'Error: --target requires a directory path.'
}

test_blank_target_value_is_rejected() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" '' --target '   '
    assert_status 2
    assert_stderr_contains 'Error: --target requires a directory path.'
}

test_default_mode_is_symlink() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" 'n
' --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains 'Mode:   symlink'
}

test_copy_option_selects_copy_mode() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" 'n
' --copy --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains 'Mode:   copy'
}

test_repeated_target_option_uses_last_value() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" 'n
' --target "${fixture}/first" --target "${fixture}/second"
    assert_status 0
    assert_stdout_contains "Target: ${fixture}/second"
    assert_absent "${fixture}/first"
    assert_directory "${fixture}/second"
}

test_relative_target_is_normalized_to_absolute_path() {
    local fixture
    fixture="$(new_fixture alpha)"
    (
        cd "${fixture}" || fail "cannot enter fixture: ${fixture}"
        run_installer "${fixture}" 'n
' --target './target/../target/nested'
        assert_status 0
        assert_stdout_contains "Target: ${fixture}/target/nested"
        assert_directory "${fixture}/target/nested"
    )
}

test_header_reports_source_directory() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" 'n
' --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains "Source: ${fixture}/skills"
}
