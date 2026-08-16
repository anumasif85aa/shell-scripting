#!/bin/bash

# Retry simulated jobs and report partial failures.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 JOBS_CSV" >&2
    exit 2
fi

jobs_file="$1"

if [[ ! -f "$jobs_file" ]]; then
    echo "Error: jobs file not found." >&2
    exit 3
fi

job_number=0
success_count=0
failure_count=0
max_attempts=3

while IFS=, read -r job failures_before_success
do
    ((job_number++))
    [[ "$job_number" -eq 1 ]] && continue
    [[ -z "$job" ]] && continue

    if [[ ! "$failures_before_success" =~ ^[0-9]+$ ]]; then
        echo "Error: invalid failure count for $job." >&2
        ((failure_count++))
        continue
    fi

    job_succeeded=false

    for (( attempt=1; attempt<=max_attempts; attempt++ ))
    do
        echo "$job: attempt $attempt"

        if [[ "$attempt" -gt "$failures_before_success" ]]; then
            echo "$job: succeeded"
            job_succeeded=true
            ((success_count++))
            break
        fi

        echo "$job: temporary failure" >&2
    done

    if [[ "$job_succeeded" == "false" ]]; then
        echo "$job: failed after $max_attempts attempts" >&2
        ((failure_count++))
    fi
done < "$jobs_file"

echo "Jobs succeeded: $success_count"
echo "Jobs failed: $failure_count"

if [[ "$failure_count" -gt 0 ]]; then
    exit 1
fi

exit 0

