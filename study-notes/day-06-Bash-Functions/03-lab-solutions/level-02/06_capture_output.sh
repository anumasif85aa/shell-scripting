#!/bin/bash

# Task 6: Capture function output

multiply()
{
    local first="$1"
    local second="$2"

    echo $((first * second))
}

result="$(multiply 6 7)"
echo "Result: $result"

