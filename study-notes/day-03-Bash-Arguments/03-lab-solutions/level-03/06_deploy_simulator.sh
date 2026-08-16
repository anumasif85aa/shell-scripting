#!/bin/bash

# Task 6: Final deployment simulator

usage()
{
    echo "Usage: $0 -a APPLICATION -e ENVIRONMENT -v VERSION -c CONFIG_FILE"
    echo "Example: $0 -a training-api -e test -v 3.1.0 -c artifacts/config/app.conf"
}

application=""
environment=""
version=""
config_file=""

while getopts ":a:e:v:c:h" option
do
    case "$option" in
        a) application="$OPTARG" ;;
        e) environment="$OPTARG" ;;
        v) version="$OPTARG" ;;
        c) config_file="$OPTARG" ;;
        h)
            usage
            exit 0
            ;;
        :)
            echo "Option -$OPTARG requires a value" >&2
            usage >&2
            exit 1
            ;;
        \?)
            echo "Unknown option: -$OPTARG" >&2
            usage >&2
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))

if [[ -z "$application" || -z "$environment" || -z "$version" || -z "$config_file" ]]; then
    echo "Error: all options are required" >&2
    usage >&2
    exit 1
fi

case "$environment" in
    dev|test|stage|prod)
        ;;
    *)
        echo "Invalid environment: $environment" >&2
        exit 1
        ;;
esac

if [[ ! -s "$config_file" ]] || ! grep -q '[^[:space:]]' "$config_file"; then
    echo "Configuration missing or empty: $config_file" >&2
    exit 1
fi

server_file="artifacts/servers.txt"

if [[ ! -f "$server_file" ]]; then
    echo "Server inventory missing: $server_file" >&2
    exit 1
fi

server_count=0

echo "=== Deployment Simulation ==="
echo "Application: $application"
echo "Environment: $environment"
echo "Version: $version"
echo "Configuration: $config_file"
echo

while IFS= read -r server
do
    [[ -n "$server" ]] || continue
    echo "Would deploy $application version $version to $server"
    server_count=$((server_count + 1))
done < "$server_file"

echo
echo "Deployment simulation completed"
echo "Servers processed: $server_count"
