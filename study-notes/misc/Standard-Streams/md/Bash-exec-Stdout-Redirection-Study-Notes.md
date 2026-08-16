# Bash `exec` Stdout Redirection — English Study Notes

## Table of Contents

- [1. Command](#1-command)
- [2. Simple Meaning](#2-simple-meaning)
- [3. Command Breakdown](#3-command-breakdown)
- [4. What Does `exec` Do Here?](#4-what-does-exec-do-here)
- [5. Meaning of `>>`](#5-meaning-of-)
- [6. Complete Example](#6-complete-example)
- [7. Stdout and Stderr](#7-stdout-and-stderr)
- [8. Redirecting Both Streams](#8-redirecting-both-streams)
- [9. Validating the Log Directory](#9-validating-the-log-directory)
- [10. Restoring Terminal Output](#10-restoring-terminal-output)
- [11. `exec` With a Command vs Redirection](#11-exec-with-a-command-vs-redirection)
- [12. Common Mistakes](#12-common-mistakes)
- [13. Practice Lab](#13-practice-lab)
- [14. Quick Summary](#14-quick-summary)

---

## 1. Command

```bash
exec >> logs/stdout.log
```

---

## 2. Simple Meaning

This command sends **all subsequent normal output** from the current script to `logs/stdout.log` instead of the terminal.

In simple terms:

> From this point forward, append the script's stdout to `logs/stdout.log` without deleting the file's existing contents.

---

## 3. Command Breakdown

| Part | Meaning |
|---|---|
| `exec` | Changes a file descriptor in the current shell or script. |
| `>>` | Appends output to the end of a file. |
| `logs/` | Directory containing the log files. |
| `stdout.log` | File that receives the normal output. |

The explicit form is:

```bash
exec 1>> logs/stdout.log
```

File descriptor `1` represents stdout.

---

## 4. What Does `exec` Do Here?

Without `exec`, every command could be redirected separately:

```bash
echo "Script started" >> logs/stdout.log
date >> logs/stdout.log
whoami >> logs/stdout.log
```

However:

```bash
exec >> logs/stdout.log
```

changes stdout's destination once. All later commands in the current script inherit that destination, so individual redirection is unnecessary.

```text
Before exec:

Command -> stdout -> Terminal

After exec:

Command -> stdout -> logs/stdout.log
```

This change remains active for the rest of the current script or shell unless stdout is redirected again or restored.

---

## 5. Meaning of `>>`

```bash
exec >> logs/stdout.log
```

`>>` is append redirection:

- It creates the file if the file is missing and its parent directory is available.
- It preserves existing content.
- It adds new output at the end of the file.

If `>` is used instead:

```bash
exec > logs/stdout.log
```

the existing contents are replaced when the redirection is opened.

| Syntax | Result |
|---|---|
| `exec > file` | Redirect stdout and overwrite the file. |
| `exec >> file` | Redirect stdout and append to the file. |

---

## 6. Complete Example

```bash
#!/bin/bash

mkdir -p logs

echo "Before redirection"

exec >> logs/stdout.log

echo "Script started"
date
whoami
echo "Script finished"
```

### Terminal Output

```text
Before redirection
```

The commands after `exec` do not display their normal output on the terminal because stdout now points to the file.

Review the log:

```bash
cat logs/stdout.log
```

Possible contents:

```text
Script started
Tue Aug 11 06:30:00 PM CDT 2026
khalid
Script finished
```

Running the script again adds another set of output to the end of the file.

---

## 7. Stdout and Stderr

This command redirects only stdout:

```bash
exec >> logs/stdout.log
```

| File descriptor | Stream | Purpose |
|---:|---|---|
| `0` | stdin | Provides input. |
| `1` | stdout | Carries normal output. |
| `2` | stderr | Carries errors and warnings. |

Errors can therefore remain visible on the terminal.

```bash
#!/bin/bash

mkdir -p logs
exec >> logs/stdout.log

echo "Normal message"
ls /missing-directory
```

Result:

- `Normal message` goes to `logs/stdout.log`.
- The `ls` error remains on the terminal through stderr.

---

## 8. Redirecting Both Streams

Send stdout and stderr to separate files:

```bash
exec 1>> logs/stdout.log
exec 2>> logs/stderr.log
```

The resulting flow is:

```text
Normal output -> logs/stdout.log
Error output  -> logs/stderr.log
```

Complete example:

```bash
#!/bin/bash

mkdir -p logs

exec 1>> logs/stdout.log
exec 2>> logs/stderr.log

echo "Script started"
ls /etc/passwd
ls /missing-directory
echo "Script finished"
```

Append both streams to the same file:

```bash
exec >> logs/combined.log 2>&1
```

Bash processes this from left to right:

1. Stdout is appended to `combined.log`.
2. Stderr is sent to stdout's current destination.
3. Both streams therefore go to `combined.log`.

---

## 9. Validating the Log Directory

The `logs` directory must exist before Bash can open `logs/stdout.log`.

Basic approach:

```bash
mkdir -p logs
exec >> logs/stdout.log
```

With error handling:

```bash
if ! mkdir -p logs; then
    echo "Error: could not create the logs directory." >&2
    exit 1
fi

if ! exec >> logs/stdout.log; then
    echo "Error: could not open the stdout log." >&2
    exit 1
fi
```

If the `exec` redirection fails, stdout is not changed. Sending the custom failure message to stderr helps ensure it remains visible.

---

## 10. Restoring Terminal Output

A script can save its original stdout, redirect it temporarily, and later restore it.

```bash
#!/bin/bash

mkdir -p logs

# Save the original stdout on file descriptor 3.
exec 3>&1

# Redirect stdout to the log file.
exec 1>> logs/stdout.log

echo "This goes to the log file"
date

# Restore the original stdout.
exec 1>&3

# Close file descriptor 3.
exec 3>&-

echo "This appears on the terminal"
```

| Command | Meaning |
|---|---|
| `exec 3>&1` | Save stdout's current destination on descriptor `3`. |
| `exec 1>> file` | Redirect stdout to the log file. |
| `exec 1>&3` | Restore stdout from the saved destination. |
| `exec 3>&-` | Close descriptor `3`. |

This is an intermediate-to-advanced pattern. Whole-script redirection is sufficient for many beginner scripts.

---

## 11. `exec` With a Command vs Redirection

`exec` has two important forms.

### Redirection only

```bash
exec >> logs/stdout.log
```

No external command is provided. Bash changes the current shell's stdout destination, and the script continues.

### With a command

```bash
exec bash another_script.sh
```

The current shell process is replaced by `bash another_script.sh`. When the replacement command finishes, execution does not return to the old script.

| Form | Behavior |
|---|---|
| `exec redirection` | Changes file descriptors in the current shell. |
| `exec command` | Replaces the current shell process with the command. |

---

## 12. Common Mistakes

### Mistake 1: Not creating the directory

```bash
exec >> logs/stdout.log
```

The redirection fails if `logs` does not exist.

Better:

```bash
mkdir -p logs || exit 1
exec >> logs/stdout.log
```

### Mistake 2: Expecting later output on the terminal

```bash
exec >> logs/stdout.log
echo "Hello"
```

`Hello` goes to the file, not the terminal.

### Mistake 3: Assuming errors were also redirected

```bash
exec >> logs/stdout.log
```

This redirects only stdout. Redirect stderr separately:

```bash
exec 2>> logs/stderr.log
```

### Mistake 4: Treating `>` and `>>` as identical

```bash
exec > logs/stdout.log
```

Overwrites the old content.

```bash
exec >> logs/stdout.log
```

Preserves the old content and appends new output.

### Mistake 5: Printing a terminal message after redirection

```bash
exec >> logs/stdout.log
echo "Logging enabled"
```

The message also goes to the log. Print it before redirection or save and restore the original stdout.

---

## 13. Practice Lab

Create `exec_logging_demo.sh` that:

1. Safely creates a `logs` directory.
2. Prints `Logging is starting` on the terminal before redirection.
3. Appends stdout to `logs/stdout.log` using `exec`.
4. Appends stderr to `logs/stderr.log`.
5. Generates normal output using `date`, `whoami`, and `pwd`.
6. Generates a controlled error using `ls /missing-directory`.
7. Allows both log files to be reviewed afterward.

Suggested solution:

```bash
#!/bin/bash

if ! mkdir -p logs; then
    echo "Error: could not create the logs directory." >&2
    exit 1
fi

echo "Logging is starting"

exec 1>> logs/stdout.log
exec 2>> logs/stderr.log

echo "[$(date)] Script started"
echo "User: $(whoami)"
echo "Directory: $(pwd)"

ls /missing-directory

echo "[$(date)] Script finished"
exit 0
```

Run it:

```bash
bash exec_logging_demo.sh
```

Review the logs:

```bash
cat logs/stdout.log
cat logs/stderr.log
```

---

## 14. Quick Summary

```bash
exec >> logs/stdout.log
```

Meaning:

> From this point forward, append all normal output from the current script to `logs/stdout.log`.

Remember:

```text
exec = change the current shell's redirection
1    = stdout
2    = stderr
>    = overwrite
>>   = append
```

Common whole-script logging pattern:

```bash
mkdir -p logs || exit 1
exec 1>> logs/stdout.log
exec 2>> logs/stderr.log
```

