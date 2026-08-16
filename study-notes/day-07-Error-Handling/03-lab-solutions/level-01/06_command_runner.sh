#!/bin/bash

# Run one controlled action and report its result.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 {date|uptime|fail}" >&2
    exit 2
fi

run_action() {
    case "$1" in
        date)
            date
            ;;
        uptime)
            uptime
            ;;
        fail)
            cd /known-missing-directory
            ;;
        *)
            echo "Error: invalid action: $1" >&2
            return 2
            ;;
    esac
}

if run_action "$1"; then
    echo "Action completed successfully: $1"
else
    status=$?
    echo "Error: action failed: $1 (status $status)" >&2
    exit "$status"
fi

