#!/bin/bash

# Validate a batch of files while preserving per-file meaning.

if [[ "$#" -eq 0 ]]; then
    echo "Usage: $0 FILE..." >&2
    exit 2
fi

validate_file() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        return 1
    fi

    if ! grep -q '[^[:space:]]' "$file"; then
        return 2
    fi

    return 0
}

failure_count=0

for file in "$@"
do
    validate_file "$file"
    status=$?

    case "$status" in
        0)
            echo "Usable file: $file"
            ;;
        1)
            echo "Missing file: $file" >&2
            ((failure_count++))
            ;;
        2)
            echo "Empty file: $file" >&2
            ((failure_count++))
            ;;
    esac
done

if [[ "$failure_count" -gt 0 ]]; then
    exit 1
fi

exit 0

