#!/bin/bash

# Task 4: Check whether a regular file is empty

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 FILE" >&2
    exit 2
fi

file="$1"

if [[ ! -f "$file" ]]; then
    echo "$file is not a regular file"
    exit 1
elif [[ -s "$file" ]]; then
    echo "$file is a regular file containing data"
else
    echo "$file is a regular file but empty"
fi

exit 0
