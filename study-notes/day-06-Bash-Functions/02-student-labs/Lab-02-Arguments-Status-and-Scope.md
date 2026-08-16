# Lab 02 — Arguments, Status, and Scope

## Objective

Use function arguments safely, understand local variables, and return success or
failure.

## Task 1 — Default Name

Create `01_default_name.sh`.

- Define `greet`.
- Use `${1:-Guest}`.
- Call it once with `Ayesha` and once without an argument.

## Task 2 — Add Two Numbers

Create `02_add_numbers.sh`.

- Define `add_numbers`.
- Require exactly two arguments.
- If the argument count is wrong, print usage to standard error and return `1`.
- Otherwise display the sum.

Test:

```bash
./02_add_numbers.sh
```

The main script should call:

```bash
add_numbers 7 5
```

## Task 3 — Validate a Whole Number

Create `03_validate_number.sh`.

- Define `is_number`.
- Accept one value.
- Return `0` for a whole number and `1` for invalid input.
- Use the function in an `if` statement.
- Test with `25` and `apple`.

## Task 4 — Local Variable

Create `04_local_variable.sh`.

- Create a global variable: `fruit="apple"`.
- Define `change_fruit`.
- Inside it, create `local fruit="banana"`.
- Display the value inside and outside the function.
- Confirm that the outside value stays `apple`.

## Task 5 — File Check

Create `05_check_file.sh`.

- Define `check_file`.
- Use `[[ -f "$1" ]]`.
- Return `0` when the regular file exists.
- Print an error to standard error and return `1` when it does not.
- Test it with this lab file and with `missing.txt`.

## Task 6 — Capture Function Output

Create `06_capture_output.sh`.

- Define `multiply`.
- Accept two numbers.
- Output only the answer.
- Capture the result using command substitution.
- Display `Result: ANSWER`.

Use `6` and `7`; the result should be `42`.

## Verification

After each function call, temporarily use:

```bash
echo "Status: $?"
```

Confirm success is `0` and failure is non-zero.

