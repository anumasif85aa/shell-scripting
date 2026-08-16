#!/bin/bash

# Task 3: Validate a whole number

is_number()
{
    if [[ "$1" =~ ^-?[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

for value in 25 apple
do
    if is_number "$value"; then
        echo "$value is a valid whole number"
    else
        echo "$value is not a valid whole number"
    fi
done

