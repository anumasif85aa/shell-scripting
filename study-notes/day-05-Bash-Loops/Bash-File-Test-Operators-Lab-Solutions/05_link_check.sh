#!/bin/bash

# Task 5: Identify symbolic links before other path types

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 PATH" >&2
    exit 2
fi

path="$1"

if [[ -L "$path" ]]; then
    echo "$path is a symbolic link"

    if [[ -e "$path" ]]; then
        echo "The symbolic-link target exists"
    else
        echo "The symbolic-link target is missing"
    fi
elif [[ -f "$path" ]]; then
    echo "$path is a regular file"
elif [[ -d "$path" ]]; then
    echo "$path is a directory"
else
    echo "$path is missing or is another path type"
    exit 1
fi

exit 0
