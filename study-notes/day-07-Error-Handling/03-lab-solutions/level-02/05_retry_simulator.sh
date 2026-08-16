#!/bin/bash

# Simulate a retryable operation without contacting a real service.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 FAILURES_BEFORE_SUCCESS" >&2
    exit 2
fi

failures_before_success="$1"

if [[ ! "$failures_before_success" =~ ^[0-5]$ ]]; then
    echo "Error: value must be from 0 through 5." >&2
    exit 2
fi

max_attempts=5

for (( attempt=1; attempt<=max_attempts; attempt++ ))
do
    echo "Attempt $attempt of $max_attempts"

    if [[ "$attempt" -gt "$failures_before_success" ]]; then
        echo "Operation succeeded on attempt $attempt."
        exit 0
    fi

    echo "Warning: simulated temporary failure." >&2
done

echo "Error: all retry attempts were exhausted." >&2
exit 1

