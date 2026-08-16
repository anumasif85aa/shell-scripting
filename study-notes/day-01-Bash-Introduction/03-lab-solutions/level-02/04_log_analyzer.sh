#!/bin/bash

# Count log levels and classify the result.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 LOG_FILE" >&2
    exit 1
fi

log_file="$1"

if [[ ! -f "$log_file" ]]; then
    echo "Error: log file not found: $log_file" >&2
    exit 1
fi

info_count="$(awk '/INFO/{count++} END{print count+0}' "$log_file")"
warning_count="$(awk '/WARNING/{count++} END{print count+0}' "$log_file")"
error_count="$(awk '/ERROR/{count++} END{print count+0}' "$log_file")"

echo "INFO: $info_count"
echo "WARNING: $warning_count"
echo "ERROR: $error_count"

if [[ "$error_count" -gt 0 ]]; then
    echo "Status: Critical"
elif [[ "$warning_count" -gt 0 ]]; then
    echo "Status: Warning"
else
    echo "Status: Healthy"
fi

