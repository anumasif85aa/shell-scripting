# Lab 01 — Error Handling Foundations

## Objective

Learn to detect, explain, and return failures using syntax checks, exit
statuses, stderr, input validation, and direct command testing.

## Rules

- Use `#!/bin/bash`.
- Use `echo`, not `printf`.
- Quote variables.
- Do not use `sudo`.
- Test successful and failing input.

## Task 1 — Syntax Checker

Create `01_syntax_checker.sh`.

- Accept one script path.
- Validate that it is a regular file.
- Run `bash -n` on it.
- Display `Syntax is valid` on success.
- Send a clear error to stderr and exit nonzero on failure.

Test with:

```text
artifacts/source/good-script.sh
artifacts/source/broken-if.sh
```

## Task 2 — Exit-Status Demonstration

Create `02_exit_status.sh`.

- Run `pwd` and save its status immediately.
- Run `cd /directory-that-does-not-exist` and save its status immediately.
- Display both statuses with labels.
- Explain in comments why `$?` must be saved immediately.

## Task 3 — Separate Output and Errors

Create `03_streams.sh`.

- Write `Starting health check` to stdout.
- Write `Practice warning: service unavailable` to stderr.
- Exit with status `1`.
- Run it with:

```bash
./03_streams.sh > output.log 2> error.log
```

- Check both files and the script status.

## Task 4 — Argument and File Guard

Create `04_file_guard.sh`.

- Require exactly one argument.
- Use status `2` for incorrect usage.
- Require a regular, nonempty file.
- Use status `3` when the file is missing or empty.
- Display the first line only after validation passes.

## Task 5 — Safe Directory Creation

Create `05_create_directory.sh`.

- Accept one relative directory name.
- Reject absolute paths and names containing `..`.
- If the path already exists, report an error.
- Test `mkdir` directly with `if`.
- Print success only when creation succeeds.

## Task 6 — Simple Command Runner

Create `06_command_runner.sh`.

- Accept one action: `date`, `uptime`, or `fail`.
- Use `case`.
- `fail` should run a known failing command.
- Print a success message only after command success.
- Print a failure message to stderr and return nonzero otherwise.

## Verification

```bash
bash -n 01_syntax_checker.sh 02_exit_status.sh 03_streams.sh \
04_file_guard.sh 05_create_directory.sh 06_command_runner.sh
```

