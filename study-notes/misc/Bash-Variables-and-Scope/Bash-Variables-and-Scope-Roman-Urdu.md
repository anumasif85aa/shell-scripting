# Bash Variables and Scope — Roman Urdu 

## Summary

Variable ek naam wala container hota hai jisme value temporarily store ki jati hai. Scope batata hai ke variable script ke kis hissa mein available hai.

Bash mein important variable aur scope types:

| Type | Asaan matlab |
|---|---|
| Global variable | Poori script aur functions mein available |
| Local variable | Sirf us function ke andar available |
| Environment variable | Export hone ke baad child processes ko bhi milta hai |
| Positional parameter | Script ya function ko diye gaye arguments |
| Readonly variable | Banane ke baad change nahin kiya ja sakta |
| Subshell variable | Subshell ki change parent shell mein wapas nahin aati |

---

## Table of Contents

1. [Variable kya hota hai?](#1-variable-kya-hota-hai)
2. [Variable banane ke rules](#2-variable-banane-ke-rules)
3. [Scope kya hota hai?](#3-scope-kya-hota-hai)
4. [Global variable](#4-global-variable)
5. [Function ke andar global variable](#5-function-ke-andar-global-variable)
6. [Local variable](#6-local-variable)
7. [Global aur local variable ka comparison](#7-global-aur-local-variable-ka-comparison)
8. [Global variable ko protect karna](#8-global-variable-ko-protect-karna)
9. [Function arguments ka scope](#9-function-arguments-ka-scope)
10. [Script aur function arguments ka difference](#10-script-aur-function-arguments-ka-difference)
11. [Environment variables](#11-environment-variables)
12. [Parent aur child shell](#12-parent-aur-child-shell)
13. [Subshell scope](#13-subshell-scope)
14. [Command substitution scope](#14-command-substitution-scope)
15. [Readonly variables](#15-readonly-variables)
16. [Variable ko remove karna](#16-variable-ko-remove-karna)
17. [Best practices](#17-best-practices)
18. [Complete practice script](#18-complete-practice-script)
19. [Quick revision](#19-quick-revision)
20. [Practice tasks](#20-practice-tasks)

---

## 1. Variable kya hota hai?

Variable ek naam wala container hota hai jisme hum koi value temporarily store karte hain.

```bash
name="Khalid"
course="Bash Scripting"
age=25
```

Variable ki value use karne ke liye uske naam se pehle `$` lagate hain:

```bash
echo "$name"
echo "$course"
echo "$age"
```

Output:

```text
Khalid
Bash Scripting
25
```

Variable ka naam:

```bash
name
```

Variable ki value:

```text
Khalid
```

Variable ko expand karna:

```bash
$name
```

[Back to Table of Contents](#table-of-contents)

---

## 2. Variable banane ke rules

### Rule 1: `=` ke aas-paas spaces nahin honi chahiye

Sahi:

```bash
name="Ali"
```

Ghalat:

```bash
name = "Ali"
```

Ghalat example mein Bash `name` ko command samajhne ki koshish karega.

### Rule 2: Value mein spaces hon to quotes use karein

```bash
course="Bash Scripting"
```

### Rule 3: Variable names case-sensitive hote hain

```bash
name="Ali"
Name="Khalid"
```

`name` aur `Name` do alag variables hain.

### Rule 4: Variable name digit se start nahin ho sakta

Sahi:

```bash
student1="Ali"
```

Ghalat:

```bash
1student="Ali"
```

### Rule 5: Underscore use kiya ja sakta hai

```bash
student_name="Ali Khan"
course_name="Bash Scripting"
```

### Rule 6: Variable use karte waqt quotes recommended hain

```bash
echo "$student_name"
```

Quotes spaces aur special characters ko safely preserve karte hain.

[Back to Table of Contents](#table-of-contents)

---

## 3. Scope kya hota hai?

Scope ka matlab hai:

> Variable script ke kis hissa mein available aur accessible hai?

Misal ke taur par:

- Kya variable poori script mein use ho sakta hai?
- Kya woh sirf function ke andar available hai?
- Kya child process usay dekh sakta hai?
- Kya subshell mein ki gayi change parent shell tak wapas aayegi?

Bash mein do basic scopes:

1. Global scope
2. Local scope

Advanced level par environment, child-process aur subshell scope bhi samajhna zaroori hai.

[Back to Table of Contents](#table-of-contents)

---

## 4. Global variable

Jo variable function ke bahar banaya jaye, woh aam tor par global variable hota hai.

Global variable:

- Poori script mein available hota hai.
- Function ke andar bhi use ho sakta hai.
- Function uski value change bhi kar sakta hai.

Example:

```bash
#!/bin/bash

course="Bash Scripting"

show_course()
{
    echo "Function ke andar: $course"
}

show_course

echo "Function ke bahar: $course"
```

Output:

```text
Function ke andar: Bash Scripting
Function ke bahar: Bash Scripting
```

`course` function ke bahar banaya gaya tha. Is liye woh global hai aur function ke andar bhi available hai.

[Back to Table of Contents](#table-of-contents)

---

## 5. Function ke andar global variable

Bash mein agar function ke andar variable assign karein aur `local` use na karein, to variable global ho sakta hai.

```bash
#!/bin/bash

create_name()
{
    student="Ali"
}

create_name

echo "$student"
```

Output:

```text
Ali
```

`student` function ke andar assign hua, lekin `local` use nahin hua. Is liye function complete hone ke baad bhi variable available hai.

Yeh behavior accidental changes aur variable-name conflicts paida kar sakta hai.

[Back to Table of Contents](#table-of-contents)

---

## 6. Local variable

Local variable sirf us function ke andar available hota hai jahan woh declare kiya gaya ho.

Syntax:

```bash
local variable_name="value"
```

Example:

```bash
#!/bin/bash

show_student()
{
    local student="Ali"

    echo "Function ke andar: $student"
}

show_student

echo "Function ke bahar: $student"
```

Output:

```text
Function ke andar: Ali
Function ke bahar:
```

Function ke bahar `student` ki value print nahin hui, kyun ke woh local variable tha.

Important:

```bash
local
```

sirf function ke andar use hota hai.

[Back to Table of Contents](#table-of-contents)

---

## 7. Global aur local variable ka comparison

| Feature | Global variable | Local variable |
|---|---|---|
| Kahan available hota hai? | Poori script mein | Sirf function ke andar |
| Kaise banate hain? | Normal assignment | `local` keyword ke saath |
| Function ke bahar use ho sakta hai? | Haan | Nahin |
| Function usay change kar sakta hai? | Haan | Sirf apni local copy ko |
| Accidental changes ka risk | Zyada | Kam |
| Functions ke temporary data ke liye | Recommended nahin | Recommended |

Quick example:

```bash
global_name="Khalid"

demo()
{
    local local_name="Ali"

    echo "$global_name"
    echo "$local_name"
}
```

Function ke andar dono variables available hain. Function ke bahar sirf `global_name` available hoga.

[Back to Table of Contents](#table-of-contents)

---

## 8. Global variable ko protect karna

### `local` ke baghair

```bash
#!/bin/bash

name="Khalid"

change_name()
{
    name="Ali"
    echo "Function ke andar: $name"
}

change_name

echo "Function ke bahar: $name"
```

Output:

```text
Function ke andar: Ali
Function ke bahar: Ali
```

Function ne global `name` ko permanently change kar diya.

### `local` ke saath

```bash
#!/bin/bash

name="Khalid"

change_name()
{
    local name="Ali"
    echo "Function ke andar: $name"
}

change_name

echo "Function ke bahar: $name"
```

Output:

```text
Function ke andar: Ali
Function ke bahar: Khalid
```

Ab do alag variables hain:

- Function ke andar local `name="Ali"`
- Function ke bahar global `name="Khalid"`

Local variable ne global variable ko change nahin kiya.

[Back to Table of Contents](#table-of-contents)

---

## 9. Function arguments ka scope

Function ke apne positional parameters hote hain:

```bash
show_student()
{
    echo "First argument: $1"
    echo "Second argument: $2"
}

show_student "Ali" "Bash"
```

Output:

```text
First argument: Ali
Second argument: Bash
```

Function ke andar:

| Parameter | Matlab |
|---|---|
| `$1` | Function ka pehla argument |
| `$2` | Function ka doosra argument |
| `$#` | Function arguments ki tadaad |
| `"$@"` | Function ke tamam arguments, alag-alag preserve hote hain |
| `"$*"` | Tamam arguments ek combined string ki tarah |

### Numbered function arguments

```bash
show_items()
{
    local item
    local count=1

    echo "Arguments count: $#"

    for item in "$@"
    do
        echo "Item $count: $item"
        ((count++))
    done
}

show_items "apple" "banana" "red cherry"
```

Output:

```text
Arguments count: 3
Item 1: apple
Item 2: banana
Item 3: red cherry
```

`"$@"` ki wajah se `"red cherry"` ek hi argument rehta hai.

`item` aur `count` ko `local` banaya gaya hai, is liye woh function ke bahar variables ko affect nahin karte.

[Back to Table of Contents](#table-of-contents)

---

## 10. Script aur function arguments ka difference

Script run karein:

```bash
bash script.sh Khalid
```

Script level par:

```bash
$1 = Khalid
```

Lekin agar function ko alag argument diya jaye:

```bash
greet "Ali"
```

Function ke andar:

```bash
$1 = Ali
```

Complete example:

```bash
#!/bin/bash

greet()
{
    echo "Function argument: $1"
}

echo "Script argument: $1"

greet "Ali"
```

Run:

```bash
bash script.sh Khalid
```

Output:

```text
Script argument: Khalid
Function argument: Ali
```

Function call ke waqt function ko apne positional arguments milte hain. Function ke andar `$1` temporary taur par function ka pehla argument ban jata hai.

[Back to Table of Contents](#table-of-contents)

---

## 11. Environment variables

Environment variable aisa variable hota hai jo current shell se start hone wale child processes ko bhi diya jata hai.

### Normal shell variable

```bash
course="Bash Scripting"
```

Yeh current shell mein available hai, lekin child process ko automatically nahin milega.

### Exported environment variable

```bash
export course="Bash Scripting"
```

Ab child process bhi is variable ko receive kar sakta hai:

```bash
bash -c 'echo "$course"'
```

Output:

```text
Bash Scripting
```

Existing variable ko baad mein bhi export kiya ja sakta hai:

```bash
course="Bash Scripting"
export course
```

System ke common environment variables:

```bash
echo "$USER"
echo "$HOME"
echo "$PATH"
echo "$SHELL"
```

[Back to Table of Contents](#table-of-contents)

---

## 12. Parent aur child shell

Important rule:

> Child process parent ke exported variables receive kar sakta hai, lekin child process parent ke variable ko permanently change nahin kar sakta.

Example:

```bash
name="Khalid"

bash -c 'name="Ali"; echo "Child: $name"'

echo "Parent: $name"
```

Output:

```text
Child: Ali
Parent: Khalid
```

Child shell ne apni copy change ki. Parent shell ka original variable change nahin hua.

### Export ka direction

```text
Parent shell
     |
     | exported variable
     v
Child process
```

Exported value parent se child ki taraf jati hai. Child ki later change parent mein wapas nahin aati.

[Back to Table of Contents](#table-of-contents)

---

## 13. Subshell scope

Parentheses:

```bash
( commands )
```

commands ko subshell mein run karti hain.

```bash
name="Khalid"

(
    name="Ali"
    echo "Subshell: $name"
)

echo "Main shell: $name"
```

Output:

```text
Subshell: Ali
Main shell: Khalid
```

Subshell mein ki gayi variable change main shell mein wapas nahin aati.

### Braces ka difference

Commands braces mein:

```bash
{ commands; }
```

current shell mein run hoti hain.

```bash
name="Khalid"

{
    name="Ali"
}

echo "$name"
```

Output:

```text
Ali
```

Comparison:

| Structure | Kahan run hoti hai? | Variable changes preserve hoti hain? |
|---|---|---|
| `( commands )` | Subshell | Nahin |
| `{ commands; }` | Current shell | Haan |

[Back to Table of Contents](#table-of-contents)

---

## 14. Command substitution scope

Command substitution:

```bash
$(command)
```

command ka output capture karti hai aur aam tor par subshell environment mein chalti hai.

```bash
name="Khalid"

result=$(
    name="Ali"
    echo "$name"
)

echo "Result: $result"
echo "Original: $name"
```

Output:

```text
Result: Ali
Original: Khalid
```

Command substitution ke andar wali change original `name` ko affect nahin karti.

Common example:

```bash
today=$(date)
echo "$today"
```

`date` ka output `today` variable mein store ho jata hai.

[Back to Table of Contents](#table-of-contents)

---

## 15. Readonly variables

Agar variable ki value change nahin honi chahiye to `readonly` use karein:

```bash
readonly course="Bash Scripting"
```

Ab isay change karne ki koshish:

```bash
course="Linux"
```

error degi.

Constants ke liye uppercase naam use karna common practice hai:

```bash
readonly COURSE_NAME="Bash Scripting"
readonly MAX_ATTEMPTS=3
```

Function ke andar local readonly variable:

```bash
demo()
{
    local -r message="Hello"
    echo "$message"
}
```

`-r` ka matlab readonly hai.

[Back to Table of Contents](#table-of-contents)

---

## 16. Variable ko remove karna

Variable ko remove karne ke liye `unset` use hota hai:

```bash
name="Ali"

echo "$name"

unset name

echo "$name"
```

Pehli baar:

```text
Ali
```

Doosri baar koi value print nahin hogi.

Readonly variable ko normal taur par `unset` ya change nahin kiya ja sakta.

Function remove karne ke liye:

```bash
unset -f function_name
```

Variable remove karne ke liye:

```bash
unset variable_name
```

[Back to Table of Contents](#table-of-contents)

---

## 17. Best practices

### 1. Functions mein temporary variables ko `local` banayein

```bash
calculate_total()
{
    local price=$1
    local quantity=$2
    local total=$((price * quantity))

    echo "$total"
}
```

### 2. Variables ko quotes mein expand karein

```bash
echo "$name"
cp -- "$source" "$destination"
```

### 3. Meaningful names use karein

Behtar:

```bash
student_name="Ali"
```

Kam clear:

```bash
x="Ali"
```

### 4. Constants ko uppercase aur readonly rakhein

```bash
readonly MAX_RETRIES=3
```

### 5. Zarurat ke baghair variable export na karein

Sirf woh variables export karein jo child processes ko chahiye.

### 6. Function arguments ko local variables mein store karein

```bash
greet()
{
    local name=$1
    echo "Hello: $name"
}
```

### 7. Temporary local variables ko declare karein

```bash
show_items()
{
    local item

    for item in "$@"
    do
        echo "$item"
    done
}
```

Benefits:

- Global variables accidentally change nahin hote.
- Functions reusable bante hain.
- Script samajhna asaan hota hai.
- Variable-name conflicts kam hote hain.
- Debugging asaan hoti hai.

[Back to Table of Contents](#table-of-contents)

---

## 18. Complete practice script

```bash
#!/bin/bash

# Global and readonly variables
course="Bash Scripting"
readonly MAX_STUDENTS=3

show_student()
{
    local student_name=$1
    local student_number=$2

    echo "Student $student_number: $student_name"
    echo "Course: $course"
}

show_all_students()
{
    local student
    local count=1

    echo "Total arguments: $#"

    for student in "$@"
    do
        show_student "$student" "$count"
        ((count++))
    done
}

show_all_students "Ali" "Khalid" "Sara"

echo
echo "Maximum students: $MAX_STUDENTS"
```

Output:

```text
Total arguments: 3
Student 1: Ali
Course: Bash Scripting
Student 2: Khalid
Course: Bash Scripting
Student 3: Sara
Course: Bash Scripting

Maximum students: 3
```

Scope explanation:

| Variable | Type | Kahan available hai? |
|---|---|---|
| `course` | Global | Poori script aur functions mein |
| `MAX_STUDENTS` | Global readonly | Poori script mein, lekin change nahin ho sakta |
| `student_name` | Local | Sirf `show_student` function mein |
| `student_number` | Local | Sirf `show_student` function mein |
| `student` | Local | Sirf `show_all_students` function mein |
| `count` | Local | Sirf `show_all_students` function mein |
| `"$@"` | Function arguments | Current function call ke andar |

[Back to Table of Contents](#table-of-contents)

---

## 19. Quick revision

| Concept | Syntax | Matlab |
|---|---|---|
| Normal variable | `name="Ali"` | Value store karta hai |
| Variable expansion | `"$name"` | Stored value use karta hai |
| Global variable | `course="Bash"` | Poori script mein available |
| Local variable | `local name="Ali"` | Sirf function ke andar |
| Environment variable | `export name="Ali"` | Child processes ko bhi milta hai |
| Readonly variable | `readonly MAX=3` | Change nahin kiya ja sakta |
| Remove variable | `unset name` | Variable delete karta hai |
| Script arguments | `$1`, `$2`, `"$@"` | Script ko diye gaye arguments |
| Function arguments | `$1`, `$2`, `"$@"` | Function call ko diye gaye arguments |
| Subshell | `( commands )` | Changes parent shell mein wapas nahin aatin |
| Current shell group | `{ commands; }` | Changes current shell mein rehti hain |

## Final memory rules

> Function ke bahar variable aam tor par global hota hai.

> Function ke andar `local` ke saath variable sirf us function ka hota hai.

> `export` variable ko child processes tak bhejta hai.

> Child process parent ke variable ko permanently change nahin kar sakta.

> Subshell mein ki gayi changes parent shell mein wapas nahin aatin.

> Functions ke temporary variables ke liye `local` use karna best practice hai.

[Back to Table of Contents](#table-of-contents)

---

## 20. Practice tasks

### Task 1 — Global variable

`course="Bash Scripting"` naam ka global variable banayein aur usay function ke andar aur bahar print karein.

### Task 2 — Local variable

Function ke andar:

```bash
local student="Ali"
```

banayein. Function ke andar aur bahar print karke difference dekhein.

### Task 3 — Protect global variable

Global variable:

```bash
name="Khalid"
```

banayein. Function ke andar `local name="Ali"` use karein aur prove karein ke global value change nahin hui.

### Task 4 — Function arguments

Function ko teen arguments dein:

```bash
"apple" "banana" "red cherry"
```

`"$@"` aur local counter use karke output banayein:

```text
Item 1: apple
Item 2: banana
Item 3: red cherry
```

### Task 5 — Environment variable

Ek variable banayein, phir `bash -c` se test karein:

1. Export ke baghair
2. Export ke saath

### Task 6 — Subshell

Main shell mein:

```bash
name="Khalid"
```

set karein. Subshell mein value `Ali` karein aur prove karein ke main shell ki value ab bhi `Khalid` hai.

[Back to Table of Contents](#table-of-contents)
