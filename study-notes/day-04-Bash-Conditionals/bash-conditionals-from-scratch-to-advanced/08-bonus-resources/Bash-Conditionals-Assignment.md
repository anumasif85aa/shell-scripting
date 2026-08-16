# Bash Conditionals Assignment

## Objective

Build a local system-readiness checker without using functions, loops, arrays, `case`, `sudo`, or remote systems.

## Requirements

Create `system_readiness.sh`.

The script must receive:

```text
$1 = environment
$2 = configuration file
$3 = log file
```

Validate:

1. Exactly three arguments were supplied.
2. Environment is `development`, `testing`, or `production`.
3. Configuration path is a readable, non-empty regular file.
4. Log path is a readable regular file.
5. Log filename ends in `.log`.
6. Log does not contain `CRITICAL`.

If every check passes:

```text
System readiness: PASS
```

Otherwise:

```text
System readiness: FAIL
```

Errors must go to `stderr`, and failure must return status `1`.

## Submission

- `system_readiness.sh`
- `README.md`
- Terminal evidence for at least three successful or failed tests
- Output of `bash -n system_readiness.sh`
