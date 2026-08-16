# Lab 02 — Validation, Loops, and Shift

## Objective

Validate arguments and process flexible argument lists safely.

## Task 1 — Require Two Values

Create `01_require_two.sh`.

- Require exactly two arguments.
- Print `Usage: SCRIPT FIRST SECOND` to stderr when the count is wrong.
- Exit with status `1` on failure.
- Display both arguments on success.

## Task 2 — Validate One Number

Create `02_validate_number.sh`.

- Require one argument.
- Accept positive and negative whole numbers.
- Reject text and decimals.

## Task 3 — Validate a File

Create `03_validate_file.sh`.

- Require one file path.
- Use `[[ -f "$file" ]]`.
- Test with `artifacts/config/app.conf`.
- Test with `missing.conf`.

## Task 4 — Process Any Number of Fruits

Create `04_process_fruits.sh`.

- Require at least one argument.
- Loop through `"$@"`.
- Number the output:

```text
Fruit 1: apple
Fruit 2: banana
```

## Task 5 — Process with Shift

Create `05_shift_queue.sh`.

- Use `while [[ $# -gt 0 ]]`.
- Display the current `$1`.
- Use `shift`.
- Continue until no arguments remain.

## Task 6 — Multiple Multiplication Tables

Create `06_multiplication_tables.sh`.

- Accept any number of table values.
- Validate each value.
- Skip invalid values with `continue`.
- Print every valid table from 1 through 10.

Test:

```bash
./06_multiplication_tables.sh 2 apple 5
```

