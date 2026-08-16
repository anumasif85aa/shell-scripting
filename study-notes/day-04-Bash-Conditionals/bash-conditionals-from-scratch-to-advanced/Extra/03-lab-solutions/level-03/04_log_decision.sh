#!/bin/bash

# Classify a log file by its ERROR and WARNING messages.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 LOG_FILE" >&2
    exit 1
fi

log_file="$1"

if [[ ! -f "$log_file" ]]; then
    echo "Error: log file not found: $log_file" >&2
    exit 1
fi

error_count="$(grep -c 'ERROR' "$log_file")"
warning_count="$(grep -c 'WARNING' "$log_file")"

if [[ "$error_count" -gt 0 ]]; then
    echo "Log status: critical ($error_count error messages)"
elif [[ "$warning_count" -gt 0 ]]; then
    echo "Log status: warning ($warning_count warning messages)"
else
    echo "Log status: healthy"
fi

