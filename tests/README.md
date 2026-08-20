# installSkills Tests

Behavior tests for the [`installSkills`](../installSkills) installer script. The suite runs the
real script against throwaway fixture repositories, so no build tooling is added to this
repository.

## Run

```bash
./tests/run.sh
```

Filter by test name substring:

```bash
./tests/run.sh target
```

The runner requires Java 25+, the same requirement as `installSkills`. It uses `JAVA_CMD` when
set, then `JAVA_HOME/bin/java`, then `java` from `PATH`, and fails with a clear message when the
resolved runtime is older than 25.

## Layout

| Path | Purpose |
| --- | --- |
| `run.sh` | Discovers `cases/*.sh`, runs every `test_*` function in a subshell, prints a summary and exits non-zero on failure. |
| `lib.sh` | Java resolution, fixture creation, installer invocation and assertions. |
| `cases/option_parsing.sh` | `--help`, `--version`, `--copy`, `--target` parsing and error exits. |
| `cases/discovery.sh` | Skill discovery, ordering, and missing/empty source directory errors. |
| `cases/prompting.sh` | Per-skill confirmation prompt answers, including closed stdin. |
| `cases/install.sh` | Symlink and copy installs, previous entry cleanup, and summary counters. |

## How A Test Works

`new_fixture <skill-name>...` creates a temporary directory containing a copy of `installSkills`
and a synthetic `skills/` tree, one `SKILL.md` per named skill. `run_installer <fixture> <answers>
[args...]` executes that copy with prompt answers on stdin and captures `RUN_STATUS`,
`RUN_STDOUT` and `RUN_STDERR` for the assertion helpers. All fixtures live under a single
temporary root that is removed when the runner exits.

```bash
test_copy_option_selects_copy_mode() {
    local fixture
    fixture="$(new_fixture alpha)"
    run_installer "${fixture}" 'n
' --copy --target "${fixture}/target"
    assert_status 0
    assert_stdout_contains 'Mode:   copy'
}
```

## Add A Test

1. Add a `test_<behavior>` function to the matching file under `cases/`, or create a new
   `cases/<area>.sh` file.
2. Build state with `new_fixture`, drive the installer with `run_installer`, and assert with the
   helpers in `lib.sh`.
3. Run `./tests/run.sh` and `shellcheck -x tests/run.sh tests/lib.sh tests/cases/*.sh`.
