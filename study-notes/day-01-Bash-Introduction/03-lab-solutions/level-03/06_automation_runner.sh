#!/bin/bash

# Run a safe configuration, metrics, and log validation workflow.

if [[ "$#" -ne 3 ]]; then
    echo "Usage: $0 CONFIG_FILE METRICS_FILE LOG_FILE" >&2
    exit 2
fi

config_file="$1"
metrics_file="$2"
log_file="$3"

validate_inputs() {
    local file

    for file in "$config_file" "$metrics_file" "$log_file"
    do
        if [[ ! -f "$file" ]]; then
            echo "Input missing: $file" >&2
            return 1
        fi
    done
}

check_configuration() {
    grep -q '^APP_NAME=.\+' "$config_file" &&
    grep -q '^APP_ENV=.\+' "$config_file" &&
    grep -q '^APP_PORT=[0-9]\+$' "$config_file"
}

check_metrics() {
    awk -F, '
        NR == 1 { next }
        $4 >= 90 { critical++ }
        END { exit(critical > 0 ? 1 : 0) }
    ' "$metrics_file"
}

check_log() {
    ! grep -q 'ERROR' "$log_file"
}

echo "Stage 1: validating input"
if ! validate_inputs; then
    echo "Automation failed during input validation." >&2
    exit 1
fi

echo "Stage 2: checking configuration"
if ! check_configuration; then
    echo "Automation failed during configuration check." >&2
    exit 1
fi

echo "Stage 3: checking metrics"
if ! check_metrics; then
    echo "Automation failed: critical disk usage found." >&2
    exit 1
fi

echo "Stage 4: checking log"
if ! check_log; then
    echo "Automation failed: ERROR found in log." >&2
    exit 1
fi

echo "Automation summary: all required checks passed."
exit 0

