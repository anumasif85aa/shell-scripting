#!/bin/bash

# Title: Regular File Checker
# Purpose: Check whether a supplied path is a regular file.

if ! read -r -p "Enter a filename or path: " filename; then
    echo "Error: could not read the input." >&2
    exit 1
fi

if [[ -z "$filename" ]]; then
    echo "Error: filename cannot be empty." >&2
    exit 1
fi

if [[ -f "$filename" ]]; then
    echo "Regular file exists: $filename"
    exit 0
else
    echo "Regular file does not exist: $filename" >&2
    exit 1
fi

