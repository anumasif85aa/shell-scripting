#!/bin/bash

# Task 2: Validate an environment argument

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 ENVIRONMENT" >&2
    exit 1
fi

environment="$1"

case "$environment" in
    dev|test|stage|prod)
        echo "Valid environment: $environment"
        ;;
    *)
        echo "Invalid environment: $environment" >&2
        exit 1
        ;;
esac

