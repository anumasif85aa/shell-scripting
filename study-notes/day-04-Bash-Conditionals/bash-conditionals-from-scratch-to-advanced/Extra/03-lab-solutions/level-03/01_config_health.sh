#!/bin/bash

# Check that a configuration file exists and has meaningful content.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 CONFIG_FILE" >&2
    exit 1
fi

config_file="$1"

if [[ -f "$config_file" ]] && grep -q '[^[:space:]]' "$config_file"; then
    echo "Configuration is ready: $config_file"
else
    echo "Error: configuration is missing or empty: $config_file" >&2
    exit 1
fi

