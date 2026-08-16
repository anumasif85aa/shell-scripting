#!/bin/bash

# Convert a numeric score into a letter grade.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 SCORE" >&2
    exit 1
fi

score="$1"

if [[ ! "$score" =~ ^[0-9]+$ ]] || [[ "$score" -gt 100 ]]; then
    echo "Error: score must be between 0 and 100." >&2
    exit 1
fi

if [[ "$score" -ge 90 ]]; then
    echo "Grade: A"
elif [[ "$score" -ge 80 ]]; then
    echo "Grade: B"
elif [[ "$score" -ge 70 ]]; then
    echo "Grade: C"
elif [[ "$score" -ge 60 ]]; then
    echo "Grade: D"
else
    echo "Grade: F"
fi

