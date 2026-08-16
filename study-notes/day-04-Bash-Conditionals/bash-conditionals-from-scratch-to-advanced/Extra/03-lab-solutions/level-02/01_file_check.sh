#!/bin/bash

# Check whether an argument points to a regular file.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 FILE" >&2
    exit 1
fi

if [[ -f "$1" ]]; then
    echo "Regular file found: $1"
else
    echo "Error: regular file not found: $1" >&2
    exit 1
fi

