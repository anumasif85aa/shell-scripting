#!/bin/bash

# Task 5: Check a regular file

check_file()
{
    local file="$1"

    if [[ -f "$file" ]]; then
        echo "File found: $file"
        return 0
    else
        echo "Error: file not found: $file" >&2
        return 1
    fi
}

check_file "Lab-02-Arguments-Status-and-Scope.md"
echo "First status: $?"

check_file "missing.txt"
echo "Second status: $?"

