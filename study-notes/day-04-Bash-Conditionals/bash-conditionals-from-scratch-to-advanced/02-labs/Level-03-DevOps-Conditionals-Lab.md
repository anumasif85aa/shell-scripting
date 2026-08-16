# Level 03 Lab: DevOps Release Conditionals

## Six connected tasks: zero to hero

## Objective

Build a safe local release-approval workflow using Bash conditionals. The final question is:

```text
Is this release safe and approved for deployment?
```

This is a local simulation. Do not use `sudo`, remote servers, production resources, functions, loops, arrays, `case`, or `getopts`.

Use the files in `04-lab-data/`.

## Task 1: Change-request validator

Create `01_change_request.sh`.

1. Receive a change ID as `$1`.
2. Reject missing input.
3. Accept only values matching `CHG-*`.
4. Confirm that the ID appears in `approval.txt`.
5. Print a clear success or failure and return the correct exit status.

## Task 2: Release-artifact validator

Create `02_artifact_check.sh`.

Validate the supplied release artifact:

- Exists as a regular file
- Is readable
- Is not empty
- Filename ends in `.tar.gz`

Print a separate result for every check. If any check fails, exit `1`.

## Task 3: Environment validator

Create `03_environment_check.sh`.

Read values from `release.env` with `grep` and `cut`:

- `APP_NAME`
- `VERSION`
- `ENVIRONMENT`
- `PORT`

Validate:

- No value is empty.
- Environment is `development`, `testing`, or `production`.
- Version matches `v` followed by digits and dots.
- Port contains digits and is from `1` to `65535`.

## Task 4: Approval validator

Create `04_approval_check.sh`.

Use `grep -q` directly in conditions to confirm that `approval.txt` contains:

```text
STATUS=approved
SECURITY_REVIEW=passed
TEST_RESULT=passed
```

Exit `1` if any approval is missing.

## Task 5: Server readiness

Create `05_server_readiness.sh`.

Validate `server-status.env`:

- `DISK_OK=yes`
- `MEMORY_OK=yes`
- `SERVICE_PORT_FREE=yes`
- `MAINTENANCE_MODE=no`

Use combined conditions. This file represents a simulated local server; no connection is performed.

## Task 6: Release controller and audit

Create `06_release_controller.sh`.

Perform the complete decision in one script:

1. Validate the change ID.
2. Validate the artifact.
3. Validate the release environment.
4. Validate approvals.
5. Validate server readiness.
6. Create a final decision:
   - `APPROVED FOR SIMULATION`
   - `REJECTED`
7. Append the decision, timestamp, application, version, and change ID to `deployment-audit.log`.
8. Print:

```text
Simulation only: no deployment was performed.
```

## Safe flow

```text
Input
  ↓
Validate change
  ↓
Validate artifact
  ↓
Validate configuration
  ↓
Validate approvals
  ↓
Validate readiness
  ↓
Record decision
```

## Final verification

```bash
bash -n *.sh
```

Test both approved and rejected conditions.
