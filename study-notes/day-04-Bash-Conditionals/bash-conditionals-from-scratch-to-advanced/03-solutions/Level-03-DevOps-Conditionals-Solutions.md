# Level 03 Solutions: DevOps Release Conditionals

All actions are local simulations.

## Solution 1: `01_change_request.sh`

```bash
#!/bin/bash

script_directory="$(cd -- "$(dirname -- "$0")" && pwd)"
approval_file="$script_directory/../../04-lab-data/approval.txt"
change_id="${1:-}"

if [[ -z "$change_id" ]]; then
    echo "Usage: $0 CHANGE_ID" >&2
    exit 1
elif [[ "$change_id" != CHG-* ]]; then
    echo "FAIL: change ID must match CHG-*." >&2
    exit 1
elif grep -q "^CHANGE_ID=${change_id}$" "$approval_file"; then
    echo "PASS: approved change request found: $change_id"
    exit 0
else
    echo "FAIL: change request was not found." >&2
    exit 1
fi
```

## Solution 2: `02_artifact_check.sh`

```bash
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
```

## Solution 3: `03_environment_check.sh`

```bash
#!/bin/bash

script_directory="$(cd -- "$(dirname -- "$0")" && pwd)"
config_file="${1:-$script_directory/../../04-lab-data/release.env}"

if [[ ! -s "$config_file" ]]; then
    echo "FAIL: release configuration is missing or empty." >&2
    exit 1
fi

app_name="$(grep -m1 '^APP_NAME=' "$config_file" | cut -d= -f2-)"
version="$(grep -m1 '^VERSION=' "$config_file" | cut -d= -f2-)"
environment="$(grep -m1 '^ENVIRONMENT=' "$config_file" | cut -d= -f2-)"
port="$(grep -m1 '^PORT=' "$config_file" | cut -d= -f2-)"

if [[ -z "$app_name" || -z "$version" || -z "$environment" || -z "$port" ]]; then
    echo "FAIL: one or more required values are empty." >&2
    exit 1
elif [[ "$environment" != "development" &&
        "$environment" != "testing" &&
        "$environment" != "production" ]]; then
    echo "FAIL: invalid environment: $environment" >&2
    exit 1
elif [[ ! "$version" =~ ^v[0-9]+([.][0-9]+)*$ ]]; then
    echo "FAIL: invalid version: $version" >&2
    exit 1
elif [[ ! "$port" =~ ^[0-9]+$ ]] || (( port < 1 || port > 65535 )); then
    echo "FAIL: invalid port: $port" >&2
    exit 1
else
    echo "Application: $app_name"
    echo "Version: $version"
    echo "Environment: $environment"
    echo "Port: $port"
    echo "Environment validation passed."
    exit 0
fi
```

## Solution 4: `04_approval_check.sh`

```bash
#!/bin/bash

script_directory="$(cd -- "$(dirname -- "$0")" && pwd)"
approval_file="${1:-$script_directory/../../04-lab-data/approval.txt}"

if [[ ! -s "$approval_file" ]]; then
    echo "FAIL: approval file is missing or empty." >&2
    exit 1
elif grep -q '^STATUS=approved$' "$approval_file" &&
     grep -q '^SECURITY_REVIEW=passed$' "$approval_file" &&
     grep -q '^TEST_RESULT=passed$' "$approval_file"; then
    echo "Approval validation passed."
    exit 0
else
    echo "Approval validation failed." >&2
    exit 1
fi
```

## Solution 5: `05_server_readiness.sh`

```bash
#!/bin/bash

script_directory="$(cd -- "$(dirname -- "$0")" && pwd)"
status_file="${1:-$script_directory/../../04-lab-data/server-status.env}"

if [[ ! -s "$status_file" ]]; then
    echo "FAIL: simulated server-status file is missing or empty." >&2
    exit 1
fi

disk_ok="$(grep -m1 '^DISK_OK=' "$status_file" | cut -d= -f2-)"
memory_ok="$(grep -m1 '^MEMORY_OK=' "$status_file" | cut -d= -f2-)"
port_free="$(grep -m1 '^SERVICE_PORT_FREE=' "$status_file" | cut -d= -f2-)"
maintenance="$(grep -m1 '^MAINTENANCE_MODE=' "$status_file" | cut -d= -f2-)"

if [[ "$disk_ok" == "yes" &&
      "$memory_ok" == "yes" &&
      "$port_free" == "yes" &&
      "$maintenance" == "no" ]]; then
    echo "Simulated server is ready."
    exit 0
else
    echo "Simulated server is not ready." >&2
    exit 1
fi
```

