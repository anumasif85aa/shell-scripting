#!/bin/bash

read -r -p "Enter age: " age

if [[ -z "$age" ]]; then
    echo "Error: age cannot be empty." >&2
    exit 1
elif [[ ! "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: age must contain digits only." >&2
    exit 1
elif (( age >= 18 )); then
    echo "Adult"
else
    echo "Minor"
fi

exit 0
