#!/bin/bash

current_user="$(whoami)"
current_host="$(hostname)"
current_date="$(date)"
current_directory="$(pwd)"
bash_version="$BASH_VERSION"

echo "User: $current_user"
echo "Hostname: $current_host"
echo "Date: $current_date"
echo "Directory: $current_directory"
echo "Bash version: $bash_version"
