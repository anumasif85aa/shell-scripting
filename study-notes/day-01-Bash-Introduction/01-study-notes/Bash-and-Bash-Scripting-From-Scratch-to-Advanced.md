# Bash and Bash Scripting — From Scratch to Advanced

## 1. What Is a Shell?

A shell is a program that accepts commands and asks the operating system to
perform work.

```text
User → Terminal → Shell → Linux kernel → Hardware
```

- **Terminal:** the window where you type.
- **Shell:** interprets commands.
- **Kernel:** manages CPU, memory, disks, processes, and devices.
- **Bash:** one popular shell.

Check the configured login shell:

```bash
echo "$SHELL"
```

Check the current process:

```bash
echo "$0"
ps -p "$$"
```

Check the Bash version:

```bash
bash --version
echo "$BASH_VERSION"
```

`$SHELL` usually shows the configured login shell. It does not always prove
which interpreter is running the current script.

## 2. What Is Bash?

Bash means **Bourne Again Shell**. It can be used:

- Interactively to run commands.
- As an interpreter for script files.
- To combine Linux tools into repeatable automation.

A command is usually run once:

```bash
date
```

A script stores commands in a file:

```bash
#!/bin/bash

echo "Starting report"
date
uptime
```

## 3. Linux Architecture for a Bash Student

| Layer | Purpose | Examples |
|---|---|---|
| Hardware | Physical resources | CPU, RAM, disk |
| Kernel | Controls resources | processes, filesystems, devices |
| System libraries | Common program functions | glibc |
| Shell and utilities | User command environment | Bash, `ls`, `grep` |
| Applications | User workloads | web server, editor |

Bash is not the Linux kernel. Bash starts programs and receives their exit
statuses.

## 4. Prepare the Environment

Create a safe practice directory:

```bash
mkdir -p ~/bash-lab
cd ~/bash-lab
```

Useful tools:

```bash
command -v bash
command -v vim
command -v nano
```

List installed login shells:

```bash
cat /etc/shells
```

Start another installed shell temporarily:

```bash
zsh
```

Return to the previous shell:

```bash
exit
```

## 5. Essential Commands

| Command | Purpose |
|---|---|
| `pwd` | Show current directory |
| `ls -la` | List files, including hidden files |
| `cd DIR` | Change directory |
| `mkdir DIR` | Create directory |
| `touch FILE` | Create empty file or update timestamp |
| `cp SOURCE DEST` | Copy |
| `mv SOURCE DEST` | Move or rename |
| `rm FILE` | Remove one file carefully |
| `cat FILE` | Display a small file |
| `less FILE` | View a long file |
| `head FILE` | Show beginning |
| `tail FILE` | Show end |
| `grep PATTERN FILE` | Search text |
| `find DIR ...` | Search filesystem entries |
| `man COMMAND` | Read the manual |

Command structure:

```text
command option argument
ls      -l     /etc
```

## 6. Editors

### Nano

```bash
nano hello.sh
```

- Save: `Ctrl+O`
- Exit: `Ctrl+X`

### Vim

```bash
vim hello.sh
```

- Insert mode: `i`
- Escape to normal mode: `Esc`
- Save and quit: `:wq`
- Quit without saving: `:q!`

Choose one editor first. Learn the other later.

## 7. Your First Bash Script

```bash
#!/bin/bash

# Title: Hello Script
# Purpose: Display a greeting
# Usage: ./hello.sh

echo "Hello from Bash"
```

Check syntax:

```bash
bash -n hello.sh
```

Make executable:

```bash
chmod u+x hello.sh
```

Run directly:

```bash
./hello.sh
```

Run with Bash:

```bash
bash hello.sh
```

`./hello.sh` requires execute permission and uses the shebang. `bash hello.sh`
starts Bash explicitly, so the file itself does not need execute permission.

## 8. The Shebang

Common Bash shebang:

```bash
#!/bin/bash
```

PATH-based Bash lookup:

