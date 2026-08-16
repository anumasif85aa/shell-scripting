# Lab 03 — DevOps Conditional Flow

## Objective

Build practical validation and decision gates without modifying real services.

## Task 1 — Configuration Health

Create `01_config_health.sh`.

- Accept a configuration path.
- Require a regular file containing non-whitespace content.
- Test with:

```text
artifacts/config/app.conf
artifacts/config/empty.conf
```

## Task 2 — Disk Usage Decision

Create `02_disk_usage.sh`.

- Accept a simulated usage percentage.
- Validate `0` through `100`.
- Display:

```text
0–69   Healthy
70–84  Warning
85–100 Critical
```

## Task 3 — Service Status Report

Create `03_service_status.sh`.

- Accept a service name.
- Search `artifacts/service-status.txt`.
- Display whether it is `running`, `stopped`, or missing.

## Task 4 — Log Decision

Create `04_log_decision.sh`.

- Accept a log file.
- Count `ERROR` and `WARNING` lines.
- Display `Critical` if errors exist.
- Display `Warning` if only warnings exist.
- Otherwise display `Healthy`.

## Task 5 — Deployment Gate

Create `05_deployment_gate.sh`.

- Require `ENVIRONMENT VERSION CONFIG_FILE`.
- Allow `dev`, `test`, `stage`, and `prod`.
- Require version format `MAJOR.MINOR.PATCH`.
- Require a meaningful configuration file.
- Display `Deployment checks passed` only when every test succeeds.

## Task 6 — Command and Function Status

Create `06_create_directory.sh`.

- Accept one directory path.
- Define a `create_directory` function.
- If the directory already exists, return failure.
- Otherwise create it.
- Use:

```bash
if ! create_directory; then
```

- Display a clear error and exit `1` on failure.
- Display success on creation.
- Use only a practice directory under the current working directory.

## Final Verification

```bash
bash -n *.sh
```

Valid paths should return `0`; rejected input should return non-zero.

