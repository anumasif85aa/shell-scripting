#!/bin/bash

# Task 5: Safe backup function

backup_file()
{
    local source_file="$1"
    local destination="$2"
    local backup_name

    if [[ ! -f "$source_file" ]]; then
        echo "Source file not found: $source_file" >&2
        return 1
    fi

    mkdir -p -- "$destination" || return 1

    backup_name="$(basename "$source_file").bak"
    cp -- "$source_file" "$destination/$backup_name" || return 1

    echo "Backup created: $destination/$backup_name"
}

backup_file "artifacts/config/app.conf" "backups"

