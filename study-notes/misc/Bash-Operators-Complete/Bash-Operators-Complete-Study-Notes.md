# Bash Operators — Complete Study Notes

## Summary

Bash operators allow a script to compare numbers and strings, test files, combine conditions, perform calculations, match patterns, redirect output, and control command execution.

The correct operator depends on the task and the Bash structure being used:

| Task type | Recommended structure | Example |
|---|---|---|
| Compare whole numbers | `[[ ... ]]` | `[[ "$age" -ge 18 ]]` |
| Compare strings | `[[ ... ]]` | `[[ "$name" == "Ali" ]]` |
| Validate with regex | `[[ ... ]]` | `[[ "$value" =~ ^[0-9]+$ ]]` |
| Check files or directories | `[[ ... ]]` | `[[ -f "$file" ]]` |
| Perform arithmetic | `(( ... ))` | `(( total = price * quantity ))` |
| Capture an arithmetic result | `$(( ... ))` | `result=$((5 + 3))` |
| Combine conditions | `[[ ... ]]` | `[[ "$age" -ge 18 && "$citizen" == "yes" ]]` |
| Run commands based on success | Command list | `mkdir backup && echo "Created"` |
| Redirect normal output | Redirection | `command > output.txt` |
| Redirect errors | Redirection | `command 2> error.txt` |

---

## Table of Contents

