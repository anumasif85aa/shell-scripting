# Lab 02 — Tests, Logic, and Case

## Objective

Practise string tests, numeric tests, file tests, logical operators, and
`case`.

## Task 1 — Regular File Check

Create `01_file_check.sh`.

- Accept a file path.
- Use `-f`.
- Test with `artifacts/config/app.conf` and `missing.conf`.

## Task 2 — Directory Check

Create `02_directory_check.sh`.

- Accept a directory path.
- Use `-d`.
- Display whether it exists.

## Task 3 — Number Comparison

Create `03_compare_numbers.sh`.

- Accept two whole numbers.
- Display whether the first is greater, smaller, or equal.

## Task 4 — Accepted Range with AND

Create `04_range_check.sh`.

- Accept one whole number.
- Use `&&`.
- Accept numbers from `10` through `50`.

## Task 5 — Environment with OR

Create `05_environment_type.sh`.

- Accept one environment.
- If it is `dev` or `test`, display `Non-production`.
- If it is `stage` or `prod`, display `Controlled environment`.
- Reject other values.

## Task 6 — Menu with Case

Create `06_menu.sh`.

- Accept `start`, `stop`, `restart`, or `status`.
- Use `case`.
- Display a simulated action.
- Do not control a real service.

