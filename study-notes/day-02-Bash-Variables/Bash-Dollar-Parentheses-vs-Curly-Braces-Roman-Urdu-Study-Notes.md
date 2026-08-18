# Bash `$()` aur `${}` — Roman Urdu Study Notes

## Table of Contents

1. [Quick Comparison](#1-quick-comparison)
2. [`$()` — Command Substitution](#2----command-substitution)
3. [`$()` Kaisay Kaam Karta Hai](#3--kaisay-kaam-karta-hai)
4. [Nested Command Substitution](#4-nested-command-substitution)
5. [`${}` — Parameter Expansion](#5----parameter-expansion)
6. [Useful Parameter Expansions](#6-useful-parameter-expansions)
7. [`$()` aur `${}` ko Sath Use Karna](#7--aur--ko-sath-use-karna)
8. [Common Mistakes](#8-common-mistakes)
9. [Quick Reference](#9-quick-reference)
10. [Final Summary](#10-final-summary)

## Suggested Script Files

| Script name | Kis concept ke liye hai? |
|---|---|
| `command_substitution_date.sh` | `date` command ka output capture karna |
| `current_directory.sh` | `pwd` command ka output capture karna |
| `current_user.sh` | Command substitution directly use karna |
| `script_directory_path.sh` | Nested command substitution use karna |
| `variable_expansion.sh` | `${}` se variable read karna |
| `pluralize_fruit.sh` | Variable name ko following text se separate karna |
| `default_name.sh` | `$1` ke liye default value use karna |
| `empty_source_file.sh` | Safe empty default value use karna |
| `string_length.sh` | String ki length maloom karna |
| `remove_file_extension.sh` | Filename suffix remove karna |
| `extract_filename.sh` | Path se directory prefix remove karna |
| `replace_text.sh` | Parameter expansion se text replace karna |
| `array_element.sh` | Aik array element access karna |
| `array_all_elements.sh` | Tamam array elements access aur loop karna |
| `array_indexes.sh` | Tamam array indexes access karna |
| `student_time.sh` | `$()` aur `${}` ko aik sath use karna |
| `script_path_info.sh` | Script path aur directory display karna |
| `command_and_arithmetic_expansion.sh` | Command aur arithmetic expansion compare karna |

---

## 1. Quick Comparison

Bash mein `$()` aur `${}` bilkul mukhtalif kaam karte hain.

| Syntax | Naam | Maqsad |
|---|---|---|
| `$(command)` | Command substitution | Command chalata hai aur us ka standard output capture karta hai |
| `${variable}` | Parameter expansion | Variable ki value expand, read, ya modify karta hai |

Memory rule:

```text
$()  → Command chalao aur us ka output capture karo
${}  → Variable ki value expand ya modify karo
```

---

## 2. `$()` — Command Substitution

Basic syntax:

```bash
variable="$(command)"
```

Bash `$()` ke andar command chalati hai aur poori expression ko command ke output se replace kar deti hai.

### `date` ka output capture karna

**Create: `command_substitution_date.sh`**

```bash
#!/bin/bash

# Title: Command Substitution with Date
# Purpose: Capture and display the output of the date command.

today="$(date)"
echo "$today"

exit 0
```

Possible output:

```text
Tue Aug 18 10:30:00 CDT 2026
```

Is script mein:

1. `date` command chalti hai.
2. `$()` us ka output capture karta hai.
3. Output `today` variable mein store hota hai.
4. `echo` stored value display karta hai.

### Current directory capture karna

**Create: `current_directory.sh`**

```bash
#!/bin/bash

# Title: Current Directory
# Purpose: Capture and display the current working directory.

current_directory="$(pwd)"
echo "$current_directory"

exit 0
```

Possible output:

```text
/home/khalid/nit/shell-scripting
```

### Variable ke baghair direct use

Command substitution ko directly kisi command ke andar bhi use kiya ja sakta hai.

**Create: `current_user.sh`**

```bash
#!/bin/bash

# Title: Current User
# Purpose: Display the output of whoami directly.

echo "Current user: $(whoami)"

exit 0
```

Possible output:

```text
Current user: khalid
```

### Important behavior

`$()` command ka **standard output** capture karta hai. Standard error par bheji gayi error messages automatically capture nahi hoti.

```bash
result="$(ls existing-file.txt)"
```

Agar command successful ho to `ls` ka output `result` mein store hoga.

Command substitution captured output ke end se trailing newline characters bhi remove kar deta hai.

---

## 3. `$()` Kaisay Kaam Karta Hai

Yeh command dekhein:

```bash
current_directory="$(pwd)"
```

Bash isay is order mein process karti hai:

```text
1. pwd command chalaye
2. Standard output capture kare
3. End ke newline characters remove kare
4. Result current_directory variable mein assign kare
```

Outer quotes recommended hain:

```bash
current_directory="$(pwd)"
```

Quotes captured output ko unwanted word splitting aur filename expansion se protect karti hain.

---

## 4. Nested Command Substitution

Aik command substitution ke andar doosri command substitution use ki ja sakti hai.

**Create: `script_directory_path.sh`**

```bash
#!/bin/bash

# Title: Script Directory Path
# Purpose: Find and display the script's absolute directory.

script_directory="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "Script directory: $script_directory"
exit 0
```

Inner command substitution:

```bash
$(dirname -- "${BASH_SOURCE[0]}")
```

Yeh `dirname` command chalati hai aur script path ka directory wala hissa return karti hai.

Outer command substitution:

```bash
$(cd -- "directory" && pwd)
```

Yeh directory mein jati hai aur `pwd` se absolute path capture karti hai.

Inside-out flow:

```text
${BASH_SOURCE[0]}
        ↓
Current script ka path expand hota hai
        ↓
dirname directory return karta hai
        ↓
cd us directory mein jata hai
        ↓
pwd absolute path print karta hai
        ↓
$() path capture karta hai
```

---

## 5. `${}` — Parameter Expansion

Basic syntax:

```bash
${variable}
```

Parameter expansion Bash ko variable ki value expand karne ke liye kehti hai.

**Create: `variable_expansion.sh`**

```bash
#!/bin/bash

# Title: Variable Expansion
# Purpose: Read and display a variable with curly braces.

name="Khalid"
echo "${name}"

exit 0
```

Output:

```text
Khalid
```

### Curly braces kyun use karte hain?

Curly braces clearly batati hain ke variable name kahan end hota hai.

**Create: `pluralize_fruit.sh`**

```bash
#!/bin/bash

# Title: Append Text to a Variable Value
# Purpose: Separate the variable name from following text.

fruit="apple"
echo "${fruit}s"

exit 0
```

Output:

```text
apples
```

Agar aap yeh likhein:

```bash
echo "$fruits"
```

to Bash `fruits` naam ka different variable dhoonday gi.

### `$variable` aur `${variable}`

Yeh dono aam tor par same value dete hain:

```bash
echo "$name"
echo "${name}"
```

Braces zaroori ya zyada useful hoti hain jab:

- Variable ke foran baad text ho.
- Array elements access karne hon.
- Advanced parameter-expansion operators use karne hon.
- Expression ko zyada readable banana ho.

---

## 6. Useful Parameter Expansions

### 6.1 Variable read karna

Is concept ko `variable_expansion.sh` mein demonstrate kiya gaya hai:

```bash
name="Khalid"
echo "${name}"
```

### 6.2 Default value use karna

**Create: `default_name.sh`**

```bash
#!/bin/bash

# Title: Default Name
# Purpose: Use Guest when the first argument is missing or empty.

name="${1:-Guest}"
echo "Hello, $name"

exit 0
```

Agar `$1` unset ya empty ho, to `name` ko `Guest` milta hai.

Argument ke baghair:

```bash
bash default_name.sh
```

Output:

```text
Hello, Guest
```

Argument ke sath:

```bash
bash default_name.sh Ali
```

Output:

```text
Hello, Ali
```

### 6.3 Safe empty string banana

**Create: `empty_source_file.sh`**

```bash
#!/bin/bash

# Title: Empty Source File Default
# Purpose: Safely use an empty string when $1 is unavailable.

source_file="${1:-}"

echo "Source file: $source_file"
exit 0
```

Agar `$1` missing ya empty ho to `source_file` ko empty string milti hai.

### 6.4 String length maloom karna

**Create: `string_length.sh`**

```bash
#!/bin/bash

# Title: String Length
# Purpose: Display the number of characters in a variable.

name="Khalid"
echo "${#name}"

exit 0
```

Output:

```text
6
```

`${#name}` variable ki value mein characters count karta hai.

### 6.5 Suffix remove karna

**Create: `remove_file_extension.sh`**

```bash
#!/bin/bash

# Title: Remove File Extension
# Purpose: Remove the .txt suffix from a filename.

file="report.txt"
echo "${file%.txt}"

exit 0
```

Output:

```text
report
```

`%` variable ke end se shortest matching suffix pattern remove karta hai.

### 6.6 Prefix remove karke filename nikalna

**Create: `extract_filename.sh`**

```bash
#!/bin/bash

# Title: Extract Filename
# Purpose: Remove the directory portion from a path.

path="/home/khalid/report.txt"
echo "${path##*/}"

exit 0
```

Output:

```text
report.txt
```

`##*/` final `/` tak sab kuch remove kar deta hai.

### 6.7 Text replace karna

**Create: `replace_text.sh`**

```bash
#!/bin/bash

# Title: Replace Text
# Purpose: Replace the first matching text in a variable.

message="Hello World"
echo "${message/World/Bash}"

exit 0
```

Output:

```text
Hello Bash
```

### 6.8 Aik array element access karna

**Create: `array_element.sh`**

```bash
#!/bin/bash

# Title: Access One Array Element
# Purpose: Display the value stored at index 1.

friends=("Ali" "Omar" "Sara")
echo "${friends[1]}"

exit 0
```

Output:

```text
Omar
```

Bash array index `0` se start hota hai.

### 6.9 Tamam array elements access karna

**Create: `array_all_elements.sh`**

```bash
#!/bin/bash

# Title: Access All Array Elements
# Purpose: Display all elements together and one per line.

friends=("Ali" "Omar" "Sara")

echo "${friends[@]}"

for friend in "${friends[@]}"
do
    echo "$friend"
done

exit 0
```

Output:

```text
Ali Omar Sara
Ali
Omar
Sara
```

Reliable iteration ke liye quoted `"${friends[@]}"` use karein.

### 6.10 Tamam array indexes access karna

**Create: `array_indexes.sh`**

```bash
#!/bin/bash

# Title: Access Array Indexes
# Purpose: Display every index and its corresponding value.

friends=("Ali" "Omar" "Sara")

for index in "${!friends[@]}"
do
    echo "Index $index: ${friends[index]}"
done

exit 0
```

Output:

```text
Index 0: Ali
Index 1: Omar
Index 2: Sara
```

---

## 7. `$()` aur `${}` ko Sath Use Karna

**Create: `student_time.sh`**

```bash
#!/bin/bash

# Title: Student and Current Time
# Purpose: Use command substitution and parameter expansion together.

name="Khalid"
current_time="$(date +%H:%M)"

echo "Student: ${name}"
echo "Time: ${current_time}"

exit 0
```

| Expression | Kaam |
|---|---|
| `$(date +%H:%M)` | `date` command chalata aur output capture karta hai |
| `${name}` | `name` ki stored value expand karta hai |
| `${current_time}` | Captured time expand karta hai |

Doosra example:

**Create: `script_path_info.sh`**

```bash
#!/bin/bash

# Title: Script Path Information
# Purpose: Display the current script path and its directory.

script_name="${BASH_SOURCE[0]}"
script_directory="$(dirname -- "$script_name")"

echo "Script: ${script_name}"
echo "Directory: ${script_directory}"

exit 0
```

Yahan `${}` variables ki values read karta hai, jabke `$()` `dirname` command chala kar us ka output capture karta hai.

---

## 8. Common Mistakes

### Mistake 1: `${}` se command chalana

Ghalat:

```bash
today="${date}"
```

Yeh `date` naam ka variable read karta hai; `date` command nahi chalata.

Sahi:

```bash
today="$(date)"
```

### Mistake 2: `$()` se ordinary variable read karna

Ghalat:

```bash
name="Khalid"
echo "$(name)"
```

Bash `name` ko command samajh kar chalane ki koshish karegi.

Sahi:

```bash
echo "${name}"
```

### Mistake 3: Variable ke baad text ho aur braces na lagana

```bash
fruit="apple"
echo "$fruits"
```

Bash `fruits` naam ka variable dhoonday gi.

Sahi:

```bash
echo "${fruit}s"
```

### Mistake 4: Array expansion ghalat likhna

Ghalat:

```bash
echo "$friends[@]"
```

Yeh first element ke baad literal `[@]` print kar sakta hai.

Sahi:

```bash
echo "${friends[@]}"
```

### Mistake 5: Expansions quote na karna

Kam safe:

```bash
echo $name
```

Preferred:

```bash
echo "$name"
```

Arrays ke liye:

```bash
for friend in "${friends[@]}"
do
    echo "$friend"
done
```

Quotes `"Red Cherry"` jaisi value ko aik hi item rakhti hain.

### Mistake 6: `$((...))` aur `$(...)` confuse karna

| Syntax | Maqsad |
|---|---|
| `$(command)` | Command substitution |
| `$((expression))` | Arithmetic expansion |

**Create: `command_and_arithmetic_expansion.sh`**

```bash
#!/bin/bash

# Title: Command and Arithmetic Expansion
# Purpose: Compare command output capture with arithmetic calculation.

current_date="$(date)"
total=$((5 + 3))

echo "Date: $current_date"
echo "Total: $total"

exit 0
```

---

## 9. Quick Reference

| Requirement | Syntax | Example |
|---|---|---|
| Command output capture karein | `$(command)` | `user="$(whoami)"` |
| Variable expand karein | `${variable}` | `echo "${user}"` |
| Value ke baad text lagayein | `${variable}text` | `echo "${fruit}s"` |
| Unset ya empty par default | `${variable:-default}` | `name="${1:-Guest}"` |
| Empty default | `${variable:-}` | `file="${1:-}"` |
| String length | `${#variable}` | `echo "${#name}"` |
| Suffix remove karein | `${variable%pattern}` | `${file%.txt}` |
| Longest prefix remove karein | `${variable##pattern}` | `${path##*/}` |
| Pehla match replace karein | `${variable/old/new}` | `${text/foo/bar}` |
| Aik array element | `${array[index]}` | `${friends[0]}` |
| Tamam array elements | `${array[@]}` | `"${friends[@]}"` |
| Tamam array indexes | `${!array[@]}` | `"${!friends[@]}"` |
| Arithmetic calculation | `$((expression))` | `total=$((5 + 3))` |

---

## 10. Final Summary

```bash
current_user="$(whoami)"
echo "User: ${current_user}"
```

Is example mein:

1. `$(whoami)` command chalata hai aur us ka output capture karta hai.
2. `${current_user}` stored variable value expand karta hai.

Final memory rule:

```text
$()     = command ka output
${}     = variable ki value ya parameter operation
$(( ))  = arithmetic calculation
```

Brackets Bash ko batati hain ke kis qisam ka kaam karna hai. `$()` mein parentheses command substitution ko represent karti hain, jabke `${}` mein curly braces parameter expansion ko represent karti hain.
