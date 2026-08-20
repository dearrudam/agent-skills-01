#!/usr/bin/env bash
# Shared helpers for the installSkills test suite.

REPOSITORY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INSTALLER="${REPOSITORY_ROOT}/installSkills"
MINIMUM_JAVA_FEATURE_VERSION=25

resolve_java() {
    if [[ -n "${JAVA_CMD:-}" ]]; then
        printf '%s\n' "${JAVA_CMD}"
        return 0
    fi
    if [[ -n "${JAVA_HOME:-}" && -x "${JAVA_HOME}/bin/java" ]]; then
        printf '%s\n' "${JAVA_HOME}/bin/java"
        return 0
    fi
    command -v java
}

java_feature_version() {
    "$1" -XshowSettings:properties -version 2>&1 |
        sed -n 's/^ *java\.specification\.version = \([0-9][0-9]*\).*/\1/p' |
        head -n 1
}

require_java() {
    JAVA_BIN="$(resolve_java || true)"
    if [[ -z "${JAVA_BIN}" ]]; then
        printf 'Error: no java executable found. Install JDK %s+ or set JAVA_CMD.\n' \
            "${MINIMUM_JAVA_FEATURE_VERSION}" >&2
        exit 1
    fi
    local feature
    feature="$(java_feature_version "${JAVA_BIN}")"
    if [[ -z "${feature}" || "${feature}" -lt "${MINIMUM_JAVA_FEATURE_VERSION}" ]]; then
        printf 'Error: installSkills requires Java %s+, found "%s" at %s. Set JAVA_CMD or JAVA_HOME.\n' \
            "${MINIMUM_JAVA_FEATURE_VERSION}" "${feature:-unknown}" "${JAVA_BIN}" >&2
        exit 1
    fi
    export JAVA_BIN
}

# Creates an isolated copy of the installer plus a synthetic skills tree.
# Usage: new_fixture <skill-name>...
# Each named skill directory gets a SKILL.md file. Echoes the fixture root.
new_fixture() {
    local fixture
    fixture="$(mktemp -d "${TEST_TMP_ROOT}/fixture.XXXXXX")"
    cp "${INSTALLER}" "${fixture}/installSkills"
    chmod +x "${fixture}/installSkills"
    mkdir -p "${fixture}/skills"
    local skill
    for skill in "$@"; do
        mkdir -p "${fixture}/skills/${skill}"
        printf '# %s\n' "${skill}" >"${fixture}/skills/${skill}/SKILL.md"
    done
    printf '%s\n' "${fixture}"
}

# Runs the installer of a fixture. Answers are fed on stdin, one per line.
# Usage: run_installer <fixture> <stdin-answers> [args...]
# Sets RUN_STATUS, RUN_STDOUT, RUN_STDERR.
run_installer() {
    local fixture="$1"
    local answers="$2"
    shift 2
    local out_file err_file
    out_file="$(mktemp "${TEST_TMP_ROOT}/stdout.XXXXXX")"
    err_file="$(mktemp "${TEST_TMP_ROOT}/stderr.XXXXXX")"
    set +e
    printf '%s' "${answers}" |
        "${JAVA_BIN}" --source "${MINIMUM_JAVA_FEATURE_VERSION}" "${fixture}/installSkills" "$@" \
            >"${out_file}" 2>"${err_file}"
    RUN_STATUS=$?
    set -e
    RUN_STDOUT="$(cat "${out_file}")"
    RUN_STDERR="$(cat "${err_file}")"
}

fail() {
    printf '    %s\n' "$1" >&2
    if [[ -n "${RUN_STDOUT:-}" ]]; then
        printf '    --- stdout ---\n%s\n' "${RUN_STDOUT}" >&2
    fi
    if [[ -n "${RUN_STDERR:-}" ]]; then
        printf '    --- stderr ---\n%s\n' "${RUN_STDERR}" >&2
    fi
    exit 1
}

assert_status() {
    [[ "${RUN_STATUS}" == "$1" ]] || fail "expected exit status $1, got ${RUN_STATUS}"
}

assert_stdout_contains() {
    [[ "${RUN_STDOUT}" == *"$1"* ]] || fail "stdout does not contain: $1"
}

assert_stdout_missing() {
    [[ "${RUN_STDOUT}" != *"$1"* ]] || fail "stdout unexpectedly contains: $1"
}

assert_stderr_contains() {
    [[ "${RUN_STDERR}" == *"$1"* ]] || fail "stderr does not contain: $1"
}

assert_stdout_empty() {
    [[ -z "${RUN_STDOUT}" ]] || fail "expected empty stdout"
}

assert_symlink_to() {
    [[ -L "$1" ]] || fail "expected symbolic link at: $1"
    local resolved
    resolved="$(readlink "$1")"
    [[ "${resolved}" == "$2" ]] || fail "expected link target $2, got ${resolved}"
}

assert_regular_file() {
    [[ -f "$1" && ! -L "$1" ]] || fail "expected regular file at: $1"
}

assert_directory() {
    [[ -d "$1" && ! -L "$1" ]] || fail "expected real directory at: $1"
}

assert_absent() {
    [[ ! -e "$1" && ! -L "$1" ]] || fail "expected missing path: $1"
}

assert_file_content() {
    local actual
    actual="$(cat "$1")"
    [[ "${actual}" == "$2" ]] || fail "unexpected content in $1: ${actual}"
}

# Asserts the given fragments appear in stdout in the given order.
assert_stdout_order() {
    local remainder="${RUN_STDOUT}"
    local needle
    for needle in "$@"; do
        [[ "${remainder}" == *"${needle}"* ]] || fail "stdout does not contain \"${needle}\" in order"
        remainder="${remainder#*"${needle}"}"
    done
}
