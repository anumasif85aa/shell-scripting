# Bash Scripting — Day 01 Practice Tasks

## Overview

This lab introduces the foundations of Bash scripting through five progressive tasks. You will create and execute scripts, work with variables and user input, make decisions with conditionals, test regular files, and check a systemd service.

## Learning Objectives

By the end of this lab, you should be able to:

- Create and execute a Bash script.
- Explain the purpose of a shebang.
- Create and expand variables safely.
- Read user input with `read -r`.
- Use `if`, `elif`, and `else` conditions.
- Validate a whole number before using arithmetic comparisons.
- Check whether a regular file exists.
- Check whether a systemd service is active.
- Document your scripts, commands, results, and lessons learned.

## Table of Contents

1. [Lab Preparation](#1-lab-preparation)
2. [Task 1 — Your First Script](#2-task-1--your-first-script)
3. [Task 2 — Variables and Quoting](#3-task-2--variables-and-quoting)
4. [Task 3 — User Input with `read`](#4-task-3--user-input-with-read)
5. [Task 4 — Conditional Decisions](#5-task-4--conditional-decisions)
6. [Task 5 — Service Status Checker](#6-task-5--service-status-checker)
7. [Hints and Quick Reference](#7-hints-and-quick-reference)
8. [Syntax and Behavior Tests](#8-syntax-and-behavior-tests)
9. [Documentation Requirements](#9-documentation-requirements)
10. [Submission Checklist](#10-submission-checklist)

---

## 1. Lab Preparation

Create and enter a dedicated working directory:

```bash
mkdir -p bash-day-01
cd bash-day-01
```

Your completed directory should contain:

```text
bash-day-01/
├── hello.sh
├── variables.sh
├── greet.sh
├── check_number.sh
├── file_check.sh
├── server_check.sh
└── day-01-shell-scripting.md
```

---

## 2. Task 1 — Your First Script

### Filename

```text
hello.sh
```

### Requirements

1. Create a file named `hello.sh`.
2. Add the following shebang as the first line:

   ```bash
   #!/bin/bash
   ```

3. Use `echo` to print:

   ```text
   Hello, DevOps!
   ```

4. Make the script executable:

   ```bash
   chmod +x hello.sh
   ```

5. Run it directly:

   ```bash
   ./hello.sh
   ```

### Investigation

Temporarily remove or comment out the shebang and compare these commands:

```bash
./hello.sh
bash hello.sh
```

Document what happens in your environment.

> `bash hello.sh` explicitly starts Bash, so it does not require a shebang. Direct execution with `./hello.sh` relies on the shebang to identify the intended interpreter. Some interactive shells may attempt a fallback for a simple text file without a shebang, but this behavior should not be relied upon. A portable executable script should include the correct shebang.

Restore the shebang after completing the investigation.

### Questions

- What does `#!/bin/bash` tell the operating system?
- What does `chmod +x` change?
- What is the difference between `./hello.sh` and `bash hello.sh`?

---

## 3. Task 2 — Variables and Quoting

### Filename

```text
variables.sh
```

### Requirements

1. Add the Bash shebang.
2. Create a variable named `NAME` containing your name.
3. Create a variable named `ROLE` containing a role such as `DevOps Engineer`.
4. Print the following sentence using both variables:

   ```text
   Hello, I am <NAME> and I am a <ROLE>.
   ```

5. Make the script executable and run it.

### Variable Hint

```bash
NAME="Khalid"
ROLE="DevOps Engineer"
```

Do not place spaces around `=` in a Bash assignment.

Correct:

```bash
NAME="Khalid"
```

Incorrect:

```bash
NAME = "Khalid"
```

### Quoting Experiment

Add two temporary output lines:

```bash
echo "Hello, $NAME"
echo 'Hello, $NAME'
```

Document the difference.

| Quote Type | Expected Behavior |
|---|---|
| Double quotes: `"..."` | Variable references such as `$NAME` are expanded. |
| Single quotes: `'...'` | Text is treated literally; `$NAME` is not expanded. |

---

## 4. Task 3 — User Input with `read`

### Filename

```text
greet.sh
```

### Requirements

Create a script that:

1. Asks the user for their name.
2. Asks the user for their favorite tool.
3. Stores both answers in variables.
4. Prints:

   ```text
   Hello <name>, your favorite tool is <tool>.
   ```

### Recommended Input Syntax

```bash
read -r -p "Enter your name: " name
```

| Part | Meaning |
|---|---|
| `read` | Reads input from standard input. |
| `-r` | Prevents backslashes from being interpreted as escapes. |
| `-p` | Displays a prompt before reading. |
| `name` | Variable that receives the input. |

### Testing

Test values containing spaces, such as:

```text
Muhammad 
Visual Studio Code
```

Quote variable expansions when displaying them:

```bash
echo "$name"
```

---

## 5. Task 4 — Conditional Decisions

This task contains two scripts.

### Task 4A — Classify a Number

#### Filename

```text
check_number.sh
```

#### Requirements

Create a script that:

1. Reads one value from the user.
2. Validates that it is a positive or negative whole number, or zero.
3. Prints an error and exits with status `1` if the input is invalid.
4. Prints whether a valid number is:
   - Positive
   - Negative
   - Zero
5. Exits with status `0` after successful completion.

#### Validation Hint

Use this Bash regex to accept an optional minus sign followed by one or more digits:

```bash
^-?[0-9]+$
```

Use it with the Bash regex operator:

```bash
[[ "$number" =~ ^-?[0-9]+$ ]]
```

Validate the input before performing arithmetic comparisons.

#### Arithmetic Comparison Hints

Inside `(( ... ))`, you may use:

```bash
(( number > 0 ))
(( number < 0 ))
```

Test at least these inputs:

```text
10
-5
0
apple
2.5
```

### Task 4B — Check a Regular File

#### Filename

```text
file_check.sh
```

#### Requirements

Create a script that:

1. Asks the user for a filename or path.
2. Tests whether it exists as a regular file using `-f`.
3. Prints an appropriate result.
4. Returns `0` when the regular file exists.
5. Returns `1` when it does not exist as a regular file.

#### File-Test Hint

```bash
[[ -f "$filename" ]]
```

Important distinction:

| Test | Meaning |
|---|---|
| `-f` | The path exists and is a regular file. |
| `-d` | The path exists and is a directory. |
| `-e` | The path exists, regardless of its type. |

The task specifically requests `-f`, so a directory should not be reported as a regular file.

Create a test file if needed:

```bash
touch abc.txt
```

Test both:

```text
abc.txt
missing.txt
```

---

## 6. Task 5 — Service Status Checker

### Filename

```text
server_check.sh
```

### Requirements

Create a script that:

1. Stores a systemd service name in a variable, for example:

   ```bash
   service_name="nginx"
   ```

2. Asks:

   ```text
   Do you want to check the status of nginx? (y/n):
   ```

3. Accepts `y` or `Y` as Yes.
4. For Yes:
   - Displays the service status without opening a pager.
   - Reliably checks whether the service is active.
   - Prints either an active or inactive message.
5. Accepts `n` or `N` as No and prints:

   ```text
   Skipped.
   ```

6. Prints an error for any other answer.

### Recommended Commands

Display service details:

```bash
systemctl status --no-pager "$service_name"
```

Reliably test the active state:

```bash
systemctl is-active --quiet "$service_name"
```

Do not parse the human-readable output of `systemctl status`. Use the exit status from `systemctl is-active --quiet` for the conditional decision.

### Suggested Decision Structure

Use `case` or `if` to handle:

| Input | Action |
|---|---|
| `y` or `Y` | Check the service. |
| `n` or `N` | Print `Skipped.` |
| Anything else | Print an invalid-response error. |

### Environment Note

This task requires a Linux environment running systemd. It may not work in:

- A container without systemd
- A minimal Linux environment
- WSL when systemd is disabled

Check whether systemd is available:

```bash
systemctl --version
```

Also verify that the chosen service exists. Service names may differ across distributions. For example, the OpenSSH service may be named `ssh` on Ubuntu and `sshd` on RHEL-family systems.

---

## 7. Hints and Quick Reference

### Shebang

```bash
#!/bin/bash
```

Identifies Bash as the script's intended interpreter during direct execution.

### Variables

```bash
NAME="Khalid"
```

Do not use spaces around `=`.

### User Input

```bash
read -r -p "Enter your name: " name
```

### Conditional Structure

```bash
if condition; then
    echo "The first condition is true."
elif another_condition; then
    echo "The second condition is true."
else
    echo "No earlier condition is true."
fi
```

### Regular-File Test

```bash
if [[ -f "$filename" ]]; then
    echo "The path is a regular file."
fi
```

### Error Message

```bash
echo "Error: something went wrong." >&2
```

`>&2` sends the message to standard error.

### Exit Status

```bash
exit 0  # Success
exit 1  # Failure
```

### Check the Previous Status

```bash
echo "$?"
```

Check `$?` immediately because the next command replaces it.

---

## 8. Syntax and Behavior Tests

### Check Every Script's Syntax

```bash
bash -n hello.sh
bash -n variables.sh
bash -n greet.sh
bash -n check_number.sh
bash -n file_check.sh
bash -n server_check.sh
```

No output normally means Bash found no syntax error.

### Make the Scripts Executable

```bash
chmod +x hello.sh variables.sh greet.sh check_number.sh file_check.sh server_check.sh
```

### Run the Scripts

```bash
./hello.sh
./variables.sh
./greet.sh
./check_number.sh
./file_check.sh
./server_check.sh
```

### Check Exit Statuses

After testing success and failure paths:

```bash
echo "$?"
```

### Optional Debugging

```bash
bash -x script.sh
```

This displays commands as Bash executes them. Do not use execution tracing on scripts that process passwords, tokens, or other secrets.

---

## 9. Documentation Requirements

Create the following Markdown file:

```text
day-01-shell-scripting.md
```

Include these sections:

### 1. Student Information

- Name
- Date
- Linux distribution or environment

### 2. Task Evidence

For each script, include:

- Filename
- Complete code
- Command used to run it
- Output from a successful test
- Output from at least one failure or alternate test, where applicable
- Exit status

Use fenced code blocks:

````markdown
```bash
# Script code or command
```

```text
Program output
```
````

### 3. Investigation Answers

Answer:

1. What happened when the shebang was removed?
2. What was the difference between single and double quotes?
3. Why should numeric input be validated before arithmetic?
4. What is the difference between `-f` and `-e`?
5. Why is `systemctl is-active` better for a script's decision than parsing `systemctl status` output?

### 4. What You Learned

Write at least three clear learning points.

Example format:

```markdown
## What I Learned

1. I learned that ...
2. I learned that ...
3. I learned that ...
```

---

## 10. Submission Checklist

- [ ] `hello.sh` has the correct shebang and output.
- [ ] The shebang investigation is documented.
- [ ] `variables.sh` demonstrates variable expansion and quoting.
- [ ] `greet.sh` reads both required values with `read -r`.
- [ ] `check_number.sh` validates input before arithmetic.
- [ ] Positive, negative, zero, and invalid inputs were tested.
- [ ] `file_check.sh` uses `-f` with a quoted path.
- [ ] Existing and missing regular files were tested.
- [ ] `server_check.sh` handles Yes, No, and invalid responses.
- [ ] Service activity is tested with `systemctl is-active --quiet`.
- [ ] All scripts pass `bash -n`.
- [ ] Success and failure exit statuses were checked.
- [ ] `day-01-shell-scripting.md` contains code, output, answers, and learning points.

---


