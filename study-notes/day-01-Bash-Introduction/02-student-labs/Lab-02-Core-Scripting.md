# Lab 02 — Core Bash Scripting

## Objective

Use conditions, loops, files, functions, arrays, and text processing in one
connected learning flow.

## Practice Artifacts

Use the files inside `artifacts/`.

## Task 1 — Number Classifier

Create `01_number_classifier.sh`.

- Accept one whole number.
- Validate it.
- Display whether it is positive, negative, or zero.
- Display whether it is even or odd.

## Task 2 — Multiplication Table

Create `02_multiplication_table.sh`.

- Accept one positive whole number.
- Use a loop.
- Display its table from `1` through `10`.

Example:

```bash
./02_multiplication_table.sh 7
```

## Task 3 — Server List Reader

Create `03_server_reader.sh`.

- Read `artifacts/data/servers.txt`.
- Use `while IFS= read -r`.
- Skip empty lines and lines beginning with `#`.
- Number each accepted server.
- Display the final count.

## Task 4 — Log Analyzer

Create `04_log_analyzer.sh`.

- Accept a log file.
- Count `INFO`, `WARNING`, and `ERROR`.
- Display `Critical` if errors exist.
- Display `Warning` if only warnings exist.
- Otherwise display `Healthy`.

## Task 5 — File Report Function

Create `05_file_report.sh`.

- Accept one or more paths.
- Create a function named `describe_path`.
- Use file tests to classify each path as:
  - regular file
  - directory
  - symbolic link
  - missing
- Loop through `"$@"`.

## Task 6 — Environment Menu

Create `06_environment_menu.sh`.

- Accept an environment and an action.
- Valid environments: `dev`, `test`, `stage`, `prod`.
- Valid actions: `check`, `deploy`, `status`.
- Use `case`.
- Block `deploy` to `prod`; this is a safe simulation.

## Verification

Every valid run should exit `0`. Invalid usage or input should exit nonzero.

