# Bash Variables: From Scratch to Advanced

## 1. Learning objectives

After completing these notes and labs, you should be able to:

- Create and use Bash variables.
- Understand the difference between shell variables and environment variables.
- Protect spaces and special characters with quotes.
- Read input from a user safely.
- use positional arguments such as `$1`, `$2`, `$#`, and `"$@"`.
- Store command output in a variable.
- Perform basic arithmetic.
- Use default, required, alternate, and assigned values.
- Change strings with parameter expansion.
- Validate configuration before running an action.
- Handle secrets more safely.
- Apply variables in practical DevOps scripts.

---

## 2. What is a variable?

A variable is a named place that stores a value.

```bash
fruit="apple"
echo "$fruit"
```

Output:

```text
apple
```

Think of the variable name as a labelled box:

```text
fruit  --->  apple
```

The value can later be replaced:

```bash
fruit="banana"
echo "$fruit"
```

## 3. Variable assignment rules

Correct:

```bash
name="Ali"
age=20
city="New York"
```

Incorrect:

```bash
name = "Ali"
age =20
city= "New York"
```

There must be no spaces around `=`.

## 4. Reading a variable

Use `$` before the variable name:

```bash
name="Ali"
echo "$name"
```

Braces make the variable boundary clear:

```bash
fruit="apple"
echo "${fruit}s"
```

Output:

```text
apples
```

Without braces, Bash looks for a variable named `fruits`:

```bash
echo "$fruits"
```

## 5. Variable names

Valid names:

```bash
name="Ali"
student_name="Omar"
server2="web"
APP_ENV="production"
```

Invalid names:

```bash
2server="web"
student-name="Omar"
student name="Ali"
```

Recommended style:

- Use lowercase names for ordinary script variables: `username`, `log_file`.
- Use uppercase names for exported environment variables or constants: `APP_ENV`, `MAX_RETRIES`.
- Use meaningful names.
- Avoid names such as `PATH`, `HOME`, `SHELL`, and `USER` for your own values.

## 6. Quoting variables

### Double quotes

Double quotes allow variable expansion and keep spaces together:

```bash
name="Muhammad Khalid Khan"
echo "$name"
```

Use double quotes for most variable expansions:

```bash
mkdir -p "$directory"
cp "$source" "$destination"
```

### Single quotes

Single quotes print text literally:

```bash
name="Ali"
echo '$name'
```

Output:

```text
$name
```

### No quotes

Unquoted variables can be split into multiple words and may expand wildcard characters.

```bash
file="my notes.txt"
cat $file
```

Bash may treat this as two filenames: `my` and `notes.txt`.

Safer:

```bash
cat "$file"
```

## 7. User input with `read`

```bash
read -r -p "Enter your name: " name
echo "Hello, $name"
```

Options:

| Option | Purpose |
|---|---|
| `-r` | Prevent backslash processing |
| `-p` | Display a prompt |
| `-s` | Hide typed input |
| `-n 1` | Read one character |
| `-t 10` | Wait up to 10 seconds |

Password-style input:

```bash
read -r -s -p "Enter password: " password
echo
echo "Password received."
```

Do not print the password.

## 8. Positional arguments

Run:

```bash
bash fruit.sh apple banana cherry
```

Inside the script:

| Variable | Meaning |
|---|---|
| `$0` | Script name |
| `$1` | First argument: `apple` |
| `$2` | Second argument: `banana` |
| `$3` | Third argument: `cherry` |
| `$#` | Number of arguments |
| `"$@"` | All arguments, kept separately |
| `"$*"` | All arguments combined as one string when quoted |

Example:

```bash
echo "Script: $0"
echo "First fruit: $1"
echo "Number of fruits: $#"
echo "All fruits: $*"
```

For safely passing all arguments to another command, prefer:

```bash
"$@"
```

## 9. Command substitution

Store command output in a variable:

```bash
current_user="$(whoami)"
today="$(date +%F)"
hostname_value="$(hostname)"
```

Use the modern `$(command)` form instead of old backticks.

```bash
echo "User: $current_user"
echo "Date: $today"
echo "Host: $hostname_value"
```

Command substitution removes trailing newline characters from the captured output.

## 10. Arithmetic variables

```bash
apples=5
bananas=3
total=$((apples + bananas))
echo "Total fruits: $total"
```

Common operators:

| Operator | Meaning |
|---|---|
| `+` | Addition |
| `-` | Subtraction |
| `*` | Multiplication |
| `/` | Integer division |
| `%` | Remainder |
| `++` | Increase by one |
| `--` | Decrease by one |

