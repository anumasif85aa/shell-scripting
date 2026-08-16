# Bash Flow Control — `exit`, `return`, `continue`, `break`, and `shift`

## Table of Contents

1. [Introduction](#1-introduction)
2. [Quick Reference](#2-quick-reference)
3. [`exit 0` — Successful Script Completion](#3-exit-0--successful-script-completion)
4. [`exit 1` and Other Failure Statuses](#4-exit-1-and-other-failure-statuses)
5. [`continue` — Skip One Loop Item](#5-continue--skip-one-loop-item)
6. [`break` — End a Loop](#6-break--end-a-loop)
7. [`return` — Leave a Function](#7-return--leave-a-function)
8. [`exit` vs `return`](#8-exit-vs-return)
9. [`shift` — Process Arguments](#9-shift--process-arguments)
10. [`true`, `false`, and `:`](#10-true-false-and-)
11. [`$?` — Previous Command Status](#11--previous-command-status)
12. [Complete Practical Example](#12-complete-practical-example)
13. [Common Mistakes](#13-common-mistakes)
14. [Summary](#14-summary)

---

## 1. Introduction

Bash provides commands that control how a script proceeds. They can stop the entire script, leave a function, skip one loop iteration, end a loop, or move through command-line arguments.

These commands have different scopes. For example, `continue` affects a loop, whereas `exit` terminates the entire script.

---

## 2. Quick Reference

| Command | Normally Used In | Effect |
|---|---|---|
| `exit 0` | Script | Ends the entire script and reports success. |
| `exit 1` | Script | Ends the entire script and reports failure. |
| `exit N` | Script | Ends the script with status `N`. |
| `continue` | Loop | Skips the rest of the current iteration. |
| `break` | Loop | Immediately ends the loop. |
| `return 0` | Function | Leaves the function and reports success. |
| `return 1` | Function | Leaves the function and reports failure. |
| `return N` | Function | Leaves the function with status `N`. |
| `shift` | Argument processing | Removes `$1` and moves later arguments left. |
| `true` | Anywhere | Always returns status `0`. |
| `false` | Anywhere | Always returns status `1`. |
| `:` | Anywhere | Does nothing and normally returns `0`. |

---

## 3. `exit 0` — Successful Script Completion

```bash
echo "Installation completed."
exit 0
```

This means:

> Stop the entire script and report successful completion.

Commands after `exit` do not run:

```bash
echo "Before exit"
exit 0
echo "After exit"
```

Only `Before exit` is displayed.

Check the status from the calling shell:

```bash
bash script.sh
echo "$?"
```

Expected status:

```text
0
```

---

## 4. `exit 1` and Other Failure Statuses

```bash
if (( EUID != 0 )); then
    echo "Error: run this script with sudo." >&2
    exit 1
fi
```

`exit 1` stops the entire script and reports failure.

| Status | General Meaning |
|---:|---|
| `0` | Success |
| Nonzero | Failure or another exceptional result |

Frequently observed statuses include:

| Status | Common Meaning |
|---:|---|
| `1` | General failure |
| `2` | Often incorrect usage or a command-specific error |
| `126` | Command found but could not be executed |
| `127` | Command not found |
| `128 + N` | Process ended because of signal `N` |

The exact meaning of a nonzero status can depend on the command. Document custom statuses in your scripts:

```bash
# Exit statuses:
# 1 = invalid input
# 2 = missing source file
# 3 = permission failure
```

Example:

```bash
if [[ ! -f "$source_file" ]]; then
    echo "Error: source file does not exist." >&2
    exit 2
fi
```

---

## 5. `continue` — Skip One Loop Item

`continue` means:

> Skip the remaining commands for the current item and begin the next loop iteration.

```bash
for package in nginx curl wget
do
    if command -v "$package" >/dev/null 2>&1; then
        echo "$package is already available."
        continue
    fi

    echo "Installing $package..."
done
```

If `curl` is available, the installation message for `curl` is skipped and the loop moves to `wget`.

`continue` does not end the loop, function, or script. It affects only the current iteration.

---

## 6. `break` — End a Loop

`break` immediately ends the nearest loop:

```bash
for server in web01 web02 web03
do
    if [[ "$server" == "web02" ]]; then
        echo "Target found. Stopping the search."
        break
    fi

    echo "Checking $server"
done

echo "The script continues after the loop."
```

Output:

```text
Checking web01
Target found. Stopping the search.
The script continues after the loop.
```

`web03` is not processed, but the script continues after `done`.

| Command | Effect |
|---|---|
| `continue` | Skip this iteration; keep the loop running. |
| `break` | Stop the complete loop. |

---

## 7. `return` — Leave a Function

`return` normally belongs inside a function:

```bash
check_file()
{
    if [[ -f "$1" ]]; then
        echo "File exists: $1"
        return 0
    fi

    echo "File does not exist: $1" >&2
    return 1
}
```

Use the function:

```bash
if check_file "abc.txt"; then
    echo "The file check succeeded."
else
    echo "The file check failed."
fi
```

| Return Status | Meaning |
|---:|---|
| `return 0` | Function succeeded. |
| `return 1` | Function failed. |
| `return N` | Function returned status `N`. |

### Implicit Function Return

If no explicit `return` is used, a Bash function returns the status of its final command:

```bash
is_installed()
{
    command -v "$1" >/dev/null 2>&1
}
```

This function returns the status produced by `command -v`.

---

## 8. `exit` vs `return`

| Command | Ends Current Function | Ends Entire Script |
|---|---:|---:|
| `return` | Yes | No |
| `exit` | Yes | Yes |

Example using `return`:

```bash
demo()
{
    echo "Inside the function"
    return 1
    echo "This line will not run"
}

demo
echo "The script is still running"
```

The function ends, but the script continues.

Example using `exit`:

```bash
demo()
{
    echo "Inside the function"
    exit 1
}

demo
echo "This line will not run"
```

`exit 1` terminates the entire script, even inside a function.

---

## 9. `shift` — Process Arguments

`shift` removes the current `$1` and moves every later positional argument left.

Suppose you run:

```bash
bash script.sh apple banana cherry
```

Initially:

```text
$1 = apple
$2 = banana
$3 = cherry
$# = 3
```

After one `shift`:

```text
$1 = banana
$2 = cherry
$# = 2
```

Example:

```bash
while [[ "$#" -gt 0 ]]
do
    echo "Processing: $1"
    shift
done
```

Output:

```text
Processing: apple
Processing: banana
Processing: cherry
```

You may shift more than one position:

```bash
shift 2
```

Do not shift beyond the number of available arguments; doing so returns a nonzero status.

---

## 10. `true`, `false`, and `:`

### `true`

`true` always succeeds:

```bash
true
echo "$?"
```

Output: `0`

It is commonly used for an infinite loop:

```bash
while true
do
    echo "Running..."
    sleep 2
done
```

### `false`

`false` always fails:

```bash
false
echo "$?"
```

Output: `1`

It can test failure-handling logic:

```bash
if false; then
    echo "Success"
else
    echo "Failure"
fi
```

### `:` — Null Command

The colon command does nothing and normally returns success:

```bash
:
echo "$?"
```

It can also create an infinite loop:

```bash
while :
do
    echo "Running..."
    sleep 2
done
```

---

## 11. `$?` — Previous Command Status

`$?` contains the status returned by the most recently completed foreground command:

```bash
command -v nginx >/dev/null 2>&1
echo "$?"
```

- `0`: the command succeeded.
- Nonzero: the command failed.

Check it immediately because every new command replaces it:

```bash
command -v nginx >/dev/null 2>&1
echo "Checking status"
echo "$?"
```

The final `$?` belongs to the first `echo`, not to `command -v`.

Direct checking is usually clearer:

```bash
if command -v nginx >/dev/null 2>&1; then
    echo "nginx is available."
else
    echo "nginx is unavailable."
fi
```

---

## 12. Complete Practical Example

```bash
#!/bin/bash

# Demonstrate validation, continue, break, return, and exit.

is_available()
{
    command -v "$1" >/dev/null 2>&1
}

if [[ "$#" -eq 0 ]]; then
    echo "Usage: $0 COMMAND [COMMAND ...]" >&2
    exit 1
fi

missing_command=0

for command_name in "$@"
do
    if [[ "$command_name" == "stop" ]]; then
        echo "Stop request received."
        break
    fi

    if is_available "$command_name"; then
        echo "[AVAILABLE] $command_name"
        continue
    fi

    echo "[MISSING] $command_name" >&2
    missing_command=1
done

if (( missing_command != 0 )); then
    exit 1
fi

exit 0
```

Example:

```bash
bash command_check.sh bash missing-command curl
```

The script returns `1` if at least one requested command is missing.

---

## 13. Common Mistakes

### Using `exit` When Only the Loop Should Stop

`exit` terminates the entire script. Use `break` to end only the loop.

### Using `break` or `continue` Outside a Loop

Both commands require an active loop. `break` ends it; `continue` starts its next iteration.

### Assuming `return 1` Ends the Script

`return 1` leaves the current function. The script continues unless the caller responds to the failure.

### Checking `$?` Too Late

Check `$?` immediately, or place the important command directly inside `if`.

### Assuming Every Nonzero Status Means the Same Thing

Nonzero generally means ordinary success was not reported, but its exact meaning is command-specific.

---

## 14. Summary

```text
exit 0    → End the entire script successfully
exit 1    → End the entire script with failure
return 0  → Leave a function successfully
return 1  → Leave a function with failure
continue  → Skip the current loop iteration
break     → End the current loop
shift     → Remove $1 and move arguments left
true      → Always return status 0
false     → Always return status 1
:          → Do nothing and normally return status 0
$?         → Status of the most recent foreground command
```

The key question is:

> Do you want to stop the script, leave a function, skip one loop item, or end the loop?

Choose the flow-control command based on that required behavior.
