#!/bin/bash

# Task 3: Server inventory report

show_server()
{
    local server="$1"
    echo "Checking server: $server"
}

while IFS= read -r server
do
    [[ -n "$server" ]] || continue
    show_server "$server"
done < "artifacts/servers.txt"

