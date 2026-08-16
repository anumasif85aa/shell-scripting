# Bash `trap` Command — Complete Study Notes

## Table of Contents

1. [`trap` overview](#1-trap-overview)
2. [Why `trap` is useful](#2-why-trap-is-useful)
3. [Basic syntax](#3-basic-syntax)
4. [Common events and signals](#4-common-events-and-signals)
5. [The `EXIT` trap](#5-the-exit-trap)
6. [Handling `Ctrl+C` with `INT`](#6-handling-ctrlc-with-int)
7. [Handling `TERM`](#7-handling-term)
8. [The `ERR` trap](#8-the-err-trap)
9. [Cleaning up temporary files](#9-cleaning-up-temporary-files)
10. [Preserving the original exit status](#10-preserving-the-original-exit-status)
11. [`set -E`, `set -e`, and `trap`](#11-set--e-set--e-and-trap)
12. [Viewing, removing, and resetting traps](#12-viewing-removing-and-resetting-traps)
13. [Signals that cannot be trapped](#13-signals-that-cannot-be-trapped)
14. [Complete practical script](#14-complete-practical-script)
15. [Common mistakes](#15-common-mistakes)
16. [Best practices](#16-best-practices)
17. [Quick-reference table](#17-quick-reference-table)
18. [Practice exercises](#18-practice-exercises)
19. [Summary](#19-summary)

---

## 1. `trap` overview

`trap` is a Bash built-in command that runs specified commands when the shell receives a particular signal or encounters a particular event.

In simple terms:

> `trap` tells a script, “When this event occurs, perform this action.”

Example:

```bash
trap 'echo "The script is exiting."' EXIT
```

The registered `echo` command runs automatically when the script exits.

`trap` is especially useful when a script creates temporary files, starts background processes, acquires locks, or must respond safely to interruptions.

---

## 2. Why `trap` is useful

Common uses include:

- Deleting temporary files and directories
- Removing lock files
- Stopping background processes
- Responding to `Ctrl+C`
- Handling termination requests
- Recording useful error information
- Writing shutdown messages to log files
- Closing resources before the script ends
- Preventing temporary resources from being left behind

`trap` does not prevent an error. It defines what Bash should do after a specified event or signal occurs.

---

## 3. Basic syntax

```bash
trap 'commands' SIGNAL
```

Example:

```bash
trap 'echo "Running cleanup."' EXIT
```

One action can handle multiple signals:

```bash
trap 'echo "The script was interrupted."' INT TERM
```

For more than a very short command, define a function:

```bash
cleanup()
{
    echo "Running cleanup."
}

trap cleanup EXIT
```

Read the last line as:

> When the script exits, run the `cleanup` function.

Using a named function makes the cleanup logic easier to read, test, and maintain.

---

## 4. Common events and signals

| Event or signal | Full name | When it occurs | Common use |
|---|---|---|---|
| `EXIT` | Shell exit event | The shell or script is about to exit | Cleanup |
| `ERR` | Bash error event | An eligible command returns non-zero | Error reporting |
| `INT` | `SIGINT` | The user usually presses `Ctrl+C` | Safe interruption |
| `TERM` | `SIGTERM` | A process receives a termination request | Graceful shutdown |
| `HUP` | `SIGHUP` | A terminal or session disconnects | Reload or cleanup |
| `DEBUG` | Bash debug event | Before eligible commands execute | Advanced debugging |
| `RETURN` | Bash return event | A function or sourced file returns | Advanced tracing |

Signal names may be written with or without the `SIG` prefix:

```bash
trap handle_interrupt INT
```

This is equivalent to:

```bash
trap handle_interrupt SIGINT
```

`EXIT`, `ERR`, `DEBUG`, and `RETURN` are Bash events rather than ordinary operating-system signals.

---

## 5. The `EXIT` trap

An `EXIT` trap runs just before the shell terminates. It can run when a script:

- Completes successfully
- Calls `exit 0`
- Calls `exit 1` or another non-zero status
- Stops because of an eligible `set -e` failure
- Exits from a handled signal

### Basic example

```bash
#!/bin/bash

trap 'echo "The script has finished."' EXIT

echo "Starting work..."
echo "Work completed."
```

Output:

```text
Starting work...
Work completed.
The script has finished.
```

The `EXIT` trap runs after the normal commands but before Bash fully terminates.

### Function-based example

```bash
#!/bin/bash

cleanup()
{
    echo "Cleaning up resources."
}

trap cleanup EXIT

echo "Processing data..."
```

---

## 6. Handling `Ctrl+C` with `INT`

When a user presses `Ctrl+C`, the terminal normally sends the running foreground process a `SIGINT` signal.

```bash
#!/bin/bash

handle_interrupt()
{
    echo
    echo "The script was interrupted by the user." >&2
    exit 130
}

trap handle_interrupt INT

while true
do
    echo "The script is running..."
    sleep 2
done
```

When the user presses `Ctrl+C`, Bash runs `handle_interrupt` instead of simply ending without explanation.

### Why use exit status `130`?

A common convention for a process terminated by a signal is:

```text
128 + signal number
```

`SIGINT` has signal number `2`:

```text
128 + 2 = 130
```

Therefore, `exit 130` communicates that the script was interrupted.

---

## 7. Handling `TERM`

`SIGTERM` requests that a process terminate gracefully. Unlike `SIGKILL`, it gives the process an opportunity to perform cleanup.

```bash
#!/bin/bash

handle_termination()
{
    echo "A termination request was received." >&2
    exit 143
}

trap handle_termination TERM

while true
do
    echo "Working..."
    sleep 3
done
```

From another terminal, send the signal with:

```bash
kill -TERM PROCESS_ID
```

`SIGTERM` has signal number `15`, so its conventional status is:

```text
128 + 15 = 143
```

---

## 8. The `ERR` trap

An `ERR` trap runs when an eligible command returns a non-zero exit status.

```bash
#!/bin/bash

trap 'echo "An error occurred near line $LINENO." >&2' ERR

cp missing.txt backup.txt
```

Possible output:

```text
cp: cannot stat 'missing.txt': No such file or directory
An error occurred near line 5.
```

### Useful Bash variables

| Variable | Meaning |
|---|---|
| `$?` | Exit status of the previous command |
| `$LINENO` | Current Bash line number |
| `$BASH_COMMAND` | Command Bash is executing |
| `${BASH_SOURCE[0]}` | Name or path of the current script |

### Error-reporting function

```bash
report_error()
{
    local status=$?
    local line_number=$1

    echo "Error: a command failed near line $line_number." >&2
    echo "Command: $BASH_COMMAND" >&2
    echo "Exit status: $status" >&2

    return "$status"
}

trap 'report_error "$LINENO"' ERR
```

The status must be captured immediately because another command would replace the value of `$?`.

### Important `ERR` limitations

`ERR` does not run for every non-zero status. Bash suppresses it in several contexts where failure is being used for control flow, such as:

- A command tested directly by `if`
- A command tested by `while` or `until`
- Most non-final commands in an `&&` or `||` list
- A command whose status is inverted with `!`
- Individual pipeline commands when the overall pipeline is considered successful

Example:

```bash
if grep -q "ERROR" application.log; then
    echo "An ERROR entry was found."
else
    echo "No ERROR entry was found."
fi
```

Here, `grep` returning `1` is being used as a decision, so Bash does not treat it like an unhandled failure.

---

## 9. Cleaning up temporary files

Use `mktemp` to create a safe, uniquely named temporary file, and register a cleanup function with `EXIT`.

```bash
#!/bin/bash

temporary_file=$(mktemp)

cleanup()
{
    echo "Removing the temporary file."
    rm -f -- "$temporary_file"
}

trap cleanup EXIT

echo "Temporary data" > "$temporary_file"
echo "Temporary file: $temporary_file"
```

### Command explanation

| Command | Purpose |
|---|---|
| `mktemp` | Creates a securely named temporary file |
| `rm -f` | Removes the file without an unnecessary prompt |
| `--` | Marks the end of command options |
| `trap cleanup EXIT` | Runs `cleanup` when the script exits |

Quoting `"$temporary_file"` preserves the path as one argument. The `--` also prevents a filename beginning with `-` from being interpreted as an option.

---

## 10. Preserving the original exit status

Commands in a cleanup function can change `$?`. Capture the original status before running any cleanup command.

```bash
#!/bin/bash

temporary_file=$(mktemp)

cleanup()
{
    local status=$?

    rm -f -- "$temporary_file"

    exit "$status"
}

trap cleanup EXIT

cp missing.txt backup.txt
```

### Flow

1. `cp` fails.
2. Bash begins the exit process.
3. The `EXIT` trap calls `cleanup`.
4. `local status=$?` saves the original failure status.
5. The temporary file is removed.
6. `exit "$status"` preserves the original outcome.

### Critical rule

Capture `$?` as the first command in the handler:

```bash
local status=$?
```

Incorrect:

```bash
cleanup()
{
    echo "Cleaning up..."
    local status=$?
}
```

In the incorrect example, `status` receives the result of `echo`, not the command that caused the script to exit.

---

## 11. `set -E`, `set -e`, and `trap`

A commonly used strict-mode line is:

```bash
set -Eeuo pipefail
```

| Option | Meaning |
|---|---|
| `-e` | Exits after an eligible unhandled command failure |
| `-E` | Helps functions, command substitutions, and subshell contexts inherit the `ERR` trap |
| `-u` | Treats an unset-variable expansion as an error |
| `pipefail` | Makes a pipeline fail when any command in it fails |

### Pipeline example

```bash
#!/bin/bash

set -Eeuo pipefail

report_error()
{
    local status=$?
    local line_number=$1

    echo "Error: failure near line $line_number." >&2
    return "$status"
}

trap 'report_error "$LINENO"' ERR

grep "ERROR" missing.log | wc -l

echo "Pipeline completed."
```

If `missing.log` does not exist:

1. `grep` fails.
2. `pipefail` makes the entire pipeline fail.
3. The `ERR` trap reports the failure.
4. `set -e` stops the script.
5. `Pipeline completed.` is not printed.

### Do not treat `set -e` as complete error handling

The behavior of `set -e` depends on command context. Handle expected failures explicitly:

```bash
if cp -- "$source" "$destination"; then
    echo "Copy completed successfully."
else
    echo "Error: copy failed." >&2
    exit 1
fi
```

Explicit conditions communicate the expected behavior more clearly than relying only on `set -e`.

---

## 12. Viewing, removing, and resetting traps

### Display registered traps

```bash
trap -p
```

Display one specific trap:

```bash
trap -p EXIT
```

### Restore the default behavior

```bash
trap - EXIT
```

Reset multiple signals:

```bash
trap - INT TERM
```

### Ignore a signal

```bash
trap '' INT
```

This tells Bash to ignore `SIGINT`, which usually means ignoring `Ctrl+C`.

Restore its default behavior with:

```bash
trap - INT
```

Ignoring interruption signals should be done carefully. Users should normally have a reasonable way to stop a long-running script.

---

## 13. Signals that cannot be trapped

The following signals cannot be caught, blocked, or ignored:

```text
SIGKILL
SIGSTOP
```

Therefore, this does not work:

```bash
trap 'echo "The process was killed."' SIGKILL
```

`SIGKILL` causes the operating system to terminate the process immediately. The script receives no opportunity to run cleanup.

For important workloads, do not rely only on a final cleanup step. Save important intermediate state safely as the script progresses.

---

## 14. Complete practical script

The following script processes a source file through a temporary file and creates a final error report.

```bash
#!/bin/bash

# Title: Safe File Processor
# Purpose: Extract ERROR lines safely.
# Usage: ./safe_processor.sh SOURCE_FILE

set -Eeuo pipefail

temporary_file=""

cleanup()
{
    local status=$?

    if [[ -n "$temporary_file" && -f "$temporary_file" ]]; then
        rm -f -- "$temporary_file"
    fi

    exit "$status"
}

report_error()
{
    local status=$?
    local line_number=$1

    echo "Error: a command failed near line $line_number." >&2
    echo "Command: $BASH_COMMAND" >&2

    return "$status"
}

handle_interrupt()
{
    echo "Error: the script was interrupted." >&2
    exit 130
}

trap cleanup EXIT
trap 'report_error "$LINENO"' ERR
trap handle_interrupt INT TERM

if (( $# != 1 )); then
    echo "Usage: $0 SOURCE_FILE" >&2
    exit 2
fi

source_file=$1

if [[ ! -f "$source_file" ]]; then
    echo "Error: regular source file not found: $source_file" >&2
    exit 1
fi

temporary_file=$(mktemp)

if grep "ERROR" "$source_file" > "$temporary_file"; then
    echo "ERROR entries were found."
else
    status=$?

    if (( status == 1 )); then
        echo "No ERROR entries were found."
        : > "$temporary_file"
    else
        echo "Error: grep failed with status $status." >&2
        exit "$status"
    fi
fi

output_file="error-report.txt"
mv -- "$temporary_file" "$output_file"
temporary_file=""

echo "Report created: $output_file"
exit 0
```

### Script flow

1. Strict error handling is enabled.
2. Cleanup, error-reporting, and interruption functions are defined.
3. The functions are registered with their relevant traps.
4. The argument count is validated.
5. The source path is checked as a regular file.
6. A safe temporary file is created.
7. `grep` results are interpreted correctly:
   - Status `0`: matches were found.
   - Status `1`: no matches were found; this is handled as a normal result.
   - Status greater than `1`: a real `grep` error occurred.
8. The temporary file is moved to the final output path.
9. The temporary variable is cleared so cleanup does not remove the completed report.
10. The `EXIT` trap runs before Bash terminates.

### Why `: > "$temporary_file"`?

`:` is a Bash no-operation command. Redirecting its empty output truncates or creates the file:

```bash
: > "$temporary_file"
```

In this script, it ensures that the report is empty when no matching entries exist.

---

## 15. Common mistakes

### Mistake 1: Repeating cleanup everywhere

Instead of repeating:

```bash
rm -f -- "$temporary_file"
exit 1
```

in every failure branch, centralize cleanup:

```bash
trap cleanup EXIT
```

### Mistake 2: Capturing `$?` too late

Incorrect:

```bash
cleanup()
{
    echo "Cleaning up..."
    status=$?
}
```

Correct:

```bash
cleanup()
{
    local status=$?
    echo "Cleaning up..."
    exit "$status"
}
```

### Mistake 3: Leaving variables unquoted

Incorrect:

```bash
rm -f $temporary_file
```

Correct:

```bash
rm -f -- "$temporary_file"
```

### Mistake 4: Trying to trap `SIGKILL`

```bash
trap cleanup SIGKILL
```

`SIGKILL` cannot be trapped.

### Mistake 5: Treating `ERR` as complete error handling

An `ERR` trap is useful for reporting unexpected failures, but validation and expected outcomes still require `if`, `case`, or explicit status checks.

### Mistake 6: Accidentally replacing an existing trap

```bash
trap 'echo "First action"' EXIT
trap 'echo "Second action"' EXIT
```

The second command replaces the first `EXIT` trap. Combine both actions in one function instead.

### Mistake 7: Using unsafe cleanup targets

Never run a destructive command on a path that has not been checked:

```bash
rm -rf -- "$temporary_directory"
```

First verify that the variable is non-empty and that it refers to the expected temporary location.

---

## 16. Best practices

- Put cleanup logic in a clearly named function.
- Register traps near the beginning of the script.
- Use `mktemp` for temporary files and directories.
- Capture `$?` immediately when the original status matters.
- Quote path and filename variables.
- Use `--` with commands such as `rm`, `mv`, and `cp`.
- Handle `INT` and `TERM` for graceful shutdown when appropriate.
- Do not attempt to trap `SIGKILL` or `SIGSTOP`.
- Handle expected non-zero statuses with explicit conditions.
- Include useful context in an error report: line, command, and status.
- Make cleanup idempotent: running it more than once should remain safe.
- Validate cleanup paths before destructive operations.
- Test success, failure, and interruption paths.
- Remember that `trap` supports cleanup and reporting; it does not replace validation.

---

## 17. Quick-reference table

| Task | Syntax | Meaning |
|---|---|---|
| Run a command on exit | `trap 'command' EXIT` | Runs the command before the script exits |
| Run a cleanup function | `trap cleanup EXIT` | Calls `cleanup` before exit |
| Handle `Ctrl+C` | `trap handler INT` | Calls `handler` for `SIGINT` |
| Handle termination | `trap handler TERM` | Calls `handler` for `SIGTERM` |
| Report an eligible error | `trap handler ERR` | Calls `handler` after an eligible failure |
| Handle multiple signals | `trap handler INT TERM` | Uses one handler for both signals |
| List registered traps | `trap -p` | Displays current trap definitions |
| Show one trap | `trap -p EXIT` | Displays the `EXIT` trap |
| Reset a trap | `trap - EXIT` | Restores the default behavior |
| Ignore a signal | `trap '' INT` | Ignores `SIGINT` |
| Use a full signal name | `trap handler SIGINT` | Same signal as `INT` |
| Create a safe temporary file | `file=$(mktemp)` | Creates a unique temporary file |
| Capture an exit status | `local status=$?` | Saves the previous command's status |
| Obtain a line number | `$LINENO` | Expands to the current Bash line number |
| Obtain command context | `$BASH_COMMAND` | Shows the command Bash is executing |

---

## 18. Practice exercises

### Exercise 1: Exit message

Write a script that uses an `EXIT` trap to print:

```text
Script finished.
```

### Exercise 2: Temporary-file cleanup

Create a temporary file with `mktemp`, write data into it, and remove it automatically with an `EXIT` trap.

### Exercise 3: `Ctrl+C` handler

Create an infinite loop and handle `Ctrl+C` with an `INT` trap, an explanatory error message, and `exit 130`.

### Exercise 4: Error report

Attempt to copy a missing file. Use an `ERR` trap to display the line number and exit status.

### Exercise 5: Pipeline failure

Enable `set -Eeuo pipefail`, run `grep "ERROR" missing.log | wc -l`, and observe whether a final success message executes.

### Exercise 6: Preserve the status

Write a cleanup function that removes a temporary file without replacing the script's original failure status.

---

## 19. Summary

`trap` allows a Bash script to respond to events and signals.

The most common cleanup pattern is:

```bash
cleanup()
{
    local status=$?

    # Cleanup commands go here.

    exit "$status"
}

trap cleanup EXIT
```

This means:

> Whenever the script exits, run `cleanup` and preserve the original exit status.

Remember:

- Use `EXIT` for cleanup.
- Use `INT` to handle `Ctrl+C`.
- Use `TERM` for graceful termination.
- Use `ERR` to report eligible command failures.
- `SIGKILL` and `SIGSTOP` cannot be trapped.
- Capture `$?` before another command changes it.
- Use explicit conditions for expected failures.
- `trap` complements validation and error handling; it does not replace them.

