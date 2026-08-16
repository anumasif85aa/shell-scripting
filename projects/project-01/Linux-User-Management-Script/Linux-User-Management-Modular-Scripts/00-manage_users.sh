#!/bin/bash

# Title: Modular Linux User Management
# Purpose: Call separate scripts to create users, assign passwords,
#          and optionally grant administrative privileges.

usernames=("apple" "banana" "mango" "orange" "red_cherry")

if [[ "$EUID" -ne 0 ]]; then
    echo "Error: run this script with sudo or as root." >&2
    exit 1
fi

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

echo "Step 1: Creating user accounts"

if ! bash "$script_dir/01-create_users.sh" "${usernames[@]}"; then
    echo "Error: the user-creation step failed." >&2
    exit 1
fi

echo
echo "Step 2: Assigning passwords"

if ! bash "$script_dir/02-assign_passwords.sh" "${usernames[@]}"; then
    echo "Error: the password-assignment step failed." >&2
    exit 1
fi

echo
echo "Step 3: Asking about administrative privileges"

if ! bash "$script_dir/03-grant_admin_privileges.sh" "${usernames[@]}"; then
    echo "Error: the privilege-management step failed." >&2
    exit 1
fi

echo
echo "All requested user-management steps are complete."
exit 0

