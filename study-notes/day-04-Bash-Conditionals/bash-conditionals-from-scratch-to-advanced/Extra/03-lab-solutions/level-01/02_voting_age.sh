#!/bin/bash

# Check whether a person is old enough to vote.

read -r -p "Enter your age: " age

if [[ ! "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: age must be a whole number." >&2
    exit 1
fi

if [[ "$age" -ge 18 ]]; then
    echo "You are eligible to vote."
else
    echo "You are not eligible to vote yet."
fi

