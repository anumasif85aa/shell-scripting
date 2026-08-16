#!/bin/bash

# Task 6: Reusable function library

show_header()
{
    echo "========================================"
    echo "$1"
    echo "========================================"
}

check_file()
{
    local file="$1"

    if [[ -f "$file" ]]; then
        echo "[OK] File found: $file"
        return 0
    else
        echo "[ERROR] File missing: $file" >&2
        return 1
    fi
}

count_errors()
{
    local log_file="$1"

    if [[ ! -f "$log_file" ]]; then
        echo "Cannot count errors: $log_file is missing" >&2
        return 1
    fi

    grep -c "ERROR" "$log_file"
}

