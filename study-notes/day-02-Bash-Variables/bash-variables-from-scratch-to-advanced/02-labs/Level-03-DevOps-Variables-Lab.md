# Level 03 Lab: DevOps Variables

## Objective

Apply variables to configuration loading, required settings, build metadata, deployment planning, secret input, and preflight validation.

## Safety

- The scripts must not create users, deploy software, or change services.
- All deployment actions are simulations.
- Do not hardcode or print real credentials.
- Do not blindly `source` an untrusted file.

Use the files in `04-lab-data/`.

## Task 1: Safe configuration reader

Create `01_config_reader.sh`.

Read `app.env` line by line:

```bash
while IFS='=' read -r key value; do
    echo "Key: $key"
    echo "Value: $value"
done < app.env
```

Use `case` to accept only:

- `APP_NAME`
- `APP_ENV`
- `APP_PORT`
- `LOG_LEVEL`

Ignore blank lines and comment lines. Print the loaded configuration.

## Task 2: Required deployment variables

Create `02_required_variables.sh`.

Require these exported variables:

- `DEPLOY_APP`
- `DEPLOY_ENV`
- `DEPLOY_OWNER`

Use `${variable:?message}` or clear `if` checks. Test once with missing values and once with all values:

```bash
DEPLOY_APP=shop DEPLOY_ENV=testing DEPLOY_OWNER=ali bash 02_required_variables.sh
```

## Task 3: Build metadata

Create `03_build_metadata.sh`.

Store:

- Application name from `$1`, default `demo-app`
- Build number from `BUILD_NUMBER`, default `local`
- Current user
- Current hostname
- Current timestamp
- Git commit ID when inside a Git repository; otherwise use `not-a-git-repository`

Create a build ID from those values and print a report.

## Task 4: Deployment planner

Create `04_deployment_plan.sh`.

1. Use a read-only company variable.
2. Read application and environment from arguments.
3. Normalize environment to lowercase.
4. Allow only `development`, `testing`, or `production`.
5. Set replicas:
   - development: `1`
   - testing: `2`
   - production: `3`
6. Print a deployment plan.
7. Finish with `Simulation only: no deployment performed.`

## Task 5: Secret input practice

Create `05_secret_input.sh`.

1. Ask for a username.
2. Ask for a token using `read -r -s -p`.
3. Print the username.
4. Print only the token length.
5. Do not print the token.
6. Unset the token before the script exits.

Use a fake token for practice.

## Task 6: Preflight validator

Create `06_preflight.sh`.

Validate:

- Configuration file exists and is not empty.
- `APP_ENV` is one of the accepted environments.
- `APP_PORT` contains digits only.
- Port is from `1` to `65535`.
- `servers.txt` exists and is not empty.

Print a clear report. If any check fails, exit non-zero and print:

```text
Preflight failed. No action was performed.
```

If all checks pass, print:

```text
Preflight passed. Simulation may continue.
```

## Final verification

```bash
bash -n *.sh
```

Test every failure path as well as the successful path.
