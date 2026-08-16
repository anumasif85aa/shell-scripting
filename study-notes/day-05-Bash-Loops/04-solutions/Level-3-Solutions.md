# Level 3 Solutions — Safe DevOps Loop Practice

Try each task before reading its solution.

> These scripts analyze supplied practice data. They do not modify services, users, logs, or disks.

---

## Solution 1 — `01_server_status.sh`

```bash
#!/bin/bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 SERVER_STATUS_CSV" >&2
    exit 2
fi

status_file="$1"

if [[ ! -f "$status_file" ]]; then
    echo "Error: file not found: $status_file" >&2
    exit 1
fi

total=0
up_count=0
down_count=0

while IFS=, read -r server status
do
    if [[ "$server" == "server" ]]; then
        continue
    fi

    [[ -n "$server" ]] || continue
    total=$((total + 1))

    if [[ "$status" == "UP" ]]; then
        echo "[OK] $server is UP"
        up_count=$((up_count + 1))
    elif [[ "$status" == "DOWN" ]]; then
        echo "[ALERT] $server is DOWN"
        down_count=$((down_count + 1))
    else
        echo "[UNKNOWN] $server has status: $status"
    fi
done < "$status_file"

echo
echo "Total servers: $total"
echo "UP servers: $up_count"
echo "DOWN servers: $down_count"
```

---

## Solution 2 — `02_log_scanner.sh`

```bash
#!/bin/bash

if [[ "$#" -eq 0 ]]; then
    echo "Usage: $0 LOG_FILE..." >&2
    exit 2
fi

match_count=0

for log_file in "$@"
do
    if [[ ! -r "$log_file" ]]; then
        echo "Warning: cannot read $log_file" >&2
        continue
    fi

    echo "Scanning: $log_file"

    while IFS= read -r line || [[ -n "$line" ]]
    do
        if [[ "$line" == *ERROR* || "$line" == *FAILED* ]]; then
            echo "$line"
            match_count=$((match_count + 1))
        fi
    done < "$log_file"
done

echo
echo "Total ERROR or FAILED lines: $match_count"
```

---

## Solution 3 — `03_disk_alert.sh`

```bash
#!/bin/bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 DISK_DATA_FILE" >&2
    exit 2
fi

disk_file="$1"
threshold=80

if [[ ! -f "$disk_file" ]]; then
    echo "Error: file not found: $disk_file" >&2
    exit 1
fi

while IFS=, read -r mount_point usage
do
    if [[ "$mount_point" == "mount" ]]; then
        continue
    fi

    [[ -n "$mount_point" ]] || continue

    if [[ "$usage" -ge "$threshold" ]]; then
        echo "[WARNING] $mount_point is ${usage}% full"
    else
        echo "[OK] $mount_point is ${usage}% full"
    fi
done < "$disk_file"
```

---

## Solution 4 — `04_retry.sh`

```bash
#!/bin/bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 TARGET_FILE" >&2
    exit 2
fi

target_file="$1"
maximum_attempts=5

for (( attempt=1; attempt<=maximum_attempts; attempt++ ))
do
    echo "Attempt $attempt of $maximum_attempts"

    if [[ -f "$target_file" ]]; then
        echo "Success: $target_file is available"
        exit 0
    fi

    if [[ "$attempt" -lt "$maximum_attempts" ]]; then
        sleep 2
    fi
done

echo "Error: $target_file was not found" >&2
exit 1
```

---

## Solution 5 — `05_log_report.sh`

```bash
#!/bin/bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 LOG_DIRECTORY" >&2
    exit 2
fi

log_directory="$1"

if [[ ! -d "$log_directory" ]]; then
    echo "Error: directory not found: $log_directory" >&2
    exit 1
fi

file_count=0
total_lines=0

for log_file in "$log_directory"/*.log
do
    [[ -e "$log_file" ]] || continue

    line_count="$(wc -l < "$log_file")"
    echo "$(basename "$log_file"): $line_count lines"

    file_count=$((file_count + 1))
    total_lines=$((total_lines + line_count))
done

if [[ "$file_count" -eq 0 ]]; then
    echo "No log files found."
else
    echo
    echo "Log files processed: $file_count"
    echo "Combined lines: $total_lines"
fi
```

---

## Solution 6 — `06_health_report.sh`

```bash
#!/bin/bash

if [[ "$#" -ne 3 ]]; then
    echo "Usage: $0 SERVER_CSV DISK_FILE LOG_DIRECTORY" >&2
    exit 2
fi

server_file="$1"
disk_file="$2"
log_directory="$3"
threshold=80

if [[ ! -f "$server_file" ]]; then
    echo "Error: server file not found: $server_file" >&2
    exit 1
fi

if [[ ! -f "$disk_file" ]]; then
    echo "Error: disk file not found: $disk_file" >&2
    exit 1
fi

if [[ ! -d "$log_directory" ]]; then
    echo "Error: log directory not found: $log_directory" >&2
    exit 1
fi

servers_checked=0
servers_down=0
disk_warnings=0
log_errors=0

while IFS=, read -r server status
do
    [[ "$server" == "server" ]] && continue
    [[ -n "$server" ]] || continue

    servers_checked=$((servers_checked + 1))

    if [[ "$status" == "DOWN" ]]; then
        servers_down=$((servers_down + 1))
    fi
done < "$server_file"

while IFS=, read -r mount_point usage
do
    [[ "$mount_point" == "mount" ]] && continue
    [[ -n "$mount_point" ]] || continue

    if [[ "$usage" -ge "$threshold" ]]; then
        disk_warnings=$((disk_warnings + 1))
    fi
done < "$disk_file"

for log_file in "$log_directory"/*.log
do
    [[ -e "$log_file" ]] || continue

    while IFS= read -r line || [[ -n "$line" ]]
    do
        if [[ "$line" == *ERROR* || "$line" == *FAILED* ]]; then
            log_errors=$((log_errors + 1))
        fi
    done < "$log_file"
done

if [[ "$servers_down" -eq 0 && "$disk_warnings" -eq 0 && "$log_errors" -eq 0 ]]; then
    overall_status="HEALTHY"
else
    overall_status="ATTENTION REQUIRED"
fi

echo "SYSTEM HEALTH PRACTICE REPORT"
echo "============================="
echo "Servers checked: $servers_checked"
echo "Servers down: $servers_down"
echo "Disk warnings: $disk_warnings"
echo "Log errors: $log_errors"
echo "Overall status: $overall_status"
```

Run from the `04-solutions` directory:

```bash
bash 06_health_report.sh \
    ../03-lab-data/servers/server-status.csv \
    ../03-lab-data/disk-usage.txt \
    ../03-lab-data/logs
```

Expected summary:

```text
Servers checked: 4
Servers down: 2
Disk warnings: 2
Log errors: 4
Overall status: ATTENTION REQUIRED
```

