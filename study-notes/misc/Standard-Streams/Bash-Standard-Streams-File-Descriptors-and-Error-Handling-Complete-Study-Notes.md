# Bash Standard Streams, File Descriptors, Redirection, and Error Handling

## Complete Consolidated Study Notes

These notes combine the related lessons on `stdin`, `stdout`, `stderr`, file descriptors, redirection, command status, logging, and source-file validation into one learning path. Repeated explanations have been merged, while the unique examples, practical scripts, lab tasks, interview questions, and Roman Urdu revision points have been retained.

---

## Table of Contents

- [1. Learning Objectives](#1-learning-objectives)
- [2. The Linux Input and Output Model](#2-the-linux-input-and-output-model)
- [3. Standard Input](#3-standard-input)
- [4. Standard Output](#4-standard-output)
- [5. Standard Error](#5-standard-error)
- [6. File Descriptors](#6-file-descriptors)
- [7. Basic Redirection](#7-basic-redirection)
- [8. Combining and Separating Streams](#8-combining-and-separating-streams)
- [9. Why Redirection Order Matters](#9-why-redirection-order-matters)
- [10. Pipes](#10-pipes)
- [11. The Tee Command](#11-the-tee-command)
- [12. The Dev Null Device](#12-the-dev-null-device)
- [13. Command-Specific Stdin and Stdout Options](#13-command-specific-stdin-and-stdout-options)
- [14. Custom File Descriptors](#14-custom-file-descriptors)
- [15. Whole-Script Redirection and Logging](#15-whole-script-redirection-and-logging)
- [16. Command Status](#16-command-status)
- [17. File Descriptor vs Command Status](#17-file-descriptor-vs-command-status)
- [18. Sending Script Errors to Stderr](#18-sending-script-errors-to-stderr)
- [19. Source-File Validation](#19-source-file-validation)
- [20. Practical Copy Script](#20-practical-copy-script)
- [21. Common Mistakes and Troubleshooting](#21-common-mistakes-and-troubleshooting)
- [22. Quick Reference Tables](#22-quick-reference-tables)
- [23. Six-Task Practice Lab](#23-six-task-practice-lab)
- [24. Interview Questions](#24-interview-questions)
- [25. Roman Urdu Revision Summary](#25-roman-urdu-revision-summary)
- [26. Final Memory Rules](#26-final-memory-rules)

---

## 1. Learning Objectives

After completing these notes, you should be able to:

- Explain what a stream is.
- Describe `stdin`, `stdout`, and `stderr`.
- Recognize file descriptors `0`, `1`, and `2`.
- Redirect input, normal output, and errors.
- Explain the difference between overwrite and append redirection.
- Combine or separate stdout and stderr correctly.
- Explain why redirection order matters.
- Connect commands with pipes.
- Display and save output with `tee`.
- Discard unwanted output with `/dev/null` safely.
- Distinguish file descriptors from command statuses.
- Use `$?`, `if`, `exit`, and `return` correctly.
- Send custom error messages to stderr with `>&2`.
- Validate a source file before processing it.
- Build clear logging and error-handling patterns in Bash scripts.

---

## 2. The Linux Input and Output Model

A **stream** is a logical path through which data flows from one place to another. It is not a physical folder or a particular file.

When a Linux program starts, it normally receives three standard streams:

| File descriptor | Stream | Full name | Default connection | Purpose |
|---:|---|---|---|---|
| `0` | `stdin` | Standard input | Keyboard | Provides data to the program. |
| `1` | `stdout` | Standard output | Terminal | Carries normal results. |
| `2` | `stderr` | Standard error | Terminal | Carries warnings and error messages. |

```mermaid
flowchart LR
    A["Keyboard or input file"] -->|"stdin: 0"| B["Command or script"]
    B -->|"stdout: 1"| C["Normal result"]
    B -->|"stderr: 2"| D["Error message"]
```

Although stdout and stderr both appear on the terminal by default, they remain separate streams and can be redirected independently.

---

## 3. Standard Input

Standard input is the data received by a command or script. Its file descriptor is `0`.

### Read from the keyboard

```bash
read -r -p "Enter your name: " name
echo "Hello, $name"
```

- `read` receives data from stdin.
- `-r` prevents backslashes from being treated as escape characters.
- `-p` displays a prompt.
- `name` stores the value entered by the user.

### Observe stdin with cat

```bash
cat
```

Type text and press Enter. `cat` reads the text from stdin and writes it to stdout. Press `Ctrl+D` to send the end-of-file signal and finish.

### Observe stdin with sort

```bash
sort
```

Enter:

```text
banana
apple
mango
```

Press `Ctrl+D`. `sort` then prints:

```text
apple
banana
mango
```

### Redirect a file into stdin

```bash
sort < students.txt
```

The file becomes the command's standard input.

The explicit form is:

```bash
sort 0< students.txt
```

The `0` is normally omitted because `<` redirects stdin by default.

---

## 4. Standard Output

Standard output carries the normal result of a command. Its file descriptor is `1`.

```bash
echo "Hello, Bash"
```

By default, the message appears on the terminal.

### Redirect stdout and overwrite

```bash
echo "Ali" > students.txt
```

The `>` operator:

- Creates `students.txt` if it does not exist.
- Replaces its existing contents if it already exists.

The explicit form is:

```bash
echo "Ali" 1> students.txt
```

The `1` is optional because stdout is the default output stream.

### Append stdout

```bash
echo "Sara" >> students.txt
echo "Omar" >> students.txt
```

`>>` adds data to the end of the file without removing existing content.

| Syntax | Result |
|---|---|
| `> file` | Create or overwrite the file. |
| `>> file` | Create or append to the file. |

---

## 5. Standard Error

Standard error carries warnings and error messages. Its file descriptor is `2`.

Generate an error:

```bash
ls /missing-file
```

The error appears on the terminal through stderr.

### Redirect stderr and overwrite

```bash
ls /missing-file 2> errors.log
```

The error is stored in `errors.log` instead of appearing on the terminal.

### Append stderr

```bash
ls /missing-one 2>> errors.log
ls /missing-two 2>> errors.log
```

Both errors are added to the end of the log.

### Why stdout and stderr look the same

Run:

```bash
ls /etc/passwd /missing-file
```

This command produces:

- A valid result on stdout.
- An error message on stderr.

Both appear on the terminal because that is their default destination. Their different behavior becomes visible when one stream is redirected.

Save only stdout:

```bash
ls /etc/passwd /missing-file > success.log
```

Save only stderr:

```bash
ls /etc/passwd /missing-file 2> errors.log
```

---

## 6. File Descriptors

A **file descriptor** is a small integer used by a process as a handle for an open input/output resource.

A file descriptor is not the resource itself. It may refer to:

- A terminal
- A regular file
- A pipe
- A socket
- Another open input/output resource

The standard descriptors are:

```text
0 = stdin
1 = stdout
2 = stderr
```

Examples:

```bash
0< input.txt
1> output.txt
2> error.log
```

The descriptor answers this question:

> Which open input or output channel should Bash use?

---

## 7. Basic Redirection

### Redirect stdin

```bash
command < input.txt
```

### Redirect stdout

```bash
command > output.log
```

### Append stdout

```bash
command >> output.log
```

### Redirect stderr

```bash
command 2> error.log
```

### Append stderr

```bash
command 2>> error.log
```

### A destination is required

This is incomplete:

```bash
ls /missing 2>
```

Bash reports a syntax error because `2>` must be followed by a destination.

Correct:

```bash
ls /missing 2> error.log
```

---

## 8. Combining and Separating Streams

### Save stdout and stderr separately

```bash
command > output.log 2> error.log
```

Example:

```bash
ls /etc/passwd /missing-file > output.log 2> error.log
```

### Save both streams in one file

Traditional form:

```bash
command > combined.log 2>&1
```

Bash shortcut:

```bash
command &> combined.log
```

Append both streams:

```bash
command >> combined.log 2>&1
```

or:

```bash
command &>> combined.log
```

### Meaning of 2 greater-than ampersand 1

```bash
2>&1
```

means:

> Send file descriptor `2` to the destination currently used by file descriptor `1`.

It duplicates the destination; it does not mean “send output to a file named `1`.”

### 2 greater-than ampersand 1 by itself

```bash
ls /missing 2>&1
```

stdout still points to the terminal, so stderr is also sent to the terminal. No log file is created.

---

## 9. Why Redirection Order Matters

Bash processes redirections from left to right.

### Both streams go to the file

```bash
command > combined.log 2>&1
```

Order:

1. stdout is redirected to `combined.log`.
2. stderr is redirected to stdout's current destination.
3. Both streams therefore go to `combined.log`.

### Only stdout goes to the file

```bash
command 2>&1 > combined.log
```

Order:

1. stderr is connected to stdout's original destination, normally the terminal.
2. stdout is then redirected to `combined.log`.
3. stderr remains connected to the terminal.

The same symbols in a different order can therefore produce different results.

---

## 10. Pipes

A pipe sends the stdout of one command to the stdin of another command.

The pipe operator is:

```text
|
```

Example:

```bash
cat students.txt | sort
```

Flow:

```text
cat stdout -> sort stdin
```

When the second command can read a file directly, this is often simpler:

```bash
sort students.txt
```

Another example:

```bash
grep bash /etc/passwd | wc -l
```

### A normal pipe does not carry stderr

```bash
command1 | command2
```

Only stdout from `command1` goes through the pipe. stderr remains on its current destination.

Include stderr explicitly:

```bash
command1 2>&1 | command2
```

Example:

```bash
ls /etc/passwd /missing-file 2>&1 | tee command.log
```

### Pipeline status

Without `pipefail`, a pipeline normally returns the status of its final command.

For scripts where an earlier pipeline failure must be detected, enable:

```bash
set -o pipefail
```

Then the pipeline returns a nonzero status when one of its commands fails, subject to Bash's pipeline-status rules.

---

## 11. The Tee Command

`tee` copies stdin to both stdout and one or more files. It lets you watch output and save it at the same time.

```bash
echo "Deployment started" | tee deployment.log
```

Append instead of overwrite:

```bash
echo "Deployment completed" | tee -a deployment.log
```

Capture both stdout and stderr:

```bash
command 2>&1 | tee command.log
```

This is useful for:

- Deployment logs
- Troubleshooting sessions
- Installation output
- CI/CD job records
- Commands that must remain visible while being recorded

---

## 12. The Dev Null Device

`/dev/null` is a special Linux device that discards data written to it. It is sometimes called the **bit bucket**.

Discard stdout:

```bash
command > /dev/null
```

Discard stderr:

```bash
command 2> /dev/null
```

Discard both:

```bash
command > /dev/null 2>&1
```

Bash shortcut:

```bash
command &> /dev/null
```

Use `/dev/null` carefully. During learning or troubleshooting, error messages usually contain information you need.

When a command provides a quiet option, that option may express your intention more clearly. For example:

```bash
grep -q "Ali" students.txt
```

---

## 13. Command-Specific Stdin and Stdout Options

Some programs provide long options named `--stdin` or `--stdout`. These are program-specific options, not universal Bash redirection operators.

### The stdout option

GNU `gzip` supports:

```bash
gzip --stdout file.txt > file.txt.gz
```

Its short form is:

```bash
gzip -c file.txt > file.txt.gz
```

`--stdout` tells `gzip` to write compressed data to stdout instead of replacing the original file.

### The stdin option

Some RHEL-family versions of `passwd` support `--stdin`:

```bash
passwd --stdin username
```

This option is not available on every distribution, including typical Ubuntu installations. Do not assume that all commands support `--stdin` or `--stdout`; check the command's help or manual page:

```bash
command --help
man command
```

Security note: avoid placing plaintext passwords in shell history or exposing them through insecure pipelines. Use approved account-management and secret-handling methods in real environments.

---

## 14. Custom File Descriptors

Bash can open additional descriptors beyond `0`, `1`, and `2`.

```bash
exec 3> custom.log
echo "Custom message" >&3
exec 3>&-
```

Explanation:

| Command | Meaning |
|---|---|
| `exec 3> custom.log` | Open `custom.log` for writing on file descriptor `3`. |
| `echo ... >&3` | Send the message through descriptor `3`. |
| `exec 3>&-` | Close descriptor `3`. |

Custom descriptors are useful when a script needs a dedicated log or another persistent input/output channel.

---

## 15. Whole-Script Redirection and Logging

The `exec` builtin can change the streams used by all commands that follow it in the current shell.

### Redirect all later stderr

```bash
#!/bin/bash

mkdir -p logs
exec 2>> logs/stderr.log

echo "Script started"
cat missing.txt
ls /missing-directory
echo "Script finished"
```

After `exec 2>> logs/stderr.log`, later error messages are appended to that file.

[exec explanation click here](md/Bash-exec-Stdout-Redirection-Study-Notes.md)

[exec explanation click here in roman Urdu](md/Bash-exec-Stdout-Redirection-Roman-Urdu-Study-Notes.md)

### Separate all later stdout and stderr

```bash
#!/bin/bash

mkdir -p logs
exec >> logs/stdout.log
exec 2>> logs/stderr.log

echo "[$(date)] Script started"
ls
cat missing.txt
echo "[$(date)] Script finished"
```

### Timestamped log filename

```bash
mkdir -p logs
error_log="logs/error-$(date '+%Y-%m-%d_%H-%M-%S').log"
cat missing.txt 2> "$error_log"
```

Example filename:

```text
logs/error-2026-08-11_18-30-00.log
```

### Practical logging script

```bash
#!/bin/bash

log_dir="./logs"
stdout_log="$log_dir/stdout.log"
stderr_log="$log_dir/stderr.log"

mkdir -p "$log_dir" || {
    echo "Error: could not create log directory." >&2
    exit 1
}

exec >> "$stdout_log"
exec 2>> "$stderr_log"

echo "[$(date)] Script started"

if ls /etc/passwd; then
    echo "[$(date)] File check succeeded"
else
    status=$?
    echo "[$(date)] File check failed with status $status" >&2
fi

echo "[$(date)] Script finished"
```

---

## 16. Command Status

A **command status**, also called an exit status or return status, is a number produced when a command finishes.

The usual convention is:

```text
0       = success
nonzero = failure or another command-defined result
```

Shell statuses are represented in the range `0` through `255`.

### Check the latest status

```bash
ls /missing
echo "$?"
```

`$?` contains the status of the most recently completed command.

Important: every subsequent command replaces `$?`.

Save the value immediately:

```bash
cp source.txt backup.txt
status=$?
echo "cp returned: $status"
```

### Prefer direct conditional checks

Instead of checking `$?` later:

```bash
if cp -- source.txt backup.txt; then
    echo "Copy completed"
else
    echo "Copy failed" >&2
fi
```

`if` runs the `then` block when the command returns status `0`.

### Negate(to reverse) a command result

```bash
if ! cp -- source.txt backup.txt; then
    echo "Copy failed" >&2
    exit 1
fi
```

`!` reverses the success/failure result for the condition.

### Set a script status

```bash
exit 0
```

Ends the script successfully.

```bash
exit 1
```

Ends the script with a general failure status.

Inside a function, use `return N` to leave the function with status `N`.

---

## 17. File Descriptor vs Command Status

File descriptors and command statuses both use numbers, but they answer different questions:

```text
File descriptor = Where does data travel?
Command status  = How did the command finish?
```

| Feature | File descriptor | Command status |
|---|---|---|
| Purpose | Identifies an input/output channel | Reports how a command finished |
| Main question | Where should data go? | Did the command succeed? |
| Common values | `0`, `1`, `2`, and custom descriptors | `0` through `255` |
| Used with | Redirection operators | `$?`, `if`, `exit`, and `return` |
| Example | `2> error.log` | `exit 2` |
| Meaning of `0` | stdin | Success |
| Meaning of `1` | stdout | A nonzero result, often general failure |
| Meaning of `2` | stderr | A command-defined nonzero status |

Consider:

```bash
ls /missing 2> error.log
echo "$?"
```

- In `2> error.log`, `2` is the stderr file descriptor.
- If `echo "$?"` prints `2`, that is the exit status returned by `ls`.

The identical number has two unrelated meanings determined by context.

---

## 18. Sending Script Errors to Stderr

`echo` normally writes to stdout. Send a custom message to stderr with:

```bash
echo "Error: source file does not exist." >&2
```

This is equivalent to:

```bash
echo "Error: source file does not exist." 1>&2
```

Meaning:

> Redirect `echo`'s stdout to stderr's current destination.

This allows callers to separate successful output from errors:

```bash
bash script.sh > output.log 2> error.log
```

### Difference among similar forms

| Syntax | Meaning |
|---|---|
| `echo "Error" >&2` | Send the message to stderr. |
| `echo "Error" 1>&2` | Explicit equivalent of `>&2`. |
| `echo "Error" >2` | Write the message to a file named `2`. |
| `echo "Error" &>2` | Send both streams to a file named `2`. |
| `command 2> error.log` | Redirect the command's stderr to a file. |

This command does not use `error.log` as a destination:

```bash
echo "hello" >&2 error.log
```

`error.log` is an additional argument to `echo`, so the message becomes:

```text
hello error.log
```

To redirect stderr to the file, use:

```bash
echo "hello" 2> error.log
```

However, because `echo` normally writes to stdout, that particular command leaves `error.log` empty. To save `echo`'s message as error output, first send it to stderr and redirect the surrounding command or group:

```bash
{ echo "hello" >&2; } 2> error.log
```

---

## 19. Source-File Validation

Consider:

```bash
source_file="abc.txt"

if [[ ! -f "$source_file" ]]; then
    echo "Error: source file does not exist." >&2
    exit 1
fi
```

### Variable assignment

```bash
source_file="abc.txt"
```

The path is stored in a variable. There must be no spaces around `=` in a Bash assignment.

`abc.txt` is a relative path, so Bash checks the current working directory. Confirm it with:

```bash
pwd
```

### Condition breakdown

```bash
if [[ ! -f "$source_file" ]]; then
```

| Part | Meaning |
|---|---|
| `if` | Begins the conditional decision. |
| `[[ ... ]]` | Bash conditional-expression syntax. |
| `!` | Negates the test result. |
| `-f` | Tests for an existing regular file. |
| `"$source_file"` | Safely expands the path. |
| `then` | Begins the block that runs when the condition is true. |

Plain-English meaning:

> If the source path is not an existing regular file, run the error block.

### Why quoting matters

```bash
[[ -f "$source_file" ]]
```

Quoting keeps a path containing spaces together and is a safe, consistent habit for pathname variables.

### File-test operators

| Operator | Test |
|---|---|
| `-f` | Existing regular file |
| `-d` | Existing directory |
| `-e` | Existing filesystem entry |
| `-r` | Readable by the current process |
| `-w` | Writable by the current process |
| `-x` | Executable or traversable by the current process |
| `-s` | Existing file with a size greater than zero |

### Complete validation script

```bash
#!/bin/bash

# Title: Source File Validation

source_file="${1:-}"

if [[ -z "$source_file" ]]; then
    echo "Usage: $0 SOURCE_FILE" >&2
    exit 1
fi

if [[ ! -f "$source_file" ]]; then
    echo "Error: source file does not exist: $source_file" >&2
    exit 1
fi

echo "Source file exists: $source_file"
exit 0
```

Syntax-check it:

```bash
bash -n validate_source.sh
```

Test the failure path:

```bash
bash validate_source.sh missing.txt 2> error.log
status=$?
cat error.log
echo "Status: $status"
```

Test the success path:

```bash
touch report.txt
bash validate_source.sh report.txt
echo "$?"
```

---

## 20. Practical Copy Script

This example uses file descriptors to control where messages go and command statuses to control what the script does next.

```bash
#!/bin/bash

# Title: Safe File Copy

source_file="${1:-}"
destination="${2:-}"

if [[ -z "$source_file" || -z "$destination" ]]; then
    echo "Usage: $0 SOURCE DESTINATION" >&2
    exit 1
fi

if [[ ! -f "$source_file" ]]; then
    echo "Error: source is not a regular file: $source_file" >&2
    exit 1
fi

if cp -- "$source_file" "$destination" 2> error.log; then
    echo "Copy completed: $source_file -> $destination"
    exit 0
else
    status=$?
    echo "Error: copy failed with status $status" >&2
    echo "Details were saved in error.log" >&2
    exit "$status"
fi
```

Important elements:

| Code | Purpose |
|---|---|
| `cp --` | Marks the end of options so filenames beginning with `-` are safer. |
| `2> error.log` | Saves errors produced by `cp`. |
| `if cp ...; then` | Checks the `cp` status directly. |
| `status=$?` | Immediately preserves the failed `cp` status. |
| `>&2` | Sends the script's custom failure messages to stderr. |
| `exit "$status"` | Reports the underlying copy failure to the caller. |

---

## 21. Common Mistakes and Troubleshooting

### Accidentally overwriting a file

```bash
echo "new line" > notes.txt
```

Use `>>` when existing content must be preserved.

### Redirecting the wrong stream

```bash
cd /root > error.log
```

The permission error still appears because `>` redirects stdout, but the error is on stderr.

Correct:

```bash
cd /root 2> error.log
```

### Forgetting the destination

```bash
ls /missing 2>
```

`2>` requires a filename or another valid destination.

### Confusing a descriptor with a filename

```bash
echo "Error" >2
```

This writes to a file named `2`.

Use:

```bash
echo "Error" >&2
```

### Checking the status too late

Incorrect:

```bash
cp source.txt backup.txt
echo "Copy attempted"
echo "$?"
```

The final status belongs to `echo`, not `cp`.

Correct:

```bash
cp source.txt backup.txt
status=$?
echo "cp returned: $status"
```

### Reporting success after an error

Incorrect:

```bash
echo "Error: file missing" >&2
exit 0
```

Correct:

```bash
echo "Error: file missing" >&2
exit 1
```

### Using the wrong file test

`-f` checks for a regular file, not every kind of path. Use `-d` for a directory or `-e` for general path existence.

### Forgetting relative-path behavior

```bash
source_file="abc.txt"
```

This checks the current working directory, which may differ from the script directory.

### Hiding useful errors too early

```bash
command &> /dev/null
```

Do not suppress all output until the command is understood and tested.

### Forgetting quotes

Avoid:

```bash
cat $file
```

Prefer:

```bash
cat "$file"
```

---

## 22. Quick Reference Tables

### Standard streams

| Number | Stream | Default |
|---:|---|---|
| `0` | stdin | Keyboard |
| `1` | stdout | Terminal |
| `2` | stderr | Terminal |

### Redirection

| Syntax | Meaning |
|---|---|
| `< file` | Read stdin from a file. |
| `> file` | Redirect stdout and overwrite. |
| `>> file` | Redirect stdout and append. |
| `1> file` | Explicitly redirect stdout. |
| `2> file` | Redirect stderr and overwrite. |
| `2>> file` | Redirect stderr and append. |
| `> file 2>&1` | Send stdout and stderr to one file. |
| `&> file` | Bash shortcut to redirect both streams. |
| `&>> file` | Append both streams in Bash. |
| `>&2` | Send stdout to stderr's current destination. |
| `2>&1` | Send stderr to stdout's current destination. |
| `\|` | Send stdout to another command's stdin. |
| `2>&1 \|` | Send both streams into a pipe. |
| `> /dev/null` | Discard stdout. |
| `2> /dev/null` | Discard stderr. |
| `&> /dev/null` | Discard both streams in Bash. |

### Command status

| Syntax | Meaning |
|---|---|
| `$?` | Status of the most recently completed command |
| `0` | Success |
| Nonzero | Failure or another command-defined result |
| `exit N` | End the script with status `N` |
| `return N` | End the function with status `N` |
| `if command; then` | Run `then` when the command returns `0` |
| `if ! command; then` | Run `then` when the command returns nonzero |

---

## 23. Six-Task Practice Lab

Complete the tasks in order because each task builds on the previous one.

### Task 1: Observe the three streams

Run:

```bash
echo "Hello Bash"
read -r -p "Enter a word: " word
ls /missing-file
```

Identify which operation uses stdin, stdout, or stderr.

### Task 2: Redirect stdout and stderr

Run:

```bash
ls /etc/passwd /missing-file > success.log 2> errors.log
```

Display both files and explain why their contents are different.

### Task 3: Practise stdin and pipes

Create data:

```bash
echo "banana" > fruits.txt
echo "apple" >> fruits.txt
echo "cherry" >> fruits.txt
```

Sort through stdin:

```bash
sort < fruits.txt
```

Count matching lines through a pipe:

```bash
grep "a" fruits.txt | wc -l
```

### Task 4: Combine and display streams

Save both streams:

```bash
ls /etc/passwd /missing-file > combined.log 2>&1
```

Then display and save both streams with `tee`:

```bash
ls /etc/passwd /missing-file 2>&1 | tee visible.log
```

### Task 5: Validate a file

Create `validate_file.sh` that:

1. Accepts a filename as `$1`.
2. Sends a usage message to stderr when the argument is missing.
3. Uses `[[ ! -f "$file" ]]` to detect a missing regular file.
4. Sends failures to stderr.
5. Uses `exit 1` for failure and `exit 0` for success.

### Task 6: Build a logged copy script

Create `logged_copy.sh` that:

1. Accepts a source and destination.
2. Validates both arguments.
3. Validates the source file.
4. Copies with `cp --`.
5. Saves `cp` errors in `error.log`.
6. Prints success on stdout.
7. Prints failure on stderr.
8. Returns an appropriate command status.

---

## 24. Interview Questions

### 1. What are the three standard streams?

stdin, stdout, and stderr.

### 2. What are their file descriptor numbers?

`0`, `1`, and `2`, respectively.

### 3. What is the difference between `>` and `>>`?

`>` overwrites the destination file; `>>` appends to it.

### 4. How do you redirect only stderr?

```bash
command 2> error.log
```

### 5. How do you combine stdout and stderr?

```bash
command > combined.log 2>&1
```

In Bash, `command &> combined.log` is a shortcut.

### 6. What does a normal pipe carry?

It carries stdout from the command on the left to stdin of the command on the right.

### 7. What does `2>&1` mean?

Send stderr to stdout's current destination.

### 8. Why does redirection order matter?

Bash processes redirections from left to right, and each duplication uses the destination that exists at that moment.

### 9. What is `/dev/null`?

A special device that discards data written to it.

### 10. What is the difference between stderr and exit status?

stderr carries error text; exit status is a number reporting how a command finished.

### 11. Why should script errors go to stderr?

It allows callers, scripts, and logging systems to separate successful output from failures.

### 12. What does `$?` contain?

The status of the most recently completed command.

### 13. Why must `$?` be checked immediately?

Every subsequent command replaces it.

### 14. What does `[[ ! -f "$file" ]]` test?

It is true when the path is not an existing regular file.

### 15. What is a custom file descriptor?

An additional numeric handle, such as descriptor `3`, that a process opens for a specific input/output resource.

---

## 25. Roman Urdu Revision Summary

### Stream kya hai?

Stream data ke flow ka logical rasta hai. Yeh koi folder nahi hoti. Data keyboard, file, command ya terminal ke darmiyan stream ke zariye move karta hai.

```text
0 = stdin  = input andar aata hai
1 = stdout = normal output bahar jata hai
2 = stderr = error output bahar jata hai
```

### Basic redirection

```bash
command > output.log
```

stdout ko file mein bhejta aur purana content overwrite karta hai.

```bash
command >> output.log
```

stdout ko file ke end mein append karta hai.

```bash
command 2> error.log
```

stderr ko `error.log` mein bhejta hai.

```bash
command > combined.log 2>&1
```

stdout aur stderr dono ko ek file mein bhejta hai. Order important hai kyun ke Bash redirections ko left se right process karta hai.

### Error message stderr par

```bash
echo "Error: file missing" >&2
```

`echo` normally stdout use karta hai. `>&2` us message ko stderr ki current destination par bhejta hai.

### File descriptor vs status

```text
File descriptor = Data kahan jayega?
Command status  = Command kis tarah finish hui?
```

```bash
2> error.log
```

Yahan `2` stderr ka file descriptor hai.

```bash
exit 2
```

Yahan `2` command status hai.

### Source-file validation

```bash
if [[ ! -f "$source_file" ]]; then
    echo "Error: source file does not exist." >&2
    exit 1
fi
```

Simple meaning:

> Agar source path existing regular file nahi hai to error stderr par bhejo aur script ko failure status ke saath band kar do.

---

## 26. Final Memory Rules

```text
stdin  = input
stdout = normal output
stderr = error output
```

```text
0 = stdin
1 = stdout
2 = stderr
```

```text
File descriptor = where data travels
Command status  = how the command finished
```

```bash
command > output.log 2> error.log
```

means:

```text
Normal output -> output.log
Error output  -> error.log
```

The central scripting rule is:

> Send useful results to stdout, send clear failure messages to stderr, and return an accurate command status.

