#!/bin/bash

# Describe one or more filesystem paths.

if [[ "$#" -eq 0 ]]; then
    echo "Usage: $0 PATH..." >&2
    exit 1
fi

describe_path() {
    local path="$1"

    if [[ -L "$path" ]]; then
        echo "$path: symbolic link"
    elif [[ -f "$path" ]]; then
        echo "$path: regular file"
    elif [[ -d "$path" ]]; then
        echo "$path: directory"
    else
        echo "$path: missing"
    fi
}

for path in "$@"
do
    describe_path "$path"
done

