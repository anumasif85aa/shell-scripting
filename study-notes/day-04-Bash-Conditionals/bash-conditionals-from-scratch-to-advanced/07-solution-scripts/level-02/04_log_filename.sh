#!/bin/bash

filename="${1:-}"

if [[ -z "$filename" ]]; then
    echo "Usage: $0 FILENAME" >&2
    exit 1
elif [[ "$filename" == *.log ]]; then
    echo "Valid log filename: $filename"
    exit 0
else
    echo "Invalid log filename: $filename" >&2
    exit 1
fi
