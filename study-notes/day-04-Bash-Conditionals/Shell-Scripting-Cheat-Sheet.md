#  Table of Contents

- [Task 1: Basics](#task-1-basics)
- [Task 2: Operators and Conditionals](#task-2-operators-and-conditionals)
- [Task 3: Loops](#task-3-loops)
- [Task 4: Functions](#task-4-functions)
- [Task 5: Text Processing Commands](#task-5-text-processing-commands)
- [Task 6: Useful Patterns and One-Liners](#task-6-useful-patterns-and-one-liners)
- [Task 7: Error Handling and Debugging](#task-7-error-handling-and-debugging)

# Shell Scripting Quick Reference

| Topic | Key Syntax | Example | Description |
|---|---|---|---|
| Variable | `VAR="value"` | `NAME="DevOps"` | Creates `NAME` and stores the text `DevOps` in it. |
| Argument | `$1`, `$2` | `./script.sh arg1` | Runs `script.sh` and passes `arg1` as its first argument (`$1`). |
| If | `if [[ condition ]]; then` | `if [[ -f "$file" ]]; then` | Checks whether a regular file exists and runs the `then` block if it does. |
| For loop | `for i in list; do ...; done` | `for i in 1 2 3; do echo "$i"; done` | Loops through and prints `1`, `2`, and `3`. |
| Function | `name() { ...; }` | `greet() { echo "Hi"; }` | Defines `greet`; calling it prints `Hi`. |
| Grep | `grep pattern file` | `grep -i "error" log.txt` | Prints lines from `log.txt` containing `error`, ignoring letter case. |
| Awk | `awk -FDELIM '{print $N}' file` | `awk -F: '{print $1}' /etc/passwd` | Prints the username field before the first `:` on every `/etc/passwd` line. |
| Sed | `sed -i 's/old/new/g' file` | `sed -i 's/foo/bar/g' config.txt` | Replaces every `foo` with `bar` directly inside `config.txt`. |
| While loop | `while condition; do ...; done` | `while IFS= read -r line; do echo "$line"; done < file.txt` | Reads `file.txt` line by line and prints every line. |
| Case | `case value in pattern) ...;; esac` | `case "$1" in start) echo "Starting";; esac` | Prints `Starting` when the first argument is `start`. |
| Exit code | `exit N` | `exit 1` | Stops the script and returns failure status `1`. |
| Debug | `bash -x script.sh` | `bash -x script.sh` | Runs `script.sh` and displays each expanded command before execution. |
| Strict mode | `set -euo pipefail` | `set -euo pipefail` | Enables exit-on-error, unset-variable checks, and pipeline failure detection. |

---



## Task 1: Basics
### Basics — Quick Reference Table

| Topic | Key Syntax | Example | Description |
|---|---|---|---|
| Shebang | `#!/bin/bash` | `#!/bin/bash` | Makes the operating system use Bash when this executable script is started directly. |
| Make Executable | `chmod +x file.sh` | `chmod +x script.sh` | Adds execute permission to `script.sh`. |
| Run Script | `./script.sh` | `./script.sh` | Runs the executable `script.sh` located in the current directory. |
| Run with Bash | `bash script.sh` | `bash script.sh` | Starts `script.sh` with Bash even if the file is not executable. |
| Comment | `# comment` | `# This is a comment` | Adds a note that Bash ignores during execution. |
| Inline Comment | `command # comment` | `echo "Hi" # greeting` | Prints `Hi`; Bash ignores `# greeting`. |
| Variable | `VAR="value"` | `name="bhai"` | Creates `name` and stores the text `bhai` in it. |
| Use Variable | `$VAR` | `echo "$name"` | Prints the value currently stored in `name`. |
| Single Quotes | `'text'` | `echo '$name'` | Prints the literal text `$name` instead of its value. |
| Read Input | `read var` | `read username` | Reads one input line and stores it in `username`. |
| Read with Prompt | `read -p "msg" var` | `read -p "Name: " user` | Shows `Name: ` and stores the entered text in `user`. |
| Script Name | `$0` | `echo "$0"` | Prints the name or path used to start the current script. |
| First Argument | `$1` | `./script.sh file.txt` | Runs the script with `file.txt` available inside it as `$1`. |
| Argument Count | `$#` | `echo "$#"` | Prints how many command-line arguments were passed to the script. |
| All Arguments | `"$@"` | `for arg in "$@"; do echo "$arg"; done` | Loops through and prints every argument while preserving spaces. |
| Exit Status | `$?` | `echo "$?"` | Prints the exit status of the most recently executed command. |

---

### Shebang (#!/bin/bash)

Defines which interpreter should run the script.

```bash
#!/bin/bash
```
Without it, the script may run with the wrong shell.

---

### Running a Script

Make executable:
```bash
chmod +x script.sh
```
Run directly:
```bash
./script.sh
```
Run with bash explicitly:
```bash
bash script.sh
```

---

### Comments
Single-line comment:
```bash
# This is a comment
```
Inline comment:
```bash
echo "Hello"  # Print greeting
```
---

### Variables
Declare variable (no spaces):
```bash
name="khalid"
```
Use variable:
```bash
echo $name
```
Always prefer quoting:
```bash
echo "$name"
```
Single quotes prevent expansion:
```bash
echo '$name'   # Prints literally: $name
```
---

Reading User Input

Basic read:
```bash
read username
```
Prompt while reading:
```bash
read -p "Enter your name: " username
```
Read password silently:
```bash
read -sp "Password: " pass; echo
```

---

### Command-Line Arguments
```bash
echo "$0"   # Script name
echo "$1"   # First argument
echo "$#"   # Number of arguments
echo "$@"   # All arguments (safe for loops)
echo "$?"   # Exit status of last command
```
Examples:
```bash
./script.sh file.txt

echo "Script: $0"
echo "File: $1"
```
Loop through arguments safely:
```bash
for arg in "$@"; do
  echo "$arg"
done
```

## Task 2: Operators and Conditionals
### Operators and Conditionals — Quick Reference Table

| Topic | Key Syntax | Example | Description |
|---|---|---|---|
| String Equal | `[[ "$a" = "$b" ]]` | `[[ "$env" = "prod" ]]` | Returns success when `env` contains exactly `prod`. |
| String Not Equal | `[[ "$a" != "$b" ]]` | `[[ "$user" != "root" ]]` | Returns success when `user` does not contain `root`. |
| Empty String | `[[ -z "$var" ]]` | `[[ -z "$name" ]]` | Returns success when `name` is empty. |
| Not Empty | `[[ -n "$var" ]]` | `[[ -n "$name" ]]` | Returns success when `name` contains at least one character. |
| Equal (int) | `-eq` | `[[ "$a" -eq 5 ]]` | Returns success when integer `a` equals `5`. |
| Not Equal (int) | `-ne` | `[[ "$a" -ne 5 ]]` | Returns success when integer `a` is not equal to `5`. |
| Less Than | `-lt` | `[[ "$a" -lt 10 ]]` | Returns success when integer `a` is less than `10`. |
| Greater Than | `-gt` | `[[ "$a" -gt 10 ]]` | Returns success when integer `a` is greater than `10`. |
| Less or Equal | `-le` | `[[ "$a" -le 10 ]]` | Returns success when integer `a` is less than or equal to `10`. |
| Greater or Equal | `-ge` | `[[ "$a" -ge 10 ]]` | Returns success when integer `a` is greater than or equal to `10`. |
| File Exists | `-e` | `[[ -e file.txt ]]` | Returns success when `file.txt` exists as any filesystem object. |
| Regular File | `-f` | `[[ -f file.txt ]]` | Returns success when `file.txt` exists and is a regular file. |
| Directory | `-d` | `[[ -d /etc ]]` | Returns success because `/etc` exists and is a directory. |
| Readable | `-r` | `[[ -r file.txt ]]` | Returns success when the current user can read `file.txt`. |
| Writable | `-w` | `[[ -w file.txt ]]` | Returns success when the current user can write to `file.txt`. |
| Executable | `-x` | `[[ -x script.sh ]]` | Returns success when the current user can execute `script.sh`. |
| Not Empty File | `-s` | `[[ -s file.txt ]]` | Returns success when `file.txt` exists and contains data. |
| If Statement | `if ...; then` | `if [[ -f "$file" ]]; then echo "Exists"; fi` | Prints `Exists` when the path stored in `file` is a regular file. |
| Else If | `elif` | `elif [[ "$env" = "dev" ]]; then echo "Development"` | Prints `Development` when earlier conditions failed and `env` equals `dev`. |
| Else | `else` | `else echo "Unknown"` | Prints `Unknown` when every preceding `if` or `elif` condition failed. |
| Logical AND | `&&` | `[[ -f file ]] && echo "Exists"` | Prints `Exists` only when `file` exists as a regular file. |
| Logical OR | `\|\|` | `[[ -f file ]] \|\| echo "Missing"` | Prints `Missing` only when `file` is not a regular file. |
| Logical NOT | `!` | `if ! [[ -f file ]]; then echo "Missing"; fi` | Prints `Missing` when `file` is not a regular file. |
| Case Statement | `case var in` | `case "$1" in start) echo "Starting";; esac` | Prints `Starting` when the first argument is `start`. |

---

### String Comparisons

Use `[[ ... ]]` for safer Bash comparisons.

Equal / Not equal:

```bash
if [[ "$a" = "$b" ]]; then echo "Equal"; fi
if [[ "$a" != "$b" ]]; then echo "Not equal"; fi
```
Empty / Not empty:
```bash
[[ -z "$var" ]] && echo "Empty"
[[ -n "$var" ]] && echo "Not empty"
```
---

Integer Comparisons
```bash
[[ "$a" -eq "$b" ]]  # equal
[[ "$a" -ne "$b" ]]  # not equal
[[ "$a" -lt "$b" ]]  # less than
[[ "$a" -gt "$b" ]]  # greater than
[[ "$a" -le "$b" ]]  # less or equal
[[ "$a" -ge "$b" ]]  # greater or equal
```
Example:
```bash
if [[ "$count" -gt 10 ]]; then
  echo "Count is greater than 10"
fi
```
---

File Test Operators
```bash
[[ -f file.txt ]]   # regular file exists
[[ -d dir/ ]]       # directory exists
[[ -e path ]]       # file or directory exists
[[ -r file ]]       # readable
[[ -w file ]]       # writable
[[ -x file ]]       # executable
[[ -s file ]]       # not empty
```
Example:
```bash
if [[ -f "$config" && -s "$config" ]]; then
  echo "Config file exists and is not empty"
fi
```
---

if / elif / else Syntax
```bash
if [[ "$env" = "prod" ]]; then
  echo "Production"
elif [[ "$env" = "dev" ]]; then
  echo "Development"
else
  echo "Unknown environment"
fi
```
---

### Logical Operators

AND (&&) — run next if previous succeeds:
```bash
[[ -f file.txt ]] && echo "File exists"
```
OR (||) — run next if previous fails:
```bash
[[ -f file.txt ]] || echo "File missing"
```
NOT (!) — negate condition:
```bash
if ! [[ -f file.txt ]]; then
  echo "File not found"
fi
```
Combine conditions:
```bash
if [[ -f file.txt && -r file.txt ]]; then
  echo "File exists and is readable"
fi
```
---

### Case Statement
Clean alternative to multiple `if` statements.
```bash
case "$1" in
  start)
    echo "Starting service"
    ;;
  stop)
    echo "Stopping service"
    ;;
  restart)
    echo "Restarting service"
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    ;;
esac
```

---


## Task 3: Loops
### Loops — Quick Reference Table

| Topic | Key Syntax | Example | Description |
|---|---|---|---|
| For (List) | `for i in list; do ...; done` | `for i in 1 2 3; do echo "$i"; done` | Loops through and prints `1`, `2`, and `3`. |
| For (Range) | `{START..END}` | `for i in {1..5}; do echo "$i"; done` | Generates and prints the numbers `1` through `5`. |
| For (C-Style) | `for ((init; test; update)); do ...; done` | `for ((i=0; i<5; i++)); do echo "$i"; done` | Prints `0` through `4`, increasing `i` by one after each iteration. |
| While Loop | `while condition; do ...; done` | `while (( x < 5 )); do echo "$x"; ((x++)); done` | Prints `x` and increments it repeatedly while it is less than `5`. |
| Until Loop | `until condition; do ...; done` | `until (( x > 5 )); do echo "$x"; ((x++)); done` | Prints and increments `x` until its value becomes greater than `5`. |
| Break | `break` | `[[ "$i" -eq 3 ]] && break` | Exits the current loop immediately when `i` equals `3`. |
| Continue | `continue` | `[[ "$i" -eq 3 ]] && continue` | Skips the remaining commands in the iteration when `i` equals `3`. |
| Loop Files | `for f in pattern; do ...; done` | `for f in *.log; do echo "$f"; done` | Prints every filename in the current directory that ends with `.log`. |
| Read File Line-by-Line | `while IFS= read -r line; do ...; done` | `while IFS= read -r line; do echo "$line"; done < file.txt` | Reads `file.txt` safely and prints it one line at a time. |
| Loop Command Output | `command \| while IFS= read -r line` | `ps aux \| while IFS= read -r line; do echo "$line"; done` | Reads and prints every line produced by `ps aux`. |

---

### for Loop (List-Based)

Iterate over a list of values.

```bash
for item in apple banana mango; do
  echo "$item"
done
```
Using brace expansion:
```bash
for i in {1..5}; do
  echo "$i"
done
```
---

### for Loop (C-Style)
Useful for counters and numeric logic.
```bash
for ((i=0; i<5; i++)); do
  echo "Index: $i"
done
```
---

### while Loop
Runs while condition is true.
```bash
count=1
while [[ "$count" -le 3 ]]; do
  echo "Count: $count"
  ((count++))
done
```
---

### until Loop
Runs until condition becomes true (opposite of while).
```bash
count=1
until [[ "$count" -gt 3 ]]; do
  echo "Count: $count"
  ((count++))
done
```
Common real-world pattern (wait for service):
```bash
until ping -c1 8.8.8.8 &>/dev/null; do
  sleep 2
done
```
---
### Loop Control
break — exit loop early:
```bash
for i in {1..5}; do
  [[ "$i" -eq 3 ]] && break
  echo "$i"
done
```
continue — skip current iteration:
```bash
for i in {1..5}; do
  [[ "$i" -eq 3 ]] && continue
  echo "$i"
done
```
---

### Looping Over Files
Iterate over matching files:
```bash
for file in *.log; do
  echo "Processing $file"
done
```
Safer globbing (avoid literal *.log):
```bash
shopt -s nullglob
for file in *.log; do
  echo "$file"
done
```
---

### Looping Over Command Output
Preferred safe pattern:
```bash
while IFS= read -r line; do
  echo "Line: $line"
done < file.txt
```
From command output:
```bash
command | while IFS= read -r line; do
  echo "$line"
done
```
Example with ps:
```bash
ps aux | while IFS= read -r line; do
  echo "$line"
done
```
## Task 4: Functions
### Functions — Quick Reference Table

| Topic | Key Syntax | Example | Description |
|---|---|---|---|
| Define Function | `name() { ...; }` | `greet() { echo "Hi"; }` | Defines a function named `greet` that prints `Hi` when called. |
| Call Function | `name` | `greet` | Calls `greet` and runs the commands defined inside it. |
| Function Argument | `$1`, `$2` | `add() { echo $(( $1 + $2 )); }` | Defines `add` to print the sum of its first two arguments. |
| Return Status | `return N` | `return 0` | Stops the current function and reports successful status `0`. |
| Capture Exit Code | `$?` | `check_file; echo "$?"` | Calls `check_file` and prints the status it returns. |
| Return Data | `echo value` | `result=$(multiply 2 3)` | Calls `multiply 2 3` and stores its printed output in `result`. |
| Local Variable | `local var="value"` | `local temp="inside"` | Creates `temp` with value `inside`, visible only within the current function scope. |
| Multiple Args | `"$@"` | `for arg in "$@"; do echo "$arg"; done` | Loops through and prints every function argument while preserving spaces. |

---

### Defining a Function

Basic syntax:

```bash
greet() {
  echo "Hello!"
}
```
Functions group reusable logic into blocks.
### Calling a Function
Just use its name:
```bash
greet
```
Example:
```bash
log() {
  echo "[INFO] $1"
}

log "Server started"
```
---

### Passing Arguments to Functions
Arguments are accessed using $1, $2, etc.
```bash
add() {
  echo $(( $1 + $2 ))
}

add 3 5
```
Example with multiple args:
```bash
deploy() {
  echo "Deploying to environment: $1"
}

deploy prod
```
---

### Return Values — return vs echo
`return` sets exit status (0–255 only):
```bash
check() {
  [[ -f "$1" ]] && return 0 || return 1
}

check file.txt
echo $?   # prints function exit status
```
`echo` returns actual data:
```bash
multiply() {
  echo $(( $1 * $2 ))
}

result="$(multiply 4 5)"
echo "$result"
```
Use `return` for status, `echo` for data.

---

### Local Variables
Use `local` to limit variable scope inside function.
```bash
example() {
  local temp="inside"
  echo "$temp"
}

example
```
Prevents variable conflicts with global scope.

---

## Task 5 Text Processing Commands
### Text Processing — Quick Reference Table

| Command | Key Syntax | Example | Description |
|---|---|---|---|
| grep | `grep pattern file` | `grep -i "error" app.log` | Prints lines in `app.log` containing `error`, ignoring letter case. |
| grep (recursive) | `grep -r pattern dir` | `grep -r "TODO" .` | Searches the current directory and its subdirectories for lines containing `TODO`. |
| grep (count) | `grep -c pattern file` | `grep -c "error" app.log` | Prints how many lines in `app.log` contain `error`. |
| awk | `awk '{print $N}' file` | `awk '{print $1,$3}' file.txt` | Prints the first and third whitespace-separated fields from every `file.txt` line. |
| awk (delimiter) | `awk -FDELIM '{print $N}' file` | `awk -F: '{print $1}' /etc/passwd` | Splits `/etc/passwd` on `:` and prints each username field. |
| awk (pattern) | `awk '/pattern/ {action}' file` | `awk '/error/ {print $1}' app.log` | Prints the first field from each `app.log` line containing `error`. |
| sed (replace) | `sed -i 's/old/new/g' file` | `sed -i 's/foo/bar/g' config.txt` | Replaces every `foo` with `bar` directly inside `config.txt`. |
| sed (delete) | `sed '/pattern/d' file` | `sed '/error/d' app.log` | Prints `app.log` while omitting every line containing `error`; the file is unchanged. |
| cut (delimiter) | `cut -dDELIM -fN file` | `cut -d, -f2 data.csv` | Splits each `data.csv` line on commas and prints the second field. |
| cut (chars) | `cut -cSTART-END file` | `cut -c1-10 file.txt` | Prints characters `1` through `10` from every line of `file.txt`. |
| sort | `sort file` | `sort names.txt` | Prints the lines of `names.txt` in ascending text order. |
| sort (numeric) | `sort -n file` | `sort -n numbers.txt` | Prints the lines of `numbers.txt` in ascending numeric order. |
| sort (reverse) | `sort -nr file` | `sort -nr numbers.txt` | Prints the numbers in `numbers.txt` from largest to smallest. |
| uniq | `sort file \| uniq` | `sort file.txt \| uniq` | Sorts `file.txt` and prints one copy of each duplicate line. |
| uniq (count) | `sort file \| uniq -c` | `sort file.txt \| uniq -c` | Sorts `file.txt` and prints each unique line with its occurrence count. |
| tr | `tr SET1 SET2 < file` | `tr ' ' '_' < file.txt` | Prints `file.txt` with every space changed to an underscore. |
| wc | `wc -l file` | `wc -l app.log` | Prints the number of lines in `app.log`. |
| head | `head -n N file` | `head -n 20 file.txt` | Prints the first `20` lines of `file.txt`. |
| tail | `tail -n N file` | `tail -n 50 app.log` | Prints the last `50` lines of `app.log`. |
| tail (follow) | `tail -f file` | `tail -f app.log` | Displays existing final lines and then prints new lines appended to `app.log`. |

---

### grep — Search Patterns

Basic search:

```bash
grep "error" app.log
```
Common flags:

```bash
grep -i "error" file.txt     # case-insensitive
grep -r "TODO" .             # recursive search
grep -c "error" file.txt     # count matches
grep -n "error" file.txt     # show line numbers
grep -v "debug" file.txt     # invert match
grep -E "error|fail" file.txt # extended regex
```
---

### awk — Pattern Scanning & Columns
Print columns:
```bash
awk '{print $1}' file.txt
awk '{print $1, $3}' file.txt
```
Set field separator:
```bash
awk -F: '{print $1}' /etc/passwd
awk -F, '{print $2}' data.csv
```
Pattern matching:
```bash
awk '/error/ {print $1}' app.log
```
---

### sed — Stream Editor
Substitute text:
```bash
sed 's/old/new/' file.txt
sed 's/old/new/g' file.txt   # global replace
```
Delete lines:
```bash
sed '2d' file.txt            # delete line 2
sed '/error/d' file.txt      # delete lines matching pattern
```
In-place edit:
```bash
sed -i 's/old/new/g' file.txt
```
---
### cut — Extract Columns
By delimiter:
```bash
cut -d: -f1 /etc/passwd
cut -d, -f2 data.csv
```
By character position:
```bash
cut -c1-5 file.txt
```
---

### sort — Sort Lines
Alphabetical (default):
```bash
sort file.txt
```
Numerical:
```bash
sort -n numbers.txt
```
Reverse:
```bash
sort -r file.txt
```
Unique sort:
```bash
sort -u file.txt
```
---

### uniq — Remove Duplicates
Remove consecutive duplicates:
```bash
uniq file.txt
```
Count occurrences:
```bash
uniq -c file.txt
```
Common pattern:
```bash
sort file.txt | uniq -c | sort -nr
```
---

### tr — Translate / Delete Characters
Lowercase to uppercase:
```bash
tr 'a-z' 'A-Z' < file.txt
```
Delete characters:
```bash
tr -d '\r' < file.txt
```
Replace spaces with underscores:
```bash
echo "hello world" | tr ' ' '_'
```
---

### wc — Count Lines / Words / Characters
```bash
wc file.txt          # lines, words, bytes
wc -l file.txt       # lines only
wc -w file.txt       # words only
wc -c file.txt       # bytes/characters
```
---

### head / tail — View File Portions
First 10 lines (default):
```bash
head file.txt
```
First N lines:
```bash
head -n 20 file.txt
```
Last 10 lines:
```bash
tail file.txt
```
Follow log file (live):
```bash
tail -f app.log
```
Last N lines:
```bash
tail -n 50 app.log
```
## Task 6: Useful Patterns and One-Liners
### Useful Patterns & One-Liners — Quick Reference Table

| Task | Key Syntax | Example | Description |
|---|---|---|---|
| Delete old files | `find PATH -mtime +N -delete` | `find /var/log -type f -name "*.log" -mtime +7 -delete` | Permanently deletes regular `.log` files under `/var/log` modified more than seven days ago. |
| Preview old files | `find PATH -mtime +N -print` | `find . -type f -mtime +30 -print` | Lists regular files under the current directory modified more than 30 days ago. |
| Count lines in logs | `cat files \| wc -l` | `cat *.log \| wc -l` | Prints the total number of lines across all matching `.log` files. |
| Replace in many files | `sed -i 's/old/new/g' files` | `sed -i 's/foo/bar/g' *.conf` | Replaces every `foo` with `bar` directly in all matching `.conf` files. |
| Recursive replace | `grep -rl pattern PATH \| xargs sed -i` | `grep -rl "localhost" . \| xargs sed -i 's/localhost/127.0.0.1/g'` | Finds files under the current directory containing `localhost` and replaces it with `127.0.0.1`. |
| Check service running | `pgrep -x name` | `pgrep -x nginx` | Prints process IDs when a process named exactly `nginx` is running. |
| Check service (systemd) | `systemctl is-active service` | `systemctl is-active nginx` | Prints the current active state of the `nginx` systemd service. |
| Disk usage alert | `df -h \| awk 'condition'` | `df -h \| awk '$5+0 > 80 {print}'` | Prints filesystem rows whose used percentage is greater than `80`. |
| Parse CSV | `awk -F, '{print $N}' file` | `awk -F, '{print $2}' data.csv` | Splits each `data.csv` line on commas and prints the second field. |
| Parse JSON | `jq 'filter' file` | `jq '.name' file.json` | Prints the value of the top-level `name` property in `file.json`. |
| Tail & filter errors | `tail -f file \| grep pattern` | `tail -f app.log \| grep --line-buffered ERROR` | Follows `app.log` and immediately prints newly seen lines containing `ERROR`. |
| Retry command | `for ...; command && break; done` | `for i in {1..5}; do curl -fsS URL && break; done` | Tries the `curl` request up to five times and stops after the first success. |
| Check command exists | `command -v name` | `command -v docker \|\| exit 1` | Prints Docker's resolved command path, or exits with status `1` when Docker is unavailable. |
| Find large files | `find PATH -type f -size +N` | `find / -type f -size +100M 2>/dev/null` | Lists regular files larger than `100 MiB` and hides permission-denied errors. |

---
---

### Find and Delete Files Older Than N Days

Delete `.log` files older than 7 days:

```bash
find /var/log -type f -name "*.log" -mtime +7 -delete
```
---
### Count Lines in All .log Files
Total lines across all `.log` files:
```bash
cat *.log | wc -l
```
Safer version (handles many files):
```bash
find . -name "*.log" -exec cat {} + | wc -l
```
---
### Replace a String Across Multiple Files
Replace `localhost` with `127.0.0.1` in all .conf files:
```bash
sed -i 's/localhost/127.0.0.1/g' *.conf
```
Recursive replace:
```bash
grep -rl "localhost" . | xargs sed -i 's/localhost/127.0.0.1/g'
```
---
### Check If a Service Is Running
Using `pgrep`:
```bash
pgrep -x nginx >/dev/null && echo "Running" || echo "Stopped"
```
Using systemctl:
```bash
systemctl is-active --quiet nginx && echo "Active"
```
---

### Monitor Disk Usage with Alert
Alert if disk usage > 80%:
```bash
df -h | awk '$5+0 > 80 {print "High usage:", $0}'
```
Script-style check:
```bash
usage=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
[[ "$usage" -gt 80 ]] && echo "Disk usage critical: $usage%"
```
---

### Parse CSV from Command Line
Print second column from CSV:
```bash
awk -F, '{print $2}' data.csv
```
Skip header row:
```bash
awk -F, 'NR>1 {print $1, $3}' data.csv
```
---

### Parse JSON from Command Line (jq)
Extract field:
```bash
jq '.name' file.json
```
Extract nested value:
```bash
jq '.user.email' file.json
```
From API response:
```bash
curl -s https://api.example.com | jq '.status'
```
---

### Tail Log and Filter Errors in Real Time
Show only ERROR lines:
```bash
tail -f app.log | grep --line-buffered "ERROR"
```
Case-insensitive filter:
```bash
tail -f app.log | grep -i --line-buffered "fail"
```
---

### Retry Command Until Success
Retry up to 5 times:
```bash
for i in {1..5}; do
  curl -fsS https://example.com && break
  sleep 2
done
```
---

### Check If Command Exists
Ensure required tool is installed:
```bash
command -v docker >/dev/null || { echo "Docker not installed"; exit 1; }
```
---
### Top 10 Memory-Consuming Processes
```bash
ps aux --sort=-%mem | head -10
```
---
### Find Large Files (>100MB)
```bash
find / -type f -size +100M 2>/dev/null
```
---

## Task 7: Error Handling and Debugging
### Error Handling & Debugging — Quick Reference Table

| Topic | Key Syntax | Example | Description |
|---|---|---|---|
| Exit Success | `exit 0` | `exit 0` | Stops the script and reports successful status `0` to its caller. |
| Exit Failure | `exit 1` | `exit 1` | Stops the script and reports failure status `1` to its caller. |
| Last Exit Code | `$?` | `echo "$?"` | Prints the exit status returned by the immediately preceding command. |
| Exit on Error | `set -e` | `set -e` | Enables Bash's exit-on-unhandled-error behavior for subsequent commands, subject to exceptions. |
| Unset Variable Error | `set -u` | `set -u` | Makes a later expansion of an unset variable produce an error. |
| Pipe Failure Detection | `set -o pipefail` | `set -o pipefail` | Makes later pipelines return failure when any command in the pipeline fails. |
| Strict Mode | `set -euo pipefail` | `set -euo pipefail` | Enables exit-on-error, unset-variable checks, and pipeline failure detection. |
| Debug Mode | `bash -x script.sh` | `bash -x script.sh` | Runs `script.sh` and prints each expanded command before execution. |
| Disable Debug | `set +x` | `set +x` | Disables command tracing from this point onward in the current shell. |
| Trap on Exit | `trap 'cmd' EXIT` | `trap 'cleanup' EXIT` | Calls the `cleanup` function whenever the current shell exits. |
| Trap Ctrl+C | `trap 'cmd' INT` | `trap 'echo "Stopped"' INT` | Prints `Stopped` when the script receives the Ctrl+C interrupt signal. |
| Cleanup Temp File | `tmp=$(mktemp); trap ... EXIT` | `tmp=$(mktemp); trap 'rm -f "$tmp"' EXIT` | Creates a temporary file and automatically removes it when the script exits. |

---

### Exit Codes

Every command returns an exit status.

```bash
echo $?
```
`0`= success

Non-zero = failure

Manually exit:
```bash
exit 0   # success
exit 1   # generic error
```
Example:
```bash
if [[ ! -f config.txt ]]; then
  echo "Config missing"
  exit 1
fi
```
---
### set -e — Exit on Error
Exit immediately if a command fails.
```bash
set -e
```
Example:
```bash
set -e
cp file.txt /backup/
echo "Copy successful"
```
If `cp` fails, script stops immediately.
---

### set -u — Error on Unset Variables
Treat undefined variables as errors.
```bash
set -u
```
Example:
```bash
set -u
echo "$username"
```
If `username` is not defined, script exits.
---

### set -o pipefail — Catch Errors in Pipes
Fail if any command in a pipeline fails.

Without pipefail:
```bash
false | true   # exits with success
```
With pipefail:
```bash
set -o pipefail
false | true   # now fails
```
Recommended strict mode:
```bash
set -euo pipefail
```
---

### set -x — Debug Mode (Trace Execution)
Print each command before executing it.
```bash
set -x
```
Disable debug mode
```bash
set +x
```
Run script with debug:
```bash
bash -x script.sh
```
Useful for troubleshooting variable values and flow.
---

### trap — Cleanup on Exit or Signal
Run cleanup code when script exits.
```bash
cleanup() {
  rm -f /tmp/tempfile
}

trap cleanup EXIT
```
Handle Ctrl+C (SIGINT):
```bash
trap 'echo "Interrupted"; exit 130' INT
```

Example with temp file:
```bash
tmp=$(mktemp)
trap 'rm -f "$tmp"' EXIT
```
