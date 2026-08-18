# Bash Strings, Variables, Parameters, and Arguments — Study Notes

## Table of Contents

1. [String](#1-string)
2. [Variable](#2-variable)
3. [Parameter](#3-parameter)
4. [Argument](#4-argument)
5. [Positional Parameters](#5-positional-parameters)
6. [Parameter Expansion](#6-parameter-expansion)
7. [Default Values](#7-default-values)
8. [Command Substitution](#8-command-substitution)
9. [Empty String and Unset Variable](#9-empty-string-and-unset-variable)
10. [Practice Scripts](#10-practice-scripts)
11. [Common Mistakes](#11-common-mistakes)
12. [Quick Reference](#12-quick-reference)

---

## 1. String

A **string** is a sequence of text characters.

```bash
"Hello"
"Khalid Khan"
"123"
"red cherry"
""
```

- `"Hello"` is a string.
- `"123"` is also a string when it is treated as text.
- `"red cherry"` is a string containing a space.
- `""` is an **empty string** containing zero characters.

```bash
message="Hello, Khalid"
echo "$message"
```

Double quotes allow variable expansion and preserve spaces as part of one value. Single quotes prevent variable expansion:

```bash
name="Ali"
echo '$name'
```

The output is `$name`, not `Ali`.

---

## 2. Variable

A **variable** is a named container that stores a value.

```bash
name="Khalid"
course="Bash Scripting"
age="25"
```

- `name`, `course`, and `age` are variable names.
- Do not use `$` while assigning a value.
- Do not place spaces around `=`.
- Use `$` when retrieving the value.

```bash
echo "$name"
```

Correct:

```bash
name="Khalid"
```

Incorrect:

```bash
name = "Khalid"
```

Bash treats the incorrect form as a command named `name`, rather than as a variable assignment.

---

## 3. Parameter

A **parameter** is a Bash entity that holds a value. Named variables and positional parameters are both types of parameters.

Named parameter:

```bash
name="Ali"
echo "$name"
```

Positional parameters:

```bash
echo "$1"
echo "$2"
```

`$1` and `$2` receive arguments supplied on the command line.

---

## 4. Argument

An **argument** is an actual value passed to a command, script, or function.

```bash
bash greet_student.sh Khalid
```

Here:

- `Khalid` is the command-line argument.
- Inside the script, `$1` is the positional parameter.
- The value of `$1` is `Khalid`.

```text
On the command line: Khalid = argument
Inside the script:   $1     = positional parameter
```

Example with two arguments:

```bash
bash copy_file.sh abc.txt backup/
```

| Position | Parameter | Argument value |
|---|---|---|
| First | `$1` | `abc.txt` |
| Second | `$2` | `backup/` |

---

## 5. Positional Parameters

Bash stores command-line information in special parameters.

| Parameter | Meaning |
|---|---|
| `$0` | Script name or the path used to invoke it |
| `$1` | First argument |
| `$2` | Second argument |
| `${10}` | Tenth argument |
| `$#` | Total number of arguments |
| `"$@"` | All arguments, with each argument kept separate |
| `"$*"` | All arguments represented as one combined string |
| `$?` | Exit status of the previous command; it is not an argument |

### Why is `"$@"` recommended?

```bash
for item in "$@"
do
    echo "Item: $item"
done
```

If one argument is `"red cherry"`, quoted `"$@"` preserves it as one item.

---

## 6. Parameter Expansion

When Bash replaces `$name` or `${name}` with its value, the process is called **parameter expansion**.

```bash
name="Khalid"
echo "${name}"
```

Both `$name` and `${name}` retrieve the value. Braces clearly separate the parameter name from surrounding text:

```bash
fruit="apple"
echo "${fruit}s"
```

Output:

```text
apples
```

If you write `echo "$fruits"`, Bash searches for a variable named `fruits`. It does not automatically interpret it as `fruit` followed by `s`.

---

## 7. Default Values

### `${parameter:-default}`

This expansion means:

> Use the default value when the parameter is unset or empty.

```bash
name="${1:-Guest}"
```

- With `bash greet_student.sh Khalid`, the value is `Khalid`.
- With `bash greet_student.sh`, the value is `Guest`.

### `${1:-}`

```bash
source_file="${1:-}"
```

This means:

> Use the value of `$1` when it exists and is not empty; otherwise, use an empty string.

This form is safer than accessing `$1` directly when `set -u` is enabled.

---

## 8. Command Substitution

`$(command)` runs a command and captures its standard output.

```bash
current_date="$(date)"
echo "$current_date"
```

Here:

- `current_date` is a variable.
- `date` is a command.
- `$(date)` is command substitution.
- The command output is stored as a string.

### Parameter expansion versus command substitution

| Syntax | Name | Purpose |
|---|---|---|
| `${name}` | Parameter expansion | Retrieves or modifies a parameter value |
| `$(date)` | Command substitution | Runs a command and captures its output |

---

## 9. Empty String and Unset Variable

### Empty string

```bash
name=""
```

The variable exists, but its value contains zero characters.

### Unset variable

```bash
unset name
```

The variable is no longer defined.

### Checking for an empty value

```bash
if [[ -z "$name" ]]; then
    echo "Name is empty."
fi
```

`-z` succeeds when the string length is zero. With `set -u`, use this safer form:

```bash
if [[ -z "${name:-}" ]]; then
    echo "Name is empty or unset."
fi
```

---

## 10. Practice Scripts

### Script 1: Variables and strings

**Create: `student_information.sh`**

```bash
#!/bin/bash

# Title: Student Information
# Purpose: Store and display string values using variables.

student_name="Khalid"
course="Bash Scripting"

echo "Student: $student_name"
echo "Course: $course"

exit 0
```

Run:

```bash
bash student_information.sh
```

### Script 2: Argument and positional parameter

**Create: `greet_student.sh`**

```bash
#!/bin/bash

# Title: Greet Student
# Purpose: Receive a student name as the first argument.

name="${1:-}"

if [[ -z "$name" ]]; then
    echo "Usage: $0 NAME" >&2
    exit 1
fi

echo "Hello, $name!"
exit 0
```

Run:

```bash
bash greet_student.sh Khalid
```

If no name is supplied, the script prints its usage message to standard error and exits with status `1`.

### Script 3: All arguments

**Create: `show_arguments.sh`**

```bash
#!/bin/bash

# Title: Show Arguments
# Purpose: Display the script name, argument count, and every argument.

echo "Script name: $0"
echo "Argument count: $#"

item_number=1

for argument in "$@"
do
    echo "Argument $item_number: $argument"
    item_number=$((item_number + 1))
done

exit 0
```

Run:

```bash
bash show_arguments.sh apple banana "red cherry"
```

Output:

```text
Argument count: 3
Argument 1: apple
Argument 2: banana
Argument 3: red cherry
```

The exact script-name line depends on how you invoke the script.

### Script 4: Combining both expansions

**Create: `session_summary.sh`**

```bash
#!/bin/bash

# Title: Session Summary
# Purpose: Use parameter expansion and command substitution.

student_name="${1:-Guest}"
current_date="$(date)"

echo "Student: ${student_name}"
echo "Date: ${current_date}"

exit 0
```

This script uses:

- `${1:-Guest}` for parameter expansion with a default.
- `$(date)` for command substitution.
- `${student_name}` and `${current_date}` to retrieve variable values.

---

## 11. Common Mistakes

| Mistake | Problem | Correct form |
|---|---|---|
| `name = "Ali"` | Spaces make it an attempted command, not an assignment | `name="Ali"` |
| `echo $name` | Word splitting and pathname expansion may occur | `echo "$name"` |
| Treating an argument and parameter as identical | The supplied value and its receiver are different concepts | `Ali` is an argument; `$1` is a parameter |
| `$10` | Bash may interpret it as `$1` followed by literal `0` | `${10}` |
| Unquoted `$@` | An argument containing spaces may split | `"$@"` |
| Using single quotes around a variable | Single quotes prevent expansion | `echo "$name"` |

---

## 12. Quick Reference

| Term | Simple meaning | Example |
|---|---|---|
| String | A sequence of text characters | `"Hello World"` |
| Variable | A named container that stores a value | `name="Ali"` |
| Parameter | A Bash entity that holds a value | `$name`, `$1` |
| Argument | An actual value passed to a script | `bash script.sh Ali` |
| Positional parameter | A numbered parameter that receives an argument | `$1`, `$2` |
| Parameter expansion | Retrieves or transforms a parameter value | `${name}` |
| Default-value expansion | Supplies a fallback for an unset or empty value | `${1:-Guest}` |
| Command substitution | Runs a command and captures its output | `$(date)` |
| Empty string | A string containing zero characters | `""` |
| Unset variable | A variable that is not defined | `unset name` |

## Final Summary

Consider:

```bash
bash greet_student.sh Khalid
```

```text
greet_student.sh → script name
Khalid           → argument
$1               → positional parameter
name="$1"         → stores the argument in a variable
"Khalid"         → string value
${name}          → parameter expansion
```

> **Golden rule:** An argument is the actual value supplied from outside, while a parameter receives or holds that value inside the script.

