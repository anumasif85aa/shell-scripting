# Lab 01 — Arguments Baby Steps

## Objective

Learn positional parameters using simple fruit examples.

## Rules

- Use `#!/bin/bash`.
- Use `echo`.
- Do not use functions in this first lab.
- Quote every argument expansion.
- Run `bash -n` before executing each script.

## Task 1 — Script Name and First Fruit

Create `01_first_fruit.sh`.

- Display the script name using `$0`.
- Display the first argument using `$1`.

Run:

```bash
./01_first_fruit.sh apple
```

## Task 2 — Three Fruits

Create `02_three_fruits.sh`.

- Display `$1`, `$2`, and `$3` on labelled lines.

Run:

```bash
./02_three_fruits.sh apple banana cherry
```

## Task 3 — Count the Fruits

Create `03_count_fruits.sh`.

- Display the number of supplied arguments using `$#`.
- Display all arguments using `"$@"`.

## Task 4 — Fruit Basket Loop

Create `04_fruit_basket.sh`.

- Loop over `"$@"`.
- Display every value as `Fruit: VALUE`.

Run with at least four fruits.

## Task 5 — A Fruit with Spaces

Create `05_fruit_with_spaces.sh`.

- Display the first argument.
- Run it with `"red apple"` as one argument.
- Run it again without quotes and compare the result.

## Task 6 — Default Fruit

Create `06_default_fruit.sh`.

- Use `${1:-apple}`.
- Run the script without an argument.
- Run it again with `mango`.

## Verification

```bash
bash -n *.sh
```

