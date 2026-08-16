# Level 02 Solutions: Practical Variables

## Solution 1: `01_environment.sh`

```bash
#!/bin/bash

environment="${1:-development}"
environment="${environment,,}"

if [[ "$environment" == "development" ||
      "$environment" == "testing" ||
      "$environment" == "production" ]]; then
    echo "Environment: $environment"
    exit 0
else
    echo "Error: use development, testing, or production." >&2
    exit 1
fi
```

## Solution 2: `02_port_validator.sh`

```bash
#!/bin/bash

read -r -p "Enter port number: " port

if [[ -z "$port" ]]; then
    echo "Error: port cannot be empty." >&2
    exit 1
elif [[ ! "$port" =~ ^[0-9]+$ ]]; then
    echo "Error: port must contain digits only." >&2
    exit 1
elif (( port < 1 || port > 65535 )); then
    echo "Error: port must be from 1 to 65535." >&2
    exit 1
else
    echo "Valid port: $port"
    exit 0
fi
```

## Solution 3: `03_app_report.sh`

```bash
#!/bin/bash

app_name="${APP_NAME:-demo-app}"
app_env="${APP_ENV:-development}"
app_port="${APP_PORT:-8080}"

echo "Application: $app_name"
echo "Environment: $app_env"
echo "Port: $app_port"
```

Tests:

```bash
bash 03_app_report.sh
APP_NAME=shop APP_ENV=testing APP_PORT=9090 bash 03_app_report.sh
```

## Solution 4: `04_filename_inspector.sh`

```bash
#!/bin/bash

path="${1:-/var/log/my-app.log}"
filename="${path##*/}"
base_name="${filename%.*}"
extension="${filename##*.}"
length="${#filename}"

echo "Original path: $path"
echo "Filename: $filename"
echo "Base name: $base_name"
echo "Extension: $extension"
echo "Filename length: $length"
```

## Solution 5: `05_log_name.sh`

```bash
#!/bin/bash

app_name="${1:-demo-app}"
timestamp="$(date +%Y%m%d-%H%M%S)"
log_name="${app_name}-${timestamp}.log"

echo "Application: $app_name"
echo "Log filename: $log_name"
```

## Solution 6: `06_backup_plan.sh`

```bash
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
```

## Suggested tests

```bash
bash 01_environment.sh
bash 01_environment.sh PRODUCTION
bash 01_environment.sh unknown

bash 04_filename_inspector.sh "/var/log/my app.log"
bash 06_backup_plan.sh
bash 06_backup_plan.sh "/srv/app data" "/tmp/my backups"
```
