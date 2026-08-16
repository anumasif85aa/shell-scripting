#!/bin/bash

# Task 2: Validate a whole number

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 WHOLE_NUMBER" >&2
    exit 1
fi

number="$1"

if [[ ! "$number" =~ ^-?[0-9]+$ ]]; then
    echo "Error: '$number' is not a valid whole number" >&2
    exit 1
fi

echo "Valid whole number: $number"

