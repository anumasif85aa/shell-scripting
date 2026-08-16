# Bash Conditionals: From Scratch to Advanced

## 1. What Is a Conditional?

A conditional lets a script make a decision.

```text
If a condition is true:
    perform one action
Otherwise:
    perform another action
```

Real-life example:

```text
If it is raining:
    take an umbrella
Otherwise:
    continue without one
```

Bash example:

```bash
if [[ "$weather" == "yes" ]]; then
    echo "Take an umbrella"
else
    echo "You do not need an umbrella"
fi
```

## 2. Bash Uses Command Status

Bash conditionals evaluate command exit status.

| Status | Meaning |
|---:|---|
| `0` | Success or true |
| Non-zero | Failure or false |

Example:

```bash
mkdir practice
echo "$?"
```

If `mkdir` succeeds, the status is normally `0`. If it fails, the status is
non-zero.

## 3. Basic `if` Syntax

```bash
if [[ condition ]]; then
    command
fi
```

Example:

```bash
age=20

if [[ "$age" -ge 18 ]]; then
    echo "Adult"
fi
```

Important keywords:

| Keyword | Purpose |
|---|---|
| `if` | Start the decision |
| `then` | Start commands for a successful condition |
| `elif` | Test another condition |
| `else` | Run when earlier conditions failed |
| `fi` | End the conditional |

## 4. `if/else`

```bash
if [[ condition ]]; then
    command_when_true
else
    command_when_false
fi
```

Example:

```bash
read -r -p "Is it raining? Enter yes or no: " weather

if [[ "$weather" == "yes" ]]; then
    echo "Take an umbrella"
else
    echo "You do not need an umbrella"
fi
```

## 5. `if/elif/else`

Use `elif` when there are several possible decisions:

```bash
read -r -p "Enter traffic-light color: " light

if [[ "$light" == "red" ]]; then
    echo "Stop"
elif [[ "$light" == "yellow" ]]; then
    echo "Get ready"
elif [[ "$light" == "green" ]]; then
    echo "Go"
else
    echo "Invalid traffic-light color" >&2
    exit 1
fi
```

Bash stops after the first successful branch.

## 6. `[[ ]]` Versus `[ ]`

Recommended for Bash scripts:

```bash
[[ "$name" == "Ali" ]]
```

Portable test command:

```bash
[ "$name" = "Ali" ]
```

`[[ ]]` is safer and more powerful in Bash:

- Reduced word-splitting problems
- Pattern matching
- Regular-expression matching
- `&&` and `||` inside the condition

Spaces are required:

```bash
[[ "$name" == "Ali" ]]    # Correct
[["$name" == "Ali"]]      # Incorrect
```

## 7. String Comparisons

| Operator | Meaning |
|---|---|
| `==` | Strings are equal |
| `!=` | Strings are different |
| `-z` | String is empty |
| `-n` | String is not empty |

Examples:

```bash
[[ "$name" == "Ali" ]]
[[ "$environment" != "prod" ]]
[[ -z "$username" ]]
[[ -n "$username" ]]
```

Always quote normal string variables:

```bash
if [[ -z "$username" ]]; then
    echo "Username is required" >&2
fi
```

## 8. Numeric Comparisons

Use numeric operators inside `[[ ]]`:

| Operator | Meaning |
|---|---|
| `-eq` | Equal |
| `-ne` | Not equal |
| `-gt` | Greater than |
| `-ge` | Greater than or equal |
| `-lt` | Less than |
| `-le` | Less than or equal |

Example:

```bash
score=85

if [[ "$score" -ge 80 ]]; then
    echo "Passed"
else
    echo "More practice required"
fi
```

Do not use string operators for numeric meaning:

```bash
[[ "$number" -gt 10 ]]    # Numeric comparison
[[ "$number" > 10 ]]      # String ordering, not normal numeric comparison
```

## 9. Arithmetic Conditions with `(( ))`

Inside arithmetic conditions, use normal mathematical operators:

```bash
if (( age >= 18 )); then
    echo "Adult"
fi
```

More examples:

```bash
(( number == 10 ))
(( number != 10 ))
(( number > 5 ))
(( number <= 100 ))
```

`(( expression ))` succeeds when the expression evaluates to a non-zero value.

## 10. File and Directory Tests

| Test | Meaning |
|---|---|
| `-e` | Path exists |
| `-f` | Regular file exists |
| `-d` | Directory exists |
| `-s` | File exists and has a size greater than zero |
| `-r` | Readable |
| `-w` | Writable |
| `-x` | Executable |
| `-L` | Symbolic link |

Examples:

```bash
if [[ -f "$file" ]]; then
    echo "Regular file found"
fi

if [[ -d "$directory" ]]; then
    echo "Directory found"
fi
```

A file containing only spaces or a newline has a non-zero byte size. To require
meaningful content:

```bash
if [[ -s "$file" ]] && grep -q '[^[:space:]]' "$file"; then
    echo "File contains content"
fi
```

## 11. Logical AND with `&&`

Both conditions must succeed:

```bash
age=25

if [[ "$age" -ge 18 && "$age" -le 65 ]]; then
    echo "Age is within the accepted range"
fi
```

With separate commands:

```bash
if [[ -f "$file" ]] && [[ -r "$file" ]]; then
    echo "File exists and is readable"
fi
```

## 12. Logical OR with `||`

At least one condition must succeed:

```bash
if [[ "$environment" == "dev" || "$environment" == "test" ]]; then
    echo "Non-production environment"
fi
```

Short-circuit command example:

```bash
cd project || exit 1
```

The script exits only if `cd project` fails.

## 13. Logical NOT with `!`

`!` reverses success and failure:

```bash
if [[ ! -f "$file" ]]; then
    echo "File is missing" >&2
fi
```

