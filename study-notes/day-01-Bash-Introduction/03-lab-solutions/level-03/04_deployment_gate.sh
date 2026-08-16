#!/bin/bash

# Validate a simulated deployment request.

if [[ "$#" -ne 3 ]]; then
    echo "Usage: $0 ENVIRONMENT VERSION CONFIG_FILE" >&2
    exit 2
fi

environment="$1"
version="$2"
config_file="$3"

validate_config() {
    local file="$1"

    [[ -f "$file" ]] || return 1
    grep -q '^APP_NAME=.\+' "$file" || return 1
    grep -q '^APP_ENV=.\+' "$file" || return 1
    grep -q '^APP_PORT=[0-9]\+$' "$file" || return 1
}

case "$environment" in
    dev|test|stage|prod)
        ;;
    *)
        echo "Deployment blocked: invalid environment." >&2
        exit 1
        ;;
esac

if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Deployment blocked: version must look like 1.2.3." >&2
    exit 1
fi

if ! validate_config "$config_file"; then
    echo "Deployment blocked: configuration validation failed." >&2
    exit 1
fi

if [[ "$environment" == "prod" && "${APPROVED:-no}" != "yes" ]]; then
    echo "Deployment blocked: production requires APPROVED=yes." >&2
    exit 1
fi

echo "Deployment checks passed."
echo "Environment: $environment"
echo "Version: $version"

