# Lab 03 — DevOps-Style Bash Automation

## Objective

Build a safe mini automation workflow using validation, functions, arrays,
logs, configuration, dry-run behavior, and meaningful exit statuses.

## Safety

- Do not use `sudo`.
- Do not manage real services.
- Do not deploy anything.
- Restrict created files and directories to the current lab directory.

## Task 1 — Configuration Validator

Create `01_validate_config.sh`.

- Accept one configuration file.
- Require a regular file with non-whitespace content.
- Require these keys:
  - `APP_NAME`
  - `APP_ENV`
  - `APP_PORT`
- Require environment `dev`, `test`, `stage`, or `prod`.
- Require the port to be a whole number from `1` through `65535`.

Use `artifacts/config/app.env`.

## Task 2 — Health Report

Create `02_health_report.sh`.

- Accept a simulated metrics CSV.
- Read the header and data lines.
- Classify each server:
  - `Critical` if disk is at least `90`
  - `Warning` if disk is at least `80` or memory is at least `85`
  - `Healthy` otherwise
- Display totals for healthy, warning, and critical.

Use `artifacts/data/server-metrics.csv`.

## Task 3 — Backup Planner

Create `03_backup_planner.sh`.

- Accept `SOURCE`, `DESTINATION`, and optional `--apply`.
- Validate that source is a directory.
- In default dry-run mode, display what would happen.
- With `--apply`, create the destination if needed and copy only `.conf` files.
- Do not overwrite existing destination files.
- Report copied and skipped counts.

Use `artifacts/config/` as the source and a new practice directory as the
destination.

## Task 4 — Deployment Gate

Create `04_deployment_gate.sh`.

- Accept `ENVIRONMENT VERSION CONFIG_FILE`.
- Allow only `dev`, `test`, `stage`, and `prod`.
- Require version format `MAJOR.MINOR.PATCH`.
- Reuse a `validate_config` function.
- For `prod`, also require environment variable:

```bash
APPROVED=yes
```

- This task only approves or blocks; it never deploys.

## Task 5 — Batch Log Summary

Create `05_batch_log_summary.sh`.

- Accept one or more log files.
- Use a function to analyze each file.
- Use an array for valid files.
- Skip missing files with a warning.
- Display per-file error counts and a grand total.
- Exit:
  - `0` when no errors exist
  - `1` when errors exist
  - `2` when no valid log files were supplied

## Task 6 — Automation Runner

Create `06_automation_runner.sh`.

- Accept `CONFIG_FILE METRICS_FILE LOG_FILE`.
- Create separate functions for:
  - input validation
  - configuration check
  - metrics check
  - log check
- Write normal progress to stdout.
- Write failures to stderr.
- Stop when a required stage fails.
- Display one final summary.
- Return a meaningful exit status.
- Test a successful run with `artifacts/data/healthy-server-metrics.csv` and
  `artifacts/logs/healthy.log`.
- Test a blocked run with `artifacts/data/server-metrics.csv` or
  `artifacts/logs/application.log`.

## Final Verification

```bash
bash -n *.sh
```

Test normal input, missing input, invalid values, empty files, and a second run.

