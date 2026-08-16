#!/bin/bash

# Display a multiplication table from 1 through 10.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 POSITIVE_NUMBER" >&2
    exit 1
fi

table="$1"

if [[ ! "$table" =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: enter a positive whole number." >&2
    exit 1
fi

for (( number=1; number<=10; number++ ))
do
    echo "$table x $number = $(( table * number ))"
done

