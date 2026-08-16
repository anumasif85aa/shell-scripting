#!/bin/bash

script_directory="$(cd -- "$(dirname -- "$0")" && pwd)"
config_file="${1:-$script_directory/../../04-lab-data/app.env}"

if [[ ! -s "$config_file" ]]; then
    echo "Error: configuration file is missing or empty: $config_file" >&2
    exit 1
fi

app_name=""
app_env=""
app_port=""
log_level=""

while IFS='=' read -r key value; do
    [[ -z "$key" || "$key" == \#* ]] && continue

    case "$key" in
        APP_NAME) app_name="$value" ;;
        APP_ENV) app_env="$value" ;;
        APP_PORT) app_port="$value" ;;
        LOG_LEVEL) log_level="$value" ;;
        *) echo "Warning: ignored unknown key: $key" >&2 ;;
    esac
done < "$config_file"

echo "Application: $app_name"
echo "Environment: $app_env"
echo "Port: $app_port"
echo "Log level: $log_level"
