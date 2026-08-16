#!/bin/bash

# Task 3: Configuration inspector

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 CONFIG_FILE" >&2
    exit 1
fi

config_file="$1"

if [[ ! -s "$config_file" ]] || ! grep -q '[^[:space:]]' "$config_file"; then
    echo "Error: configuration is missing or empty: $config_file" >&2
    exit 1
fi

line_count="$(wc -l < "$config_file")"

echo "Configuration: $config_file"
echo "Line count: $line_count"
