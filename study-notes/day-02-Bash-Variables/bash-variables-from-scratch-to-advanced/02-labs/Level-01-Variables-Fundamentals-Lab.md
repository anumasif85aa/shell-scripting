# Level 01 Lab: Variables Fundamentals

## Objective

Learn variable assignment, expansion, quotes, user input, arguments, command substitution, and arithmetic through small scripts.

## Rules

- Use `#!/bin/bash`.
- Use `echo`, not `printf`.
- Do not use functions.
- Quote variable expansions.
- Run `bash -n script.sh` before executing each script.

## Task 1: Three fruits

Create `01_fruits.sh`.

1. Create three variables containing `apple`, `banana`, and `cherry`.
2. Print each fruit on a labelled line.
3. Print one sentence containing all three variables.

Expected style:

```text
First fruit: apple
Second fruit: banana
Third fruit: cherry
My fruits are apple, banana, and cherry.
```

## Task 2: Student profile

Create `02_student_profile.sh`.

1. Ask for the student's name with `read -r -p`.
2. Ask for the course name.
3. Ask for the city.
4. Print a neat three-line profile.
5. Test a name and city containing spaces.

## Task 3: Quoting practice

Create `03_quoting.sh`.

1. Store `Bash Variables` in a variable.
2. Print it with double quotes.
3. Print the variable name literally with single quotes.
4. Add the word `Lab` directly after the value by using braces.

## Task 4: Fruit arguments

Create `04_fruit_arguments.sh`.

Run it like this:

```bash
bash 04_fruit_arguments.sh apple banana cherry
```

Print:

- Script name
- First argument
- Second argument
- Third argument
- Number of arguments
- All arguments

## Task 5: System variables

Create `05_system_report.sh`.

Use command substitution to store and display:

- Current user
- Hostname
- Current date
- Current directory
- Bash version

## Task 6: Fruit calculator

Create `06_fruit_calculator.sh`.

1. Store `5` in `apples`.
2. Store `3` in `bananas`.
3. Calculate total fruit with `$(( ))`.
4. Print the two quantities and total.

## Verification

```bash
bash -n 01_fruits.sh
bash -n 02_student_profile.sh
bash -n 03_quoting.sh
bash -n 04_fruit_arguments.sh
bash -n 05_system_report.sh
bash -n 06_fruit_calculator.sh
```

## Deliverables

- `01_fruits.sh`
- `02_student_profile.sh`
- `03_quoting.sh`
- `04_fruit_arguments.sh`
- `05_system_report.sh`
- `06_fruit_calculator.sh`
- A short `README.md` showing one successful test for every script
