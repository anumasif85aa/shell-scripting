# Bash Functions: From Scratch to Advanced

## 1. What Is a Function?

A function is a named block of commands. Define the commands once and call the
function whenever those commands are needed.

Without a function:

```bash
echo "Checking the server"
date
hostname

echo "Checking the server"
date
hostname
```

With a function:

```bash
show_server()
{
    echo "Checking the server"
    date
    hostname
}

show_server
show_server
```

Benefits:

- Less repeated code
- Easier reading
- Easier testing
- Easier maintenance
- Reusable automation steps

## 2. Basic Syntax

Recommended style:

```bash
function_name()
{
    command
    command
}
```

One-line style:

```bash
function_name() { command; }
```

The semicolon is required before `}` when the complete function is written on
one line.

Another valid Bash style is:

```bash
function function_name
{
    command
}
```

For beginners, use the first style consistently.

## 3. Define Before Calling

Bash normally reads and executes a script from top to bottom. Define the
function before calling it:

```bash
greet()
{
    echo "Hello, students"
}

greet
```

Incorrect order:

```bash
greet

greet()
{
    echo "Hello"
}
```

This can produce `greet: command not found`.

## 4. Calling a Function

Call a function by writing its name:

```bash
show_date()
{
    date
}

show_date
```

Do not use parentheses when calling it:

```bash
show_date      # Correct
show_date()    # Incorrect function call
```

## 5. Function Arguments

Values written after a function name become that function's positional
parameters:

```bash
greet()
{
    echo "Hello, $1"
}

greet "Ali"
greet "Omar"
```

Output:

```text
Hello, Ali
Hello, Omar
```

Inside a function:

| Parameter | Meaning |
|---|---|
| `$0` | Script name, not the function name |
| `$1` | First function argument |
| `$2` | Second function argument |
| `$#` | Number of function arguments |
| `"$@"` | All function arguments, kept separately |
| `"$*"` | All arguments combined into one value when quoted |

Example:

```bash
show_items()
{
    echo "Argument count: $#"

    for item in "$@"
    do
        echo "Item: $item"
    done
}

show_items "apple" "banana" "red cherry"
```

Always prefer `"$@"` when processing every argument.

## 6. Script Arguments Versus Function Arguments

The script receives its own arguments:

```bash
./demo.sh apple banana
```

At the top level, `$1` is `apple` and `$2` is `banana`.

When a function is called with different arguments, `$1` and `$2` temporarily
refer to the function arguments:

```bash
show_values()
{
    echo "Function first argument: $1"
}

echo "Script first argument: $1"
show_values "mango"
echo "Script first argument again: $1"
```

## 7. Variables and Scope

A normal Bash variable is global unless declared with `local`.

```bash
name="Ali"

change_name()
{
    name="Omar"
}

change_name
echo "$name"
```

Output:

```text
Omar
```

The function changed the global variable.

Use `local` to keep a variable inside the function:

```bash
name="Ali"

change_name()
{
    local name="Omar"
    echo "Inside: $name"
}

change_name
echo "Outside: $name"
```

Output:

```text
Inside: Omar
Outside: Ali
```

Good practice:

```bash
calculate_total()
{
    local first="$1"
    local second="$2"
    local total=$((first + second))

    echo "$total"
}
```

## 8. Output Is Not the Same as Return Status

`echo` sends text to standard output:

```bash
get_hostname()
{
    hostname
}
```

`return` sends a numeric status back to the caller:

```bash
check_number()
{
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}
```
["  if [[ "$1" =~ ^ [0-9]+$ ]]; then  " EXPLANATION](Bash-Regex-Digits-Only-Validation.md)

["  if [[ "$1" =~ ^ [0-9]+$ ]]; then  " EXPLANATION-URDU](Bash-Regex-Digits-Only-Validation-Roman-Urdu.md)

| Command | Purpose |
|---|---|
| `echo "text"` | Produce data or a message |
| `return 0` | Report success |
| `return 1` | Report failure |
| `exit 0` | End the entire script successfully |
| `exit 1` | End the entire script with failure |

Use `return` inside a function when you want to stop only that function. Use
`exit` when you want to stop the entire script.

## 9. Function Return Status

A function's status is normally the status of its last command:

```bash
demo()
{
    echo "This succeeds"
}

demo
echo "Status: $?"
```

You can set it explicitly:

```bash
demo()
{
    return 7
}

demo
echo "Status: $?"
```

Bash status codes are integers from `0` through `255`.

- `0` means success.
- A non-zero value means failure or another special condition.

## 10. Calling a Function in an `if` Statement

```bash
file_exists()
{
    local file="$1"
    [[ -e "$file" ]]
}

if file_exists "config.txt"; then
    echo "Configuration found"
else
    echo "Configuration missing"
fi
```

The `if` statement checks the function's return status.

## 11. Capturing Function Output

Use command substitution:

```bash
get_current_user()
{
    whoami
}

current_user="$(get_current_user)"
echo "User: $current_user"
```

Keep informational messages away from standard output when the function's
output will be captured:

```bash
get_total()
{
    local first="$1"
    local second="$2"

    echo "Calculating total..." >&2
    echo $((first + second))
}

answer="$(get_total 5 7)"
echo "Answer: $answer"
```

