# Lab 01 — Bash Foundations

## Objective

Learn the shell environment, output, variables, input, arguments, permissions,
and exit statuses.

## Rules

- Use `#!/bin/bash`.
- Use `echo`, not `printf`.
- Quote variable expansions.
- Do not use `sudo`.
- Run `bash -n` before executing each script.

## Task 1 — Environment Inspector

Create `01_environment.sh`.

- Display labelled values for:
  - configured shell
  - current shell process
  - Bash version
  - user
  - home directory
  - working directory
  - PATH
- Redirect the report into `environment.txt`.

## Task 2 — Hello System

Create `02_hello_system.sh`.

- Add a shebang, title, author, purpose, and usage comments.
- Display your name, hostname, date, and working directory on separate labelled
  lines.

## Task 3 — Standard Streams

Create `03_streams.sh`.

- Send `Script started successfully` to stdout.
- Send `This is a practice error` to stderr.
- Run the script once normally.
- Run it again with stdout in `output.log` and stderr in `error.log`.

## Task 4 — User Input

Create `04_student_greeting.sh`.

- Ask for a student name using `read -r -p`.
- Reject an empty name.
- Display the entered name and current course.

## Task 5 — Fruit Arguments

Create `05_fruits.sh`.

- Accept three arguments: `apple`, `banana`, and `cherry`.
- Display the script name, each fruit, argument count, and all arguments.
- Display usage and exit nonzero unless exactly three arguments are supplied.

Example:

```bash
./05_fruits.sh apple banana cherry
```

## Task 6 — Permissions and Exit Status

Create `06_command_status.sh`.

- Attempt to run the script before and after `chmod u+x`.
- Inside the script, run one successful command and save its status.
- Run one failing command and save its status.
- Display both statuses.
- Add comments explaining why `bash script.sh` and `./script.sh` differ.

## Verification

```bash
bash -n 01_environment.sh 02_hello_system.sh 03_streams.sh \
04_student_greeting.sh 05_fruits.sh 06_command_status.sh
```

