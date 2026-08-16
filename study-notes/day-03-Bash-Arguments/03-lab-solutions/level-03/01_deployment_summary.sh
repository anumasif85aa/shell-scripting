#!/bin/bash

# Task 1: Deployment summary

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 APPLICATION ENVIRONMENT VERSION" >&2
    exit 1
fi

application="$1"
environment="$2"
version="$3"

echo "=== Deployment Summary ==="
echo "Application: $application"
echo "Environment: $environment"
echo "Version: $version"

