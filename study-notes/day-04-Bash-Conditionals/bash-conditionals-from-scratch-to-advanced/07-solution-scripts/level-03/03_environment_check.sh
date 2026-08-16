#!/bin/bash

script_directory="$(cd -- "$(dirname -- "$0")" && pwd)"
config_file="${1:-$script_directory/../../04-lab-data/release.env}"

if [[ ! -s "$config_file" ]]; then
    echo "FAIL: release configuration is missing or empty." >&2
    exit 1
fi

app_name="$(grep -m1 '^APP_NAME=' "$config_file" | cut -d= -f2-)"
version="$(grep -m1 '^VERSION=' "$config_file" | cut -d= -f2-)"
environment="$(grep -m1 '^ENVIRONMENT=' "$config_file" | cut -d= -f2-)"
port="$(grep -m1 '^PORT=' "$config_file" | cut -d= -f2-)"

if [[ -z "$app_name" || -z "$version" || -z "$environment" || -z "$port" ]]; then
    echo "FAIL: one or more required values are empty." >&2
    exit 1
elif [[ "$environment" != "development" &&
        "$environment" != "testing" &&
        "$environment" != "production" ]]; then
    echo "FAIL: invalid environment: $environment" >&2
    exit 1
elif [[ ! "$version" =~ ^v[0-9]+([.][0-9]+)*$ ]]; then
    echo "FAIL: invalid version: $version" >&2
    exit 1
elif [[ ! "$port" =~ ^[0-9]+$ ]] || (( port < 1 || port > 65535 )); then
    echo "FAIL: invalid port: $port" >&2
    exit 1
else
    echo "Application: $app_name"
    echo "Version: $version"
    echo "Environment: $environment"
    echo "Port: $port"
    echo "Environment validation passed."
    exit 0
fi
