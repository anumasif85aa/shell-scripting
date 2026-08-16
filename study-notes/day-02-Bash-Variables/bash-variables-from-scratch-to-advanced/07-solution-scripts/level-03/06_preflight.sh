#!/bin/bash

script_directory="$(cd -- "$(dirname -- "$0")" && pwd)"
config_file="${1:-$script_directory/../../04-lab-data/app.env}"
servers_file="${2:-$script_directory/../../04-lab-data/servers.txt}"

app_env=""
app_port=""
failed=0

if [[ ! -s "$config_file" ]]; then
    echo "FAIL: configuration file is missing or empty." >&2
    failed=1
else
    echo "PASS: configuration file exists and is not empty."

    while IFS='=' read -r key value; do
        case "$key" in
            APP_ENV) app_env="$value" ;;
            APP_PORT) app_port="$value" ;;
        esac
    done < "$config_file"
fi

if [[ "$app_env" == "development" ||
      "$app_env" == "testing" ||
      "$app_env" == "production" ]]; then
    echo "PASS: APP_ENV is valid: $app_env"
else
    echo "FAIL: APP_ENV is invalid or missing." >&2
    failed=1
fi

if [[ "$app_port" =~ ^[0-9]+$ ]] &&
   (( app_port >= 1 && app_port <= 65535 )); then
    echo "PASS: APP_PORT is valid: $app_port"
else
    echo "FAIL: APP_PORT must be from 1 to 65535." >&2
    failed=1
fi

if [[ -s "$servers_file" ]]; then
    echo "PASS: servers file exists and is not empty."
else
    echo "FAIL: servers file is missing or empty." >&2
    failed=1
fi

if (( failed != 0 )); then
    echo "Preflight failed. No action was performed." >&2
    exit 1
fi

echo "Preflight passed. Simulation may continue."
exit 0
