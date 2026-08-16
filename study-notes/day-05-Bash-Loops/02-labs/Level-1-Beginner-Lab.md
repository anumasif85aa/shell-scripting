# Level 1 Lab — Bash Loop Foundations

## Objective

Learn basic `for` loops, numeric loops, script arguments, `break`, and `continue`.

## Rules

- Use `echo`, not `printf`.
- Do not use functions.
- Quote variables.
- Check every script with `bash -n`.
- Use simple names such as `apple`, `banana`, and `cherry`.

---

## Task 1 — Fruit basket

Create `01_fruit_basket.sh`.

Use one `for` loop to display:

```text
Fruit: apple
Fruit: banana
Fruit: cherry
```

Run:

```bash
bash -n 01_fruit_basket.sh
bash 01_fruit_basket.sh
```

---

## Task 2 — Count five fruits

Create `02_fruit_counter.sh`.

Use a C-style `for` loop to display:

```text
Fruit number: 1
Fruit number: 2
Fruit number: 3
Fruit number: 4
Fruit number: 5
```

---

## Task 3 — Fruits as arguments

Create `03_fruit_arguments.sh`.

Run it like this:

```bash
bash 03_fruit_arguments.sh apple banana cherry
```

Requirements:

- Display the script name.
- Display the number of arguments.
- Loop through every argument using `"$@"`.

Expected output:

```text
Script: 03_fruit_arguments.sh
Number of fruits: 3
Fruit: apple
Fruit: banana
Fruit: cherry
```

The displayed script name may include its path.

---

## Task 4 — Skip the banana

Create `04_skip_banana.sh`.

Loop through:

```text
apple banana cherry mango
```

Use `continue` to skip `banana`.

Expected output:

```text
apple
cherry
mango
```

---

## Task 5 — Stop at cherry

Create `05_stop_at_cherry.sh`.

Loop through:

```text
apple banana cherry mango
```

Use `break` when the value becomes `cherry`.

Expected output:

```text
Checking: apple
Checking: banana
Cherry found. Stopping the loop.
```

`mango` must not be processed.

---

## Task 6 — Simple countdown

Create `06_countdown.sh`.

Use a C-style loop to count from 5 down to 1, then display `Go!`.

Expected output:

```text
5
4
3
2
1
Go!
```

---

## Level 1 verification

```bash
bash -n 01_fruit_basket.sh
bash -n 02_fruit_counter.sh
bash -n 03_fruit_arguments.sh
bash -n 04_skip_banana.sh
bash -n 05_stop_at_cherry.sh
bash -n 06_countdown.sh
```

All commands should return no output and status `0`.

