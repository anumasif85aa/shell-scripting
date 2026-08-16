#!/bin/bash

# Task 3: Validate a file argument

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 FILE" >&2
    exit 1
fi

file="$1"

if [[ ! -f "$file" ]]; then
    echo "Error: regular file not found: $file" >&2
    exit 1
fi

echo "File found: $file"

