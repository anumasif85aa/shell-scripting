# Mini Project: Local Release Approval Gate

## Scenario

A release must not continue until its change request, artifact, configuration, approvals, and simulated server status all pass validation.

## Build

Create `release_gate.sh` using only:

- Variables and arguments
- `if`, `elif`, and `else`
- `[[ ]]` and `(( ))`
- `&&`, `||`, and `!`
- Basic commands such as `grep`, `cut`, `date`, and `echo`
- Redirection and exit statuses

Do not use functions, loops, arrays, `case`, `sudo`, remote systems, or production resources.

## Inputs

Use the supplied files:

- `release.env`
- `approval.txt`
- `server-status.env`
- `inventory-api-v1.0.0.tar.gz`

Receive the change ID as `$1`.

## Required checks

- Change ID matches `CHG-*`.
- Change ID exists in approval data.
- Artifact is a readable, non-empty `.tar.gz` file.
- Application and version are not empty.
- Environment is allowed.
- Port is valid.
- Change is approved.
- Security review passed.
- Tests passed.
- Simulated disk and memory are ready.
- Service port is free.
- Maintenance mode is off.

## Output

Print one `PASS` or `FAIL` line for every stage and one final decision:

```text
APPROVED FOR SIMULATION
```

or:

```text
REJECTED
```

Append the decision to a local audit file. Never deploy anything.

## Success criteria

- `bash -n release_gate.sh` returns no output.
- Approved data returns status `0`.
- At least three changed or missing inputs return status `1`.
- The audit log records every final decision.
