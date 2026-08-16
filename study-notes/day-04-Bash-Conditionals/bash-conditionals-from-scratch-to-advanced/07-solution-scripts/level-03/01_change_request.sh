#!/bin/bash

script_directory="$(cd -- "$(dirname -- "$0")" && pwd)"
approval_file="$script_directory/../../04-lab-data/approval.txt"
change_id="${1:-}"

if [[ -z "$change_id" ]]; then
    echo "Usage: $0 CHANGE_ID" >&2
    exit 1
elif [[ "$change_id" != CHG-* ]]; then
    echo "FAIL: change ID must match CHG-*." >&2
    exit 1
elif grep -q "^CHANGE_ID=${change_id}$" "$approval_file"; then
    echo "PASS: approved change request found: $change_id"
    exit 0
else
    echo "FAIL: change request was not found." >&2
    exit 1
fi
