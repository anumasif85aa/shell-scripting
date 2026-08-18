# Bash Strings, Variables, Parameters aur Arguments — Roman Urdu Study Notes

## Table of Contents

1. [String](#1-string)
2. [Variable](#2-variable)
3. [Parameter](#3-parameter)
4. [Argument](#4-argument)
5. [Positional Parameters](#5-positional-parameters)
6. [Parameter Expansion](#6-parameter-expansion)
7. [Default Values](#7-default-values)
8. [Command Substitution](#8-command-substitution)
9. [Empty String aur Unset Variable](#9-empty-string-aur-unset-variable)
10. [Practice Scripts](#10-practice-scripts)
11. [Common Mistakes](#11-common-mistakes)
12. [Quick Reference](#12-quick-reference)

---

## 1. String

**String** text ya characters ka collection hoti hai.

```bash
"Hello"
"Khalid Khan"
"123"
"red cherry"
""
```

- `"Hello"` ek string hai.
- `"123"` bhi string hai jab usay text ki tarah use kiya jaye.
- `"red cherry"` spaces wali string hai.
- `""` ek **empty string** hai, jis mein zero characters hain.

```bash
message="Hello, Khalid"
echo "$message"
```

Double quotes variable expansion allow karti aur spaces ko aik value ka hissa rakhti hain. Single quotes variable ko expand nahi kartin:

```bash
name="Ali"
echo '$name'
```

Output `$name` hoga, `Ali` nahi.

---

## 2. Variable

**Variable** aik named container hai jo value store karta hai.

```bash
name="Khalid"
course="Bash Scripting"
age="25"
```

- `name`, `course` aur `age` variable names hain.
- Assignment ke waqt `$` nahi lagta.
- `=` ke aas paas spaces nahi honi chahiye.
- Value use karte waqt `$` lagta hai.

```bash
echo "$name"
```

Correct:

```bash
name="Khalid"
```

Incorrect:

```bash
name = "Khalid"
```

---

## 3. Parameter

**Parameter** Bash ki aisi entity hai jo value hold karti hai. Named variables aur positional parameters dono parameters ki types hain.

Named parameter:

```bash
name="Ali"
echo "$name"
```

Positional parameters:

```bash
echo "$1"
echo "$2"
```

`$1` aur `$2` command line se milnay walay arguments receive karte hain.

---

## 4. Argument

**Argument** woh actual value hai jo command, script ya function ko di jati hai.

```bash
bash greet_student.sh Khalid
```

Yahan:

- `Khalid` argument hai.
- Script ke andar `$1` positional parameter hai.
- `$1` ki value `Khalid` hogi.

```text
Command line par: Khalid = argument
Script ke andar:  $1     = positional parameter
```

Do arguments:

```bash
bash copy_file.sh abc.txt backup/
```

| Position | Parameter | Argument |
|---|---|---|
| Pehla | `$1` | `abc.txt` |
| Doosra | `$2` | `backup/` |

---

## 5. Positional Parameters

| Parameter | Meaning |
|---|---|
| `$0` | Script ka naam |
| `$1` | Pehla argument |
| `$2` | Doosra argument |
| `${10}` | Daswan argument |
| `$#` | Arguments ki total tadaad |
| `"$@"` | Tamam arguments; har argument alag rehta hai |
| `"$*"` | Tamam arguments ko aik combined string ki tarah dikhata hai |
| `$?` | Pichlay command ka exit status; yeh argument nahi hai |

`"$@"` recommended hai kyun ke yeh `"red cherry"` jaisay argument ko aik hi item rakhta hai:

```bash
for item in "$@"
do
    echo "Item: $item"
done
```

---

## 6. Parameter Expansion

Jab Bash `$name` ya `${name}` ko us ki value se replace karta hai, isay **parameter expansion** kehte hain.

```bash
name="Khalid"
echo "${name}"
```

`$name` aur `${name}` dono value hasil karte hain. Braces variable ka naam clearly separate karti hain:

```bash
fruit="apple"
echo "${fruit}s"
```

Output:

```text
apples
```

Agar `echo "$fruits"` likhein to Bash `fruits` naam ka variable talash karega.

---

## 7. Default Values

### `${parameter:-default}`

Is ka matlab hai:

> Agar parameter unset ya empty ho to default value use karo.

```bash
name="${1:-Guest}"
```

- `bash greet_student.sh Khalid` par value `Khalid` hogi.
- `bash greet_student.sh` par value `Guest` hogi.

### `${1:-}`

```bash
source_file="${1:-}"
```

Agar `$1` diya gaya ho to us ki value use hogi; warna empty string assign hogi. Yeh `set -u` ke saath direct `$1` se zyada safe hai.

---

## 8. Command Substitution

`$(command)` command run karke us ka standard output hasil karta hai.

```bash
current_date="$(date)"
echo "$current_date"
```

| Syntax | Naam | Kaam |
|---|---|---|
| `${name}` | Parameter expansion | Variable/parameter ki value hasil karta hai |
| `$(date)` | Command substitution | Command run karke output hasil karta hai |

---

## 9. Empty String aur Unset Variable

Empty string:

```bash
name=""
```

Variable defined hai, magar us mein zero characters hain.

Unset variable:

```bash
unset name
```

Ab variable defined nahi hai.

Safe check:

```bash
if [[ -z "${name:-}" ]]; then
    echo "Name is empty or unset."
fi
```

`-z` true hota hai jab string ki length zero ho.

---

## 10. Practice Scripts

### Script 1: Variable aur string

**Create: `student_information.sh`**

```bash
#!/bin/bash

# Title: Student Information
# Purpose: Store and display string values using variables.

student_name="Khalid"
course="Bash Scripting"

echo "Student: $student_name"
echo "Course: $course"

exit 0
```

### Script 2: Argument aur positional parameter

**Create: `greet_student.sh`**

```bash
#!/bin/bash

# Title: Greet Student
# Purpose: Receive a student name as the first argument.

name="${1:-}"

if [[ -z "$name" ]]; then
    echo "Usage: $0 NAME" >&2
    exit 1
fi

echo "Hello, $name!"
exit 0
```

Run:

```bash
bash greet_student.sh Khalid
```

### Script 3: Tamam arguments

**Create: `show_arguments.sh`**

```bash
#!/bin/bash

# Title: Show Arguments
# Purpose: Display the script name, count, and all arguments.

echo "Script name: $0"
echo "Argument count: $#"

item_number=1

for argument in "$@"
do
    echo "Argument $item_number: $argument"
    item_number=$((item_number + 1))
done

exit 0
```

Run:

```bash
bash show_arguments.sh apple banana "red cherry"
```

Output:

```text
Argument count: 3
Argument 1: apple
Argument 2: banana
Argument 3: red cherry
```

### Script 4: Dono expansions ko combine karna

**Create: `session_summary.sh`**

```bash
#!/bin/bash

# Title: Session Summary
# Purpose: Use parameter expansion and command substitution.

student_name="${1:-Guest}"
current_date="$(date)"

echo "Student: ${student_name}"
echo "Date: ${current_date}"

exit 0
```

---

## 11. Common Mistakes

| Mistake | Problem | Correct form |
|---|---|---|
| `name = "Ali"` | Assignment mein spaces | `name="Ali"` |
| `echo $name` | Word splitting/globbing ho sakti hai | `echo "$name"` |
| Argument aur parameter ko same samajhna | Actual value aur receiver mix ho jate hain | `Ali` argument, `$1` parameter |
| `$10` | Bash isay `$1` aur literal `0` samajh sakta hai | `${10}` |
| Unquoted `$@` | Spaces wala argument toot sakta hai | `"$@"` |

---

## 12. Quick Reference

| Term | Roman Urdu mein meaning | Example |
|---|---|---|
| String | Text ya characters ka collection | `"Hello World"` |
| Variable | Value store karne wala naam | `name="Ali"` |
| Parameter | Value hold karne wali Bash entity | `$name`, `$1` |
| Argument | Script ko di jane wali actual value | `bash script.sh Ali` |
| Positional parameter | Numbered parameter jo argument receive karta hai | `$1`, `$2` |
| Parameter expansion | Parameter ki value hasil/modify karna | `${name}` |
| Default expansion | Missing/empty value par default use karna | `${1:-Guest}` |
| Command substitution | Command run karke output hasil karna | `$(date)` |
| Empty string | Zero characters wali string | `""` |
| Unset variable | Aisa variable jo defined nahi hai | `unset name` |

## Final Summary

```bash
bash greet_student.sh Khalid
```

```text
greet_student.sh → script ka naam
Khalid           → argument
$1               → positional parameter
name="$1"         → argument ko variable mein store karna
"Khalid"         → string value
${name}          → parameter expansion
```

> **Golden rule:** Argument bahar se di jane wali actual value hai, jab ke parameter script ke andar us value ko receive ya hold karta hai.

