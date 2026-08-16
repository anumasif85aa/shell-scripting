#!/bin/bash

# Safely create one relative practice directory.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 RELATIVE_DIRECTORY" >&2
    exit 1
fi

directory="$1"

if [[ "$directory" == /* || "$directory" == *".."* ]]; then
    echo "Error: use a safe relative directory name." >&2
    exit 1
fi

create_directory() {
    if [[ -e "$directory" ]]; then
        echo "Directory or file already exists: $directory" >&2
        return 1
    fi

    if ! mkdir -- "$directory"; then
        echo "The mkdir command failed: $directory" >&2
        return 1
    fi
}

if ! create_directory; then
    echo "The script is exiting because the directory was not created." >&2
    exit 1
fi

echo "Directory created: $directory"

