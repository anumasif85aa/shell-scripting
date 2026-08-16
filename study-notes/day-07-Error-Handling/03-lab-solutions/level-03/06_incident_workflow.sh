#!/bin/bash

# Evaluate configuration, metrics, and logs in a controlled workflow.

set -Euo pipefail

if [[ "$#" -ne 3 ]]; then
    echo "Usage: $0 CONFIG_FILE METRICS_FILE LOG_FILE" >&2
    exit 2
fi

config_file="$1"
metrics_file="$2"
log_file="$3"

log_info() {
    echo "$(date '+%F %T') INFO $*"
}

log_error() {
    echo "$(date '+%F %T') ERROR $*" >&2
}

unexpected_error() {
    local status=$?
    log_error "Unexpected command failure: $BASH_COMMAND (status $status)"
    return "$status"
}

trap unexpected_error ERR

check_dependencies() {
    local command_name

    for command_name in awk grep date
    do
        if ! command -v "$command_name" >/dev/null 2>&1; then
            log_error "Required command not found: $command_name"
            return 3
        fi
    done
}

validate_configuration() {
    [[ -f "$config_file" ]] || return 3
    grep -q '^APP_NAME=.\+' "$config_file" || return 2
    grep -q '^APP_ENV=\(dev\|test\|stage\|prod\)$' "$config_file" || return 2
    grep -q '^APP_PORT=[0-9]\+$' "$config_file" || return 2
}

evaluate_metrics() {
    awk -F, '
        NR == 1 {
            if ($0 != "server,cpu,memory,disk") exit 2
            next
        }
        NF == 0 {
            next
        }
        NF != 4 || $2 !~ /^[0-9]+$/ || $3 !~ /^[0-9]+$/ || $4 !~ /^[0-9]+$/ {
            exit 2
        }
        $4 >= 90 || $3 >= 95 {
            critical = 1
        }
        !critical && ($4 >= 80 || $3 >= 85 || $2 >= 80) {
            warning = 1
        }
        END {
            if (critical) exit 1
            if (warning) exit 4
            exit 0
        }
    ' "$metrics_file"
}

evaluate_log() {
    if grep -q 'ERROR' "$log_file"; then
        return 1
    fi

    if grep -q 'WARNING' "$log_file"; then
        return 4
    fi

    return 0
}

log_info "Checking dependencies"
if check_dependencies; then
    dependency_status=0
else
    dependency_status=$?
    exit "$dependency_status"
fi

log_info "Validating input files"
for required_file in "$config_file" "$metrics_file" "$log_file"
do
    if [[ ! -f "$required_file" ]]; then
        log_error "Required file missing: $required_file"
        exit 3
    fi
done

log_info "Validating configuration"
if validate_configuration; then
    configuration_status=0
else
    status=$?
    log_error "Configuration validation failed."
    exit "$status"
fi

warning_found=false

log_info "Evaluating metrics"
if evaluate_metrics; then
    metrics_status=0
else
    metrics_status=$?
fi

case "$metrics_status" in
    0)
        log_info "Metrics are healthy."
        ;;
    4)
        echo "Metrics contain warnings." >&2
        warning_found=true
        ;;
    1)
        log_error "Critical metrics detected."
        exit 1
        ;;
    *)
        log_error "Metrics input is malformed."
        exit 2
        ;;
esac

log_info "Evaluating log"
if evaluate_log; then
    log_status=0
else
    log_status=$?
fi

case "$log_status" in
    0)
        log_info "No log problems detected."
        ;;
    4)
        echo "Log contains warnings." >&2
        warning_found=true
        ;;
    1)
        log_error "ERROR found in application log."
        exit 1
        ;;
esac

if [[ "$warning_found" == "true" ]]; then
    echo "Incident workflow completed with warnings."
    exit 4
fi

echo "Incident workflow completed successfully."
exit 0
