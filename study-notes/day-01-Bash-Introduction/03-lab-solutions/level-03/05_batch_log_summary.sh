#!/bin/bash

# Summarize errors across one or more log files.

if [[ "$#" -eq 0 ]]; then
    echo "Usage: $0 LOG_FILE..." >&2
    exit 2
fi

valid_files=()
grand_total=0

count_errors() {
    local file="$1"
    awk '/ERROR/{count++} END{print count+0}' "$file"
}

for file in "$@"
do
    if [[ -f "$file" ]]; then
        valid_files+=("$file")
    else
        echo "Warning: skipped missing file: $file" >&2
    fi
done

if [[ "${#valid_files[@]}" -eq 0 ]]; then
    echo "Error: no valid log files supplied." >&2
    exit 2
fi

for file in "${valid_files[@]}"
do
    error_count="$(count_errors "$file")"
    echo "$file: $error_count error messages"
    grand_total=$(( grand_total + error_count ))
done

echo "Grand total: $grand_total"

if [[ "$grand_total" -gt 0 ]]; then
    exit 1
fi

exit 0

