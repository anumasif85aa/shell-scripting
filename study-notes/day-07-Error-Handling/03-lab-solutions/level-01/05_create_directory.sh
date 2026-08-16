#!/bin/bash

# Create one safe relative practice directory.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 RELATIVE_DIRECTORY" >&2
    exit 2
fi

directory="$1"

if [[ -z "$directory" || "$directory" == /* || "$directory" == *".."* ]]; then
    echo "Error: use a safe relative directory name." >&2
    exit 2
fi

if [[ -e "$directory" ]]; then
    echo "Error: path already exists: $directory" >&2
    exit 1
fi

if mkdir -- "$directory"; then
    echo "Directory created: $directory"
else
    echo "Error: mkdir failed: $directory" >&2
    exit 1
fi

