#!/bin/bash

# Read a server list safely.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 SERVER_FILE" >&2
    exit 1
fi

server_file="$1"

if [[ ! -f "$server_file" ]]; then
    echo "Error: server file not found: $server_file" >&2
    exit 1
fi

count=0

while IFS= read -r server
do
    [[ -z "$server" ]] && continue
    [[ "$server" == \#* ]] && continue

    ((count++))
    echo "$count. $server"
done < "$server_file"

echo "Total servers: $count"

