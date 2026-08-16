#!/bin/bash

environment="${1:-development}"
environment="${environment,,}"

if [[ "$environment" == "development" ||
      "$environment" == "testing" ||
      "$environment" == "production" ]]; then
    echo "Environment: $environment"
    exit 0
else
    echo "Error: use development, testing, or production." >&2
    exit 1
fi
