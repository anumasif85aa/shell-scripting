#!/bin/bash

# Title: Grant Administrative Privileges
# Purpose: Optionally add users to the system's sudo or wheel group.

if [[ "$EUID" -ne 0 ]]; then
    echo "Error: this script requires root privileges." >&2
    exit 1
fi

if [[ "$#" -eq 0 ]]; then
    echo "Usage: $0 USERNAME [USERNAME ...]" >&2
    exit 1
fi

if getent group sudo &> /dev/null; then
    admin_group="sudo"
elif getent group wheel &> /dev/null; then
    admin_group="wheel"
else
    echo "Error: neither the sudo group nor the wheel group exists." >&2
    exit 1
fi

echo "Administrative group detected: $admin_group"

for username in "$@"
do
    if ! id "$username" &> /dev/null; then
        echo "Skipped: user does not exist: $username" >&2
        continue
    fi

    user_groups=" $(id -nG "$username") "

    if [[ "$user_groups" == *" $admin_group "* ]]; then
        echo "Skipped: $username is already in the $admin_group group"
        continue
    fi

    if ! read -r -p "Grant administrative privileges to $username? [y/N]: " answer; then
        echo >&2
        echo "Error: could not read the response." >&2
        exit 1
    fi

    case "$answer" in
        y|Y|yes|YES|Yes)
            if usermod -aG "$admin_group" "$username"; then
                echo "Administrative privileges granted: $username"
                echo "The user must sign out and sign in again before using the new group membership."
            else
                echo "Error: could not add $username to $admin_group" >&2
                exit 1
            fi
            ;;
        *)
            echo "Administrative privileges not granted: $username"
            ;;
    esac
done

exit 0

