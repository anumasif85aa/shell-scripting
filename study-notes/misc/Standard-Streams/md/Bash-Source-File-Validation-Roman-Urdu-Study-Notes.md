# Bash Source File Validation — Roman Urdu Study Notes

## Table of Contents

- [1. Code](#1-code)
- [2. Code Ka Maqsad](#2-code-ka-maqsad)
- [3. Variable Assignment](#3-variable-assignment)
- [4. File Validation Condition](#4-file-validation-condition)
- [5. `-f` Operator](#5--f-operator)
- [6. `!` Operator](#6--operator)
- [7. Error Message aur `>&2`](#7-error-message-aur-2)
- [8. `exit 1`](#8-exit-1)
- [9. `fi`](#9-fi)
- [10. Execution Outcomes](#10-execution-outcomes)
- [11. Complete Improved Script](#11-complete-improved-script)
- [12. Related File-Test Operators](#12-related-file-test-operators)
- [13. Common Mistakes](#13-common-mistakes)
- [14. Quick Summary](#14-quick-summary)

---

## 1. Code

```bash
source_file="abc.txt"

if [[ ! -f "$source_file" ]]; then
    echo "Error: source file does not exist." >&2
    exit 1
fi
```

---

## 2. Code Ka Maqsad

Yeh code check karta hai ke current working directory mein `abc.txt` naam ki **regular file** maujood hai ya nahi.

Agar file regular file ke taur par maujood nahi hai to script:

1. Error message stderr par bhejti hai.
2. Failure status `1` ke saath band ho jati hai.

Agar file maujood hai to error block skip ho jata hai aur script `fi` ke baad continue karti hai.

---

## 3. Variable Assignment

```bash
source_file="abc.txt"
```

Yeh `source_file` naam ka variable banata hai aur us mein yeh value store karta hai:

```text
abc.txt
```

Ab jab Bash yeh expression dekhega:

```bash
"$source_file"
```

to variable expand hokar banega:

```bash
"abc.txt"
```

### Relative Path

`abc.txt` ek relative path hai. Is liye Bash file ko current working directory mein check karega.

Current directory dekhne ke liye:

```bash
pwd
```

Current directory ki files dekhne ke liye:

```bash
ls
```

Agar file kisi doosri directory mein ho to uska complete ya relative path dena hoga:

```bash
source_file="/home/khalid/documents/abc.txt"
```

---

## 4. File Validation Condition

```bash
if [[ ! -f "$source_file" ]]; then
```

Is line ke different parts:

| Part | Meaning |
|---|---|
| `if` | Condition check karna start karta hai. |
| `[[ ... ]]` | Bash ka conditional-test syntax hai. |
| `!` | Test ka result reverse karta hai. |
| `-f` | Check karta hai ke path existing regular file hai. |
| `"$source_file"` | Check hone wali file ka quoted path hai. |
| `then` | Condition true ho to neeche wala block chalata hai. |

Variable expansion ke baad condition conceptually yeh banegi:

```bash
if [[ ! -f "abc.txt" ]]; then
```

Iska simple meaning:

> Agar `abc.txt` existing regular file nahi hai to `then` block chalao.

---

## 5. `-f` Operator

```bash
[[ -f "$source_file" ]]
```

`-f` check karta hai ke diya gaya path:

1. Maujood hai.
2. Regular file hai.

Agar `abc.txt` regular file hai to test true hoga.

```bash
touch abc.txt
[[ -f "abc.txt" ]]
echo "$?"
```

Expected status:

```text
0
```

Yahan status `0` test ki success ko show karta hai.

Important: `-f` directory ke liye true nahi hota. Directory check karne ke liye `-d` use hota hai.

---

## 6. `!` Operator

```bash
[[ ! -f "$source_file" ]]
```

`!` ka matlab **NOT** hai. Yeh `-f` ke result ko reverse karta hai.

| `abc.txt` Ki Condition | `-f` Result | `! -f` Result |
|---|---|---|
| Regular file maujood hai | True | False |
| File missing hai | False | True |
| Path directory hai | False | True |

Is liye:

```bash
if [[ ! -f "$source_file" ]]; then
```

ka meaning hai:

> Agar source path regular file nahi hai to error-handling block chalao.

---

## 7. Error Message aur `>&2`

```bash
echo "Error: source file does not exist." >&2
```

Yeh command error message print karti hai:

```text
Error: source file does not exist.
```

### `>&2` Ka Meaning

`echo` normally stdout par output bhejta hai.

```bash
>&2
```

`echo` ke stdout ko stderr ki current destination par bhejta hai.

File descriptor `2` stderr ko represent karta hai.

Simple meaning:

> Is message ko normal output nahi, balki error output samajh kar bhejo.

Isay explicitly is tarah bhi likh sakte hain:

```bash
echo "Error: source file does not exist." 1>&2
```

Error ko file mein save karne ke liye poori script ka stderr redirect karein:

```bash
bash check_file.sh 2> error.log
```

---

## 8. `exit 1`

```bash
exit 1
```

- `exit` poori script ko foran band karta hai.
- `1` nonzero command status hai.
- Nonzero status failure ko show karta hai.
- Is line ke baad script ki baqi commands execute nahi hoti.

Script ke baad status check karne ke liye:

```bash
bash check_file.sh
echo "$?"
```

Agar validation fail hui to expected status:

```text
1
```

---

## 9. `fi`

```bash
fi
```

`fi`, `if` statement ko close karta hai.

Basic structure:

```bash
if condition; then
    commands
fi
```

`if` ko ulta likhne par `fi` banta hai. Isay yaad rakhna asaan hai.

---

## 10. Execution Outcomes

### Outcome 1: `abc.txt` Missing Hai

Script flow:

1. `source_file` mein `abc.txt` store hota hai.
2. `-f` false hota hai.
3. `!` result ko true bana deta hai.
4. Error message stderr par jata hai.
5. `exit 1` script ko band kar deta hai.

Output:

```text
Error: source file does not exist.
```

### Outcome 2: `abc.txt` Maujood Hai

File create karein:

```bash
touch abc.txt
```

Ab:

1. `-f` true hoga.
2. `!` result ko false karega.
3. Error block skip ho jayega.
4. Script `fi` ke baad continue karegi.

Agar `fi` ke baad koi command nahi hai to screen par kuch print nahi hoga.

---

## 11. Complete Improved Script

```bash
#!/bin/bash

# Title: Source File Validation
# Purpose: Check whether abc.txt exists as a regular file.

source_file="abc.txt"

if [[ ! -f "$source_file" ]]; then
    echo "Error: source file does not exist: $source_file" >&2
    exit 1
fi

echo "Source file exists: $source_file"
exit 0
```

### Agar File Maujood Hai

```text
Source file exists: abc.txt
```

Script status:

```text
0
```

### Agar File Missing Hai

```text
Error: source file does not exist: abc.txt
```

Script status:

```text
1
```

---

## 12. Related File-Test Operators

| Operator | Kya Check Karta Hai? | Example |
|---|---|---|
| `-f` | Existing regular file | `[[ -f "$path" ]]` |
| `-d` | Existing directory | `[[ -d "$path" ]]` |
| `-e` | Koi existing filesystem path | `[[ -e "$path" ]]` |
| `-r` | Current user path ko read kar sakta hai | `[[ -r "$path" ]]` |
| `-w` | Current user path par write kar sakta hai | `[[ -w "$path" ]]` |
| `-x` | Current user path ko execute ya traverse kar sakta hai | `[[ -x "$path" ]]` |
| `-s` | File maujood aur non-empty hai | `[[ -s "$path" ]]` |

### `-f`, `-d` aur `-e` Ka Farq

```bash
[[ -f "$path" ]]
```

Regular file check karta hai.

```bash
[[ -d "$path" ]]
```

Directory check karta hai.

```bash
[[ -e "$path" ]]
```

Check karta hai ke koi filesystem object us path par exist karta hai.

---

## 13. Common Mistakes

### Mistake 1: Variable Assignment Mein Spaces

Incorrect:

```bash
source_file = "abc.txt"
```

Correct:

```bash
source_file="abc.txt"
```

Bash variable assignment mein `=` ke around spaces nahi honi chahiye.

### Mistake 2: `!` Ko Bhool Jana

```bash
if [[ -f "$source_file" ]]; then
    echo "Error: source file does not exist." >&2
fi
```

Yeh logic ulta hai: error tab print hoga jab file maujood hogi.

Missing file check karne ke liye:

```bash
if [[ ! -f "$source_file" ]]; then
```

### Mistake 3: `-f` Ko General Existence Test Samajhna

`-f` sirf regular file ke liye true hota hai. Directory ke liye `-d` aur general path existence ke liye `-e` use karein.

### Mistake 4: Error Ke Baad `exit 0`

Incorrect:

```bash
echo "Error: file missing" >&2
exit 0
```

`0` success ko show karta hai. Failure ke liye nonzero status use karein:

```bash
echo "Error: file missing" >&2
exit 1
```

### Mistake 5: Relative Path Ki Directory Bhool Jana

```bash
source_file="abc.txt"
```

Current working directory mein `abc.txt` check karta hai, zaroori nahi ke script ki apni directory mein.

Current directory confirm karein:

```bash
pwd
```

---

## 14. Quick Summary

```bash
source_file="abc.txt"
```

`abc.txt` ko variable mein store karta hai.

```bash
[[ ! -f "$source_file" ]]
```

Check karta hai ke `abc.txt` existing regular file **nahi** hai.

```bash
echo "Error: source file does not exist." >&2
```

Error message stderr par bhejta hai.

```bash
exit 1
```

Script ko failure status ke saath band karta hai.

Final meaning:

> Agar current directory mein `abc.txt` existing regular file nahi hai to error message stderr par bhejo aur script ko status `1` ke saath band kar do.

