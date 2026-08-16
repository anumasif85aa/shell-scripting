#!/bin/bash

# Task 1: Require exactly two arguments

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 FIRST SECOND" >&2
    exit 1
fi

echo "First value: $1"
echo "Second value: $2"

