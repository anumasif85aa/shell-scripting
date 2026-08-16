#!/bin/bash

log_file="${1:-}"

if [[ -z "$log_file" ]]; then
    echo "Usage: $0 LOG_FILE" >&2
    exit 1
elif [[ ! -f "$log_file" || ! -r "$log_file" || ! -s "$log_file" ]]; then
    echo "Error: log file must be readable and non-empty." >&2
    exit 1
elif grep -q "ERROR" "$log_file"; then
    echo "Errors were found."
    exit 0
else
    echo "No errors were found."
    exit 0
fi
