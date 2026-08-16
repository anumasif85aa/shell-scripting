# Bash Regular Expressions — Quick Reference Cheat Sheet

**English | POSIX Extended Regular Expressions (ERE) | Fast Lookup**

> This file focuses exclusively on Bash regular expressions. It does not cover globbing, `case` patterns, file tests, or parameter-expansion patterns.

## Quick Navigation

- [1. Essential syntax](#1-essential-syntax)
- [2. Regex symbols](#2-regex-symbols)
- [3. POSIX character classes](#3-posix-character-classes)
- [4. Anchors and matching scope](#4-anchors-and-matching-scope)
- [5. Quantifiers](#5-quantifiers)
- [6. Groups, alternatives, and captures](#6-groups-alternatives-and-captures)
- [7. Ready-to-use validation patterns](#7-ready-to-use-validation-patterns)
- [8. Quoting and escaping rules](#8-quoting-and-escaping-rules)
- [9. Match results and exit statuses](#9-match-results-and-exit-statuses)
- [10. Case-insensitive matching](#10-case-insensitive-matching)
- [11. Common mistakes](#11-common-mistakes)
- [12. Debugging quick reference](#12-debugging-quick-reference)
- [13. Bash ERE limitations](#13-bash-ere-limitations)
- [14. Copy-and-use templates](#14-copy-and-use-templates)
- [15. Final one-screen reference](#15-final-one-screen-reference)

---

## 1. Essential Syntax

### Core Bash regex table

| Purpose | Syntax | Result |
|---|---|---|
| Test for a regex match | `[[ "$value" =~ $regex ]]` | True when the value matches |
| Reverse the match result | `[[ ! "$value" =~ $regex ]]` | True when the value does not match |
| Use an inline regex | `[[ "$value" =~ ^[0-9]+$ ]]` | Validates a digits-only value |
| Store a regex in a variable | `regex='^[0-9]+$'` | Keeps complex expressions readable |
| Read the complete match | `${BASH_REMATCH[0]}` | Contains all matched text |
| Read the first group | `${BASH_REMATCH[1]}` | Contains the first `(...)` capture |
| Read the second group | `${BASH_REMATCH[2]}` | Contains the second `(...)` capture |

### Recommended form

```bash
regex='^[0-9]+$'

if [[ "$value" =~ $regex ]]; then
    echo "Valid"
else
    echo "Invalid"
fi
```

### Critical quoting rule

```bash
[[ "$value" =~ $regex ]]    # Correct
[[ "$value" =~ "$regex" ]]  # Avoid: the regex may become literal text
```

Quote the input data on the left. Do not quote the complete regex variable on the right.

---

## 2. Regex Symbols

### Metacharacter quick-reference table

| Symbol | Name | Meaning | Example | What the example matches |
|---|---|---|---|---|
| `^` | Start anchor | Beginning of the string | `^Error` | A value beginning with `Error` |
| `$` | End anchor | End of the string | `[.]log$` | A value ending with `.log` |
| `.` | Dot | Any one character | `c.t` | `cat`, `cut`, `c9t` |
| `[abc]` | Character class | One listed character | `^[abc]$` | `a`, `b`, or `c` |
| `[^abc]` | Negated class | One character not listed | `^[^0-9]$` | One non-digit |
| `[a-z]` | Range | One character from the range | `^[a-z]$` | One lowercase letter |
| `*` | Zero or more | Previous item repeated zero or more times | `ab*` | `a`, `ab`, `abb` |
| `+` | One or more | Previous item repeated one or more times | `[0-9]+` | One or more digits |
| `?` | Optional | Previous item appears zero or one time | `-?` | An optional minus sign |
| `{n}` | Exact count | Exactly `n` repetitions | `[0-9]{4}` | Exactly four digits |
| `{n,m}` | Count range | Between `n` and `m` repetitions | `[0-9]{2,4}` | Two, three, or four digits |
| `{n,}` | Minimum count | At least `n` repetitions | `[a-z]{3,}` | At least three letters |
| `(...)` | Group | Groups and captures expressions | `(yes|no)` | `yes` or `no` |
| `|` | Alternation | Left expression or right expression | `cat|dog` | `cat` or `dog` |
| `\` | Escape | Treats a special symbol literally | `\.` | An actual dot |

### Matching literal special characters

| Literal character | Escaped regex | Readable alternative |
|---|---|---|
| `.` | `\.` | `[.]` |
| `*` | `\*` | `[*]` |
| `+` | `\+` | `[+]` |
| `?` | `\?` | `[?]` |
| `(` | `\(` | `[(]` |
| `)` | `\)` | `[)]` |
| `[` | `\[` | `[[]` |
| `]` | `\]` | `[]]` |
| `$` | `\$` | `[$]` |
| `|` | `\|` | `[|]` |
| `\` | `\\` | Test carefully with the chosen quoting context |

> Forms such as `[.]`, `[+]`, and `[*]` often reduce backslash confusion in stored regex variables.

---

## 3. POSIX Character Classes

| Class | Meaning | Example regex | Example match |
|---|---|---|---|
| `[[:digit:]]` | Digit | `^[[:digit:]]+$` | `12345` |
| `[[:alpha:]]` | Letter | `^[[:alpha:]]+$` | `Khalid` |
| `[[:alnum:]]` | Letter or digit | `^[[:alnum:]]+$` | `user25` |
| `[[:lower:]]` | Lowercase letter | `^[[:lower:]]+$` | `linux` |
| `[[:upper:]]` | Uppercase letter | `^[[:upper:]]+$` | `RHEL` |
| `[[:space:]]` | Whitespace | `^[[:space:]]*$` | Spaces, tabs, or newlines |
| `[[:blank:]]` | Space or tab | `^[[:blank:]]*$` | Horizontal whitespace |
| `[[:xdigit:]]` | Hexadecimal digit | `^[[:xdigit:]]+$` | `09AFbe` |
| `[[:punct:]]` | Punctuation | `^[[:punct:]]+$` | `!?.,` |
| `[[:print:]]` | Printable character | `^[[:print:]]+$` | Visible text and spaces |
| `[[:graph:]]` | Visible non-space character | `^[[:graph:]]+$` | Printable text without spaces |
| `[[:cntrl:]]` | Control character | `[[:cntrl:]]` | Tabs, newlines, and other controls |

### Correct nesting

```bash
regex='^[[:digit:]]+$'  # Correct
regex='^[:digit:]+$'    # Incorrect
```

A POSIX class requires both bracket levels: `[[:digit:]]`.

---

## 4. Anchors and Matching Scope

### Anchor behavior

| Regex | Meaning | Result for `abc123xyz` |
|---|---|---|
| `[0-9]+` | Find digits anywhere | Match: `123` |
| `^[0-9]+` | Must begin with digits | No match |
| `[0-9]+$` | Must end with digits | No match |
| `^[0-9]+$` | Entire value must contain only digits | No match |

### Substring search

```bash
[[ "abc123xyz" =~ [0-9]+ ]]
```

This succeeds because the string contains `123`.

### Whole-string validation

```bash
[[ "123" =~ ^[0-9]+$ ]]
```

This succeeds because the complete string contains only digits.

### Quick selection table

| Requirement | Use |
|---|---|
| Search anywhere in a string | Usually omit anchors |
| Check a prefix | `^pattern` |
| Check a suffix | `pattern$` |
| Validate the complete input | `^pattern$` |

---

## 5. Quantifiers

| Quantifier | Minimum | Maximum | Allows zero occurrences? | Example |
|---|---:|---:|---:|---|
| `*` | 0 | Unlimited | Yes | `[0-9]*` |
| `+` | 1 | Unlimited | No | `[0-9]+` |
| `?` | 0 | 1 | Makes the previous item optional | `[+-]?` |
| `{3}` | 3 | 3 | No | `[0-9]{3}` |
| `{2,5}` | 2 | 5 | No | `[a-z]{2,5}` |
| `{2,}` | 2 | Unlimited | No | `[a-z]{2,}` |

### `*` versus `+`

```bash
empty=""

[[ "$empty" =~ ^[0-9]*$ ]]  # True: zero digits are allowed
[[ "$empty" =~ ^[0-9]+$ ]]  # False: at least one digit is required
```

### Optional signs

| Allowed values | Regex |
|---|---|
| Non-negative integers only | `^[0-9]+$` |
| Optional minus sign | `^-?[0-9]+$` |
| Optional plus or minus sign | `^[+-]?[0-9]+$` |

---

## 6. Groups, Alternatives, and Captures

### Grouping and alternation

```bash
regex='^(start|stop|restart|status)$'

if [[ "$action" =~ $regex ]]; then
    echo "Valid action"
fi
```

### `BASH_REMATCH` table

| Array element | Content |
|---|---|
| `${BASH_REMATCH[0]}` | Complete match |
| `${BASH_REMATCH[1]}` | First capture group |
| `${BASH_REMATCH[2]}` | Second capture group |
| `${BASH_REMATCH[n]}` | Capture group number `n` |

### Capture date components

```bash
value="2026-08-15"
regex='^([0-9]{4})-([0-9]{2})-([0-9]{2})$'

if [[ "$value" =~ $regex ]]; then
    full_match=${BASH_REMATCH[0]}
    year=${BASH_REMATCH[1]}
    month=${BASH_REMATCH[2]}
    day=${BASH_REMATCH[3]}

    echo "Full: $full_match"
    echo "Year: $year"
    echo "Month: $month"
    echo "Day: $day"
fi
```

### Capture a version

```bash
tag="v2.15.7"
regex='^v?([0-9]+)[.]([0-9]+)[.]([0-9]+)$'

if [[ "$tag" =~ $regex ]]; then
    major=${BASH_REMATCH[1]}
    minor=${BASH_REMATCH[2]}
    patch=${BASH_REMATCH[3]}
fi
```

> A later `=~` test can change `BASH_REMATCH`. Copy the required captures into variables immediately after a successful match.

---

## 7. Ready-to-Use Validation Patterns

### Numbers

| Validation | Regex | Valid examples | Invalid examples |
|---|---|---|---|
| Digits only | `^[0-9]+$` | `0`, `25`, `008` | `-2`, `2.5`, empty |
| Signed integer | `^[+-]?[0-9]+$` | `25`, `-7`, `+9` | `2.5`, `--2` |
| Positive integer, excluding zero | `^[+]?[1-9][0-9]*$` | `1`, `25`, `+8` | `0`, `-2`, `01` |
| Strict decimal | `^[+-]?[0-9]+([.][0-9]+)?$` | `5`, `-2.75` | `.5`, `5.`, `1.2.3` |
| Flexible decimal | `^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$` | `5`, `.5`, `5.`, `-2.7` | `.`, `--2` |
| Exactly four digits | `^[0-9]{4}$` | `2026`, `0042` | `26`, `20260` |
| Two to five digits | `^[0-9]{2,5}$` | `12`, `12345` | `1`, `123456` |

> A regex checks a number’s format. Validate its permitted numeric range separately with `(( ... ))`.

### Text

| Validation | Regex | Valid examples | Invalid examples |
|---|---|---|---|
| Letters only | `^[[:alpha:]]+$` | `Khalid` | `Khalid25`, empty |
| Letters and spaces | `^[[:alpha:] ]+$` | `Ali Khan` | `Ali_25` |
| Alphanumeric only | `^[[:alnum:]]+$` | `server25` | `server-25` |
| Lowercase only | `^[[:lower:]]+$` | `linux` | `Linux`, `rhel9` |
| Uppercase only | `^[[:upper:]]+$` | `RHEL` | `Rhel`, `RHEL9` |
| Non-empty value | `^.+$` | `anything` | Empty string |
| Empty or whitespace only | `^[[:space:]]*$` | Empty string, spaces | `text` |
| Contains a digit | `[0-9]` | `user2` | `user` |
| Contains whitespace | `[[:space:]]` | `Ali Khan` | `AliKhan` |
| Contains a non-digit | `[^0-9]` | `12a` | `123` |

### Names, identifiers, and choices

| Validation | Regex | Note |
|---|---|---|
| Simple Bash variable name | `^[a-zA-Z_][a-zA-Z0-9_]*$` | Cannot begin with a digit |
| Simple Linux username | `^[a-z_][a-z0-9_-]{0,31}$` | Teaching pattern; local policies may differ |
| Environment name | `^(dev|test|stage|prod)$` | Accepts only listed choices |
| Service action | `^(start|stop|restart|reload|status)$` | Controlled command selection |
| Yes/no | `^([Yy]([Ee][Ss])?|[Nn][Oo]?)$` | Accepts `y`, `yes`, `n`, and `no` |
| Simple identifier | `^[a-zA-Z][a-zA-Z0-9_-]*$` | Must begin with a letter |

### Dates, times, and versions

| Validation | Regex | Format only? |
|---|---|---:|
| Date | `^[0-9]{4}-[0-9]{2}-[0-9]{2}$` | Yes |
| Time | `^[0-9]{2}:[0-9]{2}:[0-9]{2}$` | Yes |
| Year | `^[0-9]{4}$` | Yes |
| Semantic-version shape | `^v?[0-9]+[.][0-9]+[.][0-9]+$` | Yes |
| Release tag with captures | `^v?([0-9]+)[.]([0-9]+)[.]([0-9]+)$` | Yes |

> A value such as `2026-99-99` matches the date shape. Validate calendar correctness separately.

### Network and system formats

| Validation | Regex | Important note |
|---|---|---|
| IPv4 shape | `^([0-9]{1,3}[.]){3}[0-9]{1,3}$` | Check each octet’s `0–255` range separately |
| Port-number shape | `^[0-9]{1,5}$` | Check the `1–65535` range separately |
| MAC address | `^([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}$` | Colon-separated format |
| UUID shape | `^[[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12}$` | Hexadecimal shape |
| Simple hostname label | `^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?$` | One DNS label, not a complete FQDN |
| Hexadecimal value | `^(0[xX])?[[:xdigit:]]+$` | Optional `0x` prefix |

### File-like strings and email shape

| Validation | Regex | Important note |
|---|---|---|
| Ends with `.log` | `[.]log$` | Checks a string suffix only |
| Ends with `.sh` | `[.]sh$` | Does not check file existence |
| Basic filename characters | `^[a-zA-Z0-9._-]+$` | Rejects slashes and spaces |
| Simple email shape | `^[[:alnum:]._%+-]+@[[:alnum:].-]+[.][[:alpha:]]{2,}$` | Not a complete email-standard validator |

---

## 8. Quoting and Escaping Rules

| Item | Recommended | Avoid | Reason |
|---|---|---|---|
| Input value | `"$value"` | `$value` | Represents input data safely |
| Regex variable definition | `regex='^[0-9]+$'` | Unquoted assignment | Prevents unintended shell interpretation |
| Regex variable in `=~` | `[[ "$value" =~ $regex ]]` | `[[ "$value" =~ "$regex" ]]` | A quoted right side may become literal |
| Literal dot | `[.]` or `\.` | `.` | Dot otherwise means any character |
| Complex inline regex | Store it in a variable | Excessive inline escaping | Improves readability and debugging |

### Recommended pattern

```bash
value="${1:-}"
regex='^[+-]?[0-9]+$'

if [[ "$value" =~ $regex ]]; then
    echo "Valid integer"
fi
```

### Literal dot example

```bash
regex='^[0-9]+[.][0-9]+$'
```

This matches `2.5` but not `2x5`.

---

## 9. Match Results and Exit Statuses

| Exit status | Meaning |
|---:|---|
| `0` | The regex matched |
| `1` | The regex did not match |
| `2` | The regex syntax was invalid |

### Preserve and inspect the status

```bash
if [[ "$value" =~ $regex ]]; then
    echo "Matched"
else
    status=$?

    if (( status == 1 )); then
        echo "No match"
    else
        echo "Invalid regex: status $status" >&2
        exit "$status"
    fi
fi
```

### Reject invalid input with `!`

```bash
if [[ ! "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: age must contain digits only." >&2
    exit 1
fi
```

This means: run the error block when `$age` does not completely match the digits-only regex.

---

## 10. Case-Insensitive Matching

Enable Bash’s `nocasematch` option to make `=~` matching case-insensitive:

```bash
shopt -s nocasematch

if [[ "ERROR" =~ ^error$ ]]; then
    echo "Matched without case sensitivity"
fi

shopt -u nocasematch
```

| Command | Purpose |
|---|---|
| `shopt -s nocasematch` | Enables case-insensitive matching |
| `shopt -u nocasematch` | Restores normal case-sensitive matching |

Disable the option after use so it does not unexpectedly affect later conditions.

---

## 11. Common Mistakes

| Mistake | Incorrect | Correct | Problem |
|---|---|---|---|
| Quoting the regex variable | `[[ "$v" =~ "$regex" ]]` | `[[ "$v" =~ $regex ]]` | The pattern may become literal text |
| Omitting anchors during validation | `[0-9]+` | `^[0-9]+$` | Mixed text can still match |
| Failing to escape dot | `^[0-9]+.[0-9]+$` | `^[0-9]+[.][0-9]+$` | Dot matches any character |
| Accidentally accepting empty input | `^[0-9]*$` | `^[0-9]+$` | `*` allows zero characters |
| Using a PCRE shorthand | `^\d+$` | `^[0-9]+$` | `\d` is not reliable Bash ERE syntax |
| Using a non-capturing group | `(?:yes|no)` | `(yes|no)` | Bash ERE does not support `(?:...)` |
| Treating format as a range check | `^[0-9]{1,3}$` | Regex plus arithmetic test | `999` still matches the format |
| Reading `BASH_REMATCH` too late | Read after another match | Copy immediately | A later match can overwrite it |
| Ignoring an invalid dynamic regex | Handle only match/no-match | Check for status `2` | Syntax errors can look like ordinary failures |

---

## 12. Debugging Quick Reference

| Debugging need | Command | Purpose |
|---|---|---|
| Reveal hidden characters | `printf 'value=<%q>\n' "$value"` | Shows spaces and shell-special characters |
| Print the regex | `printf 'regex=<%s>\n' "$regex"` | Shows the stored expression |
| Inspect condition status | `[[ "$value" =~ $regex ]]; echo "$?"` | Displays `0`, `1`, or `2` |
| Print the complete match | `printf '%s\n' "${BASH_REMATCH[0]}"` | Shows the full match |
| Inspect capture groups | `declare -p BASH_REMATCH` | Displays the capture array |
| Check script syntax | `bash -n script.sh` | Checks syntax without execution |
| Trace execution | `bash -x script.sh` | Displays commands as Bash runs them |

### Table-driven regex test

```bash
regex='^[0-9]+$'
tests=("25" "0" "08" "-5" "12.5" "25 years" "")

for value in "${tests[@]}"
do
    if [[ "$value" =~ $regex ]]; then
        printf 'MATCH:    <%s>\n' "$value"
    else
        printf 'NO MATCH: <%s>\n' "$value"
    fi
done
```

| Value | Expected result |
|---|---|
| `25` | Match |
| `0` | Match |
| `08` | Match |
| `-5` | No match |
| `12.5` | No match |
| `25 years` | No match |
| Empty string | No match |

---

## 13. Bash ERE Limitations

Bash `[[ ... =~ ... ]]` uses **POSIX Extended Regular Expressions (ERE)**, not PCRE.

### Avoid these PCRE constructs

| PCRE construct | Bash ERE alternative |
|---|---|
| `\d` | `[0-9]` or `[[:digit:]]` |
| `\w` | `[[:alnum:]_]` |
| `\s` | `[[:space:]]` |
| `(?:...)` | `(...)` |
| `(?=...)` | Use multiple Bash conditions |
| `(?<=...)` | Use capture groups or separate processing |
| Lazy quantifier `.*?` | No direct Bash ERE equivalent |

### Portability table

| Environment | Regex support |
|---|---|
| Bash `[[ =~ ]]` | POSIX ERE |
| `grep -E` | POSIX ERE |
| `sed -E` | Extended regex syntax |
| `awk` | ERE-style regex |
| POSIX `/bin/sh` | Does not provide `[[ =~ ]]` |

Run scripts using Bash regex with a Bash shebang:

```bash
#!/bin/bash
```

---

## 14. Copy-and-Use Templates

### Required argument and regex validation

```bash
#!/bin/bash

value="${1:-}"
regex='^[0-9]+$'

if [[ -z "$value" ]]; then
    echo "Usage: $0 NUMBER" >&2
    exit 2
fi

if [[ ! "$value" =~ $regex ]]; then
    echo "Error: enter a non-negative whole number." >&2
    exit 1
fi

echo "Valid number: $value"
exit 0
```

### Format followed by range validation

```bash
#!/bin/bash

age="${1:-}"
regex='^[0-9]+$'

if [[ ! "$age" =~ $regex ]]; then
    echo "Error: age must contain digits only." >&2
    exit 1
fi

age_number=$((10#$age))

if (( age_number < 1 || age_number > 120 )); then
    echo "Error: age must be between 1 and 120." >&2
    exit 1
fi

echo "Valid age: $age_number"
```

### Capture structured input

```bash
#!/bin/bash

release="${1:-}"
regex='^v?([0-9]+)[.]([0-9]+)[.]([0-9]+)$'

if [[ ! "$release" =~ $regex ]]; then
    echo "Usage: $0 vMAJOR.MINOR.PATCH" >&2
    exit 2
fi

major=${BASH_REMATCH[1]}
minor=${BASH_REMATCH[2]}
patch=${BASH_REMATCH[3]}

echo "Major: $major"
echo "Minor: $minor"
echo "Patch: $patch"
```

---

## 15. Final One-Screen Reference

### Essential syntax

| Need | Use |
|---|---|
| Match | `[[ "$value" =~ $regex ]]` |
| Reject a failed match | `[[ ! "$value" =~ $regex ]]` |
| Entire string | `^...$` |
| Any one character | `.` |
| One digit | `[0-9]` |
| One letter | `[[:alpha:]]` |
| One or more | `+` |
| Zero or more | `*` |
| Optional | `?` |
| Exact count | `{n}` |
| Alternatives | `(one|two)` |
| Literal dot | `[.]` |
| Complete match | `${BASH_REMATCH[0]}` |
| First capture | `${BASH_REMATCH[1]}` |

### Most-used patterns

| Need | Regex |
|---|---|
| Digits only | `^[0-9]+$` |
| Signed integer | `^[+-]?[0-9]+$` |
| Decimal | `^[+-]?[0-9]+([.][0-9]+)?$` |
| Letters only | `^[[:alpha:]]+$` |
| Alphanumeric | `^[[:alnum:]]+$` |
| Bash variable name | `^[a-zA-Z_][a-zA-Z0-9_]*$` |
| Controlled action | `^(start|stop|restart|status)$` |
| Date shape | `^[0-9]{4}-[0-9]{2}-[0-9]{2}$` |
| Version shape | `^v?[0-9]+[.][0-9]+[.][0-9]+$` |
| IPv4 shape | `^([0-9]{1,3}[.]){3}[0-9]{1,3}$` |

### Five rules to remember

1. Bash’s `=~` operator uses POSIX ERE regex.
2. Quote the input value: `"$value"`.
3. Do not quote the regex variable during matching: `$regex`.
4. Use `^...$` when the complete input must match.
5. Regex validates format; check numeric ranges and real-world validity separately.
