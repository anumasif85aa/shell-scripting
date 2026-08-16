#!/bin/bash

# Compare two whole numbers.

if [[ "$#" -ne 2 ]]; then
    echo "Usage: $0 FIRST_NUMBER SECOND_NUMBER" >&2
    exit 1
fi

first="$1"
second="$2"

if [[ ! "$first" =~ ^-?[0-9]+$ ]] || [[ ! "$second" =~ ^-?[0-9]+$ ]]; then
    echo "Error: both arguments must be whole numbers." >&2
    exit 1
fi

if [[ "$first" -gt "$second" ]]; then
    echo "$first is greater than $second."
elif [[ "$first" -lt "$second" ]]; then
    echo "$first is less than $second."
else
    echo "$first and $second are equal."
fi

