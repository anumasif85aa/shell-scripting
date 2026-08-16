# Bash Positive aur Negative Countdown — Roman Urdu Study Notes

## Table of Contents

- [Project ka Maqsad](#project-ka-maqsad)
- [Complete Script](#complete-script)
- [Script ka Flow](#script-ka-flow)
- [Input Read Karna](#input-read-karna)
- [Positive aur Negative Number Validate Karna](#positive-aur-negative-number-validate-karna)
- [Regex ki Tafseel](#regex-ki-tafseel)
- [Positive aur Negative Number Convert Karna](#positive-aur-negative-number-convert-karna)
- [`10#` Kyun Use Kiya Hai?](#10-kyun-use-kiya-hai)
- [Countdown Loop](#countdown-loop)
- [Positive aur Negative Direction](#positive-aur-negative-direction)
- [Example Outputs](#example-outputs)
- [Common Mistakes](#common-mistakes)
- [Testing](#testing)
- [Quick Summary](#quick-summary)

## Project ka Maqsad

Yeh Bash script user se positive, negative ya zero whole number leta hai aur us number se `0` ki taraf counting karta hai.

Examples:

```text
3  →  2  →  1  →  0
-3 → -2  → -1  →  0
```

Script mein input reading, regex validation, decimal conversion, `while` loop aur error handling use ki gayi hai.

Suggested script name:

```text
count_to_zero.sh
```

## Complete Script

```bash
#!/bin/bash

# Title: Count Toward Zero
# Purpose: Count from a positive or negative whole number toward zero.

if ! read -r -p "Enter a starting number: " starting_number; then
    echo "Error: could not read the input." >&2
    exit 1
fi

if [[ ! "$starting_number" =~ ^-?[0-9]+$ ]]; then
    echo "Error: enter a valid whole number." >&2
    exit 1
fi

# Safely handle leading zeros and negative values.
if [[ "$starting_number" == -* ]]; then
    digits="${starting_number#-}"
    count=$((-10#$digits))
else
    count=$((10#$starting_number))
fi

while (( count != 0 ))
do
    echo "$count"

    if (( count > 0 )); then
        count=$((count - 1))
    else
        count=$((count + 1))
    fi
done

echo "0"
echo "Done!"
exit 0
```

## Script ka Flow

```text
User se input lo
        ↓
Check karo read successful tha?
        ↓
Regex se whole number validate karo
        ↓
Positive ya negative sign check karo
        ↓
Value ko decimal number mein convert karo
        ↓
Positive ho to 1 minus karo
Negative ho to 1 plus karo
        ↓
Zero print karo
        ↓
Done!
```

## Input Read Karna

```bash
if ! read -r -p "Enter a starting number: " starting_number; then
```

| Part | Roman Urdu mein matlab |
|---|---|
| `if` | Agar condition true ho |
| `!` | Command ka result reverse karo |
| `read` | User se input lo |
| `-r` | Backslash ko normal character samjho |
| `-p` | Input se pehle prompt dikhao |
| `starting_number` | Input is variable mein store hoga |

`read` successful ho to exit status `0` deta hai. `!` us result ko false bana deta hai, is liye error block nahi chalta.

Agar `read` fail ho jaye, `!` result ko true bana deta hai aur error block run hota hai:

```bash
echo "Error: could not read the input." >&2
exit 1
```

`>&2` error message ko standard error par bhejta hai. `exit 1` script ki failure show karta hai.

## Positive aur Negative Number Validate Karna

```bash
if [[ ! "$starting_number" =~ ^-?[0-9]+$ ]]; then
    echo "Error: enter a valid whole number." >&2
    exit 1
fi
```

Iska matlab hai:

> Agar input optional minus sign ke baad sirf digits par mushtamil nahi hai, to error do aur script band kar do.

Valid inputs:

```text
10
0
-5
007
-008
```

Invalid inputs:

```text
--5
5-
- 5
4.5
five
```

## Regex ki Tafseel

Regex:

```regex
^-?[0-9]+$
```

| Symbol | Roman Urdu mein matlab |
|---|---|
| `^` | String yahan se shuru honi chahiye |
| `-` | Minus sign |
| `?` | Pichla symbol zero ya ek baar aa sakta hai |
| `-?` | Minus sign optional hai |
| `[0-9]` | Koi bhi digit `0` se `9` |
| `+` | Ek ya zyada digits zaroor hon |
| `$` | String yahan khatam honi chahiye |

### Sirf non-negative numbers

```regex
^[0-9]+$
```

Yeh `0` aur positive numbers allow karta hai, lekin negative number reject karta hai.

### Positive, negative aur zero

```regex
^-?[0-9]+$
```

Yeh optional minus sign ki wajah se positive, negative aur zero values allow karta hai.

## Positive aur Negative Number Convert Karna

```bash
if [[ "$starting_number" == -* ]]; then
    digits="${starting_number#-}"
    count=$((-10#$digits))
else
    count=$((10#$starting_number))
fi
```

### Negative value check

```bash
[[ "$starting_number" == -* ]]
```

Yeh check karta hai ke input minus sign se shuru hota hai ya nahi.

### Minus sign remove karna

```bash
digits="${starting_number#-}"
```

`${starting_number#-}` value ke start se ek minus sign remove karta hai.

Example:

```text
starting_number = -008
digits          = 008
```

### Negative decimal value banana

```bash
count=$((-10#$digits))
```

`10#` digits ko decimal samajhta hai aur bahar wala minus sign result ko negative banata hai.

```text
digits = 008
count  = -8
```

### Positive decimal value banana

```bash
count=$((10#$starting_number))
```

Example:

```text
starting_number = 008
count           = 8
```

## `10#` Kyun Use Kiya Hai?

Bash arithmetic mein leading zero wala number octal samjha ja sakta hai.

```bash
count=$((08))
```

Octal system mein sirf `0` se `7` tak digits hoti hain, is liye `08` error produce kar sakta hai.

```bash
count=$((10#08))
```

`10#` Bash ko batata hai:

> Is value ko base-10 decimal number samjho.

Result:

```text
8
```

Negative value mein sign ko alag karna zaroori hai. Yeh ghalat hai:

```bash
count=$((10#$starting_number))
```

Agar input `-5` ho to expression `10#-5` ban sakta hai, jo valid base-number syntax nahi hai.

Sahi approach:

```bash
digits="${starting_number#-}"
count=$((-10#$digits))
```

## Countdown Loop

```bash
while (( count != 0 ))
do
    echo "$count"

    if (( count > 0 )); then
        count=$((count - 1))
    else
        count=$((count + 1))
    fi
done
```

Loop tab tak chalta hai jab tak `count` zero nahi hota.

```bash
(( count != 0 ))
```

`(( ))` Bash arithmetic condition hai. Iske andar variable ke saath `$` lagana zaroori nahi hota.

## Positive aur Negative Direction

### Positive number

```bash
if (( count > 0 )); then
    count=$((count - 1))
```

Positive number se har loop mein `1` minus hota hai:

```text
3 → 2 → 1 → 0
```

### Negative number

```bash
else
    count=$((count + 1))
```

Negative number mein har loop mein `1` add hota hai, jis se value zero ki taraf jati hai:

```text
-3 → -2 → -1 → 0
```

### Zero alag se print karna

Loop ki condition `count != 0` hai, is liye loop zero par ruk jata hai. Zero ko loop ke baad print kiya gaya hai:

```bash
echo "0"
echo "Done!"
```

## Example Outputs

### Positive input

```text
Enter a starting number: 3
3
2
1
0
Done!
```

### Negative input

```text
Enter a starting number: -3
-3
-2
-1
0
Done!
```

### Zero input

```text
Enter a starting number: 0
0
Done!
```

### Positive input with leading zero

```text
Enter a starting number: 008
8
7
6
5
4
3
2
1
0
Done!
```

### Negative input with leading zero

```text
Enter a starting number: -003
-3
-2
-1
0
Done!
```

### Invalid decimal input

```text
Enter a starting number: 4.5
Error: enter a valid whole number.
```

### Invalid text input

```text
Enter a starting number: five
Error: enter a valid whole number.
```

## Common Mistakes

### Mistake 1: Minus sign ko optional na banana

```regex
^[0-9]+$
```

Yeh negative number reject karega.

Sahi regex:

```regex
^-?[0-9]+$
```

### Mistake 2: `?` ko bhool jana

```regex
^-[0-9]+$
```

Is expression mein minus sign required hai, is liye positive numbers reject ho jayenge.

### Mistake 3: Purana loop use karna

```bash
while (( count >= 0 ))
```

Yeh negative starting value ke liye run nahi karega, kyun ke `-3 >= 0` false hai.

Positive aur negative dono ke liye:

```bash
while (( count != 0 ))
```

phir direction ko `if` ke saath control karein.

### Mistake 4: Negative sign ke saath direct `10#` lagana

```bash
count=$((10#$starting_number))
```

Negative value mein pehle minus sign remove karein aur phir decimal conversion karein.

### Mistake 5: Decimal number allow karna samajhna

Regex:

```regex
^-?[0-9]+$
```

sirf whole numbers accept karta hai. `4.5` accept nahi hota.

## Testing

Script ko executable banayein:

```bash
chmod +x count_to_zero.sh
```

Syntax check karein:

```bash
bash -n count_to_zero.sh
```

Agar koi output nahi aata, normally iska matlab hai ke syntax error detect nahi hua.

Script run karein:

```bash
bash count_to_zero.sh
```

Different values test karein:

```text
5
-5
0
008
-008
4.5
hello
```

Exit status check karein:

```bash
echo $?
```

| Status | Meaning |
|---:|---|
| `0` | Script successfully complete hui |
| `1` | Input read ya validation fail hui |

Debugging ke liye:

```bash
bash -x count_to_zero.sh
```

## Quick Summary

| Expression | Matlab |
|---|---|
| `^[0-9]+$` | Sirf non-negative whole number |
| `^-?[0-9]+$` | Positive, negative ya zero whole number |
| `-?` | Optional minus sign |
| `${value#-}` | Start se minus sign remove karo |
| `10#08` | `08` ko decimal `8` samjho |
| `$((-10#$digits))` | Digits ko decimal negative value banao |
| `(( count > 0 ))` | Positive value check karo |
| `count - 1` | Positive value ko zero ki taraf lao |
| `count + 1` | Negative value ko zero ki taraf lao |
| `(( count != 0 ))` | Zero milne tak loop chalao |

## Key Lesson

> Negative number accept karne ke liye sirf regex change karna kafi nahi. Number conversion aur loop ki direction ko bhi negative values ke mutabiq handle karna hota hai.

