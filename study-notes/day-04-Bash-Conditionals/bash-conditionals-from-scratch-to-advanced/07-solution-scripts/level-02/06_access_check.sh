#!/bin/bash

role="${1:-}"
active="${2:-}"
maintenance="${3:-}"

if [[ -z "$role" || -z "$active" || -z "$maintenance" ]]; then
    echo "Usage: $0 ROLE ACTIVE MAINTENANCE" >&2
    exit 1
elif [[ ( "$role" == "admin" || "$role" == "operator" ) &&
        "$active" == "yes" &&
        ! "$maintenance" == "yes" ]]; then
    echo "Access allowed."
    exit 0
else
    echo "Access denied." >&2
    exit 1
fi
