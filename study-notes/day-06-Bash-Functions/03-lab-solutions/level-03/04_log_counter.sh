#!/bin/bash

# Task 4: Log-level counter

count_level()
{
    local level="$1"
    local log_file="$2"
    local total

    if [[ ! -f "$log_file" ]]; then
        echo "Log file not found: $log_file" >&2
        return 1
    fi

    total="$(grep -c "$level" "$log_file")"
    echo "$level lines: $total"
}

log_file="artifacts/logs/application.log"

count_level "INFO" "$log_file"
count_level "WARNING" "$log_file"
count_level "ERROR" "$log_file"

