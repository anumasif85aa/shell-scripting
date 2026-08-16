# Level 02 Lab: Practical Variables

## Objective

Use defaults, validation, environment variables, string operations, timestamps, and safe dry-run planning.

## Rules

- Use `echo`.
- Do not use functions.
- Quote variable expansions.
- Display clear errors with `>&2`.
- Exit with status `1` when required input is invalid.

## Task 1: Environment selector

Create `01_environment.sh`.

1. Read the environment from the first argument.
2. If it is missing, use `development`.
3. Convert the value to lowercase.
4. Accept only `development`, `testing`, or `production`.
5. Print an error and exit `1` for any other value.

Examples:

```bash
bash 01_environment.sh
bash 01_environment.sh PRODUCTION
bash 01_environment.sh unknown
```

## Task 2: Numeric input validation

Create `02_port_validator.sh`.

1. Ask the user for a port number.
2. Reject empty input.
3. Reject input containing anything except digits.
4. Accept only numbers from `1` to `65535`.
5. Print the final exit status after testing from the terminal.

## Task 3: Environment variable report

Create `03_app_report.sh`.

Read these environment variables:

- `APP_NAME`
- `APP_ENV`
- `APP_PORT`

Use these defaults:

```text
APP_NAME=demo-app
APP_ENV=development
APP_PORT=8080
```

Test:

```bash
bash 03_app_report.sh
APP_NAME=shop APP_ENV=testing APP_PORT=9090 bash 03_app_report.sh
```

## Task 4: Filename inspector

Create `04_filename_inspector.sh`.

Receive a path as the first argument:

```text
/var/log/my-app.log
```

Use parameter expansion to display:

- Original path
- Filename
- Base name without extension
- Extension
- Filename length

## Task 5: Log filename generator

Create `05_log_name.sh`.

1. Receive an application name as the first argument.
2. Default to `demo-app`.
3. Store a timestamp from `date +%Y%m%d-%H%M%S`.
4. Produce a log name such as:

```text
demo-app-20260725-173500.log
```

## Task 6: Backup dry run

Create `06_backup_plan.sh`.

1. Receive a source directory as `$1`.
2. Receive a destination directory as `$2`.
3. Use `./data` and `./backups` as defaults.
4. Create a timestamped archive name variable.
5. Print the exact backup plan.
6. Do not create an archive. This is a dry run.

Example:

```text
Mode: DRY RUN
Source: ./data
Destination: ./backups
Archive: data-20260725-173500.tar.gz
No files were changed.
```

## Deliverables

- Six scripts
- Terminal test evidence for valid, default, and invalid input
- A short explanation of why variables should be quoted
