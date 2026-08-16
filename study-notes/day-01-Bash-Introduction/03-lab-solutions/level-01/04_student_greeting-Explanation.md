# Bash Study Notes: Student Name Input and Validation

## Script

```bash
#!/bin/bash

# Read and validate a student name.

course="Bash Scripting"

read -r -p "Enter student name: " student_name

if [[ -z "$student_name" ]]; then
    echo "Error: student name cannot be empty." >&2
    exit 1
fi

echo "Student: $student_name"
echo "Course: $course"
```

## Purpose

This script:

1. Stores a course name in a variable.
2. Asks the user to enter a student's name.
3. Checks whether the user entered an empty value.
4. Displays an error and stops if the name is empty.
5. Displays the student's name and course when the input is valid.

---

## 1. Shebang

```bash
#!/bin/bash
```

The shebang tells Linux to execute the script using the Bash interpreter.

If the script has execute permission, it can be run with:

```bash
./student.sh
```

It can also be run explicitly with Bash:

```bash
bash student.sh
```

---

## 2. Comment

```bash
# Read and validate a student name.
```

A line beginning with `#` is a comment. It documents the code and is not executed by Bash.

---

## 3. Course variable

```bash
course="Bash Scripting"
```

This creates a variable named `course` and assigns it the value `Bash Scripting`.

Important Bash variable rules:

- Do not place spaces around `=`.
- Use quotes when a value contains spaces.
- Refer to the value using `$course`.

Correct:

```bash
course="Bash Scripting"
```

Incorrect:

```bash
course = "Bash Scripting"
```

---

## 4. Read the student name

```bash
read -r -p "Enter student name: " student_name
```

This command reads input from the keyboard and stores it in the `student_name` variable.

| Part | Meaning |
|---|---|
| `read` | Receives input from the user |
| `-r` | Treats backslashes as normal characters |
| `-p` | Displays a prompt before reading input |
| `"Enter student name: "` | The message shown to the user |
| `student_name` | Variable that stores the input |

Example:

```text
Enter student name: Ali Khan
```

Bash stores:

```bash
student_name="Ali Khan"
```

The `-r` option is recommended because it prevents `read` from interpreting backslashes as escape characters.

---

## 5. Check for empty input

```bash
if [[ -z "$student_name" ]]; then
```

This condition checks whether the value stored in `student_name` has zero characters.

| Part | Meaning |
|---|---|
| `if` | Starts a conditional statement |
| `[[ ... ]]` | Performs a Bash conditional test |
| `-z` | True when the string has zero length |
| `"$student_name"` | Safely expands the variable |
| `then` | Starts commands that run when the condition is true |

In simple language:

> If the student name is empty, run the error-handling commands.

Quoting the variable is a good safety practice:

```bash
"$student_name"
```

It preserves spaces and special characters in the entered name.

---

## 6. Send the error to stderr

```bash
echo "Error: student name cannot be empty." >&2
```

This prints an error message to standard error.

| Stream | File descriptor | Purpose |
|---|---:|---|
| Standard input | `0` | Receives input |
| Standard output | `1` | Displays normal results |
| Standard error | `2` | Displays error messages |

The redirection:

```bash
>&2
```

means:

> Send this output to file descriptor 2, which is stderr.

This allows normal output and error messages to be redirected separately.

Example:

```bash
bash student.sh 2> error.log
```

If the name is empty, the error message is saved in `error.log`.

---

## 7. Stop with a failure status

```bash
exit 1
```

This immediately terminates the entire script and returns status `1` to the shell.

| Status | Meaning |
|---:|---|
| `0` | Success |
| Non-zero | Failure or another special condition |

After running the script, check its status with:

```bash
echo $?
```

If the name was empty, the result will be:

```text
1
```

---

## 8. Close the conditional

```bash
fi
```

`fi` closes the `if` statement.

The structure is:

```bash
if condition; then
    commands
fi
```

---

## 9. Display valid information

```bash
echo "Student: $student_name"
echo "Course: $course"
```

These commands run only when the name is not empty.

The variables are expanded inside double quotes:

```bash
$student_name
$course
```

---

## Successful execution

```text
Enter student name: Ali Khan
Student: Ali Khan
Course: Bash Scripting
```

The final exit status is `0` because the last `echo` command succeeds:

```bash
echo $?
```

Output:

```text
0
```

An explicit `exit 0` is not required at the end of this script.

---

## Failed execution

If the user presses Enter without typing a name:

```text
Enter student name:
Error: student name cannot be empty.
```

The script stops at:

```bash
exit 1
```

The two final `echo` commands do not run.

---

## Execution flow

```text
Start
  |
Set course variable
  |
Ask for student name
  |
Is the name empty?
  |                 |
 Yes                No
  |                 |
Print error         Print student name
to stderr           and course
  |
exit 1
```

---

## Important limitation: spaces-only input

The original condition detects a completely empty input:

```bash
if [[ -z "$student_name" ]]; then
```

However, an input containing only spaces is not technically empty.

For example:

```text
Enter student name:
```

If the user enters three spaces, the string has three characters.

### Stricter validation

Use this condition to reject both an empty value and a value containing only whitespace:

```bash
if [[ -z "${student_name//[[:space:]]/}" ]]; then
    echo "Error: student name cannot be empty." >&2
    exit 1
fi
```

Explanation:

```bash
${student_name//[[:space:]]/}
```

removes all whitespace characters for the purpose of the test. If nothing remains, `-z` becomes true.

The original variable is not changed.

---

## Improved complete version

```bash
#!/bin/bash

course="Bash Scripting"

read -r -p "Enter student name: " student_name

if [[ -z "${student_name//[[:space:]]/}" ]]; then
    echo "Error: student name cannot be empty." >&2
    exit 1
fi

echo "Student: $student_name"
echo "Course: $course"
```

---

## Key lessons

- Use `read` to receive user input.
- Use `-r` with `read` for safer backslash handling.
- Use `-p` to display an input prompt.
- Use `[[ -z "$variable" ]]` to test for an empty string.
- Send errors to stderr with `>&2`.
- Use `exit 1` to terminate the script with a failure status.
- Quote variables to preserve spaces and avoid unexpected behavior.
- A successful script normally finishes with status `0`.
