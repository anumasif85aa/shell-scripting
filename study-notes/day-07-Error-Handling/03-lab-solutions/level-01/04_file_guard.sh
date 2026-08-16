#!/bin/bash

# Validate usage and file content before reading.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 FILE" >&2
    exit 2
fi

file="$1"

if [[ ! -f "$file" ]] || ! grep -q '[^[:space:]]' "$file"; then
    echo "Error: a nonempty regular file is required: $file" >&2
    exit 3
fi

echo "First line: $(head -n 1 "$file")"

