#!/bin/bash

path="${1:-}"

if [[ -z "$path" ]]; then
    echo "Usage: $0 PATH" >&2
    exit 1
elif [[ ! -e "$path" ]]; then
    echo "Path is missing." >&2
    exit 1
elif [[ -d "$path" ]]; then
    echo "Path type: directory"
elif [[ -f "$path" && ! -s "$path" ]]; then
    echo "Path type: empty regular file"
elif [[ -f "$path" && -s "$path" ]]; then
    echo "Path type: non-empty regular file"
else
    echo "Path exists but is another type."
fi

if [[ -r "$path" ]]; then
    echo "Readable: yes"
else
    echo "Readable: no"
fi
