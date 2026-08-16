#!/bin/bash

script_directory="$(cd -- "$(dirname -- "$0")" && pwd)"
approval_file="${1:-$script_directory/../../04-lab-data/approval.txt}"

if [[ ! -s "$approval_file" ]]; then
    echo "FAIL: approval file is missing or empty." >&2
    exit 1
elif grep -q '^STATUS=approved$' "$approval_file" &&
     grep -q '^SECURITY_REVIEW=passed$' "$approval_file" &&
     grep -q '^TEST_RESULT=passed$' "$approval_file"; then
    echo "Approval validation passed."
    exit 0
else
    echo "Approval validation failed." >&2
    exit 1
fi