Example:

```bash
count=1
((count++))
echo "$count"
```

Be careful with `set -e`: `((count++))` can return status 1 when the old value is zero. Assignment form is safer in strict scripts:

```bash
count=$((count + 1))
```

## 11. Shell variables and environment variables

A normal shell variable belongs to the current shell:

```bash
course="Bash"
```

An exported variable is inherited by child processes:

```bash
export COURSE="Bash"
bash -c 'echo "$COURSE"'
```

Create first, export later:

```bash
APP_ENV="development"
export APP_ENV
```

Or create and export together:

```bash
export APP_ENV="development"
```

Useful commands:

```bash
env
printenv
printenv PATH
export -p
```

Important: a child process cannot permanently change the environment of its parent shell.

## 12. Temporary environment variables

Set a variable for one command only:

```bash
APP_ENV="testing" bash app.sh
```

The value is available to `app.sh` but does not need to remain afterward.

## 13. Default values

Use a default when the variable is unset or empty:

```bash
environment="${APP_ENV:-development}"
echo "$environment"
```

The original variable is not changed.

## 14. Assigning a default

Assign the default to the variable when it is unset or empty:

```bash
: "${APP_ENV:=development}"
echo "$APP_ENV"
```

The `:` command does nothing by itself, but it allows the expansion to run.

## 15. Requiring a value

Stop with an error when a required variable is missing:

```bash
: "${DEPLOY_ENV:?DEPLOY_ENV is required}"
```

This is useful for configuration checks.

## 16. Alternate values

Use another value only when the variable is set and non-empty:

```bash
debug="yes"
message="${debug:+Debug mode enabled}"
echo "$message"
```

## 17. The colon difference

Colon forms treat unset and empty as missing:

```bash
value="${name:-guest}"
```

Forms without a colon only treat unset as missing:

```bash
value="${name-guest}"
```

This difference matters when an empty string is a valid value.

## 18. String length and substrings

Length:

```bash
username="khalid"
echo "${#username}"
```

Substring:

```bash
message="production-server"
echo "${message:0:10}"
```

Output:

```text
production
```

## 19. Removing patterns

```bash
file="backup.tar.gz"
echo "${file#*.}"
echo "${file##*.}"
echo "${file%.*}"
echo "${file%%.*}"
```

Meaning:

| Expansion | Action |
|---|---|
| `${var#pattern}` | Remove shortest match from start |
| `${var##pattern}` | Remove longest match from start |
| `${var%pattern}` | Remove shortest match from end |
| `${var%%pattern}` | Remove longest match from end |

Useful filename example:

```bash
path="/var/log/app.log"
filename="${path##*/}"
extension="${filename##*.}"
base="${filename%.*}"
```

## 20. Replacing text

Replace the first match:

```bash
text="dev-server-dev"
echo "${text/dev/prod}"
```

Replace all matches:

```bash
echo "${text//dev/prod}"
```

## 21. Changing letter case

```bash
environment="Production"
echo "${environment,,}"
echo "${environment^^}"
```

Output:

```text
production
PRODUCTION
```

## 22. Read-only variables

```bash
readonly COMPANY="NIT"
echo "$COMPANY"
```

Trying to change `COMPANY` later produces an error.

Another form:

```bash
declare -r MAX_RETRIES=3
```

## 23. Integer attributes

```bash
declare -i count=5
count=count+2
echo "$count"
```

Output:

```text
7
```

For beginner scripts, `$(( ))` is usually easier to read.

## 24. Checking whether a variable exists

```bash
if [[ -v APP_ENV ]]; then
    echo "APP_ENV is set."
else
    echo "APP_ENV is not set."
fi
```

Check whether it contains text:

```bash
if [[ -n "$APP_ENV" ]]; then
    echo "APP_ENV is not empty."
fi
```

## 25. Removing a variable

```bash
fruit="apple"
unset fruit
```

After `unset`, the variable no longer exists.

## 26. Indirect expansion

Indirect expansion uses the value of one variable as the name of another variable:

```bash
production_server="prod01"
target_name="production_server"
echo "${!target_name}"
```

Output:

```text
prod01
```

Use indirect expansion carefully. Associative arrays are often clearer for mapping names to values.

## 27. Special variables

| Variable | Meaning |
|---|---|
| `$?` | Exit status of the previous command |
| `$$` | Process ID of the current shell |
| `$!` | Process ID of the latest background command |
| `$-` | Current shell option flags |
| `$_` | Last argument of the previous command in many Bash contexts |

