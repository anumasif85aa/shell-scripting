#  Table of Contents

- [Task 1: Basics](#task-1-basics)
- [Task 2: Operators and Conditionals](#task-2-operators-and-conditionals)
- [Task 3: Loops](#task-3-loops)
- [Task 4: Functions](#task-4-functions)
- [Task 5: Text Processing Commands](#task-5-text-processing-commands)
- [Task 6: Useful Patterns and One-Liners](#task-6-useful-patterns-and-one-liners)
- [Task 7: Error Handling and Debugging](#task-7-error-handling-and-debugging)

#  Shell Scripting Cheat Sheet (Bash)
## Practical Bash reference for DevOps work — fast lookup, real examples, production-safe patterns.

---

## Ultra Quick Reference (Master Table)

| Topic | Key Syntax | Example | Description |
|---|---|---|---|
| Variable | `VAR="value"` | `NAME="DevOps"` | Creates `NAME` and stores the text `DevOps` in it. |
| Argument | `$1`, `$2` | `./script.sh arg1` | Runs `script.sh` and passes `arg1` as its first argument (`$1`). |
| If | `if [[ condition ]]; then` | `if [[ -f "$file" ]]; then` | Checks whether a regular file exists and runs the `then` block if it does. |
| For | `for i in list; do ...; done` | `for i in 1 2 3; do echo "$i"; done` | Loops through and prints `1`, `2`, and `3`. |
| Function | `name() { ...; }` | `greet() { echo "Hi"; }` | Defines `greet`; calling it prints `Hi`. |
| Grep | `grep pattern file` | `grep -i "error" log.txt` | Prints lines from `log.txt` containing `error`, ignoring letter case. |
| Awk | `awk -FDELIM '{print $N}' file` | `awk -F: '{print $1}' /etc/passwd` | Prints the username field before the first `:` on every `/etc/passwd` line. |
| Sed | `sed -i 's/old/new/g' file` | `sed -i 's/foo/bar/g' file` | Replaces every `foo` with `bar` directly inside `file`. |
| Strict Mode | `set -euo pipefail` | `set -euo pipefail` | Enables exit-on-error, unset-variable checks, and pipeline failure detection. |
| Debug | `bash -x script.sh` | `bash -x script.sh` | Runs `script.sh` and displays each expanded command before execution. |
| Cleanup | `trap 'cmd' EXIT` | `trap 'cleanup' EXIT` | Calls the `cleanup` function whenever the current shell exits. |

---

## Task 1: Basics

| Topic | Key Syntax | Example | Description |
|---|---|---|---|
| Shebang | `#!/bin/bash` | `#!/bin/bash` | Makes the operating system use Bash when this executable script is started directly. |
| Make Executable | `chmod +x file.sh` | `chmod +x script.sh` | Adds execute permission to `script.sh`. |
| Run Script | `./script.sh` | `./script.sh` | Runs the executable `script.sh` located in the current directory. |
| Comment | `command # comment` | `echo "Hi" # greeting` | Prints `Hi`; Bash ignores `# greeting`. |
| Variable | `VAR="value"` | `name="bhai"` | Creates `name` and stores the text `bhai` in it. |
| Read Input | `read var` | `read username` | Reads one input line and stores it in `username`. |
| Script Name | `$0` | `echo "$0"` | Prints the name or path used to start the current script. |
| First Argument | `$1` | `./script.sh file.txt` | Runs the script with `file.txt` available inside it as `$1`. |
| All Args | `"$@"` | `for arg in "$@"; do echo "$arg"; done` | Loops through and prints every argument while preserving spaces. |
| Exit Code | `$?` | `echo "$?"` | Prints the exit status of the most recently executed command. |

---

## Task 2: Operators and Conditionals

| Topic | Key Syntax | Example | Description |
|---|---|---|---|
| String Equal | `[[ "$a" = "$b" ]]` | `[[ "$env" = "prod" ]]` | Returns success when `env` contains exactly `prod`. |
| Empty | `-z` | `[[ -z "$var" ]]` | Returns success when `var` is empty. |
| Integer Equal | `-eq` | `[[ "$a" -eq 5 ]]` | Returns success when integer `a` equals `5`. |
| Greater Than | `-gt` | `[[ "$a" -gt 10 ]]` | Returns success when integer `a` is greater than `10`. |
| File Exists | `-f` | `[[ -f file.txt ]]` | Returns success when `file.txt` exists and is a regular file. |
| Directory | `-d` | `[[ -d /etc ]]` | Returns success because `/etc` exists and is a directory. |
| AND | `&&` | `[[ -f file ]] && echo OK` | Prints `OK` only when `file` exists as a regular file. |
| OR | `\|\|` | `[[ -f file ]] \|\| echo Missing` | Prints `Missing` only when `file` is not a regular file. |
| NOT | `!` | `if ! [[ -f file ]]; then echo Missing; fi` | Prints `Missing` when `file` is not a regular file. |
| Case | `case var in` | `case "$1" in start) echo "Starting";; esac` | Prints `Starting` when the first argument is `start`. |

---

## Task 3: Loops

| Topic | Key Syntax | Example | Description |
|---|---|---|---|
| For List | `for i in list; do ...; done` | `for i in 1 2 3; do echo "$i"; done` | Loops through and prints `1`, `2`, and `3`. |
| For C-Style | `for ((init; test; update)); do ...; done` | `for ((i=0;i<5;i++)); do echo "$i"; done` | Prints `0` through `4`, increasing `i` after each iteration. |
| While | `while condition; do ...; done` | `while (( x < 5 )); do echo "$x"; ((x++)); done` | Prints and increments `x` repeatedly while it is less than `5`. |
| Until | `until condition; do ...; done` | `until (( x > 5 )); do echo "$x"; ((x++)); done` | Prints and increments `x` until its value becomes greater than `5`. |
| Break | `break` | `[[ $i -eq 3 ]] && break` | Exits the current loop immediately when `i` equals `3`. |
| Continue | `continue` | `[[ $i -eq 3 ]] && continue` | Skips the remaining commands in the iteration when `i` equals `3`. |
| Files | `for f in pattern; do ...; done` | `for f in *.log; do echo "$f"; done` | Prints every filename in the current directory that ends with `.log`. |
| Read File | `while IFS= read -r line; do ...; done` | `while IFS= read -r line; do echo "$line"; done < file.txt` | Reads `file.txt` safely and prints it one line at a time. |

---

## Task 4: Functions

| Topic | Key Syntax | Example | Description |
|---|---|---|---|
| Define | `name() { ...; }` | `greet() { echo "Hi"; }` | Defines `greet`; calling it prints `Hi`. |
| Call | `name` | `greet` | Calls `greet` and runs the commands defined inside it. |
| Args | `$1`, `$2` | `add() { echo $(( $1+$2 )); }` | Defines `add` to print the sum of its first two arguments. |
| Return Status | `return N` | `return 0` | Stops the current function and reports successful status `0`. |
| Return Data | `echo value` | `result=$(func)` | Calls `func` and stores its printed output in `result`. |
| Local Var | `local var` | `local temp="x"` | Creates `temp` with value `x`, visible only within the current function scope. |

---

## Task 5: Text Processing Commands

| Command | Key Syntax | Example | Description |
|---|---|---|---|
| grep | `grep [options] pattern file` | `grep -i "error" file` | Prints lines in `file` containing `error`, ignoring letter case. |
| awk | `awk -FDELIM '{print $N}' file` | `awk -F: '{print $1}' file` | Splits every line in `file` on `:` and prints the first field. |
| sed | `sed -i 's/old/new/g' file` | `sed -i 's/a/b/g' file` | Replaces every `a` with `b` directly inside `file`. |
| cut | `cut -dDELIM -fN file` | `cut -d, -f2 file.csv` | Splits each `file.csv` line on commas and prints the second field. |
| sort | `sort [options] file` | `sort -nr file` | Prints numeric lines in `file` from largest to smallest. |
| uniq | `sort file \| uniq -c` | `sort file \| uniq -c` | Sorts `file` and prints each unique line with its occurrence count. |
| tr | `tr SET1 SET2` | `tr 'a-z' 'A-Z'` | Converts lowercase input letters to uppercase. |
| wc | `wc [options] file` | `wc -l file` | Prints the number of lines in `file`. |
| head | `head -n N file` | `head -n 20 file` | Prints the first `20` lines of `file`. |
| tail | `tail [options] file` | `tail -f app.log` | Displays existing final lines and then prints new lines appended to `app.log`. |

---

## Task 6: Useful Patterns and One-Liners

| Task | Key Syntax | Example | Description |
|---|---|---|---|
| Delete old logs | `find PATH -mtime +N -delete` | `find . -type f -name "*.log" -mtime +7 -delete` | Permanently deletes regular `.log` files under the current directory modified more than seven days ago. |
| Count log lines | `cat files \| wc -l` | `cat *.log \| wc -l` | Prints the total number of lines across all matching `.log` files. |
| Replace in files | `sed -i 's/old/new/g' files` | `sed -i 's/foo/bar/g' *.conf` | Replaces every `foo` with `bar` directly in all matching `.conf` files. |
| Check service | `pgrep -x name` | `pgrep -x nginx` | Prints process IDs when a process named exactly `nginx` is running. |
| Disk alert | `df -h \| awk 'condition'` | `df -h \| awk '$5+0>80{print}'` | Prints filesystem rows whose used percentage is greater than `80`. |
| Parse JSON | `jq 'filter' file` | `jq '.name' file.json` | Prints the value of the top-level `name` property in `file.json`. |
| Tail errors live | `tail -f file \| grep pattern` | `tail -f app.log \| grep --line-buffered ERROR` | Follows `app.log` and immediately prints newly seen lines containing `ERROR`. |

---

## Task 7: Error Handling and Debugging

| Topic | Key Syntax | Example | Description |
|---|---|---|---|
| Exit Success | `exit 0` | `exit 0` | Stops the script and reports successful status `0` to its caller. |
| Exit Fail | `exit 1` | `exit 1` | Stops the script and reports failure status `1` to its caller. |
| Last Status | `$?` | `echo "$?"` | Prints the exit status returned by the immediately preceding command. |
| Exit on Error | `set -e` | `set -e` | Enables Bash's exit-on-unhandled-error behavior for subsequent commands, subject to exceptions. |
| Unset Error | `set -u` | `set -u` | Makes a later expansion of an unset variable produce an error. |
| Pipe Fail | `set -o pipefail` | `set -o pipefail` | Makes later pipelines return failure when any command in the pipeline fails. |
| Strict Mode | `set -euo pipefail` | `set -euo pipefail` | Enables exit-on-error, unset-variable checks, and pipeline failure detection. |
| Debug | `bash -x script.sh` | `bash -x script.sh` | Runs `script.sh` and prints each expanded command before execution. |
| Trap Exit | `trap 'cmd' EXIT` | `trap 'cleanup' EXIT` | Calls the `cleanup` function whenever the current shell exits. |

---
