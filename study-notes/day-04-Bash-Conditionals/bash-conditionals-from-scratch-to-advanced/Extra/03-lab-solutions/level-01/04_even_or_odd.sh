#!/bin/bash

# Tell whether an argument is even or odd.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 NUMBER" >&2
    exit 1
fi

number="$1"

if [[ ! "$number" =~ ^-?[0-9]+$ ]]; then
    echo "Error: enter a whole number." >&2
    exit 1
fi

if (( number % 2 == 0 )); then
    echo "$number is even."
else
    echo "$number is odd."
fi

