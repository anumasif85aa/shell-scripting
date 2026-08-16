# Bash Study Notes: Digits-Only Validation with Regex

## Condition

```bash
if [[ "$1" =~ ^[0-9]+$ ]]; then
```

## Simple meaning

This condition checks whether the first argument contains only digits from beginning to end.

Suppose the script is run like this:

```bash
bash script.sh 25
```

The first argument is:

```bash
$1 = 25
```

The condition asks:

> Does `25` contain one or more digits and nothing else?

The answer is yes, so the condition is true and the `then` block runs.

---

## Breaking the condition into parts

```bash
if [[ "$1" =~ ^[0-9]+$ ]]; then
```

| Part | Meaning |
|---|---|
| `if` | Starts a decision |
| `[[ ... ]]` | Performs a Bash conditional test |
| `"$1"` | The first script or function argument |
| `=~` | Matches a value against a regular expression |
| `^` | Beginning of the value |
| `[0-9]` | Any one digit from `0` through `9` |
| `+` | One or more of the previous pattern |
| `$` | End of the value |
| `then` | Starts the commands that run when the condition is true |

The regular expression is:

```regex
^[0-9]+$
```

Read it as:

> From the beginning to the end, allow one or more digits only.

---

## Understanding `[0-9]`

```regex
[0-9]
```

This represents any one digit:

```text
0 1 2 3 4 5 6 7 8 9
```

It can match:

```text
7
```

But without `+`, it represents only one digit.

---

## Understanding `+`

```regex
[0-9]+
```

The `+` means:

> One or more of the previous item.

The previous item is `[0-9]`, so the complete part means one or more digits.

It matches:

```text
5
25
100
98765
```

It does not match an empty value because at least one digit is required.

---

## Understanding `^`

```regex
^
```

The caret means:

> Start matching from the beginning of the value.

It prevents extra characters from appearing before the digits.

---

## Understanding `$`

```regex
$
```

The dollar sign means:

> The match must finish at the end of the value.

It prevents extra characters from appearing after the digits.

This regex `$` is different from the `$` used to expand a Bash variable.

For example:

```bash
$1
```

means the first argument, while the final `$` in the regex means the end of the string.

---

## Why `^` and `$` are important

Without the beginning and ending anchors:

```bash
[[ "$1" =~ [0-9]+ ]]
```

the value only needs to contain digits somewhere.

For example:

```text
abc25xyz
```

would match because it contains `25`.

With the anchors:

```bash
[[ "$1" =~ ^[0-9]+$ ]]
```

the complete value must contain digits only.

```text
abc25xyz
```

does not match because it also contains letters.

---

## Test examples

| Value of `$1` | Result | Reason |
|---|---|---|
| `5` | True | Contains only one digit |
| `25` | True | Contains only digits |
| `1000` | True | Contains only digits |
| `007` | True | Contains only digits |
| `5a` | False | Contains a letter |
| `abc` | False | Contains letters |
| `4.5` | False | Contains a decimal point |
| `-5` | False | Contains a minus sign |
| Empty value | False | `+` requires at least one digit |
| `5 6` | False | Contains a space |

---

## Complete script

```bash
#!/bin/bash

if [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "$1 is a valid non-negative whole number."
else
    echo "Error: enter digits only." >&2
    exit 1
fi
```

### Valid input

```bash
bash script.sh 25
```

Output:

```text
25 is a valid non-negative whole number.
```

### Invalid input

```bash
bash script.sh 25abc
```

Output:

```text
Error: enter digits only.
```

The error message is sent to standard error by:

```bash
>&2
```

The script then terminates with failure status `1`.

---

## Add an argument-count check

Before testing `$1`, it is better to confirm that exactly one argument was provided:

```bash
#!/bin/bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 NUMBER" >&2
    exit 1
fi

if [[ "$1" =~ ^[0-9]+$ ]]; then
    echo "$1 is a valid non-negative whole number."
else
    echo "Error: enter digits only." >&2
    exit 1
fi
```

Special parameters:

| Parameter | Meaning |
|---|---|
| `$#` | Number of arguments |
| `$0` | Script name |
| `$1` | First argument |

---

## Allow negative whole numbers

The original pattern does not accept:

```text
-5
```

To allow an optional minus sign, use:

```bash
if [[ "$1" =~ ^-?[0-9]+$ ]]; then
```

The added part is:

```regex
-?
```

| Symbol | Meaning |
|---|---|
| `-` | A literal minus sign |
| `?` | Zero or one occurrence |

Therefore, the minus sign is optional.

This pattern accepts:

```text
5
-5
0
```

It still rejects:

```text
4.5
abc
--5
```

---

## Allow positive or negative signs

To accept an optional `+` or `-` sign:

```bash
if [[ "$1" =~ ^[+-]?[0-9]+$ ]]; then
```

This accepts:

```text
5
+5
-5
0
```

---

## Important Bash regex rule

When using `=~`, do not put the regular expression itself inside quotes.

Recommended:

```bash
[[ "$1" =~ ^[0-9]+$ ]]
```

Avoid:

```bash
[[ "$1" =~ "^[0-9]+$" ]]
```

Quoting the right-hand regular expression can make Bash treat it as literal text instead of the intended regex.

Quoting the value on the left is fine:

```bash
"$1"
```

---

## Important leading-zero note

The regex accepts values such as:

```text
007
08
09
```

They contain digits only. However, Bash arithmetic can interpret a number beginning with `0` as octal. Octal does not allow digits `8` or `9`.

The regex validation and arithmetic interpretation are separate issues:

- Regex asks: “Does this value contain digits only?”
- Arithmetic asks: “How should Bash interpret these digits?”

For beginner scripts, avoid unnecessary leading zeros when the value will be used in arithmetic.

---

## Quick comparison

| Pattern | Accepted values |
|---|---|
| `^[0-9]+$` | Zero or positive digits-only values |
| `^-?[0-9]+$` | Negative, zero, or positive whole numbers |
| `^[+-]?[0-9]+$` | Whole numbers with an optional `+` or `-` sign |

---

## Memory rule

```regex
^[0-9]+$
```

means:

> Beginning → one or more digits → end.

Or remember:

> The complete value must contain digits only.
