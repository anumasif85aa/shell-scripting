#!/bin/bash

# Task 5: Process arguments with shift

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 VALUE [VALUE ...]" >&2
    exit 1
fi

while [[ $# -gt 0 ]]
do
    echo "Processing: $1"
    shift
done

