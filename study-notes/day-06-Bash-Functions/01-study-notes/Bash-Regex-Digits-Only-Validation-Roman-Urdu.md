# Bash Study Notes: Regex Se Sirf Digits Ki Validation — Roman Urdu

## Condition

```bash
if [[ "$1" =~ ^[0-9]+$ ]]; then
```

## Asaan matlab

Yeh condition check karti hai ke pehle argument mein shuru se aakhir tak sirf digits hain ya nahin.

Maan lein script is tarah run ki gayi:

```bash
bash script.sh 25
```

Pehla argument yeh hai:

```bash
$1 = 25
```

Condition yeh sawal karti hai:

> Kya `25` mein ek ya zyada digits hain aur unke ilawa koi aur character nahin hai?

Jawab **haan** hai. Is liye condition true hogi aur `then` wala block chalega.

---

## Condition ko hisson mein samajhna

```bash
if [[ "$1" =~ ^[0-9]+$ ]]; then
```

| Hissa | Matlab |
|---|---|
| `if` | Decision ya faisla shuru karta hai |
| `[[ ... ]]` | Bash mein condition test karta hai |
| `"$1"` | Script ya function ka pehla argument |
| `=~` | Value ko regular expression ke saath match karta hai |
| `^` | Value ka shuru |
| `[0-9]` | `0` se `9` tak koi ek digit |
| `+` | Pichlay pattern ki ek ya zyada occurrences |
| `$` | Value ka aakhir |
| `then` | Condition true ho to chalne wali commands shuru karta hai |

Regular expression yeh hai:

```regex
^[0-9]+$
```

Isay is tarah parhein:

> Shuru se aakhir tak sirf ek ya zyada digits honi chahiye.

---

## `[0-9]` ko samajhna

```regex
[0-9]
```

Yeh `0` se `9` tak kisi bhi ek digit ko represent karta hai:

```text
0 1 2 3 4 5 6 7 8 9
```

Misal:

```text
7
```

Sirf `[0-9]` ek digit ko represent karta hai. Ek se zyada digits ke liye `+` lagaya jata hai.

---

## `+` ko samajhna

```regex
[0-9]+
```

`+` ka matlab hai:

> Pichli cheez ek ya ek se zyada martaba ho.

Pichli cheez `[0-9]` hai. Is liye `[0-9]+` ka matlab ek ya zyada digits hai.

Yeh values match hongi:

```text
5
25
100
98765
```

Khali value match nahin hogi, kyun ke `+` kam az kam ek digit zaroor mangta hai.

---

## `^` ko samajhna

```regex
^
```

Caret `^` ka matlab hai:

> Value ke bilkul shuru se matching start karo.

Yeh digits se pehle extra characters ko allow nahin karta.

---

## `$` ko samajhna

```regex
$
```

Regex mein dollar sign `$` ka matlab hai:

> Matching value ke bilkul aakhir par khatam honi chahiye.

Yeh digits ke baad extra characters ko allow nahin karta.

Regex ka `$`, Bash variable wale `$` se mukhtalif hai.

Misal:

```bash
$1
```

Yahan `$1` ka matlab pehla argument hai. Lekin regex ke aakhir mein `$` ka matlab string ka end hai.

---

## `^` aur `$` kyun zaroori hain?

Agar beginning aur ending anchors na lagayein:

```bash
[[ "$1" =~ [0-9]+ ]]
```

to value mein digits ka kahin bhi maujood hona kaafi hoga.

Misal:

```text
abc25xyz
```

Yeh match ho jayega, kyun ke is mein `25` maujood hai.

Lekin anchors ke saath:

```bash
[[ "$1" =~ ^[0-9]+$ ]]
```

poori value mein sirf digits hi honi chahiye.

```text
abc25xyz
```

Match nahin hoga, kyun ke is mein letters bhi hain.

---

## Test examples

