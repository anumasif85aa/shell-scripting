#!/bin/bash

# Task 3: Check access permissions

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 PATH" >&2
    exit 2
fi

path="$1"

if [[ ! -e "$path" && ! -L "$path" ]]; then
    echo "Error: path not found: $path" >&2
    exit 1
fi

if [[ -r "$path" ]]; then
    echo "Readable: yes"
else
    echo "Readable: no"
fi

if [[ -w "$path" ]]; then
    echo "Writable: yes"
else
    echo "Writable: no"
fi

if [[ -x "$path" ]]; then
    echo "Executable/Searchable: yes"
else
    echo "Executable/Searchable: no"
fi

exit 0