The calculation message goes to standard error; only `12` is captured.

## 12. Default Values

Provide a default when an argument is missing or empty:

```bash
greet()
{
    local name="${1:-Guest}"
    echo "Hello, $name"
}

greet "Ali"
greet
```

`${1:-Guest}` means: use `$1` if it has a non-empty value; otherwise use
`Guest`.

## 13. Validate Function Arguments

```bash
multiply()
{
    if [[ $# -ne 2 ]]; then
        echo "Usage: multiply NUMBER NUMBER" >&2
        return 1
    fi

    if [[ ! "$1" =~ ^-?[0-9]+$ || ! "$2" =~ ^-?[0-9]+$ ]]; then
        echo "Error: both values must be whole numbers" >&2
        return 1
    fi

    echo $(($1 * $2))
}
```

Use it:

```bash
if answer="$(multiply 6 7)"; then
    echo "Answer: $answer"
else
    echo "Calculation failed"
fi
```

## 14. Functions and Loops

```bash
show_table()
{
    local table="$1"
    local number

    for number in {1..10}
    do
        echo "$table x $number = $((table * number))"
    done
}

for value in 2 5 10
do
    show_table "$value"
    echo
done
```

## 15. Functions and Files

```bash
count_lines()
{
    local file="$1"

    if [[ ! -f "$file" ]]; then
        echo "Error: file not found: $file" >&2
        return 1
    fi

    wc -l < "$file"
}
```

## 16. Reusing Functions from Another File

Create `functions.sh`:

```bash
#!/bin/bash

show_header()
{
    echo "=============================="
    echo "$1"
    echo "=============================="
}
```

Use it in `report.sh`:

```bash
#!/bin/bash

source "./functions.sh"

show_header "System Report"
hostname
uptime
```

The dot command is equivalent:

```bash
. "./functions.sh"
```

Use `source` for readability.

## 17. Read-Only Variables

Protect a local variable from accidental changes:

```bash
show_app()
{
    local -r app_name="$1"
    echo "Application: $app_name"
}
```

`local -r` creates a local read-only variable.

## 18. Arrays Passed to Functions

Pass array elements as separate arguments:

```bash
servers=("web-01" "web-02" "db-01")

show_servers()
{
    local server

    for server in "$@"
    do
        echo "Server: $server"
    done
}

show_servers "${servers[@]}"
```

## 19. Cleanup Functions and `trap`

A cleanup function can run when the script exits:

```bash
temporary_file="/tmp/demo-$$.txt"

cleanup()
{
    rm -f -- "$temporary_file"
    echo "Temporary file removed"
}

trap cleanup EXIT

echo "Practice data" > "$temporary_file"
echo "Working with $temporary_file"
```

`trap cleanup EXIT` tells Bash to call `cleanup` when the script finishes.
Use destructive commands carefully and always keep their targets specific.

## 20. Function Libraries

A small reusable library:

```bash
#!/bin/bash

log_info()
{
    echo "[INFO] $*"
}

log_error()
{
    echo "[ERROR] $*" >&2
}

require_file()
{
    local file="$1"

    if [[ -f "$file" ]]; then
        return 0
    fi

    log_error "Required file missing: $file"
    return 1
}
```

A main script can source this file and use all three functions.

## 21. Common Mistakes

### Calling with parentheses

```bash
greet()    # Wrong when calling
greet      # Correct
```

### Missing space in a condition

```bash
[[ -f "$file" ]]    # Correct
```

### Forgetting quotes

```bash
process_file "$file"    # Correct
```

### Using `exit` when `return` is intended

```bash
check_file()
{
    [[ -f "$1" ]] || return 1
}
```

### Capturing unwanted messages

If command substitution should capture only data, send progress or error
messages to `>&2`.

### Forgetting argument validation

Check `$#` and validate expected data before using it.

## 22. Naming Guidelines

Good function names describe an action:

```text
show_usage
validate_number
check_file
create_backup
generate_report
```

Avoid unclear names:

```text
do_it
thing
abc
test1
```

Use lowercase names with underscores for consistency.

## 23. Debugging and Verification

Check syntax:

```bash
bash -n script.sh
```

Trace execution:

```bash
bash -x script.sh
```

Check a function's status immediately:

```bash
my_function
echo "$?"
```

List currently defined functions:

```bash
declare -F
```

Show one function definition:

```bash
declare -f function_name
```

## 24. Recommended Script Structure

```bash
#!/bin/bash

# 1. Global constants

# 2. Function definitions

# 3. Main script flow

main()
{
    echo "Program starts here"
}

main "$@"
```

Using a `main` function is common in larger scripts. It keeps the execution flow
separate from function definitions. For first-day practice, calling functions
directly at the bottom is also completely acceptable.

## 25. Final Learning Path

1. Define and call a function.
2. Pass one argument.
3. Pass several arguments with `"$@"`.
4. Use `local` variables.
5. Return success or failure.
6. Call functions in conditionals.
7. Capture clean function output.
8. Source a reusable function library.
9. Build small automation workflows.
10. Validate every script with `bash -n`.

