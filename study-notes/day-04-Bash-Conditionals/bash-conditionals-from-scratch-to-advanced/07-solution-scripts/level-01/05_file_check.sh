#!/bin/bash

file="${1:-}"

if [[ -z "$file" ]]; then
    echo "Usage: $0 FILE" >&2
    exit 1
elif [[ -f "$file" ]]; then
    echo "Regular file found."
    exit 0
else
    echo "Regular file not found." >&2
    exit 1
fi
