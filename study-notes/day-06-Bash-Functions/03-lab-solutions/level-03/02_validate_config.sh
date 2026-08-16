#!/bin/bash

# Task 2: Configuration validator

require_file()
{
    local file="$1"

    if [[ -s "$file" ]]; then
        echo "Valid configuration: $file"
        return 0
    else
        echo "Invalid or empty configuration: $file" >&2
        return 1
    fi
}

for config in \
    "artifacts/config/app.conf" \
    "artifacts/config/empty.conf" \
    "artifacts/config/missing.conf"
do
    require_file "$config"
done

echo "Configuration validation practice completed"
