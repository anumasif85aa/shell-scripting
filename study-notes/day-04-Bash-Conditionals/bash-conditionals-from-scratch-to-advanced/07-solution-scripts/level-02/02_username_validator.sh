#!/bin/bash

username="${1:-}"

if [[ -z "$username" ]]; then
    echo "Usage: $0 USERNAME" >&2
    exit 1
elif [[ "$username" =~ ^[a-z][a-z0-9_-]{2,}$ ]]; then
    echo "Valid username: $username"
    exit 0
else
    echo "Invalid username: $username" >&2
    exit 1
fi
