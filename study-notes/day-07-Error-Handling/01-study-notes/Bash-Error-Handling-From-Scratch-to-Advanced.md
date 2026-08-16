# Bash Error Handling — From Scratch to Advanced

## 1. What Is Error Handling?

Error handling is the planned way a script:

1. Detects that something went wrong.
2. Explains the problem clearly.
3. Chooses whether to continue, retry, use a fallback, or stop.
4. Cleans up temporary work.
5. Returns a meaningful result to the caller.

Without error handling, a script may print a success message even though an
important command failed.

```text
Input → Validate → Run → Check → Respond → Verify → Exit
```

## 2. Why It Matters

A reliable script must serve two audiences:

- **Human user:** needs a clear message.
- **Calling program:** needs a correct exit status.

Bad behavior:

```bash
cp "$source" "$destination"
echo "Backup completed"
```

The success message runs even when `cp` fails.

Better:

```bash
if cp -- "$source" "$destination"; then
    echo "Backup completed"
else
    echo "Error: backup failed" >&2
    exit 1
fi
```
[Expalnation of this code](../code-explanations/Bash-cp-Command-Error-Handling-Study-Notes.md)

## 3. Main Types of Errors

### 3.1 Syntax Error

The shell cannot parse the script.

```bash
if [[ "$age" -ge 18 ]]; then
    echo "Adult"
# Missing fi
```

Check without running commands:

```bash
bash -n script.sh
```

### 3.2 Runtime Error

The syntax is valid, but a command fails during execution.

```bash
cp missing.txt backup/
```

### 3.3 Validation Error

The supplied input is missing, malformed, or unsafe.

```bash
./table.sh apple
```

### 3.4 Logic Error

The script runs but produces the wrong result.

```bash
if [[ "$age" -le 18 ]]; then
    echo "Adult"
fi
```

`bash -n` cannot find logic errors.

### 3.5 External or Environmental Error

The script depends on something outside its own code:

- Network unavailable.
- Disk full.
- Permission denied.
- Command not installed.
- Service unavailable.
- Configuration missing.

## 4. Exit Status

Every command returns an integer status.

- `0` normally means success.
- `1` through `255` are nonzero statuses.

Check immediately:

```bash
ls /etc
echo "$?"

ls /missing
echo "$?"
```

Another command replaces `$?`, so save it immediately:

```bash
some_command
status=$?

echo "Command status: $status"
```

## 5. Exit Status Is Not the Error Message

These are different:

- **stderr message:** information for a human.
- **exit status:** numeric information for another process.

```bash
echo "Error: configuration file is missing" >&2
exit 1
```

A script may fail silently with a nonzero status, or print an error but still
return `0`. Good scripts provide both.

## 6. Standard Output and Standard Error

| Stream | Descriptor | Purpose |
|---|---:|---|
| stdin | 0 | Input |
| stdout | 1 | Normal output |
| stderr | 2 | Errors and diagnostics |

Normal output:

```bash
echo "Report created"
```

Error output:

```bash
echo "Error: report creation failed" >&2
```

Separate logs:

```bash
./script.sh > output.log 2> error.log
```

Combine both:

```bash
./script.sh > all.log 2>&1
```

Appending:

```bash
./script.sh >> all.log 2>&1
```

## 7. Explicit exit

```bash
exit 0
```

means success.

```bash
exit 1
```

means failure.

If a script reaches the end without `exit`, its status is normally the status
of the last command executed.

Example:

```bash
#!/bin/bash

echo "Finished"
```

`echo` normally succeeds, so the script normally returns `0`.

## 8. Suggested Exit-Code Plan

There is no universal meaning for every custom status, but a script should be
consistent and document its choices.

| Status | Suggested meaning |
|---:|---|
| `0` | Success |
| `1` | General runtime failure |
| `2` | Usage or validation error |
| `3` | Required file or dependency missing |
| `4` | Operation completed with a defined warning |

