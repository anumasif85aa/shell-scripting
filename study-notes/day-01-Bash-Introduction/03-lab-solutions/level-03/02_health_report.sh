#!/bin/bash

# Classify simulated server metrics from a CSV file.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 METRICS_CSV" >&2
    exit 2
fi

metrics_file="$1"

if [[ ! -f "$metrics_file" ]]; then
    echo "Error: metrics file not found: $metrics_file" >&2
    exit 1
fi

healthy=0
warning=0
critical=0
line_number=0

while IFS=, read -r server cpu memory disk
do
    ((line_number++))
    [[ "$line_number" -eq 1 ]] && continue
    [[ -z "$server" ]] && continue

    if [[ ! "$cpu" =~ ^[0-9]+$ || ! "$memory" =~ ^[0-9]+$ || ! "$disk" =~ ^[0-9]+$ ]]; then
        echo "Warning: invalid metrics for $server; skipped." >&2
        continue
    fi

    if [[ "$disk" -ge 90 ]]; then
        status="Critical"
        ((critical++))
    elif [[ "$disk" -ge 80 || "$memory" -ge 85 ]]; then
        status="Warning"
        ((warning++))
    else
        status="Healthy"
        ((healthy++))
    fi

    echo "$server: $status (CPU=$cpu%, memory=$memory%, disk=$disk%)"
done < "$metrics_file"

echo "Healthy: $healthy"
echo "Warning: $warning"
echo "Critical: $critical"

