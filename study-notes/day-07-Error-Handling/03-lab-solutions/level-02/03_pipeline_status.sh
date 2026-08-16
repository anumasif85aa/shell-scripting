#!/bin/bash

# Inspect all statuses from a pipeline.

set -o pipefail

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 SERVICES_CSV" >&2
    exit 2
fi

data_file="$1"

if [[ ! -f "$data_file" ]]; then
    echo "Error: data file not found: $data_file" >&2
    exit 3
fi

temporary_file="$(mktemp)"

cleanup() {
    local status=$?
    rm -f -- "$temporary_file"
    exit "$status"
}

trap cleanup EXIT

tail -n +2 "$data_file" | grep ',enabled$' | wc -l > "$temporary_file"
statuses=("${PIPESTATUS[@]}")

enabled_count="$(<"$temporary_file")"

echo "Enabled services: $enabled_count"
echo "tail status: ${statuses[0]}"
echo "grep status: ${statuses[1]}"
echo "wc status: ${statuses[2]}"

for status in "${statuses[@]}"
do
    if [[ "$status" -ne 0 ]]; then
        echo "Error: a pipeline component failed." >&2
        exit 1
    fi
done

exit 0