Some values already have common shell meanings, such as `126` for a command
that cannot be executed and `127` for a command not found. Avoid inventing
conflicting meanings without a reason.

## 9. Check a Command with if

The cleanest beginner approach:

```bash
if mkdir -- "$directory"; then
    echo "Directory created"
else
    echo "Error: directory creation failed" >&2
    exit 1
fi
```

`if` checks the command's exit status directly.

Avoid unnecessary `$?`:

```bash
mkdir -- "$directory"

if [[ "$?" -eq 0 ]]; then
    echo "Created"
fi
```

This works only when `$?` is checked immediately, but direct command testing is
usually clearer.

## 10. Negation with !

Run a failure block when a command fails:

```bash
if ! cp -- "$source" "$destination"; then
    echo "Error: copy failed" >&2
    exit 1
fi

echo "Copy completed"
```

`!` reverses the command result:

- command success becomes a false condition
- command failure becomes a true condition

Use this pattern when the normal path should continue after the check.

## 11. && and ||

Run the next command only after success:

```bash
mkdir reports && echo "Directory created"
```

Run a fallback after failure:

```bash
cd reports || exit 1
```

A longer chain can become hard to read:

```bash
command1 && command2 && command3 || error_handler
```

The `||` part may run because any earlier command failed. Prefer `if` for
important multi-step workflows.

## 12. Guard Clauses

A guard clause rejects a problem early:

```bash
if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 FILE" >&2
    exit 2
fi

file="$1"

if [[ ! -f "$file" ]]; then
    echo "Error: file not found: $file" >&2
    exit 3
fi

echo "Processing: $file"
```

Guard clauses keep the successful path easier to read.

## 13. Validate Before Acting

### Argument Count

```bash
if [[ "$#" -ne 2 ]]; then
    echo "Usage: $0 SOURCE DESTINATION" >&2
    exit 2
fi
```

### Empty String

```bash
if [[ -z "$name" ]]; then
    echo "Error: name cannot be empty" >&2
    exit 2
fi
```

### Whole Number

```bash
if [[ ! "$value" =~ ^-?[0-9]+$ ]]; then
    echo "Error: expected a whole number" >&2
    exit 2
fi
```

### Allowed Value

```bash
case "$environment" in
    dev|test|stage|prod)
        ;;
    *)
        echo "Error: invalid environment" >&2
        exit 2
        ;;
esac
```

### File

```bash
if [[ ! -f "$file" ]]; then
    echo "Error: regular file required" >&2
    exit 3
fi
```

### Nonempty File

```bash
if [[ ! -s "$file" ]]; then
    echo "Error: file is missing or empty" >&2
    exit 3
fi
```

`-s` checks size, not meaningful non-whitespace content:

```bash
if [[ ! -f "$file" ]] || ! grep -q '[^[:space:]]' "$file"; then
    echo "Error: meaningful content required" >&2
    exit 3
fi
```

## 14. Error Handling in Functions

Functions use command-style statuses.

```bash
validate_file() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        echo "Error: file not found: $file" >&2
        return 1
    fi

    return 0
}
```

Caller:

```bash
if ! validate_file "$config"; then
    exit 1
fi
```

Use:

- `return` to leave a function.
- `exit` to leave the entire script.

Calling `exit` inside a general-purpose function makes reuse harder.

## 15. Returning Data and Status

A function can write data to stdout and return a status:

```bash
get_port() {
    local file="$1"
    local port

    port="$(awk -F= '$1=="PORT"{print $2}' "$file")"

    if [[ -z "$port" ]]; then
        echo "Error: PORT is missing" >&2
        return 1
    fi

    echo "$port"
}
```

Caller:

```bash
if ! port="$(get_port "$config")"; then
    exit 1
fi

echo "Port: $port"
```

## 16. Command Substitution and Failure

This captures stdout:

```bash
value="$(some_command)"
```

Check the assignment directly:

```bash
if ! value="$(some_command)"; then
    echo "Error: unable to obtain value" >&2
    exit 1
fi
```

