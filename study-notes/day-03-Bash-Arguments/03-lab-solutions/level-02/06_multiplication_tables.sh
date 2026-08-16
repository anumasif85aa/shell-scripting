#!/bin/bash

# Task 6: Multiple multiplication tables

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 NUMBER [NUMBER ...]" >&2
    exit 1
fi

for table in "$@"
do
    if [[ ! "$table" =~ ^-?[0-9]+$ ]]; then
        echo "Skipped invalid number: $table" >&2
        continue
    fi

    echo "=== Multiplication Table of $table ==="

    for number in {1..10}
    do
        echo "$table x $number = $((table * number))"
    done

    echo
done