```bash
#!/usr/bin/env bash
```

Use `#!/bin/zsh` or `#!/usr/bin/env zsh` only when the script actually uses
Zsh as its interpreter.

A missing slash is incorrect:

```bash
#!bin/bash
```

## 9. Comments and Multiline Documentation

Single-line comment:

```bash
# This explains the next command.
```

Use multiple `#` lines for normal documentation:

```bash
# Author: Student Name
# Purpose: Create a system report
# Usage: ./system_report.sh
```

A here-document can also feed multiline text to a command:

```bash
cat <<'INFO'
This text is passed to cat.
Variables such as $USER are not expanded.
INFO
```

Do not treat `<< comment` as the normal commenting system. It is a
here-document redirection.

## 10. Standard Streams

Every command normally receives three streams:

| Stream | File descriptor | Purpose |
|---|---:|---|
| stdin | 0 | Input |
| stdout | 1 | Normal output |
| stderr | 2 | Error output |

Write normal output:

```bash
echo "Report created"
```

Write an error:

```bash
echo "Error: file missing" >&2
```

Redirect stdout:

```bash
date > date.txt
```

Append stdout:

```bash
uptime >> date.txt
```

Redirect stderr:

```bash
ls /missing 2> errors.log
```

Redirect both:

```bash
command > all.log 2>&1
```

Discard output:

```bash
command >/dev/null 2>&1
```

Use `/dev/null` only when hiding the output is intentional.

## 11. Pipes

A pipe sends one command's stdout to another command's stdin:

```bash
getent passwd | grep bash
```

Pipeline:

```text
command 1 stdout → command 2 stdin
```

The pipe does not automatically send stderr.

## 12. Exit Status

Immediately after a command:

```bash
echo "$?"
```

- `0` normally means success.
- A nonzero value means failure or another documented result.

Example:

```bash
mkdir practice
echo "$?"

cd /missing
echo "$?"
```

Save the status before another command changes it:

```bash
some_command
status=$?
echo "Status: $status"
```

## 13. Command Lists

Run the second command only if the first succeeds:

```bash
mkdir demo && cd demo
```

Run the second only if the first fails:

```bash
cd /missing || echo "Directory not found" >&2
```

These are short command lists. Use `if` when the logic needs explanation or
several actions.

## 14. Variables

Create variables without spaces around `=`:

```bash
name="Ali"
course="Bash Scripting"
```

Use them:

```bash
echo "Student: $name"
echo "Course: ${course}"
```

Incorrect:

```bash
name = "Ali"
```

Bash treats `name` as a command because spaces separate words.

### Quoting

Double quotes expand variables:

```bash
echo "Hello, $name"
```

Single quotes display text literally:

```bash
echo 'Hello, $name'
```

Quote variable expansions:

```bash
mkdir -- "$directory"
```

### Environment Variables

```bash
echo "$USER"
echo "$HOME"
echo "$PATH"
```

Export a variable to child processes:

```bash
export APP_ENV="test"
```

### Default Value

```bash
display_user="${SUDO_USER:-$USER}"
```

`${SUDO_USER:-$USER}` means:

- Use `SUDO_USER` if it exists and is not empty.
- Otherwise use `USER`.

## 15. Command Substitution

Capture stdout:

```bash
today="$(date +%F)"
host="$(hostname)"

echo "Date: $today"
echo "Host: $host"
```

Use `$(...)` instead of old backticks because it is easier to read and nest.

## 16. User Input

```bash
read -r -p "Enter your name: " name
echo "You entered: $name"
```

- `read` receives input.
- `-r` keeps backslashes literal.
- `-p` displays a prompt.

Secret input:

```bash
read -r -s -p "Password: " password
echo
```

Do not display or store real passwords in practice scripts.

## 17. Arguments

Run:

```bash
./fruit.sh apple banana cherry
```

Inside the script:

