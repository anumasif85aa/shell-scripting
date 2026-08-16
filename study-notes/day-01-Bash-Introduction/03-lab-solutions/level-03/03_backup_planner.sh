#!/bin/bash

# Preview or apply a safe copy of .conf files.

if [[ "$#" -lt 2 || "$#" -gt 3 ]]; then
    echo "Usage: $0 SOURCE DESTINATION [--apply]" >&2
    exit 2
fi

source_directory="$1"
destination_directory="$2"
mode="${3:-dry-run}"

if [[ ! -d "$source_directory" ]]; then
    echo "Error: source directory not found." >&2
    exit 1
fi

if [[ "$mode" != "dry-run" && "$mode" != "--apply" ]]; then
    echo "Error: optional third argument must be --apply." >&2
    exit 2
fi

if [[ "$destination_directory" == /* || "$destination_directory" == *".."* ]]; then
    echo "Error: destination must be a safe relative path." >&2
    exit 1
fi

shopt -s nullglob
config_files=("$source_directory"/*.conf)

if [[ "${#config_files[@]}" -eq 0 ]]; then
    echo "No .conf files found."
    exit 0
fi

if [[ "$mode" == "dry-run" ]]; then
    for file in "${config_files[@]}"
    do
        echo "Would copy: $file -> $destination_directory/"
    done
    exit 0
fi

mkdir -p -- "$destination_directory"
copied=0
skipped=0

for file in "${config_files[@]}"
do
    destination_file="$destination_directory/${file##*/}"

    if [[ -e "$destination_file" ]]; then
        echo "Skipped existing: $destination_file"
        ((skipped++))
        continue
    fi

    if cp -- "$file" "$destination_file"; then
        echo "Copied: $destination_file"
        ((copied++))
    else
        echo "Copy failed: $file" >&2
        exit 1
    fi
done

echo "Copied: $copied"
echo "Skipped: $skipped"

