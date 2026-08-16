# Lab 01 — Everyday Conditionals

## Objective

Learn `if`, `else`, and `elif` using simple daily-life decisions.

## Rules

- Use `#!/bin/bash`.
- Use `echo`.
- Use `read -r -p` for user input.
- Quote variables.
- Run `bash -n` before execution.

## Task 1 — Weather Decision

Create `01_weather.sh`.

- Ask whether it is raining.
- If the answer is `yes`, display `Take an umbrella`.
- Otherwise display `You do not need an umbrella`.

## Task 2 — Voting Age

Create `02_voting_age.sh`.

- Ask for an age.
- Validate that the input contains digits only.
- Display whether the person can vote using age `18`.

## Task 3 — Traffic Light

Create `03_traffic_light.sh`.

- Ask for `red`, `yellow`, or `green`.
- Use `if/elif/else`.
- Display `Stop`, `Get ready`, or `Go`.
- Treat any other value as an error.

## Task 4 — Even or Odd

Create `04_even_or_odd.sh`.

- Accept one number as `$1`.
- Validate it as a whole number.
- Use remainder `% 2`.
- Display whether it is even or odd.

## Task 5 — Empty Name

Create `05_name_check.sh`.

- Ask for a name.
- Use `-z` to reject an empty value.
- Display a greeting for a non-empty value.

## Task 6 — Grade Decision

Create `06_grade.sh`.

- Accept one score from `0` through `100`.
- Validate the format and range.
- Use:

```text
90–100 = A
80–89  = B
70–79  = C
60–69  = D
Below 60 = F
```

