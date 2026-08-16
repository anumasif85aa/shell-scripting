#!/bin/bash

source_directory="${1:-./data}"
destination_directory="${2:-./backups}"
timestamp="$(date +%Y%m%d-%H%M%S)"
source_name="${source_directory##*/}"
source_name="${source_name:-data}"
archive_name="${source_name}-${timestamp}.tar.gz"

echo "Mode: DRY RUN"
echo "Source: $source_directory"
echo "Destination: $destination_directory"
echo "Archive: $archive_name"
echo "No files were changed."
