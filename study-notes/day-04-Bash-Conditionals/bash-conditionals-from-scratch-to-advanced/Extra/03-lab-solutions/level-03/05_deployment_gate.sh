#!/bin/bash

# Approve deployment only when all required checks pass.

if [[ "$#" -ne 3 ]]; then
    echo "Usage: $0 ENVIRONMENT VERSION CONFIG_FILE" >&2
    exit 1
fi

environment="$1"
version="$2"
config_file="$3"

if [[ "$environment" != "dev" && "$environment" != "test" && "$environment" != "stage" && "$environment" != "prod" ]]; then
    echo "Deployment blocked: use dev, test, stage, or prod." >&2
    exit 1
fi

if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Deployment blocked: version must look like 1.2.3." >&2
    exit 1
fi

if [[ ! -f "$config_file" ]] || ! grep -q '[^[:space:]]' "$config_file"; then
    echo "Deployment blocked: configuration is missing or empty." >&2
    exit 1
fi

echo "Deployment approved."
echo "Environment: $environment"
echo "Version: $version"
echo "Configuration: $config_file"