## Solution 6: `06_release_controller.sh`

```bash
#!/bin/bash

script_directory="$(cd -- "$(dirname -- "$0")" && pwd)"
data_directory="$script_directory/../../04-lab-data"
approval_file="$data_directory/approval.txt"
config_file="$data_directory/release.env"
status_file="$data_directory/server-status.env"
artifact="$data_directory/artifacts/inventory-api-v1.0.0.tar.gz"
audit_file="$data_directory/deployment-audit.log"
change_id="${1:-}"
failed=0

app_name="$(grep -m1 '^APP_NAME=' "$config_file" | cut -d= -f2-)"
version="$(grep -m1 '^VERSION=' "$config_file" | cut -d= -f2-)"
environment="$(grep -m1 '^ENVIRONMENT=' "$config_file" | cut -d= -f2-)"
port="$(grep -m1 '^PORT=' "$config_file" | cut -d= -f2-)"
disk_ok="$(grep -m1 '^DISK_OK=' "$status_file" | cut -d= -f2-)"
memory_ok="$(grep -m1 '^MEMORY_OK=' "$status_file" | cut -d= -f2-)"
port_free="$(grep -m1 '^SERVICE_PORT_FREE=' "$status_file" | cut -d= -f2-)"
maintenance="$(grep -m1 '^MAINTENANCE_MODE=' "$status_file" | cut -d= -f2-)"

if [[ -z "$change_id" || "$change_id" != CHG-* ]] ||
   ! grep -q "^CHANGE_ID=${change_id}$" "$approval_file"; then
    echo "FAIL: change request validation." >&2
    failed=1
else
    echo "PASS: change request validation."
fi

if [[ -f "$artifact" && -r "$artifact" && -s "$artifact" && "$artifact" == *.tar.gz ]]; then
    echo "PASS: artifact validation."
else
    echo "FAIL: artifact validation." >&2
    failed=1
fi

if [[ -n "$app_name" &&
      "$version" =~ ^v[0-9]+([.][0-9]+)*$ &&
      ( "$environment" == "development" ||
        "$environment" == "testing" ||
        "$environment" == "production" ) &&
      "$port" =~ ^[0-9]+$ ]] &&
   (( port >= 1 && port <= 65535 )); then
    echo "PASS: release configuration."
else
    echo "FAIL: release configuration." >&2
    failed=1
fi

if grep -q '^STATUS=approved$' "$approval_file" &&
   grep -q '^SECURITY_REVIEW=passed$' "$approval_file" &&
   grep -q '^TEST_RESULT=passed$' "$approval_file"; then
    echo "PASS: required approvals."
else
    echo "FAIL: required approvals." >&2
    failed=1
fi

if [[ "$disk_ok" == "yes" &&
      "$memory_ok" == "yes" &&
      "$port_free" == "yes" &&
      "$maintenance" == "no" ]]; then
    echo "PASS: simulated server readiness."
else
    echo "FAIL: simulated server readiness." >&2
    failed=1
fi

timestamp="$(date +%Y-%m-%dT%H:%M:%S)"

if (( failed == 0 )); then
    decision="APPROVED FOR SIMULATION"
    exit_status=0
else
    decision="REJECTED"
    exit_status=1
fi

echo "$timestamp | $app_name | $version | $change_id | $decision" >> "$audit_file"
echo "Final decision: $decision"
echo "Simulation only: no deployment was performed."
exit "$exit_status"
```

## Verification

```bash
bash -n 01_change_request.sh
bash -n 02_artifact_check.sh
bash -n 03_environment_check.sh
bash -n 04_approval_check.sh
bash -n 05_server_readiness.sh
bash -n 06_release_controller.sh
```
