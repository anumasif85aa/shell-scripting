# Bash Control Flow and Exit Commands — Study Notes

## Table of Contents

1. [Introduction](#1-introduction)
2. [Quick Reference Table](#2-quick-reference-table)
3. [Control-Flow Diagram](#3-control-flow-diagram)
4. [`exit 0` — End the Script Successfully](#4-exit-0--end-the-script-successfully)
5. [`exit 1` — End the Script with Failure](#5-exit-1--end-the-script-with-failure)
6. [`exit N` — Use a Chosen Exit Status](#6-exit-n--use-a-chosen-exit-status)
7. [`return` — Leave a Function](#7-return--leave-a-function)
8. [`break` — Leave a Loop](#8-break--leave-a-loop)
9. [`continue` — Skip One Loop Iteration](#9-continue--skip-one-loop-iteration)
10. [`break 2` and `continue 2`](#10-break-2-and-continue-2)
11. [`true` — Always Report Success](#11-true--always-report-success)
12. [`false` — Always Report Failure](#12-false--always-report-failure)
13. [`:` — The Null Command](#13---the-null-command)
14. [Exit Status and `$?`](#14-exit-status-and-)
15. [Complete Practical Example](#15-complete-practical-example)
16. [Common Mistakes](#16-common-mistakes)
17. [Final Summary](#17-final-summary)

---

## 1. Introduction

Bash provides several commands that control what happens next in a script:

- `exit` ends the entire script.
- `return` leaves a function.
- `break` leaves a loop.
- `continue` skips the remainder of the current loop iteration.
- `true` deliberately returns success.
- `false` deliberately returns failure.
- `:` performs no operation and returns success.

Although these commands are related to control flow, they are not interchangeable.

---

## 2. Quick Reference Table

| Command | Used in | Purpose | Does the script end? | Status produced |
|---|---|---|---|---:|
| `exit 0` | Script or function | End the entire script successfully | Yes | `0` |
| `exit 1` | Script or function | End the entire script with failure | Yes | `1` |
| `exit N` | Script or function | End the script with a chosen status | Yes | `N` |
| `return 0` | Function or sourced file | Leave successfully | No, normally | `0` |
| `return 1` | Function or sourced file | Leave and report failure | No, normally | `1` |
| `break` | Loop | End the nearest loop | No | Not normally used as a result code |
| `break 2` | Nested loops | End two enclosing loops | No | Not normally used as a result code |
| `continue` | Loop | Skip to the next iteration | No | Not normally used as a result code |
| `continue 2` | Nested loops | Continue the second enclosing loop | No | Not normally used as a result code |
| `true` | Anywhere | Deliberately report success | No | `0` |
| `false` | Anywhere | Deliberately report failure | No | `1` |
| `:` | Anywhere | Do nothing successfully | No | `0` |

> **Important:** `break` and `continue` do not end the script. They control loops.

---

## 3. Control-Flow Diagram

```text
Start the script
       |
       v
Run commands and conditions
       |
       +-- exit N ----------> End the entire script
       |
       +-- function
       |      |
       |      +-- return N -> Leave the function
       |                       and continue after its call
       |
       +-- loop
              |
              +-- break ----> Leave the loop
              |
              +-- continue -> Start the next iteration
```

The easiest way to remember the flow is:

| Command | Simple meaning |
|---|---|
| `exit` | Leave the script |
| `return` | Leave the function |
| `break` | Leave the loop |
| `continue` | Skip to the next loop iteration |

---

## 4. `exit 0` — End the Script Successfully

Suggested script name: `successful_backup.sh`

```bash
#!/bin/bash

echo "Backup completed successfully."
exit 0
```

`exit 0` means that the script completed successfully.

Run it and inspect its status:

```bash
bash successful_backup.sh
echo "$?"
```

Expected output:

```text
Backup completed successfully.
0
```

---

## 5. `exit 1` — End the Script with Failure

Suggested script name: `source_file_check.sh`

```bash
#!/bin/bash

source_file="missing.txt"

if [[ ! -f "$source_file" ]]; then
    echo "Error: source file does not exist." >&2
    exit 1
fi

echo "The source file exists."
exit 0
```

Flow:

1. `[[ ! -f "$source_file" ]]` checks whether the path is **not** a regular file.
2. If the check succeeds, the error message is sent to standard error.
3. `exit 1` immediately ends the script.
4. The success message is not executed after the failure.

---

## 6. `exit N` — Use a Chosen Exit Status

Suggested script name: `argument_validator.sh`

```bash
#!/bin/bash

if (( $# != 2 )); then
    echo "Usage: $0 SOURCE DESTINATION" >&2
    exit 2
fi

echo "Source: $1"
echo "Destination: $2"
exit 0
```

In this example:

- `exit 0` means success.
- `exit 2` means incorrect command-line usage.

Custom meanings should be documented in the script or its README.

### Common exit-status convention

| Status | Common meaning |
|---:|---|
| `0` | Success |
| `1` | General failure |
| `2` | Incorrect usage or invalid arguments |
| `126` | Command found but could not be executed |
| `127` | Command not found |
| `128 + N` | Process ended because of signal `N` |

These are common conventions, but individual commands may define their own status meanings.

---

## 7. `return` — Leave a Function

Suggested script name: `function_file_check.sh`

```bash
#!/bin/bash

check_file()
{
    local file="${1:-}"

    if [[ -f "$file" ]]; then
        return 0
    fi

    return 1
}

if check_file "abc.txt"; then
    echo "The file exists."
else
    echo "The file does not exist."
fi

echo "The script is still running."
exit 0
```

Important difference:

| Command | Result |
|---|---|
| `return 1` | Leaves the function and reports failure |
| `exit 1` | Ends the entire script and reports failure |

A function can return a status from `0` to `255`. It does not return ordinary text like functions in some other programming languages. To produce text, use `printf` or `echo` and capture it when appropriate.

---

## 8. `break` — Leave a Loop

Suggested script name: `break_loop_demo.sh`

```bash
#!/bin/bash

for number in {1..10}
do
    if (( number == 5 )); then
        echo "Stopping the loop at $number."
        break
    fi

    echo "$number"
done

echo "The script continues after the loop."
exit 0
```

Expected output:

```text
1
2
3
4
Stopping the loop at 5.
The script continues after the loop.
```

`break` ends only the nearest loop. The script continues with the first command after `done`.

---

## 9. `continue` — Skip One Loop Iteration

Suggested script name: `continue_loop_demo.sh`

```bash
#!/bin/bash

for number in {1..5}
do
    if (( number == 3 )); then
        continue
    fi

    echo "$number"
done

exit 0
```

Expected output:

```text
1
2
4
5
```

When `number` is `3`, `continue` skips the remaining commands in that iteration. The loop then proceeds with `4`.

### Practical example: skip missing files

```bash
for file in *.log
do
    [[ -e "$file" ]] || continue
    echo "Processing: $file"
done
```

If the pattern does not identify an existing file, `continue` prevents the loop body from processing it.

---

## 10. `break 2` and `continue 2`

### `break 2`

Suggested script name: `nested_break_demo.sh`

```bash
#!/bin/bash

for server in server1 server2
do
    for port in 80 443
    do
        echo "Checking $server on port $port"

        if [[ "$server" == "server1" && "$port" == "443" ]]; then
            break 2
        fi
    done
done

echo "Both loops have ended."
exit 0
```

`break 2` ends the two enclosing loops.

### `continue 2`

Suggested script name: `nested_continue_demo.sh`

```bash
#!/bin/bash

for server in server1 server2
do
    for port in 80 443
    do
        if [[ "$port" == "80" ]]; then
            continue 2
        fi

        echo "$server:$port"
    done
done

exit 0
```

`continue 2` skips the rest of the inner loop and begins the next iteration of the second enclosing loop.

Numbered forms are useful, but simple loop structures are usually easier for beginners to read and maintain.

---

## 11. `true` — Always Report Success

Suggested script name: `true_condition_demo.sh`

```bash
#!/bin/bash

if true; then
    echo "Success"
else
    echo "Failure"
fi
```

Expected output:

```text
Success
```

### Why does it print `Success`?

`true` is a command that always returns exit status `0`.

Bash `if` statements check a command's exit status:

- Status `0` means the condition succeeded, so the `then` block runs.
- A non-zero status means the condition failed, so the `else` block runs.

Therefore, the `else` block in this example will never run unless `true` is replaced with a command that can fail.

You can verify the status directly:

```bash
true
echo "$?"
```

Output:

```text
0
```

### Practical use: infinite loop

```bash
while true
do
    echo "Monitoring..."
    sleep 5
done
```

Because `true` always succeeds, the loop continues until it is stopped or a `break` command is executed.

---

## 12. `false` — Always Report Failure

Suggested script name: `false_condition_demo.sh`

```bash
#!/bin/bash

if false; then
    echo "Success"
else
    echo "Failure"
fi
```

Expected output:

```text
Failure
```

`false` always returns status `1`, so Bash runs the `else` block.

Verify it:

```bash
false
echo "$?"
```

Output:

```text
1
```

`false` is useful when testing failure-handling logic.

---

## 13. `:` — The Null Command

The colon command performs no operation and returns status `0`.

Suggested script name: `null_command_demo.sh`

```bash
#!/bin/bash

if [[ -f "abc.txt" ]]; then
    :
else
    echo "The file does not exist."
fi
```

It may also be used to create an infinite loop:

```bash
while :
do
    echo "Running..."
    sleep 2
done
```

In this context, `:` behaves like `true`.

---

## 14. Exit Status and `$?`

Every Bash command produces an exit status.

- `0` represents success.
- A non-zero value represents failure or another special result.

`$?` contains the status of the most recently completed foreground command.

```bash
ls /tmp
echo "$?"
```

### Check it immediately

```bash
ls /missing
status=$?
echo "Status: $status"
```

Save `$?` immediately because another command will replace it:

```bash
ls /missing
echo "Checking the result"
echo "$?"
```

The final `echo "$?"` reports the status of the previous `echo`, not the status of `ls`.

### Prefer direct testing when possible

Instead of:

```bash
cp -- "$source" "$destination"

if [[ "$?" -eq 0 ]]; then
    echo "Copy completed."
fi
```

Prefer:

```bash
if cp -- "$source" "$destination"; then
    echo "Copy completed."
else
    echo "Error: copy failed." >&2
    exit 1
fi
```

The direct form is clearer and avoids accidentally overwriting `$?`.

---

## 15. Complete Practical Example

Suggested script name: `log_file_processor.sh`

```bash
#!/bin/bash

# Require exactly one argument.
if (( $# != 1 )); then
    echo "Usage: $0 LOG_FILE" >&2
    exit 2
fi

log_file="$1"

# Confirm that the supplied path is a regular file.
if [[ ! -f "$log_file" ]]; then
    echo "Error: regular file not found: $log_file" >&2
    exit 1
fi

process_log()
{
    local file="$1"

    if ! grep -q "ERROR" "$file"; then
        return 1
    fi

    return 0
}

if process_log "$log_file"; then
    echo "ERROR entries were found."
else
    echo "No ERROR entries were found."
fi

echo "Processing finished."
exit 0
```

### Script flow

```text
Check argument count
        |
        +-- Wrong --> exit 2
        |
        v
Check regular file
        |
        +-- Missing --> exit 1
        |
        v
Call function
        |
        +-- return 0 --> ERROR found
        |
        +-- return 1 --> No ERROR found
        |
        v
Finish script --> exit 0
```

> Note: `grep -q` status `1` normally means no matching line was found. Status greater than `1` indicates an actual `grep` error. Production code may distinguish these results separately.

---

## 16. Common Mistakes

### Mistake 1: Using `exit` inside a function unintentionally

```bash
check_file()
{
    [[ -f "$1" ]] || exit 1
}
```

This ends the entire script. If the caller should decide what to do, use `return`:

```bash
check_file()
{
    [[ -f "$1" ]] || return 1
}
```

### Mistake 2: Expecting `break` to end the script

`break` ends a loop only. Use `exit` to end the script.

### Mistake 3: Using `continue` outside a loop

`continue` is valid only inside a `for`, `while`, `until`, or `select` loop.

### Mistake 4: Treating every non-zero status as exactly the same

Non-zero normally means unsuccessful, but different statuses may have different meanings. For example, `grep` uses:

| Status | Meaning |
|---:|---|
| `0` | A match was found |
| `1` | No match was found |
| `2` or higher | An error occurred |

### Mistake 5: Thinking `if` requires `true` or `false` text

Bash checks command statuses, not Boolean words:

```bash
if mkdir backup; then
    echo "Directory created."
else
    echo "Directory creation failed." >&2
fi
```

Here, `mkdir` itself is the condition.

---

## 17. Final Summary

| Term | Remember it as | Main use |
|---|---|---|
| `exit 0` | End successfully | Successful script completion |
| `exit 1` | End with failure | General script error |
| `exit N` | End with a selected result | Documented error categories |
| `return N` | Leave a function | Report function success or failure |
| `break` | Leave the loop | Stop looping early |
| `continue` | Skip this iteration | Ignore one item and keep looping |
| `true` | Always succeeds | Testing and infinite loops |
| `false` | Always fails | Testing failure paths |
| `:` | Do nothing successfully | Placeholder or infinite loop |

The central lesson is:

```text
exit    -> controls the whole script
return  -> controls a function
break   -> controls when a loop ends
continue-> controls which loop iterations finish
```

