#!/bin/bash

script_directory="$(cd -- "$(dirname -- "$0")" && pwd)"
status_file="${1:-$script_directory/../../04-lab-data/server-status.env}"

if [[ ! -s "$status_file" ]]; then
    echo "FAIL: simulated server-status file is missing or empty." >&2
    exit 1
fi

disk_ok="$(grep -m1 '^DISK_OK=' "$status_file" | cut -d= -f2-)"
memory_ok="$(grep -m1 '^MEMORY_OK=' "$status_file" | cut -d= -f2-)"
port_free="$(grep -m1 '^SERVICE_PORT_FREE=' "$status_file" | cut -d= -f2-)"
maintenance="$(grep -m1 '^MAINTENANCE_MODE=' "$status_file" | cut -d= -f2-)"

if [[ "$disk_ok" == "yes" &&
      "$memory_ok" == "yes" &&
      "$port_free" == "yes" &&
      "$maintenance" == "no" ]]; then
    echo "Simulated server is ready."
    exit 0
else
    echo "Simulated server is not ready." >&2
    exit 1
fi
