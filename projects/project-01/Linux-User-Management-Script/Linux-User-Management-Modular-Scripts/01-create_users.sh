#!/bin/bash

# Title: Create Linux Users
# Purpose: Create local users and their home directories.

if [[ "$EUID" -ne 0 ]]; then
    echo "Error: this script requires root privileges." >&2
    exit 1
fi

if [[ "$#" -eq 0 ]]; then
    echo "Usage: $0 USERNAME [USERNAME ...]" >&2
    exit 1
fi

for username in "$@"
do
    if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        echo "Error: invalid username: $username" >&2
        exit 1
    fi

    if id "$username" &> /dev/null; then
        echo "Skipped: user already exists: $username"
        continue
    fi

    if useradd -m -s /bin/bash "$username"; then
        echo "User created successfully: $username"
    else
        echo "Error: could not create user: $username" >&2
        exit 1
    fi
done

exit 0

