#!/bin/bash

# Distinguish grep match, no-match, and actual error statuses.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 LOG_FILE" >&2
    exit 2
fi

log_file="$1"

if [[ ! -f "$log_file" ]]; then
    echo "Error: log file not found: $log_file" >&2
    exit 3
fi

grep -q "ERROR" "$log_file"
grep_status=$?

case "$grep_status" in
    0)
        echo "ERROR lines were found."
        exit 1
        ;;
    1)
        echo "No ERROR lines were found."
        exit 0
        ;;
    *)
        echo "Error: grep failed with status $grep_status." >&2
        exit "$grep_status"
        ;;
esac

