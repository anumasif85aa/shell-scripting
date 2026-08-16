#!/bin/bash

# Purpose: Copy selected files to another user's home directory.
# Usage:
# sudo ./simple_file_migration.sh SOURCE USER FOLDER PATTERN

if [[ "$#" -ne 4 ]]; then
    echo "Usage: sudo $0 SOURCE USER FOLDER PATTERN" >&2
    echo "Example: sudo $0 /root khan shell-scripts '*.sh'" >&2
    exit 1
fi

source_dir="$1"
target_user="$2"
folder_name="$3"
pattern="$4"

# The script needs administrative permission.
if [[ "$EUID" -ne 0 ]]; then
    echo "Error: run this script with sudo." >&2
    exit 1
fi

# Check the source directory.
if [[ ! -d "$source_dir" ]]; then
    echo "Error: source directory does not exist." >&2
    exit 1
fi

# Check the target user.
if ! id "$target_user" &>/dev/null; then
    echo "Error: user '$target_user' does not exist." >&2
    exit 1
fi

# Do not accept an absolute or parent-directory destination.
if [[ "$folder_name" == /* || "$folder_name" == *".."* ]]; then
    echo "Error: enter a safe folder name." >&2
    exit 1
fi

target_home=$(getent passwd "$target_user" | cut -d: -f6)
target_group=$(id -gn "$target_user")
destination="$target_home/$folder_name"

echo "Files selected for copying:"

find "$source_dir" \
    -maxdepth 1 \
    -type f \
    -name "$pattern" \
    -print

read -r -p "Continue with the copy? (yes/no): " answer

if [[ "$answer" != "yes" ]]; then
    echo "Operation cancelled."
    exit 0
fi

# Create the destination directory.
if ! install -d \
    -o "$target_user" \
    -g "$target_group" \
    -m 750 \
    "$destination"
then
    echo "Error: could not create the destination." >&2
    exit 1
fi

copied=0

while IFS= read -r -d '' file
do
    if install \
        -o "$target_user" \
        -g "$target_group" \
        -m 750 \
        "$file" \
        "$destination/"
    then
        echo "Copied: $file"
        ((copied++))
    else
        echo "Error: could not copy $file" >&2
    fi
done < <(
    find "$source_dir" \
        -maxdepth 1 \
        -type f \
        -name "$pattern" \
        -print0
)

echo
echo "Destination: $destination"
echo "Files copied: $copied"