Example:

```bash
ls /etc/passwd
status=$?
echo "Exit status: $status"
```

Capture `$?` immediately because the next command replaces it.

## 28. Variable scope

Variables are global within a script unless declared `local` inside a function:

```bash
name="global"

show_name() {
    local name="local"
    echo "$name"
}

show_name
echo "$name"
```

Output:

```text
local
global
```

Functions and `local` are included here for advanced understanding. The beginner labs in this package do not require functions.

## 29. Subshell behavior

Changes inside a subshell do not return to the parent:

```bash
name="Ali"

(
    name="Omar"
    echo "Inside: $name"
)

echo "Outside: $name"
```

Output:

```text
Inside: Omar
Outside: Ali
```

A pipeline may also run parts in subshells, so variable changes inside a piped `while` loop may not survive afterward.

## 30. Safer configuration handling

Avoid blindly sourcing configuration that you do not trust:

```bash
source unknown.env
```

`source` executes shell code. For simple known keys, read and validate them:

```bash
while IFS='=' read -r key value; do
    case "$key" in
        APP_NAME) app_name="$value" ;;
        APP_ENV) app_env="$value" ;;
        PORT) port="$value" ;;
    esac
done < app.env
```

Then validate values before use.

## 31. Secrets and variables

Avoid:

```bash
password="mypassword"
echo "$password"
```

Better practices:

- Do not hardcode real passwords or tokens.
- Use a secrets manager for production systems.
- Use `read -s` for interactive practice.
- Do not enable `set -x` around secrets.
- Do not pass secrets as command-line arguments when avoidable; other users may see process arguments.
- Clear a temporary secret when finished:

```bash
unset password
```

Environment variables are convenient but are not automatically a secure secret store.

## 32. Strict mode and unset variables

```bash
set -u
```

With `set -u`, using an unset variable stops the script.

Provide a safe default where appropriate:

```bash
echo "${OPTIONAL_VALUE:-not-set}"
```

A common strict-mode header is:

```bash
set -Eeuo pipefail
```

Use strict mode after you understand its behavior. It helps detect errors but does not replace validation.

## 33. Practical DevOps example

```bash
#!/bin/bash

app_name="${1:-demo-app}"
environment="${2:-development}"
config_file="${CONFIG_FILE:-./app.env}"

if [[ ! -s "$config_file" ]]; then
    echo "Error: configuration file is missing or empty: $config_file" >&2
    exit 1
fi

environment="${environment,,}"

if [[ "$environment" != "development" &&
      "$environment" != "testing" &&
      "$environment" != "production" ]]; then
    echo "Error: invalid environment: $environment" >&2
    exit 1
fi

timestamp="$(date +%Y%m%d-%H%M%S)"

echo "Application: $app_name"
echo "Environment: $environment"
echo "Configuration: $config_file"
echo "Run ID: ${app_name}-${environment}-${timestamp}"
echo "Validation passed."
```

## 34. Common mistakes

### Spaces around `=`

Wrong:

```bash
name = "Ali"
```

Correct:

```bash
name="Ali"
```

### Missing `$`

```bash
name="Ali"
echo "name"
```

This prints the word `name`, not the value.

Correct:

```bash
echo "$name"
```

### Single quotes block expansion

```bash
echo '$name'
```

Use:

```bash
echo "$name"
```

### Unquoted variables

Risky:

```bash
rm $file
```

Safer:

```bash
rm -- "$file"
```

### Overwriting special environment variables

Do not use this:

```bash
PATH="notes"
```

It can prevent the shell from finding commands.

## 35. Debugging variables

Check syntax:

```bash
bash -n script.sh
```

Show executed commands:

```bash
bash -x script.sh
```

Do not use `bash -x` when the trace may reveal secrets.

Inspect a variable safely:

```bash
declare -p variable_name
```

Check an exported variable:

```bash
printenv APP_ENV
```

## 36. Quick revision checklist

- [ ] No spaces around `=`
- [ ] Variable expansions are quoted
- [ ] Meaningful names are used
- [ ] User input uses `read -r`
- [ ] Arguments are counted before use
- [ ] Defaults are intentional
- [ ] Required values are validated
- [ ] Command output uses `$(...)`
- [ ] Errors go to `stderr`
- [ ] Real secrets are not hardcoded or printed
- [ ] Syntax passes `bash -n`
- [ ] Valid and invalid inputs are tested

---

Prepared for the Bash Scripting Learning Series.
