#!/bin/bash

# Classify a simulated disk-usage percentage.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 PERCENTAGE" >&2
    exit 1
fi

usage="$1"

if [[ ! "$usage" =~ ^[0-9]+$ ]] || [[ "$usage" -gt 100 ]]; then
    echo "Error: percentage must be from 0 to 100." >&2
    exit 1
fi

if [[ "$usage" -lt 70 ]]; then
    echo "Disk status: healthy"
elif [[ "$usage" -lt 85 ]]; then
    echo "Disk status: warning"
else
    echo "Disk status: critical"
fi

