#!/bin/bash

# Title: Number Classifier
# Purpose: Classify a validated whole number.

if ! read -r -p "Enter a whole number: " number; then
    echo "Error: could not read the input." >&2
    exit 1
fi

if [[ ! "$number" =~ ^-?[0-9]+$ ]]; then
    echo "Error: enter a valid whole number." >&2
    exit 1
fi

if (( number > 0 )); then
    echo "$number is positive."
elif (( number < 0 )); then
    echo "$number is negative."
else
    echo "$number is zero."
fi

exit 0