| Parameter | Meaning |
|---|---|
| `$0` | Script name |
| `$1` | First argument |
| `$2` | Second argument |
| `$#` | Number of arguments |
| `"$@"` | All arguments, separately and safely |
| `$?` | Status of the previous command |
| `$$` | Current shell process ID |

Example:

```bash
#!/bin/bash

echo "Script: $0"
echo "First fruit: ${1:-not supplied}"
echo "Count: $#"
```

Validate count:

```bash
if [[ "$#" -ne 2 ]]; then
    echo "Usage: $0 SOURCE DESTINATION" >&2
    exit 1
fi
```

Loop through all arguments:

```bash
for item in "$@"
do
    echo "Item: $item"
done
```

## 18. Conditionals

### if

```bash
if [[ "$weather" == "rain" ]]; then
    echo "Take an umbrella"
fi
```

### if/else

```bash
if [[ "$age" -ge 18 ]]; then
    echo "Adult"
else
    echo "Minor"
fi
```

### if/elif/else

```bash
if [[ "$score" -ge 90 ]]; then
    echo "A"
elif [[ "$score" -ge 80 ]]; then
    echo "B"
else
    echo "Keep practising"
fi
```

### Numeric Operators

| Operator | Meaning |
|---|---|
| `-eq` | Equal |
| `-ne` | Not equal |
| `-gt` | Greater than |
| `-ge` | Greater than or equal |
| `-lt` | Less than |
| `-le` | Less than or equal |

### String Tests

| Test | Meaning |
|---|---|
| `[[ "$a" == "$b" ]]` | Equal |
| `[[ "$a" != "$b" ]]` | Not equal |
| `[[ -z "$a" ]]` | Empty |
| `[[ -n "$a" ]]` | Not empty |

### File Tests

| Test | Meaning |
|---|---|
| `-e` | Path exists |
| `-f` | Regular file |
| `-d` | Directory |
| `-s` | File exists and is not empty |
| `-r` | Readable |
| `-w` | Writable |
| `-x` | Executable |
| `-L` | Symbolic link |

### Logic

```bash
if [[ "$age" -ge 18 && "$country" == "US" ]]; then
    echo "Both checks passed"
fi

if [[ "$environment" == "dev" || "$environment" == "test" ]]; then
    echo "Non-production"
fi

if [[ ! -f "$config" ]]; then
    echo "Missing configuration" >&2
fi
```

### Arithmetic Conditions

```bash
if (( number % 2 == 0 )); then
    echo "Even"
fi
```

### Test a Command Directly

```bash
if grep -q "ERROR" app.log; then
    echo "Errors found"
fi
```

`if` uses the command's exit status.

### case

```bash
case "$action" in
    start)
        echo "Starting"
        ;;
    stop)
        echo "Stopping"
        ;;
    *)
        echo "Usage: $0 {start|stop}" >&2
        exit 1
        ;;
esac
```

## 19. Loops

### for Loop

```bash
for fruit in apple banana cherry
do
    echo "Fruit: $fruit"
done
```

C-style counting:

```bash
for (( number=1; number<=5; number++ ))
do
    echo "Number: $number"
done
```

Multiplication table:

```bash
table="${1:-2}"

for (( number=1; number<=10; number++ ))
do
    echo "$table x $number = $(( table * number ))"
done
```

### while Loop

```bash
count=1

while [[ "$count" -le 5 ]]
do
    echo "Count: $count"
    ((count++))
done
```

### Read a File Safely

```bash
while IFS= read -r line
do
    echo "Line: $line"
done < servers.txt
```

### Loop Through Matching Files

```bash
for file in *.txt
do
    [[ -e "$file" ]] || continue
    echo "Text file: $file"
done
```

Alternative:

```bash
shopt -s nullglob

for file in *.txt
do
    echo "Text file: $file"
done
```

`nullglob` makes an unmatched pattern expand to zero items.

### Control

- `break` exits the loop.
- `continue` skips to the next iteration.

## 20. Functions

Basic function:

```bash
greet() {
    echo "Hello, $1"
}

greet "Ali"
```

