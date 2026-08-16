#!/bin/bash

readonly COMPANY="NIT"

app_name="${1:-demo-app}"
environment="${2:-development}"
environment="${environment,,}"

if [[ "$environment" == "development" ]]; then
    replicas=1
elif [[ "$environment" == "testing" ]]; then
    replicas=2
elif [[ "$environment" == "production" ]]; then
    replicas=3
else
    echo "Error: invalid environment: $environment" >&2
    exit 1
fi

deployment_id="${app_name}-${environment}-$(date +%Y%m%d-%H%M%S)"

echo "Company: $COMPANY"
echo "Application: $app_name"
echo "Environment: $environment"
echo "Replicas: $replicas"
echo "Deployment ID: $deployment_id"
echo "Simulation only: no deployment performed."
