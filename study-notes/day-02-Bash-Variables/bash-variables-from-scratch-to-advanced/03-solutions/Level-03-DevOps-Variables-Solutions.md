# Level 03 Solutions: DevOps Variables

## Solution 1: `01_config_reader.sh`

```bash
#!/bin/bash

script_directory="$(cd -- "$(dirname -- "$0")" && pwd)"
config_file="${1:-$script_directory/../../04-lab-data/app.env}"

if [[ ! -s "$config_file" ]]; then
    echo "Error: configuration file is missing or empty: $config_file" >&2
    exit 1
fi

app_name=""
app_env=""
app_port=""
log_level=""

while IFS='=' read -r key value; do
    [[ -z "$key" || "$key" == \#* ]] && continue

    case "$key" in
        APP_NAME) app_name="$value" ;;
        APP_ENV) app_env="$value" ;;
        APP_PORT) app_port="$value" ;;
        LOG_LEVEL) log_level="$value" ;;
        *) echo "Warning: ignored unknown key: $key" >&2 ;;
    esac
done < "$config_file"

echo "Application: $app_name"
echo "Environment: $app_env"
echo "Port: $app_port"
echo "Log level: $log_level"
```

## Solution 2: `02_required_variables.sh`

```bash
#!/bin/bash

: "${DEPLOY_APP:?DEPLOY_APP is required}"
: "${DEPLOY_ENV:?DEPLOY_ENV is required}"
: "${DEPLOY_OWNER:?DEPLOY_OWNER is required}"

echo "Application: $DEPLOY_APP"
echo "Environment: $DEPLOY_ENV"
echo "Owner: $DEPLOY_OWNER"
echo "Required variables are available."
```

Test:

```bash
bash 02_required_variables.sh
DEPLOY_APP=shop DEPLOY_ENV=testing DEPLOY_OWNER=ali bash 02_required_variables.sh
```

## Solution 3: `03_build_metadata.sh`

```bash
#!/bin/bash

app_name="${1:-demo-app}"
build_number="${BUILD_NUMBER:-local}"
build_user="$(whoami)"
build_host="$(hostname)"
build_time="$(date +%Y%m%d-%H%M%S)"

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    commit_id="$(git rev-parse --short HEAD)"
else
    commit_id="not-a-git-repository"
fi

build_id="${app_name}-${build_number}-${build_time}"

echo "Application: $app_name"
echo "Build number: $build_number"
echo "Build user: $build_user"
echo "Build host: $build_host"
echo "Build time: $build_time"
echo "Commit: $commit_id"
echo "Build ID: $build_id"
```

## Solution 4: `04_deployment_plan.sh`

```bash
#!/bin/bash

readonly COMPANY="NIT"

app_name="${1:-demo-app}"
environment="${2:-development}"
environment="${environment,,}"

if [[ "$environment" == "development" ]]; then
    replicas=1
elif [[ "$environment" == "testing" ]]; then
    replicas=2
elif [[ "$environment" == "production" ]]; then
    replicas=3
else
    echo "Error: invalid environment: $environment" >&2
    exit 1
fi

deployment_id="${app_name}-${environment}-$(date +%Y%m%d-%H%M%S)"

echo "Company: $COMPANY"
echo "Application: $app_name"
echo "Environment: $environment"
echo "Replicas: $replicas"
echo "Deployment ID: $deployment_id"
echo "Simulation only: no deployment performed."
```

## Solution 5: `05_secret_input.sh`

```bash
#!/bin/bash

read -r -p "Enter username: " username
read -r -s -p "Enter fake practice token: " token
echo

token_length="${#token}"

echo "Username: $username"
echo "Token length: $token_length"
echo "The token will not be displayed."

unset token
```

## Solution 6: `06_preflight.sh`

```bash
#!/bin/bash

script_directory="$(cd -- "$(dirname -- "$0")" && pwd)"
config_file="${1:-$script_directory/../../04-lab-data/app.env}"
servers_file="${2:-$script_directory/../../04-lab-data/servers.txt}"

app_env=""
app_port=""
failed=0

if [[ ! -s "$config_file" ]]; then
    echo "FAIL: configuration file is missing or empty." >&2
    failed=1
else
    echo "PASS: configuration file exists and is not empty."

    while IFS='=' read -r key value; do
        case "$key" in
            APP_ENV) app_env="$value" ;;
            APP_PORT) app_port="$value" ;;
        esac
    done < "$config_file"
fi

if [[ "$app_env" == "development" ||
      "$app_env" == "testing" ||
      "$app_env" == "production" ]]; then
    echo "PASS: APP_ENV is valid: $app_env"
else
    echo "FAIL: APP_ENV is invalid or missing." >&2
    failed=1
fi

if [[ "$app_port" =~ ^[0-9]+$ ]] &&
   (( app_port >= 1 && app_port <= 65535 )); then
    echo "PASS: APP_PORT is valid: $app_port"
else
    echo "FAIL: APP_PORT must be from 1 to 65535." >&2
    failed=1
fi

if [[ -s "$servers_file" ]]; then
    echo "PASS: servers file exists and is not empty."
else
    echo "FAIL: servers file is missing or empty." >&2
    failed=1
fi

if (( failed != 0 )); then
    echo "Preflight failed. No action was performed." >&2
    exit 1
fi

echo "Preflight passed. Simulation may continue."
exit 0
```

## Verification

```bash
bash -n 01_config_reader.sh
bash -n 02_required_variables.sh
bash -n 03_build_metadata.sh
bash -n 04_deployment_plan.sh
bash -n 05_secret_input.sh
bash -n 06_preflight.sh
```
