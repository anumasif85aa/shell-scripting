#!/bin/bash

# Continue processing while recording partial failures.

if [[ "$#" -eq 0 ]]; then
    echo "Usage: $0 FILE..." >&2
    exit 2
fi

success_count=0
failure_count=0

for file in "$@"
do
    if [[ -f "$file" ]] && grep -q '[^[:space:]]' "$file"; then
        line_count="$(wc -l < "$file")"
        echo "Processed: $file ($line_count lines)"
        ((success_count++))
    else
        echo "Failed: missing or empty file: $file" >&2
        ((failure_count++))
    fi
done

echo "Succeeded: $success_count"
echo "Failed: $failure_count"

if [[ "$failure_count" -gt 0 ]]; then
    exit 1
fi

exit 0

