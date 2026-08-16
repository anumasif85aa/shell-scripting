#!/bin/bash

# Title: Build File Report
# Usage: bash build-file-report.sh SEARCH_DIRECTORY [OUTPUT_FILE]

set -Eeuo pipefail

search_directory="${1:-}"
output_file="${2:-file-report.txt}"

if [[ -z "$search_directory" ]]; then
    echo "Usage: $0 SEARCH_DIRECTORY [OUTPUT_FILE]" >&2
    exit 1
fi

if [[ ! -d "$search_directory" ]]; then
    echo "Error: directory does not exist: $search_directory" >&2
    exit 1
fi

if [[ ! -r "$search_directory" ]]; then
    echo "Error: directory is not readable: $search_directory" >&2
    exit 1
fi

search_absolute=$(realpath -e -- "$search_directory") || {
    echo "Error: could not resolve search directory: $search_directory" >&2
    exit 1
}

output_absolute=$(realpath -m -- "$output_file") || {
    echo "Error: could not resolve output path: $output_file" >&2
    exit 1
}

if [[ -d "$output_file" ]]; then
    echo "Error: output path is a directory: $output_file" >&2
    exit 1
fi

: > "$output_file" || {
    echo "Error: could not create output file: $output_file" >&2
    exit 1
}

printf '%s\n' "SIZE | PATH" > "$output_file"
printf '%s\n' "-----|-----" >> "$output_file"

while IFS= read -r -d '' file
do
    size_bytes=$(stat -c '%s' -- "$file")
    human_size=$(numfmt --to=iec-i --suffix=B "$size_bytes")
    printf '%s | %s\n' "$human_size" "$file" >> "$output_file"
done < <(
    find "$search_absolute" \
        -type f \
        ! -path "$output_absolute" \
        -print0
)

echo "Report created: $output_file"
exit 0

