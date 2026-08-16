# Level 01 Lab: Conditionals Fundamentals

## Objective

Learn how Bash makes simple decisions using `if`, `elif`, `else`, `[[ ]]`, strings, numbers, files, arguments, and exit statuses.

## Beginner rules

- Use `#!/bin/bash`.
- Use `echo`, not `printf`.
- Use only variables, arguments, `read`, `if`, `elif`, `else`, `[[ ]]`, basic commands, redirection, and `exit`.
- Do not use functions, loops, arrays, `case`, `getopts`, `sudo`, remote servers, or real system changes.
- Run `bash -n script.sh` before execution.

## Task 1: Weather decision

Create `01_weather.sh`.

1. Ask: `Is it raining? Enter yes or no:`
2. If the answer is `yes`, print `Take an umbrella.`
3. Otherwise, print `You do not need an umbrella.`
4. Test both answers.

## Task 2: Traffic light

Create `02_traffic_light.sh`.

Ask for `red`, `yellow`, or `green`.

- `red` → `Stop`
- `yellow` → `Get ready`
- `green` → `Go`
- Anything else → print an error to `stderr` and exit `1`

## Task 3: Age checker

Create `03_age_check.sh`.

1. Ask for an age.
2. Reject empty input.
3. Reject values containing anything except digits.
4. If age is at least `18`, print `Adult`.
5. Otherwise, print `Minor`.

## Task 4: Fruit choice

Create `04_fruit_choice.sh`.

Ask the student to choose `apple`, `banana`, or `cherry`.

- Apple → `You selected a red fruit.`
- Banana → `You selected a yellow fruit.`
- Cherry → `You selected a small red fruit.`
- Anything else → `Fruit is not available.`

Use `if`, `elif`, and `else`.

## Task 5: File checker

Create `05_file_check.sh`.

1. Receive a filename as the first argument.
2. If no argument is supplied, print usage to `stderr` and exit `1`.
3. If it is a regular file, print `Regular file found.`
4. Otherwise, print `Regular file not found.` and exit `1`.

Test with:

```bash
bash 05_file_check.sh /etc/passwd
bash 05_file_check.sh missing.txt
```

## Task 6: Two-argument checker

Create `06_argument_check.sh`.

The script requires exactly two fruits:

```bash
bash 06_argument_check.sh apple banana
```

1. Check `$#`.
2. If the count is not `2`, print usage and exit `1`.
3. Otherwise, print both fruits and exit `0`.

## Verification

```bash
bash -n 01_weather.sh
bash -n 02_traffic_light.sh
bash -n 03_age_check.sh
bash -n 04_fruit_choice.sh
bash -n 05_file_check.sh
bash -n 06_argument_check.sh
```

## Deliverables

- Six scripts
- Successful and failed test evidence
- A short `README.md` describing what each condition checks
