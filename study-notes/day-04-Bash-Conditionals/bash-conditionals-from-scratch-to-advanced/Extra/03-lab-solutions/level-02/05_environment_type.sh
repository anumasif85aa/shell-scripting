#!/bin/bash

# Classify an application environment.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 ENVIRONMENT" >&2
    exit 1
fi

environment="$1"

if [[ "$environment" == "dev" || "$environment" == "test" ]]; then
    echo "Non-production environment: $environment"
elif [[ "$environment" == "stage" || "$environment" == "prod" ]]; then
    echo "Controlled environment: $environment"
else
    echo "Error: use dev, test, stage, or prod." >&2
    exit 1
fi