Avoid printing normal diagnostics to stdout inside the called function, because
they would be captured as data.

## 17. Pipelines

Example:

```bash
producer | filter | consumer
```

By default, the pipeline's status is usually the status of its last command.
An earlier failure may be hidden.

```bash
false | true
echo "$?"
```

The final `true` succeeds, so the pipeline may report `0`.

Enable pipeline failure detection:

```bash
set -o pipefail
```

Then a pipeline returns nonzero if any component fails, unless a later failing
status is handled by shell rules.

## 18. PIPESTATUS

Immediately after a pipeline:

```bash
command1 | command2 | command3
statuses=("${PIPESTATUS[@]}")

echo "First: ${statuses[0]}"
echo "Second: ${statuses[1]}"
echo "Third: ${statuses[2]}"
```

Save `PIPESTATUS` immediately because another command or pipeline changes it.

## 19. Strict-Mode Options

Common line:

```bash
set -Eeuo pipefail
```

| Option | Purpose |
|---|---|
| `-e` | Exit on many unhandled command failures |
| `-u` | Treat many unset variable expansions as errors |
| `-o pipefail` | Detect failure in any pipeline component |
| `-E` | Improve `ERR` trap inheritance in functions and subshell contexts |

Strict mode helps reveal problems, but it is not a replacement for deliberate
error handling.

## 20. Important set -e Limitations

`set -e` has context-dependent exceptions. A failing command may not stop the
script when used:

- as an `if` test
- after `!`
- before `&&` or `||`
- in some loop conditions
- in command substitutions, depending on context and shell options

Expected failures should be handled explicitly:

```bash
if grep -q "ERROR" "$log"; then
    echo "Errors found"
else
    status=$?

    if [[ "$status" -eq 1 ]]; then
        echo "No error lines found"
    else
        echo "grep failed with status $status" >&2
        exit 1
    fi
fi
```

For `grep`:

- `0`: match found
- `1`: no match
- greater than `1`: actual error

Not every nonzero status means the same kind of failure.

## 21. set -u and Defaults

With `set -u`, this may fail:

```bash
echo "$OPTIONAL_VALUE"
```

Use a default:

```bash
echo "${OPTIONAL_VALUE:-not-set}"
```

Require a value:

```bash
: "${REQUIRED_VALUE:?REQUIRED_VALUE must be set}"
```

Default and assign:

```bash
: "${LOG_LEVEL:=INFO}"
```

## 22. Logging

A simple logger:

```bash
log_info() {
    echo "$(date '+%F %T') INFO $*"
}

log_error() {
    echo "$(date '+%F %T') ERROR $*" >&2
}
```

Use levels consistently:

- `INFO`: normal progress.
- `WARNING`: unusual but recoverable.
- `ERROR`: required action failed.

Do not log passwords, tokens, private keys, or other secrets.

## 23. Retries

Retry only failures that may be temporary.

```bash
max_attempts=3
attempt=1

while [[ "$attempt" -le "$max_attempts" ]]
do
    if temporary_command; then
        echo "Command succeeded"
        break
    fi

    echo "Warning: attempt $attempt failed" >&2

    if [[ "$attempt" -eq "$max_attempts" ]]; then
        echo "Error: all attempts failed" >&2
        exit 1
    fi

    sleep 2
    ((attempt++))
done
```

Do not retry permanent validation errors.

## 24. Backoff

Increasing the delay reduces pressure on a struggling dependency:

```bash
delay=1

for attempt in 1 2 3
do
    if temporary_command; then
        exit 0
    fi

    sleep "$delay"
    delay=$(( delay * 2 ))
done

exit 1
```

Real automation may add a maximum delay and small random jitter.

## 25. Timeouts

Prevent a command from waiting forever:

```bash
if timeout 10s some_command; then
    echo "Command completed"
else
    status=$?
    echo "Error: command failed or timed out with status $status" >&2
fi
```