1. [Choosing the correct operator](#1-choosing-the-correct-operator)
2. [Numeric comparison operators](#2-numeric-comparison-operators)
3. [String comparison operators](#3-string-comparison-operators)
4. [Regular-expression operator](#4-regular-expression-operator)
5. [Logical operators](#5-logical-operators)
6. [File-test operators](#6-file-test-operators)
7. [Arithmetic operators](#7-arithmetic-operators)
8. [Arithmetic comparison operators](#8-arithmetic-comparison-operators)
9. [Assignment operators](#9-assignment-operators)
10. [Pattern-matching operators](#10-pattern-matching-operators)
11. [Command-control operators](#11-command-control-operators)
12. [Redirection operators](#12-redirection-operators)
13. [Task-based operator guide](#13-task-based-operator-guide)
14. [Common mistakes](#14-common-mistakes)
15. [Complete practice script](#15-complete-practice-script)
16. [Quick revision table](#16-quick-revision-table)
17. [Practice tasks](#17-practice-tasks)

---

## 1. Choosing the correct operator

Bash provides different structures for different kinds of work.

### `[[ ... ]]` — conditional testing

Use `[[ ... ]]` for:

- Numeric comparisons
- String comparisons
- File tests
- Regex matching
- Multiple logical conditions

Example:

```bash
if [[ "$age" -ge 18 ]]; then
    echo "Adult"
fi
```

### `(( ... ))` — arithmetic evaluation

Use `(( ... ))` for:

- Calculations
- Arithmetic comparisons
- Counters
- Even or odd checking

Example:

```bash
if (( number % 2 == 0 )); then
    echo "Even"
fi
```

### `$(( ... ))` — arithmetic expansion

Use `$(( ... ))` when the calculated result must be stored or used in a command.

```bash
result=$((5 + 3))
echo "$result"
```

### Commands with `&&` and `||`

Use them to run a command based on the success or failure of another command.

```bash
mkdir backup && echo "Directory created"
```

```bash
cp report.txt backup/ || echo "Copy failed" >&2
```

[Back to Table of Contents](#table-of-contents)

---

## 2. Numeric comparison operators

Use these operators inside `[[ ... ]]` when comparing whole numbers.

| Operator | Meaning | Example |
|---|---|---|
| `-eq` | Equal to | `[[ "$a" -eq "$b" ]]` |
| `-ne` | Not equal to | `[[ "$a" -ne "$b" ]]` |
| `-gt` | Greater than | `[[ "$a" -gt "$b" ]]` |
| `-ge` | Greater than or equal to | `[[ "$a" -ge "$b" ]]` |
| `-lt` | Less than | `[[ "$a" -lt "$b" ]]` |
| `-le` | Less than or equal to | `[[ "$a" -le "$b" ]]` |

### Equal to: `-eq`

```bash
number=10

if [[ "$number" -eq 10 ]]; then
    echo "Number is 10"
fi
```

### Not equal to: `-ne`

```bash
number=8

if [[ "$number" -ne 10 ]]; then
    echo "Number is not 10"
fi
```

### Greater than: `-gt`

```bash
marks=85

if [[ "$marks" -gt 80 ]]; then
    echo "Excellent"
fi
```

### Greater than or equal to: `-ge`

```bash
age=18

if [[ "$age" -ge 18 ]]; then
    echo "Eligible"
fi
```

### Less than: `-lt`

```bash
temperature=20

if [[ "$temperature" -lt 32 ]]; then
    echo "Below freezing point in Fahrenheit"
fi
```

### Less than or equal to: `-le`

```bash
attempts=3

if [[ "$attempts" -le 3 ]]; then
    echo "Attempt allowed"
fi
```

### Complete numeric example

```bash
#!/bin/bash

read -r -p "Enter your age: " age

if [[ ! "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: enter digits only." >&2
    exit 1
fi

if [[ "$age" -ge 18 ]]; then
    echo "Adult"
else
    echo "Minor"
fi
```

[Back to Table of Contents](#table-of-contents)

---

## 3. String comparison operators

Use these operators inside `[[ ... ]]` when working with text.

| Operator | Meaning | Example |
|---|---|---|
| `==` | Strings are equal | `[[ "$name" == "Ali" ]]` |
| `=` | Strings are equal | `[[ "$name" = "Ali" ]]` |
| `!=` | Strings are not equal | `[[ "$name" != "Ali" ]]` |
| `-z` | String has zero length | `[[ -z "$name" ]]` |
| `-n` | String has non-zero length | `[[ -n "$name" ]]` |
| `<` | Alphabetically before | `[[ "$a" < "$b" ]]` |
| `>` | Alphabetically after | `[[ "$a" > "$b" ]]` |

### Equal strings

```bash
color="green"

if [[ "$color" == "green" ]]; then
    echo "Go"
fi
```

### Different strings

```bash
username="khalid"

if [[ "$username" != "root" ]]; then
    echo "You are not root"
fi
```

### Empty string: `-z`

```bash
name=""

if [[ -z "$name" ]]; then
    echo "Name is empty"
fi
```

### Non-empty string: `-n`

```bash
name="Ali"

if [[ -n "$name" ]]; then
    echo "Name: $name"
fi
```

### Alphabetical comparison

```bash
first="apple"
second="banana"

if [[ "$first" < "$second" ]]; then
    echo "$first comes before $second"
fi
```

Important: `<` and `>` compare text alphabetically inside `[[ ... ]]`. They do not perform numeric comparison there.

[Back to Table of Contents](#table-of-contents)

---

## 4. Regular-expression operator

The `=~` operator matches a string against a regular expression.

| Operator | Meaning |
|---|---|
| `=~` | Regex match |

### Digits-only validation

```bash
number="25"

if [[ "$number" =~ ^[0-9]+$ ]]; then
    echo "Valid digits-only value"
else
    echo "Invalid value"
fi
```

### Regex breakdown

```regex
^[0-9]+$
```

| Part | Meaning |
|---|---|
| `^` | Beginning of the string |
| `[0-9]` | Any digit from `0` through `9` |
| `+` | One or more digits |
| `$` | End of the string |

### Allow a negative whole number

```bash
if [[ "$number" =~ ^-?[0-9]+$ ]]; then
    echo "Valid whole number"
fi
```

`-?` means that the minus sign is optional.

### Validate a simple username

```bash
username="ali_123"

if [[ "$username" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
    echo "Valid username"
else
    echo "Invalid username"
fi
```

### Important quoting rule

Quote the value:

```bash
"$number"
```

Do not quote the regex:

```bash
[[ "$number" =~ ^[0-9]+$ ]]
```

Avoid:

```bash
[[ "$number" =~ "^[0-9]+$" ]]
```

[Back to Table of Contents](#table-of-contents)

---

## 5. Logical operators

Logical operators combine or reverse conditions.

| Operator | Meaning | Requirement |
|---|---|---|
| `&&` | AND | Both conditions must be true |
| `\|\|` | OR | At least one condition must be true |
| `!` | NOT | Reverses the result |

### AND operator: `&&`

```bash
age=25
citizen="yes"

if [[ "$age" -ge 18 && "$citizen" == "yes" ]]; then
    echo "Eligible"
fi
```

Both conditions must be true.

### OR operator: `||`

```bash
day="Sunday"

if [[ "$day" == "Saturday" || "$day" == "Sunday" ]]; then
    echo "Weekend"
fi
```

Only one condition needs to be true.

### NOT operator: `!`

```bash
file="report.txt"

if [[ ! -f "$file" ]]; then
    echo "File does not exist"
fi
```

`-f "$file"` asks whether it is a regular file. `!` reverses the answer.

### Truth table

| Condition A | Condition B | `A && B` | `A \|\| B` |
|---|---|---|---|
| True | True | True | True |
| True | False | False | True |
| False | True | False | True |
| False | False | False | False |

[Back to Table of Contents](#table-of-contents)

---

## 6. File-test operators

File-test operators examine files, directories, links, and permissions.

| Operator | Checks whether |
|---|---|
| `-e` | Path exists |
| `-f` | Path is a regular file |
| `-d` | Path is a directory |
| `-r` | Path is readable |
| `-w` | Path is writable |
| `-x` | Path is executable |
| `-s` | File exists and is not empty |
| `-L` | Path is a symbolic link |
| `-b` | Path is a block device |
| `-c` | Path is a character device |
| `-p` | Path is a named pipe |
| `-S` | Path is a socket |
| `-nt` | First file is newer than second |
| `-ot` | First file is older than second |
| `-ef` | Both paths refer to the same file |

### Check whether a path exists

```bash
path="report.txt"

if [[ -e "$path" ]]; then
    echo "Path exists"
fi
```

### Check for a regular file

```bash
file="report.txt"

if [[ -f "$file" ]]; then
    echo "Regular file exists"
fi
```

### Check for a directory

```bash
directory="backup"

if [[ -d "$directory" ]]; then
    echo "Directory exists"
fi
```

### Check whether a file contains data

```bash
log_file="error.log"

if [[ -s "$log_file" ]]; then
    echo "Log file is not empty"
fi
```

### Check multiple file requirements

```bash
script="deploy.sh"

if [[ -f "$script" && -r "$script" && -x "$script" ]]; then
    echo "Script exists, is readable, and is executable"
else
    echo "Script is not ready" >&2
fi
```

### Compare modification times

```bash
if [[ "source.txt" -nt "backup.txt" ]]; then
    echo "The source file is newer"
fi
```

[Back to Table of Contents](#table-of-contents)

---

## 7. Arithmetic operators

Use arithmetic operators inside `(( ... ))` or `$(( ... ))`.

| Operator | Meaning | Example |
|---|---|---|
| `+` | Addition | `result=$((5 + 3))` |
| `-` | Subtraction | `result=$((5 - 3))` |
| `*` | Multiplication | `result=$((5 * 3))` |
| `/` | Integer division | `result=$((10 / 2))` |
| `%` | Remainder | `remainder=$((7 % 2))` |
| `**` | Power | `result=$((2 ** 3))` |
| `++` | Increase by one | `((count++))` |
| `--` | Decrease by one | `((count--))` |

### Addition

```bash
result=$((5 + 3))
echo "$result"
```

Output:

```text
8
```

### Multiplication

```bash
price=10
quantity=4
total=$((price * quantity))

echo "Total: $total"
```

### Integer division

```bash
result=$((7 / 2))
echo "$result"
```

Output:

```text
3
```

Bash integer arithmetic discards the decimal part.

### Remainder and even/odd checking

```bash
number=7

if (( number % 2 == 0 )); then
    echo "$number is even"
else
    echo "$number is odd"
fi
```

### Counter

```bash
count=1

for item in apple banana cherry
do
    echo "Item $count: $item"
    ((count++))
done
```

Output:

```text
Item 1: apple
Item 2: banana
Item 3: cherry
```

[Back to Table of Contents](#table-of-contents)

---

## 8. Arithmetic comparison operators

Use these operators inside `(( ... ))`.

| Operator | Meaning | Example |
|---|---|---|
| `==` | Equal to | `(( a == b ))` |
| `!=` | Not equal to | `(( a != b ))` |
| `>` | Greater than | `(( a > b ))` |
| `>=` | Greater than or equal to | `(( a >= b ))` |
| `<` | Less than | `(( a < b ))` |
| `<=` | Less than or equal to | `(( a <= b ))` |
| `&&` | Arithmetic AND | `(( a > 0 && b > 0 ))` |
| `\|\|` | Arithmetic OR | `(( a > 0 \|\| b > 0 ))` |
| `!` | Arithmetic NOT | `(( ! a ))` |

Example:

```bash
number=15

if (( number >= 10 )); then
    echo "Number is 10 or greater"
fi
```

### Two arithmetic conditions

```bash
number=25

if (( number >= 10 && number <= 50 )); then
    echo "Number is between 10 and 50"
fi
```

Inside `(( ... ))`, variable names normally do not require `$`:

```bash
(( number >= 10 ))
```

[Back to Table of Contents](#table-of-contents)

---

## 9. Assignment operators

Assignment operators store or update values.

| Operator | Meaning | Example |
|---|---|---|
| `=` | Assign a value | `name="Ali"` |
| `+=` | Add or append | `((number += 5))` |
| `-=` | Subtract and assign | `((number -= 5))` |
| `*=` | Multiply and assign | `((number *= 2))` |
| `/=` | Divide and assign | `((number /= 2))` |
| `%=` | Save the remainder | `((number %= 2))` |

### Basic assignment

```bash
course="Bash Scripting"
```

Do not add spaces around `=`:

```bash
course = "Bash Scripting"
```

The above line is incorrect.

### Add and assign

```bash
number=10
((number += 5))

echo "$number"
```

Output:

```text
15
```

### String append with `+=`

```bash
message="Hello"
message+=", Doston"

echo "$message"
```

Output:

```text
Hello, Doston
```

[Back to Table of Contents](#table-of-contents)

---

## 10. Pattern-matching operators

Inside `[[ ... ]]`, `==` can also compare a string against a glob pattern.

| Pattern | Meaning |
|---|---|
| `*` | Zero or more characters |
| `?` | Exactly one character |
| `[abc]` | One character from the set |
| `[0-9]` | One digit |

### Match a file extension

```bash
file="report.txt"

if [[ "$file" == *.txt ]]; then
    echo "Text file"
fi
```

Do not quote the pattern if you want pattern matching:

```bash
[[ "$file" == *.txt ]]
```

Quoting it:

```bash
[[ "$file" == "*.txt" ]]
```

checks for the literal text `*.txt`.

### Match a prefix

```bash
username="admin_khalid"

if [[ "$username" == admin_* ]]; then
    echo "Administrative account pattern"
fi
```

### Glob versus regex

| Feature | Glob | Regex |
|---|---|---|
| Operator | `==` | `=~` |
| Any number of characters | `*` | `.*` |
| One character | `?` | `.` |
| Example | `[[ "$file" == *.txt ]]` | `[[ "$file" =~ \.txt$ ]]` |

[Back to Table of Contents](#table-of-contents)

---

## 11. Command-control operators

These operators control when commands run.

| Operator | Meaning |
|---|---|
| `&&` | Run the next command only if the first succeeds |
| `\|\|` | Run the next command only if the first fails |
| `;` | Run the next command regardless of the first result |
| `&` | Run a command in the background |
| `\|` | Send one command's stdout to another command |

### Run after success: `&&`

```bash
mkdir backup && echo "Directory created"
```

The message runs only if `mkdir` succeeds.

### Run after failure: `||`

```bash
mkdir backup || echo "Directory could not be created" >&2
```

The error message runs only if `mkdir` fails.

### Run regardless: `;`

```bash
echo "First command"; echo "Second command"
```

Both commands run.

### Background execution: `&`

```bash
long_task.sh &
```

The command runs in the background, allowing the terminal to accept another command.

### Pipeline: `|`

```bash
ps aux | grep bash
```

The standard output of `ps aux` becomes the standard input of `grep`.

### Important difference

Inside `[[ ... ]]`:

```bash
[[ condition1 && condition2 ]]
```

`&&` combines conditions.

Between commands:

```bash
command1 && command2
```

`&&` controls whether the second command runs.

[Back to Table of Contents](#table-of-contents)

---

## 12. Redirection operators

Redirection operators control where input, normal output, and errors go.

| Operator | Meaning | Example |
|---|---|---|
| `>` | Send stdout to a file and overwrite it | `echo "Hello" > output.txt` |
| `>>` | Append stdout to a file | `echo "Hello" >> output.txt` |
| `2>` | Send stderr to a file and overwrite it | `ls /missing 2> error.txt` |
| `2>>` | Append stderr to a file | `ls /missing 2>> error.txt` |
| `<` | Read stdin from a file | `sort < names.txt` |
| `2>&1` | Send stderr to the same destination as stdout | `command > all.log 2>&1` |
| `>&2` | Send an output message to stderr | `echo "Error" >&2` |
| `/dev/null` | Discard output | `command > /dev/null 2>&1` |

### Standard streams

| Stream | File descriptor | Purpose |
|---|---:|---|
| Standard input | `0` | Input |
| Standard output | `1` | Normal output |
| Standard error | `2` | Error output |

### Overwrite a file

```bash
echo "First line" > output.txt
```

### Append to a file

```bash
echo "Second line" >> output.txt
```

### Save an error

```bash
ls -l /missing 2> error.txt
```

### Save normal output and errors together

```bash
command > all-output.log 2>&1
```

Redirection order matters. First, stdout is sent to `all-output.log`; then stderr is sent to the current destination of stdout.

### Send a custom message to stderr

```bash
echo "Error: file is missing" >&2
```

[Back to Table of Contents](#table-of-contents)

---

## 13. Task-based operator guide

Use this section when you know the task but are unsure which operator to choose.

| Task | Operator or test | Example |
|---|---|---|
| Check whether two numbers are equal | `-eq` | `[[ "$a" -eq "$b" ]]` |
| Check whether a number is larger | `-gt` | `[[ "$a" -gt "$b" ]]` |
| Check minimum age | `-ge` | `[[ "$age" -ge 18 ]]` |
| Check maximum attempts | `-le` | `[[ "$attempts" -le 3 ]]` |
| Check whether text is equal | `==` | `[[ "$color" == "green" ]]` |
| Check whether text is different | `!=` | `[[ "$user" != "root" ]]` |
| Check empty input | `-z` | `[[ -z "$name" ]]` |
| Check non-empty input | `-n` | `[[ -n "$name" ]]` |
| Validate digits only | `=~` | `[[ "$value" =~ ^[0-9]+$ ]]` |
| Validate a whole number | `=~` | `[[ "$value" =~ ^-?[0-9]+$ ]]` |
| Require two conditions | `&&` | `[[ "$age" -ge 18 && "$status" == "active" ]]` |
| Accept either condition | `\|\|` | `[[ "$day" == "Sat" \|\| "$day" == "Sun" ]]` |
| Reverse a condition | `!` | `[[ ! -f "$file" ]]` |
| Check whether a path exists | `-e` | `[[ -e "$path" ]]` |
| Check a regular file | `-f` | `[[ -f "$file" ]]` |
| Check a directory | `-d` | `[[ -d "$directory" ]]` |
| Check execute permission | `-x` | `[[ -x "$script" ]]` |
| Check a non-empty file | `-s` | `[[ -s "$log_file" ]]` |
| Add numbers | `+` | `total=$((a + b))` |
| Multiply numbers | `*` | `total=$((price * quantity))` |
| Check even or odd | `%` | `(( number % 2 == 0 ))` |
| Increase a counter | `++` | `((count++))` |
| Run after success | `&&` | `mkdir backup && echo "Created"` |
| Run after failure | `\|\|` | `cp file backup/ \|\| echo "Failed"` |
| Save normal output | `>` | `command > output.txt` |
| Save error output | `2>` | `command 2> error.txt` |
| Append error output | `2>>` | `command 2>> error.txt` |

### Task: Validate and compare an age

Required operator types:

1. Regex operator `=~` to validate digits
2. Numeric operator `-ge` to compare the age

```bash
if [[ ! "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: enter a valid age." >&2
    exit 1
fi

if [[ "$age" -ge 18 ]]; then
    echo "Adult"
else
    echo "Minor"
fi
```

### Task: Verify a script is ready

Required operator types:

- `-f` for a regular file
- `-r` for readable
- `-x` for executable
- `&&` to require all tests

```bash
if [[ -f "$script" && -r "$script" && -x "$script" ]]; then
    echo "Script is ready"
else
    echo "Script is not ready" >&2
fi
```

### Task: Create a directory and report failure

Required command-control operators:

```bash
mkdir "$directory" &&
    echo "Directory created: $directory"
```

Or:

```bash
mkdir "$directory" ||
    echo "Error: directory creation failed" >&2
```

For clearer error handling, an `if` statement is often better:

```bash
if mkdir "$directory"; then
    echo "Directory created: $directory"
else
    echo "Error: directory creation failed" >&2
    exit 1
fi
```

[Back to Table of Contents](#table-of-contents)

---

## 14. Common mistakes

### Mistake 1: Using string comparison for numbers

Avoid:

```bash
[[ "$number" > 10 ]]
```

Inside `[[ ... ]]`, this compares strings alphabetically.

Use:

```bash
[[ "$number" -gt 10 ]]
```

Or:

```bash
(( number > 10 ))
```

### Mistake 2: Using numeric operators on unvalidated input

Risky:

```bash
if [[ "$input" -gt 10 ]]; then
```

Validate first:

```bash
if [[ ! "$input" =~ ^-?[0-9]+$ ]]; then
    echo "Error: enter a whole number." >&2
    exit 1
fi
```

### Mistake 3: Adding spaces around assignment `=`

Incorrect:

```bash
name = "Ali"
```

Correct:

```bash
name="Ali"
```

### Mistake 4: Quoting the regex

Avoid:

```bash
[[ "$number" =~ "^[0-9]+$" ]]
```

Use:

```bash
[[ "$number" =~ ^[0-9]+$ ]]
```

### Mistake 5: Confusing `-z` and `-n`

```bash
[[ -z "$name" ]]
```

means empty.

```bash
[[ -n "$name" ]]
```

means not empty.

### Mistake 6: Forgetting quotes around variables

Recommended:

```bash
[[ -f "$file" ]]
```

```bash
cp -- "$source" "$destination"
```

Quotes preserve spaces in filenames and values.

### Mistake 7: Confusing test `&&` with command `&&`

Combining tests:

```bash
[[ -f "$file" && -r "$file" ]]
```

Controlling commands:

```bash
cp "$file" backup/ && echo "Copied"
```

### Mistake 8: Assuming regex validation solves leading-zero arithmetic

The regex:

```regex
^[0-9]+$
```

accepts `08` because it contains digits only. Bash arithmetic may interpret a leading zero as octal, causing an error for digits `8` or `9`.

For beginner practice, avoid unnecessary leading zeros when performing arithmetic.

[Back to Table of Contents](#table-of-contents)

---

## 15. Complete practice script

This example combines arguments, regex, numeric comparisons, arithmetic, strings, files, logical operators, and stderr.

```bash
#!/bin/bash

if [[ "$#" -ne 2 ]]; then
    echo "Usage: $0 NAME NUMBER" >&2
    exit 1
fi

name="$1"
number="$2"

if [[ -z "$name" ]]; then
    echo "Error: name cannot be empty." >&2
    exit 1
fi

if [[ ! "$number" =~ ^-?[0-9]+$ ]]; then
    echo "Error: enter a whole number." >&2
    exit 1
fi

echo "Name: $name"
echo "Number: $number"

if [[ "$number" -gt 0 ]]; then
    echo "$number is positive."
elif [[ "$number" -lt 0 ]]; then
    echo "$number is negative."
else
    echo "$number is zero."
fi

if (( number % 2 == 0 )); then
    echo "$number is even."
else
    echo "$number is odd."
fi

output_file="result.txt"

if echo "$name: $number" > "$output_file"; then
    echo "Result saved in $output_file"
else
    echo "Error: result could not be saved." >&2
    exit 1
fi
```

Run:

```bash
bash operator-practice.sh "Ali Khan" 7
```

Output:

```text
Name: Ali Khan
Number: 7
7 is positive.
7 is odd.
Result saved in result.txt
```

[Back to Table of Contents](#table-of-contents)

---

## 16. Quick revision table

| Category | Main operators | Typical structure |
|---|---|---|
| Numeric comparison | `-eq -ne -gt -ge -lt -le` | `[[ "$a" -gt "$b" ]]` |
| String comparison | `== = != -z -n < >` | `[[ "$name" == "Ali" ]]` |
| Regex | `=~` | `[[ "$value" =~ ^[0-9]+$ ]]` |
| Logical | `&& \|\| !` | `[[ condition1 && condition2 ]]` |
| File tests | `-e -f -d -r -w -x -s -L` | `[[ -f "$file" ]]` |
| Arithmetic | `+ - * / % ** ++ --` | `(( count++ ))` |
| Arithmetic comparison | `== != > >= < <=` | `(( number >= 10 ))` |
| Assignment | `= += -= *= /= %=` | `(( total += value ))` |
| Pattern matching | `* ? [abc]` | `[[ "$file" == *.txt ]]` |
| Command control | `&& \|\| ; & \|` | `command1 && command2` |
| Redirection | `> >> 2> 2>> < 2>&1 >&2` | `command 2> error.txt` |

### Final memory guide

```text
Numbers       → -eq, -gt, -lt inside [[ ]]
Text          → ==, !=, -z, -n inside [[ ]]
Regex         → =~ inside [[ ]]
Files         → -f, -d, -e, -r, -w, -x inside [[ ]]
Calculations  → (( )) or $(( ))
Logic         → &&, ||, !
Command flow  → command1 && command2
Output        → >, >>, 2>, 2>>
```

[Back to Table of Contents](#table-of-contents)

---

## 17. Practice tasks

### Task 1 — Age validation

Create a script that:

1. Accepts one age argument.
2. Verifies that it contains digits only.
3. Displays `Adult` when the age is `18` or greater.
4. Displays `Minor` otherwise.

Operators required:

```text
=~  -ge
```

### Task 2 — File checker

Ask the user for a path and report whether it is:

- A regular file
- A directory
- Another kind of path
- Missing

Operators required:

```text
-e  -f  -d
```

### Task 3 — Even or odd

Accept one whole number and display whether it is even or odd.

Operators required:

```text
=~  %  ==
```

### Task 4 — Login validation

Accept a username and account status. Allow login only when:

- The username is not empty
- The account status equals `active`

Operators required:

```text
-n  ==  &&
```

### Task 5 — Safe copy

Copy a file and:

- Display success only if `cp` succeeds
- Send the failure message to stderr
- Exit with status `1` on failure

Operator or feature required:

```text
if command; then
>&2
exit 1
```

### Task 6 — Numbered function arguments

Create a function that prints:

```text
Item 1: apple
Item 2: banana
Item 3: red cherry
```

Operators required:

```text
((count++))
```

[Back to Table of Contents](#table-of-contents)
