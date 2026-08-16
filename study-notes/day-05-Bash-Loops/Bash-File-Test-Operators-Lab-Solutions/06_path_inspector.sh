#!/bin/bash

# Task 6: Complete path-inspection report

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 PATH" >&2
    exit 2
fi

path="$1"

if [[ ! -e "$path" && ! -L "$path" ]]; then
    echo "Error: path does not exist: $path" >&2
    exit 1
fi

echo "PATH INSPECTION REPORT"
echo "======================"
echo "Path: $path"
echo "Exists: yes"

if [[ -L "$path" ]]; then
    echo "Type: symbolic link"

    if [[ -e "$path" ]]; then
        echo "Link target exists: yes"
    else
        echo "Link target exists: no"
    fi
elif [[ -f "$path" ]]; then
    echo "Type: regular file"
elif [[ -d "$path" ]]; then
    echo "Type: directory"
else
    echo "Type: another file type"
fi

if [[ -r "$path" ]]; then
    echo "Readable: yes"
else
    echo "Readable: no"
fi

if [[ -w "$path" ]]; then
    echo "Writable: yes"
else
    echo "Writable: no"
fi

if [[ -x "$path" ]]; then
    echo "Executable/Searchable: yes"
else
    echo "Executable/Searchable: no"
fi

if [[ -f "$path" && ! -L "$path" ]]; then
    if [[ -s "$path" ]]; then
        echo "Contains data: yes"
    else
        echo "Contains data: no"
    fi
else
    echo "Contains data: not applicable"
fi

exit 0
