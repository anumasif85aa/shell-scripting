#!/bin/bash

# Title: Controlled Cache Cleanup
# Usage: bash cleanup-cache.sh TARGET_DIRECTORY [--apply]

set -Eeuo pipefail

target_directory="${1:-}"
mode="${2:-}"

if (( $# > 2 )); then
    echo "Usage: $0 TARGET_DIRECTORY [--apply]" >&2
    exit 1
fi

if [[ -z "$target_directory" ]]; then
    echo "Error: target directory cannot be empty." >&2
    echo "Usage: $0 TARGET_DIRECTORY [--apply]" >&2
    exit 1
fi

if [[ -n "$mode" && "$mode" != "--apply" ]]; then
    echo "Error: unsupported option: $mode" >&2
    echo "Usage: $0 TARGET_DIRECTORY [--apply]" >&2
    exit 1
fi

if [[ ! -d "$target_directory" ]]; then
    echo "Error: target is not a directory: $target_directory" >&2
    exit 1
fi

if [[ ! -r "$target_directory" ]]; then
    echo "Error: target is not readable: $target_directory" >&2
    exit 1
fi

target_absolute=$(realpath -e -- "$target_directory") || {
    echo "Error: could not resolve target: $target_directory" >&2
    exit 1
}

home_absolute=$(realpath -e -- "$HOME") || {
    echo "Error: could not resolve the home directory." >&2
    exit 1
}

case "$target_absolute" in
    /|"$home_absolute")
        echo "Error: refusing unsafe target: $target_absolute" >&2
        exit 1
        ;;
esac

mapfile -d '' matching_files < <(
    find "$target_absolute" -type f -name "*.tmp" -print0
)

echo "Temporary files selected:"

if (( ${#matching_files[@]} == 0 )); then
    echo "  No matching .tmp files found."
else
    printf '  %s\n' "${matching_files[@]}"
fi

if [[ "$mode" != "--apply" ]]; then
    echo "Dry run: no files were deleted."
    exit 0
fi

if (( ${#matching_files[@]} == 0 )); then
    echo "Nothing to delete."
    exit 0
fi

if [[ ! -w "$target_absolute" ]]; then
    echo "Error: target directory is not writable: $target_absolute" >&2
    exit 1
fi

if ! read -r -p "Enter yes to delete the selected files: " answer; then
    echo "Error: could not read confirmation." >&2
    exit 1
fi

if [[ "$answer" != "yes" ]]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo "Deleting:"
find "$target_absolute" \
    -type f \
    -name "*.tmp" \
    -print \
    -delete

echo "Cleanup completed."
exit 0

