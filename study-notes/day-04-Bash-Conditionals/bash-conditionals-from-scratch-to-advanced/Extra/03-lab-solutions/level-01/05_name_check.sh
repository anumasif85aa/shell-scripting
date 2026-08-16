#!/bin/bash

# Check that the user entered a name.

read -r -p "Enter your name: " name

if [[ -z "$name" ]]; then
    echo "Error: name cannot be empty." >&2
    exit 1
else
    echo "Welcome, $name!"
fi

