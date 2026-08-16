#!/bin/bash

# Preserve the original status while cleaning one temporary file.

if [[ "$#" -gt 1 || ( "$#" -eq 1 && "$1" != "fail" ) ]]; then
    echo "Usage: $0 [fail]" >&2
    exit 2
fi

temporary_file="$(mktemp)"

if [[ -z "$temporary_file" || ! -f "$temporary_file" ]]; then
    echo "Error: unable to create a temporary file." >&2
    exit 1
fi

cleanup() {
    local status=$?

    if [[ -n "${temporary_file:-}" && -f "$temporary_file" ]]; then
        rm -f -- "$temporary_file"
    fi

    echo "Cleanup completed for: $temporary_file"
    exit "$status"
}

trap cleanup EXIT

echo "Temporary file: $temporary_file"
echo "practice data" > "$temporary_file"

if [[ "${1:-}" == "fail" ]]; then
    echo "Error: simulated processing failure." >&2
    exit 1
fi

echo "Temporary processing succeeded."
exit 0

