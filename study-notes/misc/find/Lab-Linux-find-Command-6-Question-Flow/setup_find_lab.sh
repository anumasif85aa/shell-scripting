#!/bin/bash

# Title: Linux find Command Lab Data Setup
# Usage: bash setup_find_lab.sh [TARGET_DIRECTORY]

set -Eeuo pipefail

target_directory="${1:-./find-lab-data}"

if [[ -z "$target_directory" ]]; then
    echo "Error: target directory cannot be empty." >&2
    exit 1
fi

case "$target_directory" in
    /|"$HOME"|"$HOME"/)
        echo "Error: refusing unsafe target: $target_directory" >&2
        exit 1
        ;;
esac

if [[ -e "$target_directory" ]]; then
    echo "Error: target already exists: $target_directory" >&2
    echo "Choose a new target path. Existing data will not be overwritten." >&2
    exit 1
fi

mkdir -p -- \
    "$target_directory/logs/current" \
    "$target_directory/logs/archive" \
    "$target_directory/scripts/tools" \
    "$target_directory/configs" \
    "$target_directory/reports" \
    "$target_directory/cache" \
    "$target_directory/empty-directory" \
    "$target_directory/links"

printf '%s\n' \
    '2026-08-09 08:00:01 INFO Application started' \
    '2026-08-09 08:01:15 INFO Health check passed' \
    > "$target_directory/logs/current/application.log"

printf '%s\n' \
    '2026-08-09 08:02:10 ERROR Database connection timed out' \
    '2026-08-09 08:02:14 INFO Database connection recovered' \
    > "$target_directory/logs/current/error.log"

printf '%s\n' \
    '2026-06-01 07:00:00 INFO Archived application log' \
    > "$target_directory/logs/archive/application-2026-06-01.log"

printf '%s\n' \
    '2026-06-15 09:30:00 ERROR Archived uppercase extension log' \
    > "$target_directory/logs/archive/error-2026-06-15.LOG"

: > "$target_directory/logs/archive/empty.log"

# A sparse file provides a realistic large-file match without storing 2 MiB of content.
truncate -s 2M -- "$target_directory/logs/archive/large-debug.log"

printf '%s\n' \
    '#!/bin/bash' \
    'echo "Backup simulation completed"' \
    > "$target_directory/scripts/backup.sh"

printf '%s\n' \
    '#!/bin/bash' \
    'echo "Cleanup simulation completed"' \
    > "$target_directory/scripts/cleanup.sh"

printf '%s\n' \
    '#!/bin/bash' \
    'echo "Daily report generated"' \
    > "$target_directory/scripts/daily report.sh"

printf '%s\n' \
    '#!/bin/bash' \
    'echo "Health check: OK"' \
    > "$target_directory/scripts/tools/health-check.sh"

chmod 750 -- \
    "$target_directory/scripts/backup.sh" \
    "$target_directory/scripts/cleanup.sh" \
    "$target_directory/scripts/daily report.sh" \
    "$target_directory/scripts/tools/health-check.sh"

printf '%s\n' \
    'environment=training' \
    'port=8080' \
    'debug=false' \
    > "$target_directory/configs/application.conf"

printf '%s\n' \
    'host=db01.example.internal' \
    'port=5432' \
    'database=training' \
    > "$target_directory/configs/database.conf"

printf '%s\n' \
    'Find Command Lab' \
    'Use this dataset only for controlled practice.' \
    > "$target_directory/configs/README.txt"

printf '%s\n' \
    'Daily status: healthy' \
    'Errors investigated: 1' \
    > "$target_directory/reports/daily report.txt"

printf '%s\n' \
    '# Weekly Report' \
    '- Availability: 99.9%' \
    '- Pending maintenance: none' \
    > "$target_directory/reports/weekly.md"

printf '%s\n' 'temporary session data 001' > "$target_directory/cache/session-001.tmp"
printf '%s\n' 'temporary session data 002' > "$target_directory/cache/session-002.tmp"
printf '%s\n' 'temporary file with spaces' > "$target_directory/cache/old session.tmp"
printf '%s\n' 'This file must not be deleted.' > "$target_directory/cache/keep.txt"

ln -s -- ../logs/current/application.log "$target_directory/links/latest-application.log"

touch -d '45 days ago' -- \
    "$target_directory/logs/archive/application-2026-06-01.log" \
    "$target_directory/logs/archive/error-2026-06-15.LOG" \
    "$target_directory/logs/archive/empty.log" \
    "$target_directory/logs/archive/large-debug.log" \
    "$target_directory/cache/session-001.tmp" \
    "$target_directory/cache/old session.tmp"

touch -d '3 days ago' -- \
    "$target_directory/logs/current/application.log" \
    "$target_directory/reports/daily report.txt"

echo "Lab data created successfully: $target_directory"
echo "Start with: cd \"$target_directory\""
exit 0
