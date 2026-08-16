#!/bin/bash

# Task 1: Check whether a path exists

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 PATH" >&2
    exit 2
fi

path="$1"

if [[ -e "$path" ]]; then
    echo "$path exists"
    exit 0
else
    echo "$path does not exist"
    exit 1
fi
