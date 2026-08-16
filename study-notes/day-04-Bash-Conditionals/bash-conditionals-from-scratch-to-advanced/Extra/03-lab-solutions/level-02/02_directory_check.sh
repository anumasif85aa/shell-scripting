#!/bin/bash

# Check whether an argument points to a directory.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 DIRECTORY" >&2
    exit 1
fi

if [[ -d "$1" ]]; then
    echo "Directory found: $1"
else
    echo "Error: directory not found: $1" >&2
    exit 1
fi

