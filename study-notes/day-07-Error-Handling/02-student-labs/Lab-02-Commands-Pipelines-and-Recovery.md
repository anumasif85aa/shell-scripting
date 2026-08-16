# Lab 02 — Commands, Pipelines, and Recovery

## Objective

Handle functions, command-specific statuses, pipelines, partial batch failures,
retries, and cleanup.

## Task 1 — Reusable File Validator

Create `01_validate_files.sh`.

- Accept one or more file paths.
- Create a `validate_file` function.
- The function should:
  - return `1` for a missing path
  - return `2` for an empty file
  - return `0` for a usable file
- The main script should display the correct message for each status.
- Return nonzero if any file fails.

## Task 2 — Understand grep Status

Create `02_find_errors.sh`.

- Accept one log file.
- Validate the file first.
- Use `grep -q "ERROR"`.
- Handle:
  - `0`: error lines found
  - `1`: no error lines found
  - greater than `1`: grep itself failed
- Use the supplied healthy and error logs.

## Task 3 — Pipeline Inspector

Create `03_pipeline_status.sh`.

- Accept one data file.
- Enable `pipefail`.
- Run a pipeline that selects enabled records and counts them.
- Save `PIPESTATUS` immediately.
- Display the pipeline result and every component status.
- Return nonzero if any component failed.

Use `artifacts/data/services.csv`.

## Task 4 — Batch File Processor

Create `04_batch_processor.sh`.

- Accept one or more file paths.
- Process valid nonempty files.
- Continue after individual failures.
- Count successful and failed items.
- Return nonzero when any item fails.

## Task 5 — Retry Simulator

Create `05_retry_simulator.sh`.

- Accept `FAILURES_BEFORE_SUCCESS`.
- Validate it as a number from `0` through `5`.
- Allow at most five attempts.
- Simulate failure until the requested failure count is reached.
- Display every attempt.
- Exit `0` on eventual success and `1` after retry exhaustion. A value of `5`
  should exhaust all five attempts.

Do not call a real network service.

## Task 6 — Temporary File Cleanup

Create `06_temporary_cleanup.sh`.

- Create a temporary file with `mktemp`.
- Register an `EXIT` cleanup function.
- Save the original status at the beginning of cleanup.
- Write practice data into the file.
- Accept optional argument `fail`.
- With `fail`, report an error and exit `1`.
- Otherwise display success.
- Verify that the temporary file is removed in both paths.
