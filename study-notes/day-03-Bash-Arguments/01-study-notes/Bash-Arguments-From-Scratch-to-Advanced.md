# Bash Arguments: From Scratch to Advanced

## 1. What Is an Argument?

An argument is a value supplied to a command or script when it is started.

```bash
./fruit.sh apple banana
```

In this command:

- `./fruit.sh` is the script invocation.
- `apple` is the first argument.
- `banana` is the second argument.

Arguments make one script reusable with different values.

Without arguments:

```bash
echo "Table of 5"
```

With an argument:

```bash
echo "Table of $1"
```

Now the same script can receive `2`, `5`, `10`, or another number.

## 2. Positional Parameters

Bash stores script arguments in special positional parameters.

| Parameter | Meaning |
|---|---|
| `$0` | Script name or invocation path |
| `$1` | First argument |
| `$2` | Second argument |
| `$3` | Third argument |
| `${10}` | Tenth argument |
| `$#` | Number of arguments |
| `"$@"` | All arguments, preserved separately |
| `"$*"` | All arguments combined when quoted |
| `$?` | Status of the most recent command |
| `$$` | Process ID of the current shell |

Example:

```bash
#!/bin/bash

echo "Script: $0"
echo "First: $1"
echo "Second: $2"
echo "Count: $#"
```

Run it:

```bash
./show_args.sh apple banana
```

Output:

```text
Script: ./show_args.sh
First: apple
Second: banana
Count: 2
```

## 3. Arguments After Number Nine

Use braces for argument ten and above:

```bash
echo "${10}"
echo "${11}"
```

This is incorrect:

```bash
echo "$10"
```

Bash can interpret `$10` as `$1` followed by the character `0`.

## 4. Why Quote Arguments?

Suppose the script is called like this:

```bash
./fruit.sh "red apple"
```

Inside the script:

```bash
echo "$1"
```

Output:

```text
red apple
```

Quoting protects spaces and prevents unwanted word splitting and filename
expansion.

Recommended:

```bash
file="$1"
cp -- "$file" "$destination"
```

## 5. Count Arguments with `$#`

```bash
#!/bin/bash

echo "You supplied $# argument(s)"
```

Require exactly two:

```bash
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 FIRST SECOND" >&2
    exit 1
fi
```

Useful numeric comparisons:

| Test | Meaning |
|---|---|
| `[[ $# -eq 2 ]]` | Exactly two |
| `[[ $# -ne 2 ]]` | Not equal to two |
| `[[ $# -lt 1 ]]` | Fewer than one |
| `[[ $# -gt 3 ]]` | More than three |
| `[[ $# -ge 1 ]]` | At least one |
| `[[ $# -le 5 ]]` | At most five |

## 6. Process All Arguments with `"$@"`

```bash
#!/bin/bash

for fruit in "$@"
do
    echo "Fruit: $fruit"
done
```

Run:

```bash
./basket.sh apple banana "red cherry"
```

Output:

```text
Fruit: apple
Fruit: banana
Fruit: red cherry
```

Quoted `"$@"` is the safest normal way to process every argument.

## 7. `"$@"` Versus `"$*"`

Given:

```bash
./demo.sh apple "red cherry" banana
```

`"$@"` expands as three separate values:

```text
apple
red cherry
banana
```

`"$*"` expands as one combined value:

```text
apple red cherry banana
```

Use `"$@"` in most loops and when forwarding arguments.

## 8. Default Argument Values

Use a default when an argument is missing or empty:

```bash
fruit="${1:-apple}"
echo "Fruit: $fruit"
```

Run:

```bash
./fruit.sh
```

Output:

```text
Fruit: apple
```

If an argument is supplied, Bash uses it:

```bash
./fruit.sh mango
```

## 9. Require an Argument

Parameter expansion can stop the script with a message:

```bash
file="${1:?Usage: $0 FILE}"
```

For beginners, an explicit condition is often easier to read:

```bash
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 FILE" >&2
    exit 1
fi

file="$1"
```

## 10. Validate a Whole Number

```bash
number="$1"

if [[ ! "$number" =~ ^-?[0-9]+$ ]]; then
    echo "Error: enter a valid whole number" >&2
    exit 1
fi
```

The regular expression accepts:

```text
0
25
-7
```

It rejects:

```text
apple
2.5
10x
```

## 11. Validate a File Argument

```bash
file="$1"

if [[ ! -f "$file" ]]; then
    echo "Error: regular file not found: $file" >&2
    exit 1
fi

echo "Processing: $file"
```

Common file tests:

| Test | Meaning |
|---|---|
| `-e` | Path exists |
| `-f` | Regular file |
| `-d` | Directory |
| `-s` | File exists and is not empty |
| `-r` | Readable |
| `-w` | Writable |
| `-x` | Executable |

## 12. Forward All Arguments

One script can safely pass its arguments to another command or function:

```bash
show_arguments()
{
    for value in "$@"
    do
        echo "Value: $value"
    done
}

show_arguments "$@"
```

The inner function receives the same separate values.

## 13. Use `shift`

`shift` removes `$1` and moves the remaining positional parameters left.

Before:

```text
$1 = apple
$2 = banana
$3 = cherry
```

After one `shift`:

```text
$1 = banana
$2 = cherry
```

Example:

```bash
while [[ $# -gt 0 ]]
do
    echo "Processing: $1"
    shift
done
```

Use `shift 2` to remove two positional parameters.

## 14. Set Positional Parameters

`set --` replaces the current positional parameters:

```bash
set -- apple banana "red cherry"

echo "Count: $#"

for fruit in "$@"
do
    echo "$fruit"
done
```