Functions have their own positional arguments:

```bash
show_file() {
    local file="$1"
    echo "File: $file"
}
```

Use `local` to avoid changing unrelated global variables.

### Function Status

```bash
create_directory() {
    local directory="$1"

    if [[ -e "$directory" ]]; then
        return 1
    fi

    mkdir -- "$directory"
}

if create_directory "practice"; then
    echo "Created"
else
    echo "Creation failed" >&2
fi
```

`return` provides a numeric function status from `0` through `255`. Write data
to stdout when a function needs to produce text.

## 21. Arrays

Indexed array:

```bash
servers=("web-01" "api-01" "db-01")

echo "First: ${servers[0]}"
echo "Count: ${#servers[@]}"

for server in "${servers[@]}"
do
    echo "Server: $server"
done
```

Associative array:

```bash
declare -A ports=(
    [http]=80
    [https]=443
)

echo "${ports[https]}"
```

Quote `"${array[@]}"` to preserve each element separately.

## 22. Text Processing

### grep

```bash
grep "ERROR" application.log
grep -i "warning" application.log
grep -c "ERROR" application.log
```

### cut

```bash
cut -d: -f1 /etc/passwd
```

### sort and uniq

```bash
sort names.txt
sort names.txt | uniq -c
```

### awk

```bash
awk -F, '{print $1, $3}' servers.csv
```

### sed

Preview a substitution:

```bash
sed 's/dev/test/g' app.conf
```

Write changes only after reviewing the command carefully.

## 23. Parameter Expansion

| Expansion | Meaning |
|---|---|
| `${name:-default}` | Use default if unset or empty |
| `${name:=default}` | Assign default if unset or empty |
| `${name:?message}` | Exit with message if unset or empty |
| `${#name}` | String length |
| `${file%.log}` | Remove shortest `.log` suffix |
| `${path##*/}` | Remove everything before final slash |

Rename preview:

```bash
for file in *.log
do
    [[ -e "$file" ]] || continue
    new_name="${file%.log}.txt"
    echo "Would rename: $file -> $new_name"
done
```

This is a dry run: it shows the planned change without performing it.

## 24. Processes and Jobs

```bash
ps
ps aux
pgrep bash
```

Run in background:

```bash
long_command &
```

Check shell jobs:

```bash
jobs
```

Wait for a background process:

```bash
wait "$pid"
```

Signals:

```bash
kill PID
kill -TERM PID
```

Prefer graceful `TERM` before considering stronger signals.

## 25. Input Validation

Validation is part of the script, not an optional extra.

Whole number:

```bash
if [[ ! "$value" =~ ^[0-9]+$ ]]; then
    echo "Error: enter a whole number" >&2
    exit 1
fi
```

Allowed environment:

```bash
case "$environment" in
    dev|test|stage|prod)
        ;;
    *)
        echo "Invalid environment" >&2
        exit 1
        ;;
esac
```

Regular file:

```bash
if [[ ! -f "$file" ]]; then
    echo "File not found: $file" >&2
    exit 1
fi
```

Validate before doing arithmetic, reading a file, or changing anything.

## 26. Error Handling

Fail clearly:

```bash
if ! cp -- "$source" "$destination"; then
    echo "Copy failed" >&2
    exit 1
fi
```

Guard clause:

```bash
if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 FILE" >&2
    exit 2
fi
```

Suggested status convention:

| Status | Meaning |
|---:|---|
| `0` | Success |
| `1` | General runtime failure |
| `2` | Usage or validation error |

Document any special statuses your script uses.

## 27. Safer Bash Options

Common strict-mode line:

```bash
set -Eeuo pipefail
```

- `-e`: exit on many unhandled failures.
- `-u`: error on unset variables.
- `-o pipefail`: a pipeline fails when any component fails.
- `-E`: allow `ERR` traps to be inherited in useful contexts.

These options help, but they do not replace validation and deliberate error
handling. Learn their exceptions before using them in important automation.