Command example:

```bash
if ! mkdir "$directory"; then
    echo "Could not create directory: $directory" >&2
    exit 1
fi
```

Remember: `mkdir` can fail for several reasons, not only because the directory
already exists.

## 14. Test Commands Directly

An `if` statement can run a command directly:

```bash
if grep -q "ERROR" application.log; then
    echo "Errors were found"
else
    echo "No errors were found"
fi
```

`if` checks `grep`'s status, not its printed text.

`grep -q` is quiet and is useful when only the status matters.

## 15. Check a Saved Status

Check `$?` immediately:

```bash
command
status=$?

if [[ "$status" -eq 0 ]]; then
    echo "Command succeeded"
else
    echo "Command failed with status $status" >&2
fi
```

Usually, testing the command directly is cleaner:

```bash
if command; then
    echo "Command succeeded"
else
    echo "Command failed"
fi
```

## 16. Pattern Matching

Inside `[[ ]]`, the right side can be a pattern:

```bash
filename="report.txt"

if [[ "$filename" == *.txt ]]; then
    echo "Text file"
fi
```

Do not quote the pattern if you want pattern matching:

```bash
[[ "$filename" == *.txt ]]      # Pattern
[[ "$filename" == "*.txt" ]]    # Literal text
```

## 17. Regular Expressions

Use `=~`:

```bash
if [[ "$number" =~ ^-?[0-9]+$ ]]; then
    echo "Valid whole number"
else
    echo "Invalid number" >&2
fi
```

Do not normally quote the regular expression:

```bash
[[ "$value" =~ ^[0-9]+$ ]]
```

## 18. `case` Statements

`case` is often clearer than many equality checks:

```bash
case "$environment" in
    dev)
        echo "Development"
        ;;
    test|stage)
        echo "Pre-production"
        ;;
    prod)
        echo "Production"
        ;;
    *)
        echo "Unknown environment" >&2
        exit 1
        ;;
esac
```

Keywords:

| Keyword | Purpose |
|---|---|
| `case` | Start selection |
| `in` | Begin patterns |
| `;;` | End one branch |
| `*` | Default pattern |
| `esac` | End the statement |

## 19. Nested Conditionals

```bash
if [[ -f "$file" ]]; then
    if [[ -r "$file" ]]; then
        echo "File exists and is readable"
    else
        echo "File exists but is not readable"
    fi
else
    echo "File does not exist"
fi
```

Nested decisions are valid, but excessive nesting reduces readability. Combine
simple conditions when practical.

## 20. Validate User Input

```bash
read -r -p "Enter age: " age

if [[ ! "$age" =~ ^[0-9]+$ ]]; then
    echo "Age must be a positive whole number" >&2
    exit 1
fi

if [[ "$age" -ge 18 ]]; then
    echo "Adult"
else
    echo "Minor"
fi
```

Validate format before performing a numeric comparison.

## 21. Validate Script Arguments

```bash
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 FILE ENVIRONMENT" >&2
    exit 1
fi

file="$1"
environment="$2"

if [[ ! -f "$file" ]]; then
    echo "File not found: $file" >&2
    exit 1
fi
```

## 22. Functions as Conditions

```bash
valid_environment()
{
    case "$1" in
        dev|test|stage|prod) return 0 ;;
        *) return 1 ;;
    esac
}

if valid_environment "$environment"; then
    echo "Environment accepted"
else
    echo "Invalid environment" >&2
fi
```

The `if` statement checks the function's return status.

## 23. Guard Clauses

Stop early when requirements are not met:

```bash
[[ $# -eq 2 ]] || {
    echo "Usage: $0 FILE ENVIRONMENT" >&2
    exit 1
}

[[ -f "$1" ]] || {
    echo "File not found: $1" >&2
    exit 1
}
```

An ordinary `if` is often easier for beginners. Guard clauses become useful as
scripts grow.

## 24. Deployment Gate Example

```bash
#!/bin/bash

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 ENVIRONMENT VERSION CONFIG" >&2
    exit 1
fi

environment="$1"
version="$2"
config="$3"

case "$environment" in
    dev|test|stage|prod)
        ;;
    *)
        echo "Invalid environment: $environment" >&2
        exit 1
        ;;
esac

if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Version must use MAJOR.MINOR.PATCH format" >&2
    exit 1
fi

if [[ ! -s "$config" ]] || ! grep -q '[^[:space:]]' "$config"; then
    echo "Configuration is missing or empty" >&2
    exit 1
fi

echo "All deployment checks passed"
```

## 25. Common Mistakes

### Missing spaces

Incorrect:

```bash
if [["$name" == "Ali"]]; then
```

Correct:

```bash
if [[ "$name" == "Ali" ]]; then
```

### Missing `then`

```bash
if [[ condition ]]; then
```

### Missing `fi`

Every `if` structure must end with `fi`.

### Using numeric operators on unvalidated text

Validate input first.

### Assuming every command failure has one cause

Permission errors, invalid paths, read-only filesystems, and other failures are
possible.

### Using `exit` inside a function

Use `return` when only the function should stop.

## 26. Debugging

Check syntax:

```bash
bash -n script.sh
```

Trace decisions:

```bash
bash -x script.sh
```

Print values clearly:

```bash
echo "environment=[$environment]"
echo "file=[$file]"
```

## Final Learning Path

1. Learn command success and failure.
2. Write a basic `if`.
3. Add `else`.
4. Add several choices with `elif`.
5. Compare strings and numbers.
6. Test files and directories.
7. Combine conditions with `&&` and `||`.
8. Reverse results with `!`.
9. Use patterns, regular expressions, and `case`.
10. Validate input and arguments.
11. Test commands and functions directly.
12. Build safe automation gates.

