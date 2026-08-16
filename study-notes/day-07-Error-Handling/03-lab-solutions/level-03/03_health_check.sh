#!/bin/bash

# Return status according to the highest observed severity.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 METRICS_CSV" >&2
    exit 2
fi

metrics_file="$1"

if [[ ! -f "$metrics_file" ]]; then
    echo "Error: metrics file not found." >&2
    exit 2
fi

severity=0
line_number=0

while IFS=, read -r server cpu memory disk
do
    ((line_number++))

    if [[ "$line_number" -eq 1 ]]; then
        if [[ "$server,$cpu,$memory,$disk" != "server,cpu,memory,disk" ]]; then
            echo "Error: invalid CSV header." >&2
            exit 2
        fi
        continue
    fi

    [[ -z "$server" ]] && continue

    if [[ ! "$cpu" =~ ^[0-9]+$ || ! "$memory" =~ ^[0-9]+$ || ! "$disk" =~ ^[0-9]+$ ]]; then
        echo "Error: invalid metrics for $server." >&2
        exit 2
    fi

    if [[ "$cpu" -gt 100 || "$memory" -gt 100 || "$disk" -gt 100 ]]; then
        echo "Error: percentage above 100 for $server." >&2
        exit 2
    fi

    if [[ "$disk" -ge 90 || "$memory" -ge 95 ]]; then
        echo "$server: Critical"
        severity=2
    elif [[ "$disk" -ge 80 || "$memory" -ge 85 || "$cpu" -ge 80 ]]; then
        echo "$server: Warning"
        if [[ "$severity" -lt 1 ]]; then
            severity=1
        fi
    else
        echo "$server: Healthy"
    fi
done < "$metrics_file"

case "$severity" in
    0)
        exit 0
        ;;
    1)
        exit 4
        ;;
    2)
        exit 1
        ;;
esac

