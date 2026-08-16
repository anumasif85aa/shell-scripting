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
