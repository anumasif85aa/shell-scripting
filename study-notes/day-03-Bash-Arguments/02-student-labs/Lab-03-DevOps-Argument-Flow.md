# Lab 03 — DevOps Argument Flow

## Objective

Use arguments to build safe, practical automation interfaces. These exercises
simulate operations and do not change real services.

## Task 1 — Deployment Summary

Create `01_deployment_summary.sh`.

- Require exactly three arguments:
  `APPLICATION ENVIRONMENT VERSION`
- Display a labelled deployment summary.
- Test:

```bash
./01_deployment_summary.sh web test 1.2.0
```

## Task 2 — Validate Environment

Create `02_validate_environment.sh`.

- Accept one environment.
- Allow only `dev`, `test`, `stage`, or `prod`.
- Use `case`.
- Return an error for another value.

## Task 3 — Configuration Inspector

Create `03_config_inspector.sh`.

- Accept one configuration-file path.
- Confirm that it is a regular, non-empty file.
- Display its line count.
- Test with:

```text
artifacts/config/app.conf
artifacts/config/empty.conf
```

## Task 4 — Manual Long Options

Create `04_long_options.sh`.

Support:

```text
--app VALUE
--env VALUE
--version VALUE
--help
```

Use `while`, `case`, and `shift`.

Test:

```bash
./04_long_options.sh --app api --env stage --version 2.0
```

## Task 5 — Short Options with `getopts`

Create `05_short_options.sh`.

Support:

```text
-a APPLICATION
-e ENVIRONMENT
-v VERSION
-h
```

Provide custom messages for unknown options and missing values.

## Task 6 — Final Deployment Simulator

Create `06_deploy_simulator.sh`.

- Use a `usage` function.
- Parse `-a`, `-e`, `-v`, and `-c` with `getopts`.
- Validate the environment.
- Validate the configuration file.
- Read the server names from `artifacts/servers.txt`.
- Display one simulated deployment line for each server.
- Print a final summary.

Example:

```bash
./06_deploy_simulator.sh \
    -a training-api \
    -e test \
    -v 3.1.0 \
    -c artifacts/config/app.conf
```

## Final Verification

```bash
bash -n *.sh
```

All valid runs should exit with status `0`; validation failures should return a
non-zero status.

