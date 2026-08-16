#!/bin/bash

# Validate the supplied application configuration.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 CONFIG_FILE" >&2
    exit 2
fi

config_file="$1"

if [[ ! -f "$config_file" ]] || ! grep -q '[^[:space:]]' "$config_file"; then
    echo "Error: configuration is missing or empty." >&2
    exit 1
fi

app_name="$(awk -F= '$1=="APP_NAME"{print $2}' "$config_file")"
app_env="$(awk -F= '$1=="APP_ENV"{print $2}' "$config_file")"
app_port="$(awk -F= '$1=="APP_PORT"{print $2}' "$config_file")"

if [[ -z "$app_name" || -z "$app_env" || -z "$app_port" ]]; then
    echo "Error: APP_NAME, APP_ENV, and APP_PORT are required." >&2
    exit 1
fi

case "$app_env" in
    dev|test|stage|prod)
        ;;
    *)
        echo "Error: invalid APP_ENV: $app_env" >&2
        exit 1
        ;;
esac

if [[ ! "$app_port" =~ ^[0-9]+$ ]] || [[ "$app_port" -lt 1 || "$app_port" -gt 65535 ]]; then
    echo "Error: APP_PORT must be from 1 through 65535." >&2
    exit 1
fi

echo "Configuration is valid."
echo "Application: $app_name"
echo "Environment: $app_env"
echo "Port: $app_port"

