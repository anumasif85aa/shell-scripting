# Lab 03 — Resilient DevOps-Style Workflow

## Objective

Build safe automation using configuration validation, atomic output, severity
statuses, deployment gates, retryable jobs, and a final incident workflow.

## Safety

- Do not use `sudo`.
- Do not deploy anything.
- Do not manage real services.
- Restrict output to the current practice directory.

## Task 1 — Configuration Validator

Create `01_config_validator.sh`.

- Accept one configuration file.
- Require meaningful content.
- Require:
  - `APP_NAME`
  - `APP_ENV`
  - `APP_PORT`
- Allow environments `dev`, `test`, `stage`, and `prod`.
- Require a port from `1` through `65535`.
- Use a function and meaningful statuses.

Test:

```text
artifacts/config/valid.env
artifacts/config/invalid.env
artifacts/config/empty.conf
```

## Task 2 — Atomic Report Writer

Create `02_atomic_report.sh`.

- Accept `METRICS_FILE OUTPUT_FILE`.
- Restrict output to a relative path without `..`.
- Create a temporary file.
- Generate a report into the temporary file.
- Move it to the final path only when generation succeeds.
- Add cleanup for the temporary file.
- Never leave a partial final report.

## Task 3 — Health Check Status

Create `03_health_check.sh`.

- Accept a metrics CSV.
- Display each server status:
  - Healthy
  - Warning
  - Critical
- Return:
  - `0` when all are healthy
  - `4` when warnings exist but no critical result
  - `1` when any critical result exists
  - `2` for invalid usage or malformed input

## Task 4 — Deployment Gate

Create `04_deployment_gate.sh`.

- Accept `ENVIRONMENT VERSION CONFIG_FILE LOG_FILE`.
- Validate every input before approving.
- Require semantic-looking version `MAJOR.MINOR.PATCH`.
- Block when the log contains `ERROR`.
- For `prod`, require `APPROVED=yes`.
- This script only approves or blocks.

## Task 5 — Retryable Job Runner

Create `05_job_runner.sh`.

- Read `artifacts/data/jobs.csv`.
- Columns are `job,failures_before_success`.
- Retry each job up to three times.
- Continue to the next job after exhaustion.
- Display attempts and final per-job results.
- Return nonzero when any job ultimately fails.

Test both:

```text
artifacts/data/successful-jobs.csv
artifacts/data/jobs.csv
```

## Task 6 — Incident Workflow

Create `06_incident_workflow.sh`.

- Accept `CONFIG_FILE METRICS_FILE LOG_FILE`.
- Create functions for:
  - logging
  - dependency checks
  - configuration validation
  - metrics evaluation
  - log evaluation
  - final summary
- Stop for missing dependencies, bad configuration, or critical metrics.
- Treat warnings as a completed run with warning status `4`.
- Write errors to stderr.
- Include an `ERR` trap with line and command context.

## Final Verification

Test success, warning, critical, missing-file, malformed-input, retry-exhaustion,
and cleanup behavior.

