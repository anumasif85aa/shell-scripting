#!/bin/bash

# Title: Systemd Service Status Checker
# Purpose: Optionally display and check a service's status.

service_name="nginx"

if ! command -v systemctl >/dev/null 2>&1; then
    echo "Error: systemctl is not available on this system." >&2
    exit 1
fi

if ! read -r -p "Do you want to check the status of $service_name? (y/n): " answer; then
    echo >&2
    echo "Error: could not read your response." >&2
    exit 1
fi

case "$answer" in
    y|Y)
        echo "Service details for $service_name:"
        systemctl status --no-pager "$service_name"

        if systemctl is-active --quiet "$service_name"; then
            echo "$service_name is active."
            exit 0
        else
            echo "$service_name is not active." >&2
            exit 1
        fi
        ;;
    n|N)
        echo "Skipped."
        exit 0
        ;;
    *)
        echo "Error: enter y or n." >&2
        exit 1
        ;;
esac

