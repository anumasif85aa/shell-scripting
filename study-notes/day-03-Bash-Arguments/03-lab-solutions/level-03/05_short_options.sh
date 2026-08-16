#!/bin/bash

# Task 5: Parse short options with getopts

usage()
{
    echo "Usage: $0 -a APPLICATION -e ENVIRONMENT -v VERSION"
}

application=""
environment=""
version=""

while getopts ":a:e:v:h" option
do
    case "$option" in
        a) application="$OPTARG" ;;
        e) environment="$OPTARG" ;;
        v) version="$OPTARG" ;;
        h)
            usage
            exit 0
            ;;
        :)
            echo "Option -$OPTARG requires a value" >&2
            exit 1
            ;;
        \?)
            echo "Unknown option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))

if [[ -z "$application" || -z "$environment" || -z "$version" ]]; then
    echo "Error: -a, -e, and -v are required" >&2
    usage >&2
    exit 1
fi

echo "Application: $application"
echo "Environment: $environment"
echo "Version: $version"

