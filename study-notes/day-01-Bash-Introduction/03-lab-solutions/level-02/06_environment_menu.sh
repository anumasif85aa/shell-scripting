#!/bin/bash

# Simulate environment actions safely.

if [[ "$#" -ne 2 ]]; then
    echo "Usage: $0 ENVIRONMENT {check|deploy|status}" >&2
    exit 1
fi

environment="$1"
action="$2"

case "$environment" in
    dev|test|stage|prod)
        ;;
    *)
        echo "Error: invalid environment: $environment" >&2
        exit 1
        ;;
esac

case "$action" in
    check)
        echo "Would check $environment."
        ;;
    status)
        echo "Would show $environment status."
        ;;
    deploy)
        if [[ "$environment" == "prod" ]]; then
            echo "Deployment blocked: production requires approval." >&2
            exit 1
        fi
        echo "Would deploy to $environment."
        ;;
    *)
        echo "Error: invalid action: $action" >&2
        exit 1
        ;;
esac

