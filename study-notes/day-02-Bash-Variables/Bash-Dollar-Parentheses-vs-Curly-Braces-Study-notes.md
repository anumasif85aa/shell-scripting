# Bash `$()` vs `${}` — Study Notes

## Table of Contents

1. [Quick Comparison](#1-quick-comparison)
2. [`$()` — Command Substitution](#2----command-substitution)
3. [How `$()` Works](#3-how--works)
4. [Nested Command Substitution](#4-nested-command-substitution)
5. [`${}` — Parameter Expansion](#5----parameter-expansion)
6. [Useful Parameter Expansions](#6-useful-parameter-expansions)
7. [Using `$()` and `${}` Together](#7-using--and--together)
8. [Common Mistakes](#8-common-mistakes)
9. [Quick Reference](#9-quick-reference)
10. [Final Summary](#10-final-summary)

## Suggested Script Files

| Script name | Main concept |
|---|---|
| `command_substitution_date.sh` | Capture the output of `date` |
| `current_directory.sh` | Capture the output of `pwd` |
| `current_user.sh` | Use command substitution directly |
| `script_directory_path.sh` | Use nested command substitution |
| `variable_expansion.sh` | Read a variable with `${}` |
| `pluralize_fruit.sh` | Separate a variable name from following text |
| `default_name.sh` | Use a default value for `$1` |
| `empty_source_file.sh` | Use an empty default value safely |
| `string_length.sh` | Find the length of a string |
| `remove_file_extension.sh` | Remove a filename suffix |
| `extract_filename.sh` | Remove the directory prefix from a path |
| `replace_text.sh` | Replace text with parameter expansion |
| `array_element.sh` | Access one array element |
| `array_all_elements.sh` | Access and loop through all array elements |
| `array_indexes.sh` | Access all array indexes |
| `student_time.sh` | Use `$()` and `${}` together |
| `script_path_info.sh` | Display a script path and directory |
| `command_and_arithmetic_expansion.sh` | Compare command and arithmetic expansion |

---

## 1. Quick Comparison

In Bash, `$()` and `${}` perform completely different jobs.

| Syntax | Name | Purpose |
|---|---|---|
| `$(command)` | Command substitution | Runs a command and captures its standard output |
| `${variable}` | Parameter expansion | Expands, reads, or modifies a variable's value |

Memory rule:

```text
$()  → Run a command and capture its output
${}  → Expand or work with a variable
```

---

## 2. `$()` — Command Substitution

Basic syntax:

```bash
variable="$(command)"
```

Bash runs the command inside `$()` and replaces the complete expression with the command's output.

Example:

**Create: `command_substitution_date.sh`**

```bash
#!/bin/bash

today="$(date)"
echo "$today"

exit 0
```

Possible output:

```text
Tue Aug 18 10:30:00 CDT 2026
```

Another example:

**Create: `current_directory.sh`**

```bash
#!/bin/bash

current_directory="$(pwd)"
echo "$current_directory"

exit 0
```

Possible output:

```text
/home/khalid/nit/shell-scripting
```

### Direct use without a variable

Command substitution can also be placed directly inside a command:

**Create: `current_user.sh`**

```bash
#!/bin/bash

echo "Current user: $(whoami)"

exit 0
```

Possible output:

```text
Current user: khalid
```

### Important behavior

`$()` captures the command's **standard output**. It does not automatically capture error messages sent to standard error.

```bash
result="$(ls existing-file.txt)"
```

The successful `ls` output is stored in `result`.

Command substitution also removes trailing newline characters from the captured output.

---

## 3. How `$()` Works

Consider:

```bash
current_directory="$(pwd)"
```

Bash processes it in this order:

```text
1. Run pwd
2. Capture the standard output
3. Remove trailing newline characters
4. Assign the result to current_directory
```

The outer quotes are recommended:

```bash
current_directory="$(pwd)"
```

They protect the captured output from unwanted word splitting and filename expansion when it is used as part of an assignment or command argument.

---

## 4. Nested Command Substitution

Command substitutions can be placed inside other command substitutions.

Example:

**Create: `script_directory_path.sh`**

```bash
#!/bin/bash

script_directory="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "Script directory: $script_directory"
exit 0
```

The inner command substitution is:

```bash
$(dirname -- "${BASH_SOURCE[0]}")
```

It runs `dirname` and returns the directory portion of the script path.

The outer command substitution is:

```bash
$(cd -- "directory" && pwd)
```

It changes into that directory and captures its absolute path from `pwd`.

Inside-out flow:

```text
${BASH_SOURCE[0]}
        ↓
Expand the current script path
        ↓
dirname returns its directory
        ↓
cd enters that directory
        ↓
pwd prints the absolute path
        ↓
$() captures the path
```

---

## 5. `${}` — Parameter Expansion

Basic syntax:

```bash
${variable}
```

Parameter expansion tells Bash to expand a variable and produce its value.

Example:

**Create: `variable_expansion.sh`**

```bash
#!/bin/bash

name="Khalid"
echo "${name}"

exit 0
```

Output:

```text
Khalid
```

### Why use curly braces?

Curly braces clearly show where the variable name ends.

**Create: `pluralize_fruit.sh`**

```bash
#!/bin/bash

fruit="apple"
echo "${fruit}s"

exit 0
```

Output:

```text
apples
```

Without braces:

```bash
echo "$fruits"
```

Bash searches for a different variable named `fruits`.

### `$variable` vs `${variable}`

These usually produce the same result:

```bash
echo "$name"
echo "${name}"
```

Braces become necessary when:

- Text immediately follows the variable name.
- You are accessing array elements.
- You are using advanced parameter-expansion operators.
- Braces make a complex expression easier to read.

---

## 6. Useful Parameter Expansions

### 6.1 Read a variable

This concept is demonstrated in `variable_expansion.sh` above.

```bash
name="Khalid"
echo "${name}"
```

### 6.2 Use a default value

**Create: `default_name.sh`**

```bash
#!/bin/bash

name="${1:-Guest}"
echo "Hello, $name"

exit 0
```

If `$1` is unset or empty, `name` receives `Guest`.

```bash
bash greet.sh
```

Output:

```text
Hello, Guest
```

If an argument is supplied:

```bash
bash greet.sh Ali
```

Output:

```text
Hello, Ali
```

### 6.3 Produce an empty string safely

**Create: `empty_source_file.sh`**

```bash
#!/bin/bash

source_file="${1:-}"

echo "Source file: $source_file"
exit 0
```

If `$1` is missing or empty, `source_file` receives an empty string.

### 6.4 Find string length

**Create: `string_length.sh`**

```bash
#!/bin/bash

name="Khalid"
echo "${#name}"

exit 0
```

Output:

```text
6
```

### 6.5 Remove a suffix

**Create: `remove_file_extension.sh`**

```bash
#!/bin/bash

file="report.txt"
echo "${file%.txt}"

exit 0
```

Output:

```text
report
```

The `%` operator removes the shortest matching suffix pattern.

### 6.6 Remove a prefix

**Create: `extract_filename.sh`**

```bash
#!/bin/bash

path="/home/khalid/report.txt"
echo "${path##*/}"

exit 0
```

Output:

```text
report.txt
```

The `##*/` expression removes everything through the final `/`.

### 6.7 Replace text

**Create: `replace_text.sh`**

```bash
#!/bin/bash

message="Hello World"
echo "${message/World/Bash}"

exit 0
```

Output:

```text
Hello Bash
```

### 6.8 Access one array element

**Create: `array_element.sh`**

```bash
#!/bin/bash

friends=("Ali" "Omar" "Sara")
echo "${friends[1]}"

exit 0
```

Output:

```text
Omar
```

Bash array indexes begin at `0`.

### 6.9 Access all array elements

**Create: `array_all_elements.sh`**

```bash
#!/bin/bash

friends=("Ali" "Omar" "Sara")
echo "${friends[@]}"

for friend in "${friends[@]}"
do
    echo "$friend"
done

exit 0
```

Output:

```text
Ali Omar Sara
Ali
Omar
Sara
```

### 6.10 Access all array indexes

**Create: `array_indexes.sh`**

```bash
#!/bin/bash

friends=("Ali" "Omar" "Sara")

for index in "${!friends[@]}"
do
    echo "Index $index: ${friends[index]}"
done

exit 0
```

---

## 7. Using `$()` and `${}` Together

Example:

**Create: `student_time.sh`**

```bash
#!/bin/bash

name="Khalid"
current_time="$(date +%H:%M)"

echo "Student: ${name}"
echo "Time: ${current_time}"

exit 0
```

Explanation:

| Expression | Job |
|---|---|
| `$(date +%H:%M)` | Runs `date` and captures its output |
| `${name}` | Expands the value stored in `name` |
| `${current_time}` | Expands the captured time stored in `current_time` |

Another example:

**Create: `script_path_info.sh`**

```bash
#!/bin/bash

script_name="${BASH_SOURCE[0]}"
script_directory="$(dirname -- "$script_name")"

echo "Script: ${script_name}"
echo "Directory: ${script_directory}"

exit 0
```

Here, `${}` reads variable values while `$()` runs `dirname` and captures its output.

---

## 8. Common Mistakes

### Mistake 1: Using `${}` to run a command

Incorrect:

```bash
today="${date}"
```

This reads a variable named `date`; it does not run the `date` command.

Correct:

```bash
today="$(date)"
```

### Mistake 2: Using `$()` to read an ordinary variable

Incorrect:

```bash
name="Khalid"
echo "$(name)"
```

Bash tries to run a command named `name`.

Correct:

```bash
echo "${name}"
```

### Mistake 3: Omitting braces when text follows a variable

```bash
fruit="apple"
echo "$fruits"
```

Bash looks for a variable named `fruits`.

Correct:

```bash
echo "${fruit}s"
```

### Mistake 4: Incorrect array expansion

Incorrect:

```bash
echo "$friends[@]"
```

This is treated approximately as the first array element followed by the literal text `[@]`.

Correct:

```bash
echo "${friends[@]}"
```

### Mistake 5: Leaving expansions unquoted

Less safe:

```bash
echo $name
```

Preferred:

```bash
echo "$name"
```

For arrays:

```bash
for friend in "${friends[@]}"
do
    echo "$friend"
done
```

Quoting preserves values containing spaces, such as `"Red Cherry"`, as one item.

### Mistake 6: Confusing `$((...))` with `$(...)`

| Syntax | Purpose |
|---|---|
| `$(command)` | Command substitution |
| `$((expression))` | Arithmetic expansion |

Example:

**Create: `command_and_arithmetic_expansion.sh`**

```bash
#!/bin/bash

current_date="$(date)"
total=$((5 + 3))

echo "Date: $current_date"
echo "Total: $total"

exit 0
```

---

## 9. Quick Reference

| Requirement | Syntax | Example |
|---|---|---|
| Capture command output | `$(command)` | `user="$(whoami)"` |
| Expand a variable | `${variable}` | `echo "${user}"` |
| Append text to a value | `${variable}text` | `echo "${fruit}s"` |
| Default if unset or empty | `${variable:-default}` | `name="${1:-Guest}"` |
| Empty default | `${variable:-}` | `file="${1:-}"` |
| String length | `${#variable}` | `echo "${#name}"` |
| Remove suffix | `${variable%pattern}` | `${file%.txt}` |
| Remove longest prefix | `${variable##pattern}` | `${path##*/}` |
| Replace first match | `${variable/old/new}` | `${text/foo/bar}` |
| One array element | `${array[index]}` | `${friends[0]}` |
| All array elements | `${array[@]}` | `"${friends[@]}"` |
| All array indexes | `${!array[@]}` | `"${!friends[@]}"` |
| Arithmetic expansion | `$((expression))` | `total=$((5 + 3))` |

---

## 10. Final Summary

The final example uses the same command-substitution concept as `current_user.sh`.

```bash
current_user="$(whoami)"
echo "User: ${current_user}"
```

In this example:

1. `$(whoami)` runs a command and captures its output.
2. `${current_user}` expands the stored variable value.

Final memory rule:

```text
$()     = command output
${}     = variable value or parameter operation
$(( ))  = arithmetic calculation
```

The brackets identify the type of work Bash should perform. Parentheses in `$()` mean command substitution, while curly braces in `${}` mean parameter expansion.