GNU `timeout` commonly returns `124` when the time limit expires. Check the
manual on the target system.

## 26. Traps

General form:

```bash
trap 'commands' SIGNAL
```

Useful traps:

| Trap | When it runs |
|---|---|
| `EXIT` | Shell is exiting |
| `ERR` | An eligible command fails |
| `INT` | Interrupt, often `Ctrl+C` |
| `TERM` | Termination request |

Prefer a function:

```bash
cleanup() {
    echo "Cleaning temporary work"
}

trap cleanup EXIT
```

## 27. Preserve the Original Status in Cleanup

Cleanup commands can change `$?`. Save it first:

```bash
cleanup() {
    local status=$?

    echo "Cleanup started"

    exit "$status"
}

trap cleanup EXIT
```

This allows the script to retain its original success or failure.

## 28. Safe Temporary Files

Create a unique temporary file:

```bash
temporary_file="$(mktemp)"
```

Check:

```bash
if [[ -z "$temporary_file" || ! -f "$temporary_file" ]]; then
    echo "Error: temporary file creation failed" >&2
    exit 1
fi
```

Clean up:

```bash
cleanup() {
    local status=$?

    if [[ -n "${temporary_file:-}" && -f "$temporary_file" ]]; then
        rm -f -- "$temporary_file"
    fi

    exit "$status"
}

trap cleanup EXIT
```

Do not use a predictable path such as `/tmp/myfile`.

## 29. Signals and Graceful Shutdown

```bash
interrupted=false

handle_interrupt() {
    interrupted=true
    echo "Interrupt received" >&2
}

trap handle_interrupt INT TERM
```

A long loop can check the flag and stop at a safe boundary:

```bash
for item in "${items[@]}"
do
    if [[ "$interrupted" == "true" ]]; then
        echo "Stopping safely" >&2
        exit 130
    fi

    process_item "$item"
done
```

Status `130` commonly represents termination by `Ctrl+C`, though scripts
should document their behavior.

## 30. Error Context

Useful Bash variables:

| Variable | Information |
|---|---|
| `$?` | Previous command status |
| `$LINENO` | Current line number |
| `${FUNCNAME[0]}` | Current function name |
| `$BASH_COMMAND` | Command currently being executed |
| `${BASH_SOURCE[0]}` | Current script source |

Example:

```bash
error_report() {
    local status=$?
    echo "Error on line $LINENO: $BASH_COMMAND (status $status)" >&2
    return "$status"
}

trap error_report ERR
```

Keep trap handlers simple. Complex traps can create confusing secondary
failures.

## 31. Background Jobs

Start:

```bash
command1 &
pid1=$!

command2 &
pid2=$!
```

Wait and check:

```bash
if wait "$pid1"; then
    echo "First job succeeded"
else
    echo "First job failed" >&2
fi
```

`$!` is the process ID of the most recently started background job.

## 32. Partial Success

Batch automation may have:

- all items successful
- some items successful
- no items successful

Track totals:

```bash
success_count=0
failure_count=0

for file in "$@"
do
    if process_file "$file"; then
        ((success_count++))
    else
        ((failure_count++))
    fi
done

echo "Succeeded: $success_count"
echo "Failed: $failure_count"
```

Choose and document the final status. For example, return nonzero if any
required item failed.

## 33. Rollback and Transaction Thinking

For multi-step changes:

1. Validate everything possible before changing state.
2. Record the original state.
3. Apply one controlled change at a time.
4. Verify each step.
5. Restore the previous state when safe and practical.

Simple file replacement pattern:

```bash
cp -- "$config" "$config.backup"

if ! generate_new_config > "$config"; then
    cp -- "$config.backup" "$config"
    echo "Error: original configuration restored" >&2
    exit 1
fi
```

Production rollback needs careful permission, ownership, concurrency, and
atomicity planning.

## 34. Atomic File Updates

Instead of writing directly to an important file:

