#!/bin/bash

read -r -p "Enter port number: " port

if [[ -z "$port" ]]; then
    echo "Error: port cannot be empty." >&2
    exit 1
elif [[ ! "$port" =~ ^[0-9]+$ ]]; then
    echo "Error: port must contain digits only." >&2
    exit 1
elif (( port < 1 || port > 65535 )); then
    echo "Error: port must be from 1 to 65535." >&2
    exit 1
else
    echo "Valid port: $port"
    exit 0
fi
