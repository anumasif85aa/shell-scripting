# Bash Regex — Introduction and Number Validation

## Table of Contents

- [1. What Is Regex?](#1-what-is-regex)
- [2. Digits-Only Regex](#2-digits-only-regex)
- [3. Important Regex Symbols](#3-important-regex-symbols)
- [4. Regex Matching in Bash](#4-regex-matching-in-bash)
- [5. Positive Numbers, Negative Numbers, and Zero](#5-positive-numbers-negative-numbers-and-zero)
- [6. Negative Numbers Only](#6-negative-numbers-only)
- [7. Optional Plus or Minus Sign](#7-optional-plus-or-minus-sign)
- [8. Common Number Patterns](#8-common-number-patterns)
- [9. Important Bash Notes](#9-important-bash-notes)
- [10. Complete Validation Script](#10-complete-validation-script)
- [11. Practice Tasks](#11-practice-tasks)
- [12. Summary](#12-summary)

---

## 1. What Is Regex?

**Regex** stands for **regular expression**.

A regular expression is a pattern used to:

- Check text
- Search text
- Match text
- Validate input

For example, the following regex checks whether an input contains only digits:

```regex
^[0-9]+$
```

This is not a mathematical formula. It describes the required format of a piece of text.

---

## 2. Digits-Only Regex

```regex
^[0-9]+$
```

The complete pattern means:

> From the beginning to the end of the input, there must be one or more digits and nothing else.

### Results

| Input | Result | Reason |
|---|---|---|
| `5` | Valid | It contains one digit. |
| `123` | Valid | It contains only digits. |
| `0` | Valid | Zero is also a digit. |
| `-10` | Invalid | A minus sign is not allowed. |
| `+10` | Invalid | A plus sign is not allowed. |
| `2.5` | Invalid | A decimal point is not allowed. |
| `abc` | Invalid | Letters are not allowed. |
| Empty input | Invalid | `+` requires at least one digit. |

---

## 3. Important Regex Symbols

| Symbol | Name | Meaning |
|---|---|---|
| `^` | Caret | Matches the beginning of the input. |
| `$` | Dollar sign | Matches the end of the input. |
| `[0-9]` | Character class | Matches one digit from `0` through `9`. |
| `+` | Plus quantifier | Requires the previous pattern one or more times. |
| `*` | Asterisk quantifier | Allows the previous pattern zero or more times. |
| `?` | Question-mark quantifier | Allows the previous pattern zero or one time. |
| `[+-]` | Character class | Matches either one plus or one minus sign. |
| `=~` | Regex operator | Matches a Bash value against a regex. |
| `!` | Logical NOT | Reverses a condition's result. |

### Why Use Both `^` and `$`?

Without anchors, a regex may match only one part of a longer string:

```regex
[0-9]+
```

That pattern can find `123` inside `abc123xyz`.

The anchored pattern:

```regex
^[0-9]+$
```

requires the complete input to contain digits only.

---

## 4. Regex Matching in Bash

The basic Bash syntax is:

```bash
[[ "$value" =~ REGEX ]]
```

Example:

```bash
number="123"

if [[ "$number" =~ ^[0-9]+$ ]]; then
    echo "Valid number"
else
    echo "Invalid input"
fi
```

In this condition:

- `"$number"` is the value being tested.
- `=~` is the regex-matching operator.
- `^[0-9]+$` is the required pattern.
- A successful match makes the condition true.

---

## 5. Positive Numbers, Negative Numbers, and Zero

Use the following regex to permit unsigned numbers, negative numbers, and zero:

```regex
^-?[0-9]+$
```

### Breakdown

| Part | Meaning |
|---|---|
| `^` | Beginning of the input. |
| `-?` | An optional minus sign. |
| `[0-9]+` | One or more digits. |
| `$` | End of the input. |

The `?` applies only to the immediately preceding minus sign. Therefore, the minus sign may appear:

- Zero times: `25`
- One time: `-25`
- Not two times: `--25`

### Examples

| Input | Match? |
|---|---|
| `25` | Yes |
| `-25` | Yes |
| `0` | Yes |
| `-0` | Yes, according to the text pattern |
| `--25` | No |
| `+25` | No |
| `2.5` | No |

---

## 6. Negative Numbers Only

To require an integer written with a minus sign, use:

```regex
^-[0-9]+$
```

Example:

```bash
if [[ "$number" =~ ^-[0-9]+$ ]]; then
    echo "Valid negative integer"
else
    echo "A negative whole number is required"
fi
```

### Important: The `-0` Case

The simple regex matches `-0` because its text has a minus sign followed by a digit. Mathematically, however, zero is not negative.

To require a value that is genuinely less than zero, combine format validation with a numeric comparison:

```bash
if [[ "$number" =~ ^-[0-9]+$ ]] && (( number < 0 )); then
    echo "Valid negative number"
else
    echo "Enter a number smaller than zero"
fi
```

The regex validates the format, while `(( number < 0 ))` validates the mathematical value.

---

## 7. Optional Plus or Minus Sign

To allow an explicit plus sign, a minus sign, or no sign, use:

```regex
^[+-]?[0-9]+$
```

### Examples

| Input | Match? |
|---|---|
| `25` | Yes |
| `+25` | Yes |
| `-25` | Yes |
| `++25` | No |
| `+-25` | No |
| `25+` | No |

`[+-]` is a character class that matches either one plus or one minus sign. The following `?` makes that sign optional.

---

## 8. Common Number Patterns

| Requirement | Regex |
|---|---|
| Digits only | `^[0-9]+$` |
| Unsigned, negative, or zero | `^-?[0-9]+$` |
| A required minus-sign format | `^-[0-9]+$` |
| An optional plus or minus sign | `^[+-]?[0-9]+$` |
| Exactly one digit | `^[0-9]$` |
| Zero or more digits | `^[0-9]*$` |

### Difference Between `+` and `*`

```regex
^[0-9]+$
```

The `+` requires at least one digit. Empty input is invalid.

```regex
^[0-9]*$
```

The `*` also permits zero digits, so an empty input can match. For ordinary number validation, `+` is normally the better choice.

---

## 9. Important Bash Notes

### Do Not Quote the Regex on the Right Side

Recommended:

```bash
[[ "$number" =~ ^-?[0-9]+$ ]]
```

You may also store the pattern in a variable:

```bash
integer_regex='^-?[0-9]+$'

if [[ "$number" =~ $integer_regex ]]; then
    echo "Valid integer"
fi
```

Do not quote the regex variable on the right side of `=~`, because quoting can change regex matching into literal-string matching.

### Use `[[ ]]`

The `=~` operator is used inside Bash's double-bracket conditional syntax:

```bash
[[ "$value" =~ REGEX ]]
```

Do not use:

```bash
[ "$value" =~ REGEX ]
```

The single-bracket `test` syntax does not support the Bash `=~` operator.

### Regex Validates Format

A regex checks the input's text format. Perform arithmetic only after validation. This prevents arbitrary invalid text from being used as an arithmetic expression.

---

## 10. Complete Validation Script

```bash
#!/bin/bash

# Purpose: Accept one positive or negative whole number.

if ! read -r -p "Enter a whole number: " number; then
    echo "Error: could not read input." >&2
    exit 1
fi

if [[ ! "$number" =~ ^-?[0-9]+$ ]]; then
    echo "Error: enter a valid whole number." >&2
    exit 1
fi

if (( number > 0 )); then
    echo "$number is positive."
elif (( number < 0 )); then
    echo "$number is negative."
else
    echo "$number is zero."
fi

exit 0
```

### Validation Flow

1. `read` obtains input from the user.
2. The regex validates the input's format.
3. Invalid input produces an error on `stderr`.
4. Arithmetic comparisons classify a valid integer.
5. The script returns `exit 0` after successful completion.

---

## 11. Practice Tasks

### Task 1

Write a condition that permits digits only:

```text
Accepted: 0, 7, 123
Rejected: -7, +7, 2.5, abc
```

### Task 2

Write a regex that accepts positive and negative whole numbers.

### Task 3

Write validation that rejects `-0` and permits only values smaller than zero.

### Task 4

Accept integers with an optional `+` or `-` sign.

---

## 12. Summary

- Regex is used for pattern matching and input validation.
- `^[0-9]+$` accepts one or more digits only.
- `^-?[0-9]+$` accepts integers with an optional minus sign.
- `^-[0-9]+$` requires a minus-sign format.
- `^[+-]?[0-9]+$` permits an optional plus or minus sign.
- `^` anchors the beginning and `$` anchors the end.
- Bash uses `[[ value =~ regex ]]` for regex matching.
- Regex validates format; a numeric comparison may still be needed to verify mathematical meaning.
