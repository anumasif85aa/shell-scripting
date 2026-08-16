#!/bin/bash

# Title: Interactive Greeting
# Purpose: Read a name and favorite tool from the user.

if ! read -r -p "Enter your name: " name; then
    echo "Error: could not read your name." >&2
    exit 1
fi

if [[ -z "$name" ]]; then
    echo "Error: name cannot be empty." >&2
    exit 1
fi

if ! read -r -p "Enter your favorite tool: " tool; then
    echo "Error: could not read your favorite tool." >&2
    exit 1
fi

if [[ -z "$tool" ]]; then
    echo "Error: favorite tool cannot be empty." >&2
    exit 1
fi

echo "Hello $name, your favorite tool is $tool."
exit 0

