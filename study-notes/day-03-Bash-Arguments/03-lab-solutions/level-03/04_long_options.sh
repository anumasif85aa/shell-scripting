#!/bin/bash

# Task 4: Parse long options manually

usage()
{
    echo "Usage: $0 --app VALUE --env VALUE --version VALUE"
}

application=""
environment=""
version=""

while [[ $# -gt 0 ]]
do
    case "$1" in
        --app)
            [[ $# -ge 2 ]] || {
                echo "Missing value for --app" >&2
                exit 1
            }
            application="$2"
            shift 2
            ;;
        --env)
            [[ $# -ge 2 ]] || {
                echo "Missing value for --env" >&2
                exit 1
            }
            environment="$2"
            shift 2
            ;;
        --version)
            [[ $# -ge 2 ]] || {
                echo "Missing value for --version" >&2
                exit 1
            }
            version="$2"
            shift 2
            ;;
        --help)
            usage
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

if [[ -z "$application" || -z "$environment" || -z "$version" ]]; then
    echo "Error: --app, --env, and --version are required" >&2
    usage >&2
    exit 1
fi

echo "Application: $application"
echo "Environment: $environment"
echo "Version: $version"

