#!/bin/bash

script_directory="$(cd -- "$(dirname -- "$0")" && pwd)"
default_artifact="$script_directory/../../04-lab-data/artifacts/inventory-api-v1.0.0.tar.gz"
artifact="${1:-$default_artifact}"
failed=0

if [[ -f "$artifact" ]]; then
    echo "PASS: regular artifact file exists."
else
    echo "FAIL: artifact is not a regular file." >&2
    failed=1
fi

if [[ -r "$artifact" ]]; then
    echo "PASS: artifact is readable."
else
    echo "FAIL: artifact is not readable." >&2
    failed=1
fi

if [[ -s "$artifact" ]]; then
    echo "PASS: artifact is not empty."
else
    echo "FAIL: artifact is empty or missing." >&2
    failed=1
fi

if [[ "$artifact" == *.tar.gz ]]; then
    echo "PASS: artifact name ends in .tar.gz."
else
    echo "FAIL: artifact name must end in .tar.gz." >&2
    failed=1
fi

if (( failed != 0 )); then
    echo "Artifact validation failed." >&2
    exit 1
fi

echo "Artifact validation passed."
exit 0
