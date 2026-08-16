# Lab 01 — Function Fundamentals

## Objective

Learn how to define, call, and reuse simple Bash functions.

## Rules

- Use `#!/bin/bash`.
- Use `echo`, not `printf`.
- Define every function before calling it.
- Do not use `sudo`.
- Run `bash -n` before executing each script.

## Task 1 — First Function

Create `01_hello_function.sh`.

- Define a function named `say_hello`.
- Print `Hello from my first Bash function`.
- Call the function once.

## Task 2 — Call It More Than Once

Create `02_repeat_function.sh`.

- Define `show_message`.
- Print `Practice makes progress`.
- Call it three times.

## Task 3 — Simple System Information

Create `03_system_info.sh`.

- Define `show_system_info`.
- Display the current user, hostname, date, and working directory on labelled
  lines.
- Call the function.

## Task 4 — One Argument

Create `04_greet_name.sh`.

- Define `greet`.
- Use `$1` inside the function.
- Call it with `Ali`, then call it with `Omar`.

Expected style:

```text
Hello, Ali
Hello, Omar
```

## Task 5 — Two Arguments

Create `05_fruit_pair.sh`.

- Define `show_fruits`.
- Display the first and second arguments on separate labelled lines.
- Call it with `apple banana`.
- Call it again with `mango cherry`.

## Task 6 — All Arguments

Create `06_fruit_basket.sh`.

- Define `show_basket`.
- Display the number of arguments using `$#`.
- Loop over all arguments using `"$@"`.
- Call it with `apple banana "red cherry" mango`.

## Verification

```bash
bash -n 01_hello_function.sh
bash -n 02_repeat_function.sh
bash -n 03_system_info.sh
bash -n 04_greet_name.sh
bash -n 05_fruit_pair.sh
bash -n 06_fruit_basket.sh
```

