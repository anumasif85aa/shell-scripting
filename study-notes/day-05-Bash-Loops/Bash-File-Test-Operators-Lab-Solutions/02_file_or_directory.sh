#!/bin/bash

# Task 2: Identify a regular file or directory

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 PATH" >&2
    exit 2
fi

path="$1"

if [[ -f "$path" ]]; then
    echo "$path is a regular file"
elif [[ -d "$path" ]]; then
    echo "$path is a directory"
else
    echo "$path is missing or is another path type"
    exit 1
fi

exit 0
