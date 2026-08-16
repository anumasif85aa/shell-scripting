# Level 3 Lab — Safe DevOps Loop Practice

## Objective

Use loops to analyze server status, logs, disk data, retries, and reports without changing the operating system.

> The supplied data is simulated and safe for practice.

## Lab data

```text
../03-lab-data/servers/server-status.csv
../03-lab-data/logs/application.log
../03-lab-data/logs/authentication.log
../03-lab-data/disk-usage.txt
```

---

## Task 1 — Server status report

Create `01_server_status.sh`.

Read `server-status.csv`, which contains:

```text
server,status
web01,UP
web02,DOWN
database01,UP
```

Requirements:

- Accept the CSV filename as `$1`.
- Skip the header.
- Split each line using `IFS=,`.
- Display `[OK]` for `UP`.
- Display `[ALERT]` for `DOWN`.
- Count the total, UP, and DOWN servers.
- Display a final summary.

---

## Task 2 — Scan logs for errors

Create `02_log_scanner.sh`.

Requirements:

- Accept one or more log files as arguments.
- Loop through arguments with `"$@"`.
- Verify that every item is a readable file.
- Read each file line by line.
- Display lines containing `ERROR` or `FAILED`.
- Count all matching lines.
- Continue safely if one file is missing.

Run:

```bash
bash 02_log_scanner.sh ../03-lab-data/logs/*.log
```

---

## Task 3 — Disk-usage alerts

Create `03_disk_alert.sh`.

The data format is:

```text
mount,usage
/,42
/home,73
/var,91
```

Requirements:

- Accept the filename as `$1`.
- Set a threshold of `80`.
- Skip the header.
- Display `[OK]` below the threshold.
- Display `[WARNING]` at or above the threshold.

Expected warning:

```text
[WARNING] /var is 91% full
```

---

## Task 4 — Limited retry simulator

Create `04_retry.sh`.

The script must:

- Accept a target filename as `$1`.
- Try a maximum of five times.
- Check whether the file exists.
- Sleep for two seconds between attempts.
- Stop immediately when the file appears.
- Exit `1` after the fifth failure.

Practice with two terminals:

Terminal 1:

```bash
bash 04_retry.sh ready.txt
```

Terminal 2:

```bash
touch ready.txt
```

---

## Task 5 — Log line report

Create `05_log_report.sh`.

Requirements:

- Accept a log directory as `$1`.
- Loop through `*.log`.
- Display each filename and line count.
- Count how many log files were processed.
- Count the combined number of lines.
- Handle a directory with no `.log` files.

---

## Task 6 — Capstone health report

Create `06_health_report.sh`.

Use:

- `server-status.csv`
- `disk-usage.txt`
- All files in the log directory

Your report must include:

```text
SYSTEM HEALTH PRACTICE REPORT
=============================
Servers checked:
Servers down:
Disk warnings:
Log errors:
Overall status:
```

Overall status:

- `HEALTHY` when there are no down servers, disk warnings, or log errors.
- `ATTENTION REQUIRED` when any problem is found.

This is a read-only practice report. Do not start services, delete logs, or change disk files.

---

## Level 3 verification

For every script:

```bash
bash -n SCRIPT_NAME.sh
```

Also test:

- Missing arguments
- Missing files
- Empty files
- Normal data
- Data containing warnings
- Retry success
- Retry failure

