#!/bin/bash

# Generate a report completely before publishing it.

if [[ "$#" -ne 2 ]]; then
    echo "Usage: $0 METRICS_FILE OUTPUT_FILE" >&2
    exit 2
fi

metrics_file="$1"
output_file="$2"

if [[ ! -f "$metrics_file" ]]; then
    echo "Error: metrics file not found: $metrics_file" >&2
    exit 3
fi

if [[ -z "$output_file" || "$output_file" == /* || "$output_file" == *".."* ]]; then
    echo "Error: output must be a safe relative path." >&2
    exit 2
fi

temporary_file="$(mktemp "./.report.tmp.XXXXXX")"

cleanup() {
    local status=$?

    if [[ -n "${temporary_file:-}" && -f "$temporary_file" ]]; then
        rm -f -- "$temporary_file"
    fi

    exit "$status"
}

trap cleanup EXIT

if ! awk -F, '
    NR == 1 {
        if ($1 != "server" || $2 != "cpu" || $3 != "memory" || $4 != "disk") {
            exit 2
        }
        print "SERVER HEALTH REPORT"
        next
    }
    NF == 0 {
        next
    }
    NF != 4 || $2 !~ /^[0-9]+$/ || $3 !~ /^[0-9]+$/ || $4 !~ /^[0-9]+$/ {
        exit 2
    }
    {
        print $1 ": CPU=" $2 "% MEMORY=" $3 "% DISK=" $4 "%"
    }
' "$metrics_file" > "$temporary_file"; then
    echo "Error: report generation failed; final file was not changed." >&2
    exit 1
fi

if mv -- "$temporary_file" "$output_file"; then
    temporary_file=""
    echo "Report published: $output_file"
else
    echo "Error: unable to publish report." >&2
    exit 1
fi
