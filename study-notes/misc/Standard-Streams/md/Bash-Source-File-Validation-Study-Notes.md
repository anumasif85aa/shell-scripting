# Bash Source File Validation — English Study Notes

## Table of Contents

- [1. Code](#1-code)
- [2. Purpose of the Code](#2-purpose-of-the-code)
- [3. Variable Assignment](#3-variable-assignment)
- [4. File Validation Condition](#4-file-validation-condition)
- [5. The `-f` Operator](#5-the--f-operator)
- [6. The `!` Operator](#6-the--operator)
- [7. Error Message and `>&2`](#7-error-message-and-2)
- [8. `exit 1`](#8-exit-1)
- [9. `fi`](#9-fi)
- [10. Execution Outcomes](#10-execution-outcomes)
- [11. Complete Improved Script](#11-complete-improved-script)
- [12. Related File-Test Operators](#12-related-file-test-operators)
- [13. Common Mistakes](#13-common-mistakes)
- [14. Quick Summary](#14-quick-summary)

---

## 1. Code

```bash
source_file="abc.txt"

if [[ ! -f "$source_file" ]]; then
    echo "Error: source file does not exist." >&2
    exit 1
fi
```

---

## 2. Purpose of the Code

This code checks whether a **regular file** named `abc.txt` exists in the current working directory.

If the path does not exist as a regular file, the script:

1. Sends an error message to stderr.
2. Terminates with failure status `1`.

If the regular file exists, Bash skips the error block and continues with any commands placed after `fi`.

---

## 3. Variable Assignment

```bash
source_file="abc.txt"
```

This creates a variable named `source_file` and stores the following value in it:

```text
abc.txt
```

When Bash evaluates:

```bash
"$source_file"
```

the variable expands to:

```bash
"abc.txt"
```

### Why the Variable Is Quoted

The double quotes keep the expanded value together as one argument. This is important when a path contains spaces or wildcard characters.

For example:

```bash
source_file="student files/abc.txt"
```

This test remains safe because the variable is quoted:

```bash
[[ -f "$source_file" ]]
```

### Relative Path

`abc.txt` is a relative path. Therefore, Bash checks for the file in the current working directory.

Display the current working directory with:

```bash
pwd
```

List its files with:

```bash
ls
```

If the file is elsewhere, provide its relative or absolute path:

```bash
source_file="/home/khalid/documents/abc.txt"
```

Important: a relative path is resolved from the directory where you run the script, which may be different from the directory containing the script.

---

## 4. File Validation Condition

```bash
if [[ ! -f "$source_file" ]]; then
```

This line contains several important Bash elements:

| Part | Meaning |
|---|---|
| `if` | Begins a conditional decision. |
| `[[ ... ]]` | Bash conditional-expression syntax. |
| `!` | Negates, or reverses, the test result. |
| `-f` | Tests whether the path exists as a regular file. |
| `"$source_file"` | The quoted path that Bash checks. |
| `then` | Starts the commands that run when the condition is true. |

After variable expansion, the condition is conceptually equivalent to:

```bash
if [[ ! -f "abc.txt" ]]; then
```

Its plain-English meaning is:

> If `abc.txt` does not exist as a regular file, execute the `then` block.

---

## 5. The `-f` Operator

```bash
[[ -f "$source_file" ]]
```

The `-f` file-test operator checks whether the specified path:

1. Exists.
2. Refers to a regular file.

Create a test file:

```bash
touch abc.txt
```

Run the test and display its command status:

```bash
[[ -f "abc.txt" ]]
echo "$?"
```

Expected status:

```text
0
```

Status `0` means that the test succeeded: `abc.txt` exists as a regular file.

Important: `-f` is false for a directory. Use `-d` when you specifically need to test for a directory.

---

## 6. The `!` Operator

```bash
[[ ! -f "$source_file" ]]
```

`!` means **NOT**. It reverses the result produced by `-f`.

| Condition of `abc.txt` | Result of `-f` | Result of `! -f` |
|---|---|---|
| A regular file exists | True | False |
| The path is missing | False | True |
| The path is a directory | False | True |

Therefore:

```bash
if [[ ! -f "$source_file" ]]; then
```

means:

> Run the error-handling block if the source path is not an existing regular file.

---

## 7. Error Message and `>&2`

```bash
echo "Error: source file does not exist." >&2
```

This command displays:

```text
Error: source file does not exist.
```

### Meaning of `>&2`

By default, `echo` writes to stdout, which is file descriptor `1`.

```bash
>&2
```

redirects the command's stdout to the current destination of stderr, which is file descriptor `2`.

In simple terms:

> Treat this message as error output instead of normal output.

The explicit form is:

```bash
echo "Error: source file does not exist." 1>&2
```

Both forms are equivalent in this command.

To save the entire script's stderr in a file, run:

```bash
bash check_file.sh 2> error.log
```

Normal output remains on the terminal, while error output is written to `error.log`.

---

## 8. `exit 1`

```bash
exit 1
```

- `exit` immediately terminates the entire script.
- `1` is a nonzero command status.
- A nonzero status indicates failure.
- Commands after this line are not executed when this branch runs.

Check the script's final status with:

```bash
bash check_file.sh
echo "$?"
```

If validation fails, the expected status is:

```text
1
```

By convention:

| Status | Meaning |
|---:|---|
| `0` | Success |
| Nonzero | Failure or another exceptional condition |

---

## 9. `fi`

```bash
fi
```

`fi` closes the `if` statement.

Basic structure:

```bash
if condition; then
    commands
fi
```

An easy way to remember it is that `fi` is `if` written backward.

---

## 10. Execution Outcomes

### Outcome 1: `abc.txt` Is Missing

The execution flow is:

1. `abc.txt` is stored in `source_file`.
2. The `-f` test returns false.
3. `!` reverses false to true.
4. Bash executes the `then` block.
5. The error message goes to stderr.
6. `exit 1` terminates the script.

Output:

```text
Error: source file does not exist.
```

Final status:

```text
1
```

### Outcome 2: `abc.txt` Exists

Create the file:

```bash
touch abc.txt
```

Now:

1. The `-f` test returns true.
2. `!` reverses true to false.
3. Bash skips the error block.
4. The script continues after `fi`.

If there are no commands after `fi`, nothing is printed.

---

## 11. Complete Improved Script

```bash
#!/bin/bash

# Title: Source File Validation
# Purpose: Check whether abc.txt exists as a regular file.

source_file="abc.txt"

if [[ ! -f "$source_file" ]]; then
    echo "Error: source file does not exist: $source_file" >&2
    exit 1
fi

echo "Source file exists: $source_file"
exit 0
```

### When the File Exists

```text
Source file exists: abc.txt
```

Final status:

```text
0
```

### When the File Is Missing

```text
Error: source file does not exist: abc.txt
```

Final status:

```text
1
```

### Syntax Check

Before running the script, check its Bash syntax:

```bash
bash -n check_file.sh
```

If the syntax is valid, `bash -n` normally produces no output.

---

## 12. Related File-Test Operators

| Operator | What It Tests | Example |
|---|---|---|
| `-f` | The path exists as a regular file | `[[ -f "$path" ]]` |
| `-d` | The path exists as a directory | `[[ -d "$path" ]]` |
| `-e` | A filesystem entry exists at the path | `[[ -e "$path" ]]` |
| `-r` | The current process can read the path | `[[ -r "$path" ]]` |
| `-w` | The current process can write to the path | `[[ -w "$path" ]]` |
| `-x` | The current process can execute or traverse the path | `[[ -x "$path" ]]` |
| `-s` | The file exists and has a size greater than zero | `[[ -s "$path" ]]` |

### Difference Between `-f`, `-d`, and `-e`

```bash
[[ -f "$path" ]]
```

Checks for a regular file.

```bash
[[ -d "$path" ]]
```

Checks for a directory.

```bash
[[ -e "$path" ]]
```

Checks whether a filesystem entry exists at the path, regardless of whether it is a regular file, directory, or another supported file type.

---

## 13. Common Mistakes

### Mistake 1: Spaces Around `=` in an Assignment

Incorrect:

```bash
source_file = "abc.txt"
```

Correct:

```bash
source_file="abc.txt"
```

Bash variable assignments must not contain spaces around `=`.

### Mistake 2: Forgetting `!`

```bash
if [[ -f "$source_file" ]]; then
    echo "Error: source file does not exist." >&2
fi
```

This logic is reversed because it prints the error when the file exists.

To detect a missing regular file, use:

```bash
if [[ ! -f "$source_file" ]]; then
```

### Mistake 3: Treating `-f` as a General Existence Test

`-f` is true only for a regular file. Use:

- `-d` for a directory.
- `-e` for general filesystem-path existence.

### Mistake 4: Using `exit 0` After an Error

Incorrect:

```bash
echo "Error: file missing" >&2
exit 0
```

Status `0` reports success. Use a nonzero status for failure:

```bash
echo "Error: file missing" >&2
exit 1
```

### Mistake 5: Forgetting How Relative Paths Work

```bash
source_file="abc.txt"
```

This checks the current working directory, not necessarily the script's own directory.

Confirm the current directory with:

```bash
pwd
```

### Mistake 6: Leaving the Variable Unquoted

Avoid:

```bash
[[ ! -f $source_file ]]
```

Prefer:

```bash
[[ ! -f "$source_file" ]]
```

Quoting is a consistent and safe habit for pathname variables.

---

## 14. Quick Summary

```bash
source_file="abc.txt"
```

Stores the path `abc.txt` in a variable.

```bash
[[ ! -f "$source_file" ]]
```

Tests whether `abc.txt` is **not** an existing regular file.

```bash
echo "Error: source file does not exist." >&2
```

Sends an error message to stderr.

```bash
exit 1
```

Terminates the script and reports failure.

The complete meaning is:

> If `abc.txt` is not an existing regular file in the current working directory, send an error message to stderr and terminate the script with status `1`.

