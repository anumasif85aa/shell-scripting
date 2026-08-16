#!/bin/bash

# Approve or block a simulated deployment.

if [[ "$#" -ne 4 ]]; then
    echo "Usage: $0 ENVIRONMENT VERSION CONFIG_FILE LOG_FILE" >&2
    exit 2
fi

environment="$1"
version="$2"
config_file="$3"
log_file="$4"

case "$environment" in
    dev|test|stage|prod)
        ;;
    *)
        echo "Deployment blocked: invalid environment." >&2
        exit 2
        ;;
esac

if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Deployment blocked: version must look like 1.2.3." >&2
    exit 2
fi

if [[ ! -f "$config_file" ]] || ! grep -q '^APP_NAME=.\+' "$config_file"; then
    echo "Deployment blocked: invalid configuration." >&2
    exit 3
fi

if [[ ! -f "$log_file" ]]; then
    echo "Deployment blocked: log file missing." >&2
    exit 3
fi

if grep -q 'ERROR' "$log_file"; then
    echo "Deployment blocked: ERROR found in log." >&2
    exit 1
fi

if [[ "$environment" == "prod" && "${APPROVED:-no}" != "yes" ]]; then
    echo "Deployment blocked: production requires APPROVED=yes." >&2
    exit 1
fi

echo "Deployment checks passed."
echo "Environment: $environment"
echo "Version: $version"
exit 0