| `$1` ki value | Result | Wajah |
|---|---|---|
| `5` | True | Sirf ek digit hai |
| `25` | True | Sirf digits hain |
| `1000` | True | Sirf digits hain |
| `007` | True | Sirf digits hain |
| `5a` | False | Is mein letter hai |
| `abc` | False | Is mein letters hain |
| `4.5` | False | Is mein decimal point hai |
| `-5` | False | Is mein minus sign hai |
| Khali value | False | `+` kam az kam ek digit mangta hai |
| `5 6` | False | Is mein space hai |

---

## Mukammal script

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

Kyun ke `25` mein sirf digits hain, condition true hogi.

### Invalid input

```bash
bash script.sh 25abc
```

Output:

```text
Error: enter digits only.
```

`25abc` mein digits ke saath letters bhi hain. Is liye condition false hogi aur `else` block chalega.

Error message ko standard error par bhejne ke liye yeh use hua hai:

```bash
>&2
```

Uske baad:

```bash
exit 1
```

script ko failure status `1` ke saath band kar deta hai.

---

## Argument count bhi check karein

`$1` ko test karne se pehle check karna behtar hai ke user ne exactly ek argument diya hai:

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

| Parameter | Matlab |
|---|---|
| `$#` | Arguments ki total tadaad |
| `$0` | Script ka naam |
| `$1` | Pehla argument |

Yeh condition:

```bash
if [[ "$#" -ne 1 ]]; then
```

ka matlab hai:

> Agar arguments ki tadaad `1` ke barabar nahin hai to usage error dikhao.

---

## Negative whole numbers allow karna

Original pattern yeh value accept nahin karta:

```text
-5
```

Optional minus sign allow karne ke liye:

```bash
if [[ "$1" =~ ^-?[0-9]+$ ]]; then
```

Naya hissa yeh hai:

```regex
-?
```

| Symbol | Matlab |
|---|---|
| `-` | Asal minus sign |
| `?` | Zero ya ek martaba |

Is liye minus sign optional hai.

Yeh pattern accept karega:

```text
5
-5
0
```

Yeh values reject hongi:

```text
4.5
abc
--5
```

---

## Positive ya negative sign allow karna

Optional `+` ya `-` sign accept karne ke liye:

```bash
if [[ "$1" =~ ^[+-]?[0-9]+$ ]]; then
```

Yeh values accept hongi:

```text
5
+5
-5
0
```

`[+-]` ka matlab plus ya minus sign hai, aur `?` ka matlab yeh sign optional hai.

---

## Bash regex ka important rule

`=~` use karte waqt right side par maujood regular expression ko quotes mein na rakhein.

Recommended:

```bash
[[ "$1" =~ ^[0-9]+$ ]]
```

Is se parhez karein:

```bash
[[ "$1" =~ "^[0-9]+$" ]]
```

Right-side regex ko quote karne se Bash usay intended regex ke bajaye literal text samajh sakta hai.

Left side ki value ko quotes mein rakhna theek hai:

```bash
"$1"
```

---

## Leading zero ka important note

Regex yeh values accept karta hai:

```text
007
08
09
```

Kyun ke in mein sirf digits hain. Lekin Bash arithmetic mein zero se shuru hone wala number octal samjha ja sakta hai.

Octal mein sirf digits `0` se `7` tak hoti hain. Is liye `08` aur `09` arithmetic error de sakte hain.

Regex validation aur arithmetic interpretation do alag cheezein hain:

- Regex poochta hai: “Kya value mein sirf digits hain?”
- Arithmetic poochta hai: “Bash in digits ko kis number base mein samjhe?”

Beginner scripts mein, agar number arithmetic mein use hoga to extra leading zeros se parhez karein:

```bash
bash script.sh 8
```

Is ke bajaye:

```bash
bash script.sh 08
```

---

## Quick comparison

| Pattern | Kya accept karta hai |
|---|---|
| `^[0-9]+$` | Zero ya positive digits-only values |
| `^-?[0-9]+$` | Negative, zero ya positive whole numbers |
| `^[+-]?[0-9]+$` | Optional `+` ya `-` sign wale whole numbers |

---

## Asaan memory rule

```regex
^[0-9]+$
```

Is ka matlab:

> Shuru → ek ya zyada digits → aakhir.

Ya is tarah yaad rakhein:

> Poori value mein sirf digits honi chahiye.
