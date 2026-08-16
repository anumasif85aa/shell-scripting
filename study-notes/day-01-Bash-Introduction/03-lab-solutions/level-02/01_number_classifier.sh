#!/bin/bash

# Classify one whole number.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 NUMBER" >&2
    exit 1
fi

number="$1"

if [[ ! "$number" =~ ^-?[0-9]+$ ]]; then
    echo "Error: enter a whole number." >&2
    exit 1
fi

if [[ "$number" -gt 0 ]]; then
    echo "$number is positive."
elif [[ "$number" -lt 0 ]]; then
    echo "$number is negative."
else
    echo "$number is zero."
fi

if (( number % 2 == 0 )); then
    echo "$number is even."
else
    echo "$number is odd."
fi

