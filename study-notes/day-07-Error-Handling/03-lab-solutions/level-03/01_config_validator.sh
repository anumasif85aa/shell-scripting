#!/bin/bash

# Validate required application configuration values.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 CONFIG_FILE" >&2
    exit 2
fi

validate_config() {
    local file="$1"
    local app_name
    local app_env
    local app_port

    if [[ ! -f "$file" ]] || ! grep -q '[^[:space:]]' "$file"; then
        echo "Error: configuration is missing or empty." >&2
        return 3
    fi

    app_name="$(awk -F= '$1=="APP_NAME"{print $2}' "$file")"
    app_env="$(awk -F= '$1=="APP_ENV"{print $2}' "$file")"
    app_port="$(awk -F= '$1=="APP_PORT"{print $2}' "$file")"

    if [[ -z "$app_name" || -z "$app_env" || -z "$app_port" ]]; then
        echo "Error: required configuration key is missing." >&2
        return 2
    fi

    case "$app_env" in
        dev|test|stage|prod)
            ;;
        *)
            echo "Error: invalid APP_ENV: $app_env" >&2
            return 2
            ;;
    esac

    if [[ ! "$app_port" =~ ^[0-9]+$ ]] || [[ "$app_port" -lt 1 || "$app_port" -gt 65535 ]]; then
        echo "Error: APP_PORT must be from 1 through 65535." >&2
        return 2
    fi

    echo "Application: $app_name"
    echo "Environment: $app_env"
    echo "Port: $app_port"
    return 0
}

if validate_config "$1"; then
    echo "Configuration is valid."
else
    exit $?
fi