The `--` ends options to `set`.

## 15. End of Options Marker

Many commands use `--` to indicate that option parsing has ended:

```bash
rm -- "$file"
cp -- "$source" "$destination"
```

This protects filenames beginning with `-`.

Your own script can also recognize `--` while parsing options.

## 16. Manual Named Options

Call:

```bash
./deploy.sh --app web --env test --version 1.2
```

Parse:

```bash
while [[ $# -gt 0 ]]
do
    case "$1" in
        --app)
            app="$2"
            shift 2
            ;;
        --env)
            environment="$2"
            shift 2
            ;;
        --version)
            version="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
    esac
done
```

Before using `$2`, ensure it exists:

```bash
if [[ $# -lt 2 ]]; then
    echo "Missing value for $1" >&2
    exit 1
fi
```

## 17. Short Options with `getopts`

Call:

```bash
./deploy.sh -a web -e test -v 1.2
```

Parse:

```bash
while getopts ":a:e:v:h" option
do
    case "$option" in
        a) app="$OPTARG" ;;
        e) environment="$OPTARG" ;;
        v) version="$OPTARG" ;;
        h)
            echo "Usage: $0 -a APP -e ENV -v VERSION"
            exit 0
            ;;
        :)
            echo "Option -$OPTARG requires a value" >&2
            exit 1
            ;;
        \?)
            echo "Unknown option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))
```

In `:a:e:v:h`:

- A letter followed by `:` requires a value.
- `h` is a flag without a value.
- A leading `:` enables custom missing-value handling.
- `OPTARG` contains the current option's value.
- `OPTIND` points to the next unprocessed argument.

## 18. Script Arguments and Function Arguments

The script can receive:

```bash
./demo.sh apple
```

Inside a function called with another value:

```bash
show_value()
{
    echo "Function argument: $1"
}

echo "Script argument: $1"
show_value "banana"
echo "Script argument again: $1"
```

Inside the function, `$1` temporarily means the function's first argument.
Outside it, `$1` still means the script's first argument.

## 19. Save Arguments in an Array

```bash
arguments=("$@")

echo "Saved count: ${#arguments[@]}"

for argument in "${arguments[@]}"
do
    echo "Saved: $argument"
done
```

Quoted `"${arguments[@]}"` preserves each element separately.

## 20. A Clear Usage Function

```bash
usage()
{
    echo "Usage: $0 SOURCE DESTINATION"
    echo "Example: $0 app.conf backups/"
}

if [[ $# -ne 2 ]]; then
    usage >&2
    exit 1
fi
```

A useful usage message contains:

- Script name
- Required arguments
- Optional arguments
- One realistic example

## 21. Multiplication Tables from Arguments

```bash
#!/bin/bash

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 NUMBER [NUMBER ...]" >&2
    exit 1
fi

for table in "$@"
do
    if [[ ! "$table" =~ ^-?[0-9]+$ ]]; then
        echo "Skipped invalid number: $table" >&2
        continue
    fi

    echo "=== Table of $table ==="

    for number in {1..10}
    do
        echo "$table x $number = $((table * number))"
    done

    echo
done
```

Run:

```bash
./multiplication_table.sh 2 5 10
```

## 22. Practical Deployment Arguments

```bash
#!/bin/bash

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 APP ENVIRONMENT VERSION" >&2
    exit 1
fi

app="$1"
environment="$2"
version="$3"

case "$environment" in
    dev|test|stage|prod)
        ;;
    *)
        echo "Invalid environment: $environment" >&2
        exit 1
        ;;
esac

echo "Application: $app"
echo "Environment: $environment"
echo "Version: $version"
echo "Deployment simulation completed"
```

This script simulates deployment safely without changing a real service.

## 23. Security Guidelines

- Quote every argument expansion.
- Validate file paths and numeric values.
- Never pass untrusted input to `eval`.
- Use `--` before filenames passed to commands.
- Do not place passwords directly in command-line arguments.
- Provide errors on stderr using `>&2`.
- Exit non-zero when validation fails.
- Avoid running an entire script with `sudo`.

Command-line arguments may be visible in process listings:

```bash
ps aux
```

Use secure prompts, protected files, or secret-management tools for passwords
and tokens.

## 24. Common Mistakes

### Spaces around assignment

Incorrect:

```bash
name = "$1"
```

Correct:

```bash
name="$1"
```

### Forgetting quotes

Incorrect:

```bash
for value in $@
```

Correct:

```bash
for value in "$@"
```

### Using `$10` instead of `${10}`

Correct:

```bash
echo "${10}"
```

### Using arguments before validation

Validate `$#` before depending on `$1`, `$2`, or later parameters.

### Checking `$?` too late

```bash
command
status=$?
echo "Status: $status"
```

## 25. Debugging and Verification

Check syntax:

```bash
bash -n script.sh
```

Trace execution:

```bash
bash -x script.sh apple banana
```

Show arguments safely:

```bash
counter=1

for argument in "$@"
do
    echo "Argument $counter: [$argument]"
    counter=$((counter + 1))
done
```

The brackets make leading or trailing spaces easier to notice.

## Final Learning Path

1. Use `$0`, `$1`, and `$2`.
2. Count arguments with `$#`.
3. Process all arguments with `"$@"`.
4. Quote values containing spaces.
5. Add defaults with `${1:-value}`.
6. Validate counts, numbers, and files.
7. Process arguments with loops and `shift`.
8. Add clear usage and error messages.
9. Parse long options with `case`.
10. Parse short options with `getopts`.
11. Build safe argument-driven automation.

