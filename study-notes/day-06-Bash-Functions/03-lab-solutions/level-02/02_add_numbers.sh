#!/bin/bash

# Task 2: Add two numbers

add_numbers()
{
    if [[ $# -ne 2 ]]; then
        echo "Usage: add_numbers NUMBER NUMBER" >&2
        return 1
    fi

    echo "Sum: $(($1 + $2))"
}

add_numbers 7 5