```bash
temporary_file="$(mktemp)"

if generate_content > "$temporary_file"; then
    mv -- "$temporary_file" "$target_file"
else
    echo "Error: generation failed; target not changed" >&2
    exit 1
fi
```

The temporary file should be created on the same filesystem when atomic rename
behavior is required.

## 35. Dependency Checks

```bash
required_commands=("awk" "grep" "timeout")

for command_name in "${required_commands[@]}"
do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        echo "Error: required command not found: $command_name" >&2
        exit 3
    fi
done
```

Check before starting a long workflow.

## 36. Locking and Concurrent Runs

Two copies of a script may conflict.

On systems with `flock`:

```bash
lock_file="/tmp/my-script.lock"

exec 9>"$lock_file"

if ! flock -n 9; then
    echo "Error: another instance is running" >&2
    exit 1
fi
```

Choose a lock path and permissions appropriate to the application. Do not
assume `/tmp` is always the correct place.

## 37. Debugging Failures

Syntax:

```bash
bash -n script.sh
```

Execution trace:

```bash
bash -x script.sh
```

Trace a section:

```bash
set -x
some_command
set +x
```

Do not trace secrets.

Static analysis:

```bash
shellcheck script.sh
```

## 38. Testing Failure Paths

Test:

1. Valid input.
2. Missing argument.
3. Too many arguments.
4. Invalid number.
5. Missing file.
6. Empty file.
7. Permission failure when safely simulated.
8. Command not found.
9. Pipeline component failure.
10. Timeout.
11. Retry exhaustion.
12. Interrupt and cleanup.
13. Partial batch failure.
14. Repeated execution.

Check output and status:

```bash
./script.sh bad-input
status=$?

echo "Observed status: $status"
```

## 39. Common Mistakes

| Mistake | Better approach |
|---|---|
| Print success unconditionally | Print it only after verified success |
| Check `$?` too late | Save it immediately or test command directly |
| Send errors to stdout | Use `>&2` |
| Use only `set -e` | Add explicit validation and failure handling |
| Treat every nonzero status identically | Read the command's documented statuses |
| Call `exit` inside every function | Prefer `return` for reusable functions |
| Retry invalid input | Retry only potentially temporary failures |
| Hide all errors with `/dev/null` | Log or explain expected failures |
| Cleanup changes the final status | Save `$?` at cleanup start |
| Use predictable temporary files | Use `mktemp` |
| Trace secrets | Disable tracing around secret values |
| Ignore batch partial failures | Count and report every result |

## 40. Recommended Script Pattern

```bash
#!/usr/bin/env bash

set -Eeuo pipefail

usage() {
    echo "Usage: $0 INPUT_FILE" >&2
}

log_error() {
    echo "$(date '+%F %T') ERROR $*" >&2
}

validate_input() {
    local file="$1"
    [[ -f "$file" ]]
}

main() {
    if [[ "$#" -ne 1 ]]; then
        usage
        return 2
    fi

    local input_file="$1"

    if ! validate_input "$input_file"; then
        log_error "Input file not found: $input_file"
        return 3
    fi

    if ! process_file "$input_file"; then
        log_error "Processing failed: $input_file"
        return 1
    fi

    echo "Processing completed"
}

main "$@"
```

## 41. Final Error-Handling Checklist

- [ ] Check argument count.
- [ ] Validate values before acting.
- [ ] Validate files, directories, and dependencies.
- [ ] Quote variable expansions.
- [ ] Test command statuses directly.
- [ ] Send errors to stderr.
- [ ] Use clear and actionable messages.
- [ ] Return meaningful statuses.
- [ ] Handle pipelines deliberately.
- [ ] Understand strict-mode limitations.
- [ ] Retry only temporary failures.
- [ ] Use timeouts where waiting forever is unacceptable.
- [ ] Clean temporary work safely.
- [ ] Preserve the original status during cleanup.
- [ ] Do not expose secrets in logs or traces.
- [ ] Test both success and failure paths.

