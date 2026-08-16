#!/bin/bash

# Check whether a number is from 10 through 50.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 NUMBER" >&2
    exit 1
fi

number="$1"

if [[ ! "$number" =~ ^-?[0-9]+$ ]]; then
    echo "Error: enter a whole number." >&2
    exit 1
fi

if [[ "$number" -ge 10 && "$number" -le 50 ]]; then
    echo "$number is inside the range 10 to 50."
else
    echo "$number is outside the range 10 to 50."
fi

