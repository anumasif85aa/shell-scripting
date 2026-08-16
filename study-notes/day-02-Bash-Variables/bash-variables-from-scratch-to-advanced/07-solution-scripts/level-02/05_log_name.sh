#!/bin/bash

app_name="${1:-demo-app}"
timestamp="$(date +%Y%m%d-%H%M%S)"
log_name="${app_name}-${timestamp}.log"

echo "Application: $app_name"
echo "Log filename: $log_name"
