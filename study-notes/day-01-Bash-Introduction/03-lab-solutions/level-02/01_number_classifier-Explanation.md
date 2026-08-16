# Bash Study Notes: Whole-Number Classification

## Learning objective

Learn how to:

- Accept a command-line argument
- Validate the number of arguments
- Validate a whole number with a regular expression
- Classify a number as positive, negative, or zero
- Determine whether a number is even or odd
- Report incorrect usage through standard error

## Complete script

```bash
#!/bin/bash

# Classify one whole number.

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 NUMBER" >&2
    exit 1
fi

number="$1"

if [[ ! "$number" =~ ^-?[0-9]+$ ]]; then
    echo "Error: enter a whole number." >&2
    exit 1
fi

if [[ "$number" -gt 0 ]]; then
    echo "$number is positive."
elif [[ "$number" -lt 0 ]]; then
    echo "$number is negative."
else
    echo "$number is zero."
fi

if (( number % 2 == 0 )); then
    echo "$number is even."
else
    echo "$number is odd."
fi
```

## Purpose of the script

The script requires exactly one whole number and reports two characteristics:

1. Whether the number is positive, negative, or zero
2. Whether the number is even or odd

Example:

```bash
bash classify-number.sh -7
```

Output:

```text
-7 is negative.
-7 is odd.
```

---

## 1. Shebang

```bash
#!/bin/bash
```

The shebang tells Linux to use Bash to execute the script.

---

## 2. Check the number of arguments

```bash
if [[ "$#" -ne 1 ]]; then
```

`$#` contains the number of arguments supplied to the script.

`-ne` means **not equal to**.

The condition means:

> If the argument count is not equal to one, run the error-handling block.

Examples:

| Command | Value of `$#` | Valid? |
|---|---:|---:|
| `bash classify-number.sh` | `0` | No |
| `bash classify-number.sh 7` | `1` | Yes |
| `bash classify-number.sh 7 8` | `2` | No |

---

## 3. Display the usage message

```bash
echo "Usage: $0 NUMBER" >&2
```

`$0` represents the script name.

If the user supplies the wrong number of arguments, the message might be:

```text
Usage: classify-number.sh NUMBER
```

`>&2` sends the message to standard error because it describes incorrect usage.

| Stream | File descriptor | Purpose |
|---|---:|---|
| Standard input | `0` | Receives input |
| Standard output | `1` | Displays normal results |
| Standard error | `2` | Displays errors |

---

## 4. Stop after incorrect usage

```bash
exit 1
```

This terminates the entire script with failure status `1`.

Check the script's status from the terminal:

```bash
echo $?
```

General meaning:

| Status | Meaning |
|---:|---|
| `0` | Success |
| Non-zero | Failure or another special condition |

---

## 5. Store the first argument

```bash
number="$1"
```

`$1` represents the first command-line argument.

Example:

```bash
bash classify-number.sh -15
```

Bash effectively stores:

```bash
number="-15"
```

Quotes safely preserve the argument as one value.

---

## 6. Validate the whole number

```bash
if [[ ! "$number" =~ ^-?[0-9]+$ ]]; then
```

This tests the value against a regular expression.

| Part | Meaning |
|---|---|
| `[[ ... ]]` | Bash conditional test |
| `!` | Reverses the result; means “not” |
| `=~` | Matches a string against a regular expression |
| `^` | Beginning of the value |
| `-?` | Optional minus sign |
| `[0-9]+` | One or more digits |
| `$` | End of the value |

The regular expression:

```regex
^-?[0-9]+$
```

accepts:

```text
25
-25
0
```

It rejects:

```text
4.5
hello
12abc
+
```

The complete condition means:

> If the argument is not a valid whole number, display an error and stop.

```bash
echo "Error: enter a whole number." >&2
exit 1
```

---

## 7. Classify the number by sign

```bash
if [[ "$number" -gt 0 ]]; then
    echo "$number is positive."
elif [[ "$number" -lt 0 ]]; then
    echo "$number is negative."
else
    echo "$number is zero."
fi
```

Numeric comparison operators:

| Operator | Meaning |
|---|---|
| `-eq` | Equal to |
| `-ne` | Not equal to |
| `-gt` | Greater than |
| `-ge` | Greater than or equal to |
| `-lt` | Less than |
| `-le` | Less than or equal to |

The decision process is:

- Greater than `0` → positive
- Less than `0` → negative
- Neither condition → zero

---

## 8. Determine whether it is even or odd

```bash
if (( number % 2 == 0 )); then
```

`(( ... ))` performs arithmetic evaluation.

The modulo operator `%` returns the remainder after division.

| Expression | Remainder | Classification |
|---|---:|---|
| `8 % 2` | `0` | Even |
| `7 % 2` | `1` | Odd |
| `-6 % 2` | `0` | Even |
| `-5 % 2` | `-1` | Odd |

The condition:

```bash
number % 2 == 0
```

means:

> If dividing the number by two leaves no remainder, the number is even.

Otherwise, it is odd.

---

## Example executions

### Positive even number

```bash
bash classify-number.sh 12
```

```text
12 is positive.
12 is even.
```

### Positive odd number

```bash
bash classify-number.sh 7
```

```text
7 is positive.
7 is odd.
```

### Negative even number

```bash
bash classify-number.sh -8
```

```text
-8 is negative.
-8 is even.
```

### Zero

```bash
bash classify-number.sh 0
```

```text
0 is zero.
0 is even.
```

Zero is even because dividing it by two leaves no remainder.

### Missing argument

```bash
bash classify-number.sh
```

```text
Usage: classify-number.sh NUMBER
```

### Too many arguments

```bash
bash classify-number.sh 10 20
```

```text
Usage: classify-number.sh NUMBER
```

### Invalid value

```bash
bash classify-number.sh 4.5
```

```text
Error: enter a whole number.
```

---

## Execution flow

```text
Start
  |
Exactly one argument?
  |                |
 No               Yes
  |                |
Usage error        Store $1
exit 1             |
                   Valid whole number?
                   |                |
                  No               Yes
                   |                |
               Input error         Positive, negative,
               exit 1              or zero?
                                    |
                                Even or odd?
                                    |
                                   End
```

---

## Important leading-zero warning

The regular expression accepts values such as:

```text
08
09
```

However, Bash arithmetic may treat a number beginning with `0` as octal. Octal numbers cannot contain the digits `8` or `9`, so values such as `08` can produce an arithmetic error.

For this beginner script, enter numbers without unnecessary leading zeros:

```bash
bash classify-number.sh 8
```

instead of:

```bash
bash classify-number.sh 08
```

### Safer base-10 normalization

After validation, the input can be converted explicitly to base 10:

```bash
if [[ "$number" == -* ]]; then
    number=$((-10#${number#-}))
else
    number=$((10#$number))
fi
```

Explanation:

- `10#` tells Bash to interpret the digits as base 10.
- `${number#-}` removes the leading minus sign from a negative value.
- The minus sign is applied again after base-10 conversion.

This is an advanced improvement; the original script is suitable for introductory practice when leading zeros are avoided.

---

## Key lessons

- `$#` gives the number of script arguments.
- `$0` gives the script name.
- `$1` gives the first argument.
- `=~` performs regular-expression matching.
- `!` reverses a condition.
- `-gt` and `-lt` perform numeric comparisons.
- `(( ... ))` performs arithmetic evaluation.
- `%` calculates the remainder.
- Even numbers have a remainder of `0` when divided by `2`.
- Errors should be sent to stderr with `>&2`.
- `exit 1` reports failure and stops the script.
