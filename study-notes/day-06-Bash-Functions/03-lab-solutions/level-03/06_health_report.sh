#!/bin/bash

# Task 6: Health report using a function library

source "./functions.sh"

config_file="artifacts/config/app.conf"
log_file="artifacts/logs/application.log"

show_header "Training Application Health Report"

if check_file "$config_file"; then
    config_status="available"
else
    config_status="missing"
fi

if error_count="$(count_errors "$log_file")"; then
    log_status="checked"
else
    error_count="unknown"
    log_status="failed"
fi

echo
echo "Configuration status: $config_status"
echo "Log check status: $log_status"
echo "Error count: $error_count"

