#!/bin/bash

# Check another Bash script for syntax errors.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 SCRIPT_FILE" >&2
    exit 2
fi

script_file="$1"

if [[ ! -f "$script_file" ]]; then
    echo "Error: script file not found: $script_file" >&2
    exit 3
fi

if bash -n "$script_file"; then
    echo "Syntax is valid: $script_file"
else
    echo "Error: syntax check failed: $script_file" >&2
    exit 1
fi

