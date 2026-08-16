#!/bin/bash

# Title: Assign Linux User Passwords
# Purpose: Securely set or reset passwords through the passwd command.

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
    if ! id "$username" &> /dev/null; then
        echo "Skipped: user does not exist: $username" >&2
        continue
    fi

    if ! read -r -p "Set or reset the password for $username? [y/N]: " answer; then
        echo >&2
        echo "Error: could not read the response." >&2
        exit 1
    fi

    case "$answer" in
        y|Y|yes|YES|Yes)
            echo "Enter the new password for $username when prompted."

            if passwd "$username"; then
                echo "Password updated successfully: $username"
            else
                echo "Error: password update failed: $username" >&2
                exit 1
            fi
            ;;
        *)
            echo "Skipped password assignment: $username"
            ;;
    esac
done

exit 0

