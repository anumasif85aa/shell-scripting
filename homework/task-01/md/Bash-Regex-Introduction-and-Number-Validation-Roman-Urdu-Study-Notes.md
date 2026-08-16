# Bash Regex — Introduction aur Number Validation (Roman Urdu)

## Table of Contents

- [1. Regex Kya Hai?](#1-regex-kya-hai)
- [2. Digits-Only Regex](#2-digits-only-regex)
- [3. Regex Symbols](#3-regex-symbols)
- [4. Bash Mein Regex Matching](#4-bash-mein-regex-matching)
- [5. Positive, Negative aur Zero](#5-positive-negative-aur-zero)
- [6. Sirf Negative Numbers](#6-sirf-negative-numbers)
- [7. Plus aur Minus Sign](#7-plus-aur-minus-sign)
- [8. Common Examples](#8-common-examples)
- [9. Important Bash Notes](#9-important-bash-notes)
- [10. Complete Validation Script](#10-complete-validation-script)
- [11. Practice Tasks](#11-practice-tasks)
- [12. Summary](#12-summary)

---

## 1. Regex Kya Hai?

**Regex** ka full form **Regular Expression** hai.

Regex aik pattern hota hai jo text ko:

- Check karta hai
- Search karta hai
- Match karta hai
- Validate karta hai

Misal ke taur par, agar hamein check karna ho ke user ne sirf digits enter kiye hain, hum yeh regex use kar sakte hain:

```regex
^[0-9]+$
```

Yeh koi mathematical formula nahin hai. Yeh text ka pattern describe karta hai.

---

## 2. Digits-Only Regex

```regex
^[0-9]+$
```

Is poore pattern ka matlab hai:

> Input ke start se end tak sirf aik ya zyada digits hon.

### Results

| Input | Result | Wajah |
|---|---|---|
| `5` | Valid | Aik digit hai. |
| `123` | Valid | Sirf digits hain. |
| `0` | Valid | Zero bhi digit hai. |
| `-10` | Invalid | Minus sign allowed nahin. |
| `+10` | Invalid | Plus sign allowed nahin. |
| `2.5` | Invalid | Decimal point allowed nahin. |
| `abc` | Invalid | Letters allowed nahin. |
| Empty input | Invalid | `+` kam az kam aik digit mangta hai. |

---

## 3. Regex Symbols

| Symbol | Naam | Matlab |
|---|---|---|
| `^` | Caret | Input ya string ka start. |
| `$` | Dollar sign | Input ya string ka end. |
| `[0-9]` | Character class | `0` se `9` tak koi aik digit. |
| `+` | Plus quantifier | Pichla pattern aik ya zyada martaba. |
| `*` | Asterisk quantifier | Pichla pattern zero ya zyada martaba. |
| `?` | Question-mark quantifier | Pichla pattern zero ya aik martaba. |
| `[+-]` | Character class | Plus ya minus mein se koi aik sign. |
| `=~` | Regex operator | Bash mein value ko regex se match karta hai. |
| `!` | Logical NOT | Match ka result reverse karta hai. |

### `^` aur `$` Dono Kyun?

Agar anchors use na hon, regex string ke sirf aik hissay ko bhi match kar sakta hai.

```regex
[0-9]+
```

Yeh `abc123xyz` ke andar `123` match kar sakta hai.

Lekin:

```regex
^[0-9]+$
```

poori string ko digits-only hona lazmi banata hai.

---

## 4. Bash Mein Regex Matching

Bash mein regex match ka basic syntax:

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

Yahan:

- `"$number"` woh value hai jo check ho rahi hai.
- `=~` regex matching operator hai.
- `^[0-9]+$` required pattern hai.
- Match successful ho to condition true hoti hai.

---

## 5. Positive, Negative aur Zero

Positive numbers, negative numbers aur zero allow karne ke liye:

```regex
^-?[0-9]+$
```

### Breakdown

| Hissa | Matlab |
|---|---|
| `^` | Input ka start. |
| `-?` | Minus sign optional hai. |
| `[0-9]+` | Aik ya zyada digits. |
| `$` | Input ka end. |

`?` sirf apne foran pehle wale pattern `-` par apply hota hai. Is ka matlab minus sign:

- Zero martaba aa sakta hai: `25`
- Aik martaba aa sakta hai: `-25`
- Do martaba nahin aa sakta: `--25`

### Examples

| Input | Match? |
|---|---|
| `25` | Yes |
| `-25` | Yes |
| `0` | Yes |
| `-0` | Regex ke mutabiq Yes |
| `--25` | No |
| `+25` | No |
| `2.5` | No |

---

## 6. Sirf Negative Numbers

Agar sirf minus sign wale integers accept karne hon:

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

### Important: `-0`

Simple regex `-0` ko match kar de ga, kyun ke text ka format minus sign aur digit par mushtamil hai. Lekin mathematically zero negative nahin hota.

Strictly zero se chhota number check karne ke liye regex ke baad numeric comparison bhi karein:

```bash
if [[ "$number" =~ ^-[0-9]+$ ]] && (( number < 0 )); then
    echo "Valid negative number"
else
    echo "Enter a number smaller than zero"
fi
```

---

## 7. Plus aur Minus Sign

Agar explicit plus sign, minus sign, ya koi sign na ho—teeno allow karne hon:

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

`[+-]` aik character class hai. Is ka matlab plus ya minus mein se koi aik character hai. Us ke baad `?` sign ko optional banata hai.

---

## 8. Common Examples

| Requirement | Regex |
|---|---|
| Sirf digits | `^[0-9]+$` |
| Positive, negative ya zero | `^-?[0-9]+$` |
| Sirf minus-sign format | `^-[0-9]+$` |
| Optional plus ya minus | `^[+-]?[0-9]+$` |
| Exactly aik digit | `^[0-9]$` |
| Zero ya zyada digits | `^[0-9]*$` |

### `+` aur `*` Mein Farq

```regex
^[0-9]+$
```

`+` kam az kam aik digit require karta hai. Empty input invalid hai.

```regex
^[0-9]*$
```

`*` zero digits bhi allow karta hai. Is liye empty input valid match ban sakta hai. Number validation ke liye aam tor par `+` behtar hai.

---

## 9. Important Bash Notes

### Regex ko Right Side par Quote Na Karein

Recommended:

```bash
[[ "$number" =~ ^-?[0-9]+$ ]]
```

Regex ko variable mein bhi rakh sakte hain:

```bash
integer_regex='^-?[0-9]+$'

if [[ "$number" =~ $integer_regex ]]; then
    echo "Valid integer"
fi
```

Right-side regex variable ko `[[ ... =~ ... ]]` mein quote na karein.

### `[[ ]]` Use Karein

`=~` Bash ka conditional regex operator hai aur `[[ ... ]]` ke andar use hota hai:

```bash
[[ "$value" =~ REGEX ]]
```

Yeh syntax use na karein:

```bash
[ "$value" =~ REGEX ]
```

Single brackets ke saath `=~` supported nahin hai.

### Regex Format Check Karta Hai

Regex pehle yeh check karta hai ke input ka format sahi hai ya nahin. Numeric calculation us ke baad karein. Is se invalid text ko arithmetic expression mein dene se bach jate hain.

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

1. `read` user se input leta hai.
2. Regex format check karta hai.
3. Invalid input par error `stderr` par jata hai.
4. Valid integer ko arithmetic comparison se classify kiya jata hai.
5. Script success par `exit 0` karti hai.

---

## 11. Practice Tasks

### Task 1

Aisi condition likhein jo sirf digits accept kare:

```text
Accepted: 0, 7, 123
Rejected: -7, +7, 2.5, abc
```

### Task 2

Aisi regex likhein jo positive aur negative whole numbers accept kare.

### Task 3

Aisi validation likhein jo `-0` ko reject kare aur sirf zero se chhote numbers accept kare.

### Task 4

Optional `+` ya `-` sign ke saath integers accept karein.

---

## 12. Summary

- Regex text pattern matching aur validation ke liye use hota hai.
- `^[0-9]+$` sirf aik ya zyada digits accept karta hai.
- `^-?[0-9]+$` optional minus sign ke saath integers accept karta hai.
- `^-[0-9]+$` minus-sign format require karta hai.
- `^[+-]?[0-9]+$` optional plus ya minus allow karta hai.
- `^` start aur `$` end ko anchor karte hain.
- Bash mein regex ke liye `[[ value =~ regex ]]` use hota hai.
- Regex format validate karta hai; mathematical meaning ke liye numeric comparison bhi zaroori ho sakta hai.
