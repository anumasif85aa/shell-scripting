#!/bin/bash

# Read a simulated service status from the supplied practice artifact.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 SERVICE" >&2
    exit 1
fi

service="$1"
script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
package_directory="$(cd "$script_directory/../.." && pwd)"
status_file="$package_directory/02-student-labs/artifacts/service-status.txt"

if [[ ! "$service" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "Error: invalid service name." >&2
    exit 1
fi

if [[ ! -f "$status_file" ]]; then
    echo "Error: status file not found: $status_file" >&2
    exit 1
fi

record="$(grep -m 1 "^${service}:" "$status_file")"

if [[ -z "$record" ]]; then
    echo "Error: service not found: $service" >&2
    exit 1
fi

status="${record#*:}"

if [[ "$status" == "running" ]]; then
    echo "$service is running."
elif [[ "$status" == "stopped" ]]; then
    echo "$service is stopped."
else
    echo "$service has an unknown status: $status"
fi
