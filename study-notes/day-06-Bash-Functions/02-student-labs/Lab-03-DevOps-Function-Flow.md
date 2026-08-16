# Lab 03 — Practical DevOps Function Flow

## Objective

Combine functions, arguments, conditionals, loops, files, and status codes into
small automation workflows.

Use the supplied `artifacts/` directory. Do not change real system services.

## Task 1 — Log Message Functions

Create `01_log_messages.sh`.

- Define `log_info` that displays `[INFO] MESSAGE`.
- Define `log_error` that displays `[ERROR] MESSAGE` on standard error.
- Call both functions.

## Task 2 — Configuration Validator

Create `02_validate_config.sh`.

- Define `require_file`.
- Accept a file path.
- Return success when it is a regular, non-empty file.
- Return failure and show an error otherwise.
- Test:

```text
artifacts/config/app.conf
artifacts/config/empty.conf
artifacts/config/missing.conf
```

## Task 3 — Server Inventory Report

Create `03_server_inventory.sh`.

- Define `show_server`.
- Accept one server name and display `Checking server: NAME`.
- Read `artifacts/servers.txt` with a `while` loop.
- Call the function for every server.
- Ignore empty lines.

## Task 4 — Log-Level Counter

Create `04_log_counter.sh`.

- Define `count_level`.
- Accept a log level such as `INFO`, `WARNING`, or `ERROR`.
- Accept a log filename as the second argument.
- Display how many matching lines exist.
- Use `grep -c`.
- Test all three levels with `artifacts/logs/application.log`.

## Task 5 — Safe Backup Function

Create `05_backup_file.sh`.

- Define `backup_file`.
- Accept a source file and destination directory.
- Validate that the source is a regular file.
- Create the destination directory with `mkdir -p`.
- Copy the file into the directory with `.bak` added.
- Print the backup location.
- Test with `artifacts/config/app.conf` and a local `backups/` directory.

## Task 6 — Reusable Function Library

Create two files:

```text
functions.sh
06_health_report.sh
```

In `functions.sh`, define:

- `show_header`
- `check_file`
- `count_errors`

In `06_health_report.sh`:

- Source `functions.sh`.
- Print a report header.
- Check `artifacts/config/app.conf`.
- Count `ERROR` lines in `artifacts/logs/application.log`.
- End with a clear summary.

## Final Verification

```bash
bash -n *.sh
```

Run everything as a regular user. All successful scripts should end with status
`0`.