## 28. Traps and Cleanup

```bash
temporary_directory="$(mktemp -d)"

cleanup() {
    local status=$?
    rm -rf -- "$temporary_directory"
    exit "$status"
}

trap cleanup EXIT
```

For classroom labs, avoid destructive cleanup until the target is known and
validated. `mktemp -d` creates a unique temporary directory safely.

## 29. Debugging

Syntax check:

```bash
bash -n script.sh
```

Trace execution:

```bash
bash -x script.sh
```

Enable tracing inside a small section:

```bash
set -x
command
set +x
```

Do not trace secrets because expanded values may appear in logs.

Use ShellCheck when installed:

```bash
shellcheck script.sh
```

## 30. Security and Reliability

- Quote expansions: `"$variable"`.
- Put `--` before user-supplied path arguments where supported.
- Reject unexpected input.
- Never use `eval` with untrusted input.
- Avoid hard-coded passwords and tokens.
- Do not parse `ls`; use globs, `find`, or arrays.
- Avoid running an entire script with `sudo`.
- Use least privilege.
- Preview changes before applying them.
- Prefer idempotent behavior.

Idempotent means repeated runs reach the desired state without creating
unwanted extra changes.

## 31. Script Structure

```bash
#!/usr/bin/env bash

# Title: Example Automation
# Purpose: Demonstrate a maintainable layout
# Usage: ./example.sh INPUT

set -Eeuo pipefail

usage() {
    echo "Usage: $0 INPUT" >&2
}

main() {
    if [[ "$#" -ne 1 ]]; then
        usage
        return 2
    fi

    local input="$1"
    echo "Processing: $input"
}

main "$@"
```

For first-day scripts, a simple top-to-bottom layout is fine. Functions become
useful when scripts grow or repeat logic.

## 32. Testing Strategy

Test at least:

1. Normal valid input.
2. Missing input.
3. Invalid format.
4. Missing file or directory.
5. Empty file.
6. Command failure.
7. Names containing spaces.
8. A second run of the same script.

Syntax is only the first check:

```bash
bash -n script.sh
```

Also verify output and exit status:

```bash
./script.sh valid-input
echo "$?"
```

## 33. DevOps Automation Pattern

A reliable automation script usually follows this flow:

```text
Receive input
→ validate input
→ inspect current state
→ decide whether change is required
→ perform or preview the action
→ verify the result
→ report clearly
→ exit with a meaningful status
```

Example deployment gate:

```bash
if [[ "$environment" != "test" && "$environment" != "stage" ]]; then
    echo "Deployment blocked" >&2
    exit 1
fi

if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Invalid version" >&2
    exit 1
fi

echo "Deployment checks passed"
```

## 34. Common Mistakes

| Mistake | Correction |
|---|---|
| `#!bin/bash` | `#!/bin/bash` |
| `name = Ali` | `name="Ali"` |
| `$ user="Ali"` | `user="Ali"` |
| `[["$x" == yes]]` | `[[ "$x" == "yes" ]]` |
| `if [ condition ]` without `then` | Add `then` |
| Missing `fi` | Close the conditional |
| `for ...` without `done` | Close the loop |
| Unquoted `$file` | Use `"$file"` |
| Check `$?` after another command | Save it immediately |
| Echo success after a failed command | Connect success to the command's status |
| Hard-coded password | Use a secure secret-handling method |
| Real change without preview | Add a dry-run mode |

## 35. Final Checklist

Before sharing a script:

- [ ] Correct shebang.
- [ ] Purpose and usage comments.
- [ ] Variables are quoted.
- [ ] Argument count is checked.
- [ ] Values and paths are validated.
- [ ] Errors go to stderr.
- [ ] Failures return nonzero.
- [ ] Destructive targets are restricted.
- [ ] `bash -n` passes.
- [ ] Valid and invalid cases are tested.
- [ ] Repeated execution is understood.
- [ ] Secrets are not printed.

