#!/usr/bin/env bash
# Test runner for the installSkills installer.
#
# Usage: tests/run.sh [name-filter]
#
# Requires Java 25+ on PATH, or JAVA_CMD / JAVA_HOME pointing at one.

set -uo pipefail

TESTS_DIRECTORY="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=tests/lib.sh
source "${TESTS_DIRECTORY}/lib.sh"

FILTER="${1:-}"

require_java

TEST_TMP_ROOT="$(mktemp -d "${TMPDIR:-/tmp}/installSkills-tests.XXXXXX")"
export TEST_TMP_ROOT
trap 'rm -rf "${TEST_TMP_ROOT}"' EXIT

printf 'installSkills test suite\n'
printf 'Java: %s\n' "${JAVA_BIN}"
printf 'Temp: %s\n\n' "${TEST_TMP_ROOT}"

passed=0
failed=0
failures=()

for case_file in "${TESTS_DIRECTORY}"/cases/*.sh; do
    # shellcheck disable=SC1090
    source "${case_file}"
    case_name="$(basename "${case_file}" .sh)"
    printf '%s\n' "${case_name}"
    while read -r test_function; do
        [[ -n "${FILTER}" && "${test_function}" != *"${FILTER}"* ]] && continue
        if (
            set -uo pipefail
            "${test_function}"
        ); then
            printf '  ok   %s\n' "${test_function#test_}"
            passed=$((passed + 1))
        else
            printf '  FAIL %s\n' "${test_function#test_}"
            failed=$((failed + 1))
            failures+=("${case_name}: ${test_function#test_}")
        fi
    done < <(declare -F | sed -n 's/^declare -f \(test_[A-Za-z0-9_]*\)$/\1/p')
    while read -r test_function; do
        unset -f "${test_function}"
    done < <(declare -F | sed -n 's/^declare -f \(test_[A-Za-z0-9_]*\)$/\1/p')
    printf '\n'
done

printf 'Summary: %s passed, %s failed\n' "${passed}" "${failed}"
if ((failed > 0)); then
    printf 'Failed tests:\n'
    printf '  %s\n' "${failures[@]}"
    exit 1
fi
