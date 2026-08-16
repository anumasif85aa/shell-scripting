#!/bin/bash

# Practise positional arguments with fruits.

if [[ "$#" -ne 3 ]]; then
    echo "Usage: $0 apple banana cherry" >&2
    exit 1
fi

echo "Script name: $0"
echo "First fruit: $1"
echo "Second fruit: $2"
echo "Third fruit: $3"
echo "Argument count: $#"
echo "All fruits: $*"

