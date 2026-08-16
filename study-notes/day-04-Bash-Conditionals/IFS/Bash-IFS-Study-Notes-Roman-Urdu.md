# Bash `IFS` — Roman Urdu Study Notes

## Table of Contents

1. [`IFS` kya hai?](#1-ifs-kya-hai)
2. [Default `IFS`](#2-default-ifs)
3. [`IFS` ka basic example](#3-ifs-ka-basic-example)
4. [Custom delimiter use karna](#4-custom-delimiter-use-karna)
5. [Comma-separated record parse karna](#5-comma-separated-record-parse-karna)
6. [Colon-separated data aur `/etc/passwd`](#6-colon-separated-data-aur-etcpasswd)
7. [`IFS= read -r line` ka matlab](#7-ifs-read--r-line-ka-matlab)
8. [File ko safely line by line read karna](#8-file-ko-safely-line-by-line-read-karna)
9. [`IFS=` aur `IFS=' '` mein farq](#9-ifs-aur-ifs--mein-farq)
10. [Text ko array mein convert karna](#10-text-ko-array-mein-convert-karna)
11. [User input ko delimiter se split karna](#11-user-input-ko-delimiter-se-split-karna)
12. [`read` ki last variable ka behavior](#12-read-ki-last-variable-ka-behavior)
13. [Temporary, global aur local `IFS`](#13-temporary-global-aur-local-ifs)
14. [`IFS`, `"$*"`, aur `"$@"`](#14-ifs-aur)
15. [Simple CSV aur complex CSV](#15-simple-csv-aur-complex-csv)
16. [Common mistakes](#16-common-mistakes)
17. [Best practices](#17-best-practices)
18. [Quick-reference table](#18-quick-reference-table)
19. [Practice tasks](#19-practice-tasks)
20. [Final summary](#20-final-summary)

---

## 1. `IFS` kya hai?

`IFS` ka full form hai:

```text
Internal Field Separator
```

`IFS` Bash ka special shell variable hai. Yeh Bash ko batata hai ke text ko fields ya parts mein kin characters ki bunyaad par divide karna hai.

Asaan alfaaz mein:

> `IFS` Bash ko batata hai ke input ko kahan se todna ya split karna hai.

Misal ke taur par, agar data comma-separated ho:

```text
Ali,25,DevOps
```

to hum comma ko separator bana sakte hain:

```bash
IFS=',' read -r name age role <<< "$data"
```

[IFS=',' read -r name age role <<< "$data" Explaination in roman Urdu](md/bash_read_command_roman_urdu.md)

[IFS=',' read -r name age role <<< "$data" Explaination](md/bash_read_command_study_notes.md)

Is ke baad:

| Variable | Value |
|---|---|
| `name` | `Ali` |
| `age` | `25` |
| `role` | `DevOps` |

---

## 2. Default `IFS`

Bash ka default `IFS` aam tor par in whitespace characters par mushtamil hota hai:

- Space
- Tab
- Newline

Is liye Bash default tor par whitespace ki bunyaad par fields separate kar sakta hai.

Default `IFS` ko readable form mein dekhne ke liye:

```bash
printf '%q\n' "$IFS"
```

Possible output:

```text
$' \t\n'
```

Is representation mein:

| Symbol | Meaning |
|---|---|
| Space | Normal space character |
| `\t` | Tab |
| `\n` | Newline |

`echo "$IFS"` useful display nahin deta kyun ke separators khud whitespace hote hain.

---

## 3. `IFS` ka basic example

Default `IFS` spaces ki bunyaad par words split kar sakta hai.

```bash
text="apple banana cherry"

read -r fruit1 fruit2 fruit3 <<< "$text"

echo "$fruit1"
echo "$fruit2"
echo "$fruit3"
```

[IFS=',' read -r name age role <<< "$data" Explaination in roman Urdu](md/bash_read_command_roman_urdu.md)

[IFS=',' read -r name age role <<< "$data" Explaination](md/bash_read_command_study_notes.md)



Output:

```text
apple
banana
cherry
```

Yahan hum ne custom `IFS` set nahin kiya. `read` ne default whitespace separators use kiye.

---

## 4. Custom delimiter use karna

Delimiter woh character hota hai jo fields ko separate karta hai.

Common delimiters:

| Data | Delimiter |
|---|---|
| `Ali,25,DevOps` | Comma `,` |
| `khalid:x:1000` | Colon `:` |
| `web01|running|80` | Pipe `|` |
| `apple;banana;mango` | Semicolon `;` |

Custom `IFS` ka basic pattern:

```bash
IFS='DELIMITER' read -r variable1 variable2 variable3 <<< "$data"
```

Pipe-separated example:

```bash
server_record="web01|running|80"

IFS='|' read -r server status usage <<< "$server_record"

echo "Server: $server"
echo "Status: $status"
echo "Usage: $usage%"
```

Output:

```text
Server: web01
Status: running
Usage: 80%
```

---

## 5. Comma-separated record parse karna

**Tajweez kardah script ka naam:** `split_student_record.sh`

```bash
#!/bin/bash

# Title: Student Record Parser
# Purpose: Split a comma-separated student record into variables.

data="Ali,25,DevOps"

IFS=',' read -r name age course <<< "$data"

echo "Name: $name"
echo "Age: $age"
echo "Course: $course"

exit 0
```

Output:

```text
Name: Ali
Age: 25
Course: DevOps
```

### Command ka breakdown

```bash
IFS=',' read -r name age course <<< "$data"
```

| Part | Meaning |
|---|---|
| `IFS=','` | Comma ko field separator banata hai |
| `read` | Input read karta hai |
| `-r` | Backslashes ko escape characters samajhne se rokta hai |
| `name age course` | Fields receive karne wali variables |
| `<<< "$data"` | Variable ka content `read` ko input deta hai |

Yahan `IFS` sirf `read` command ke liye comma par set hai. Poore script ka `IFS` permanently change nahin hota.

---

## 6. Colon-separated data aur `/etc/passwd`

Linux ki `/etc/passwd` file colon-separated fields use karti hai.

Example record:

```text
khalid:x:1000:1000:Khalid:/home/khalid:/bin/bash
```

Fields:

| Position | Field |
|---:|---|
| 1 | Username |
| 2 | Password placeholder |
| 3 | UID |
| 4 | GID |
| 5 | Comment/GECOS |
| 6 | Home directory |
| 7 | Login shell |

### One record parse karna

```bash
line="khalid:x:1000:1000:Khalid:/home/khalid:/bin/bash"

IFS=':' read -r username password uid gid comment home shell <<< "$line"

echo "Username: $username"
echo "UID: $uid"
echo "Home: $home"
echo "Shell: $shell"
```

### Poori `/etc/passwd` file parse karna

**Tajweez kardah script ka naam:** `parse_passwd_file.sh`

```bash
#!/bin/bash

# Title: Passwd File Parser
# Purpose: Display selected fields from /etc/passwd.

while IFS=':' read -r username password uid gid comment home shell
do
    echo "User: $username"
    echo "UID: $uid"
    echo "Home: $home"
    echo "Shell: $shell"
    echo
done < /etc/passwd

exit 0
```

### Script flow

1. `while` `/etc/passwd` ki har line read karta hai.
2. `IFS=':'` line ko colon par split karta hai.
3. Har field related variable mein store hoti hai.
4. Loop selected values print karta hai.
5. File ke end par loop complete ho jata hai.

---

## 7. `IFS= read -r line` ka matlab

Yeh Bash mein file read karne ka bohat important pattern hai:

```bash
IFS= read -r line
```

Is mein teen important parts hain:

### `IFS=`

```bash
IFS=
```

Empty `IFS` ka matlab hai:

> Input line ko field separators ki bunyaad par split ya trim na karo.

Yeh leading aur trailing whitespace ko preserve karne mein madad karta hai.

### `read`

```bash
read
```

Input se ek line read karta hai.

### `-r`

```bash
read -r
```

Backslash `\` ko escape character samajhne se rokta hai.

Misal ke taur par:

```text
C:\Users\Khalid
```

`read -r` is text ke backslashes preserve karta hai.

### `line`

```bash
line
```

Poori input line is variable mein store hoti hai.

---

## 8. File ko safely line by line read karna

**Tajweez kardah script ka naam:** `read_file_safely.sh`

```bash
#!/bin/bash

# Title: Safe Line Reader
# Purpose: Read a text file without damaging spaces or backslashes.
# Usage: ./read_file_safely.sh FILE

if (( $# != 1 )); then
    echo "Usage: $0 FILE" >&2
    exit 2
fi

input_file=$1

if [[ ! -f "$input_file" ]]; then
    echo "Error: regular file not found: $input_file" >&2
    exit 1
fi

while IFS= read -r line
do
    echo "$line"
done < "$input_file"

exit 0
```

### Recommended pattern

```bash
while IFS= read -r line
do
    commands
done < "$input_file"
```

Is pattern ke faide:

- Poori line ek unit rehti hai.
- Leading spaces preserve rehte hain.
- Backslashes preserve rehte hain.
- Filenames ya text mein spaces safely handle hoti hain.
- `cat` aur command substitution ki zaroorat nahin hoti.

### Last line without newline

Kuch files ki aakhri line newline ke baghair hoti hai. Usay bhi process karne ka advanced pattern:

```bash
while IFS= read -r line || [[ -n "$line" ]]
do
    echo "$line"
done < "$input_file"
```

`|| [[ -n "$line" ]]` ensure karta hai ke non-empty last line process ho jaye, chahe us ke end par newline na ho.

---

## 9. `IFS=` aur `IFS=' '` mein farq

Yeh dono same nahin hain.

### Empty `IFS`

```bash
IFS=
```

Meaning:

> Field splitting ke liye koi separator use na karo.

### Space wala `IFS`

```bash
IFS=' '
```

Meaning:

> Input ko space character ki bunyaad par split karo.

| Setting | Result |
|---|---|
| `IFS=` | Splitting band |
| `IFS=' '` | Space par splitting |
| `IFS=','` | Comma par splitting |
| `IFS=':'` | Colon par splitting |

---

## 10. Text ko array mein convert karna

`read -a` split hone wali fields ko indexed array mein store karta hai.

**Tajweez kardah script ka naam:** `split_fruits_array.sh`

```bash
#!/bin/bash

# Title: Comma-Separated Fruit Parser
# Purpose: Split fruit data into a Bash array.

fruits="apple,banana,red cherry"

IFS=',' read -r -a fruit_array <<< "$fruits"

echo "Total fruits: ${#fruit_array[@]}"

for fruit in "${fruit_array[@]}"
do
    echo "Fruit: $fruit"
done

exit 0
```

Output:

```text
Total fruits: 3
Fruit: apple
Fruit: banana
Fruit: red cherry
```

### Important parts

| Syntax | Meaning |
|---|---|
| `read -a fruit_array` | Fields ko array mein store karta hai |
| `${#fruit_array[@]}` | Array elements count karta hai |
| `"${fruit_array[@]}"` | Har element separately preserve karta hai |

`red cherry` ke andar space hai, lekin comma delimiter hai. Is liye yeh ek hi array element rehta hai.

---

## 11. User input ko delimiter se split karna

**Tajweez kardah script ka naam:** `parse_fruit_input.sh`

```bash
#!/bin/bash

# Title: Fruit Input Parser
# Purpose: Read three comma-separated fruits from the user.

if ! read -r -p "Enter three fruits separated by commas: " input; then
    echo >&2
    echo "Error: input read nahin ho saka." >&2
    exit 1
fi

if [[ -z "$input" ]]; then
    echo "Error: input empty nahin ho sakta." >&2
    exit 1
fi

IFS=',' read -r fruit1 fruit2 fruit3 <<< "$input"

echo "Fruit 1: $fruit1"
echo "Fruit 2: $fruit2"
echo "Fruit 3: $fruit3"

exit 0
```

Example input:

```text
apple,banana,red cherry
```

Output:

```text
Fruit 1: apple
Fruit 2: banana
Fruit 3: red cherry
```

---

## 12. `read` ki last variable ka behavior

Agar input fields ki tadaad variables se zyada ho, to `read` ki last variable remaining data receive karti hai.

```bash
data="Ali,25,DevOps,Chicago"

IFS=',' read -r name age details <<< "$data"

echo "Name: $name"
echo "Age: $age"
echo "Details: $details"
```

Output:

```text
Name: Ali
Age: 25
Details: DevOps,Chicago
```

Is liye variables ki tadaad aur data format ko samajhna zaroori hai.

Agar kisi field ko ignore karna ho, underscore variable use ki ja sakti hai:

```bash
IFS=':' read -r username _ uid gid _ home shell <<< "$line"
```

Yahan `_` ignored fields receive karti hai. Lekin aik hi `_` variable dobara use hone par us ki purani value replace ho jati hai, jo is use case mein theek hai.

---

## 13. Temporary, global aur local `IFS`

### Temporary `IFS` — recommended

```bash
IFS=',' read -r first second third <<< "$data"
```

Yeh comma separator sirf `read` command ke liye use karta hai.

### Global `IFS` — carefully use karein

```bash
IFS=','
```

Yeh current shell ya script ke baad wale operations ko bhi affect kar sakta hai.

Agar global change zaroori ho, original value save aur restore karein:

```bash
old_ifs=$IFS
IFS=','

read -r first second third <<< "$data"

IFS=$old_ifs
```

Temporary command assignment zyada simple aur safe hoti hai.

### Function mein local `IFS`

**Tajweez kardah script ka naam:** `parse_record_function.sh`

```bash
#!/bin/bash

# Title: Record Parser Function
# Purpose: Parse colon-separated records without changing the global IFS.

parse_record()
{
    local record=$1
    local IFS=':'
    local username uid shell

    read -r username uid shell <<< "$record"

    echo "Username: $username"
    echo "UID: $uid"
    echo "Shell: $shell"
}

parse_record "ali:1001:/bin/bash"

exit 0
```

`local IFS=':'` sirf function ko affect karta hai. Function ke bahar original `IFS` safe rehta hai.

---

## 14. `IFS`, `"$*"`, aur `"$@"`

Quoted `"$*"` tamam positional arguments ko ek string mein join karta hai. Arguments ke darmiyan `IFS` ka pehla character use hota hai.

**Tajweez kardah script ka naam:** `join_arguments.sh`

```bash
#!/bin/bash

# Title: Argument Joiner
# Purpose: Demonstrate how IFS affects quoted "$*".

if (( $# == 0 )); then
    echo "Usage: $0 ARGUMENT..." >&2
    exit 2
fi

IFS=','

echo "Joined with \"\$*\": $*"

echo "Separate values with \"\$@\":"
for argument in "$@"
do
    echo "- $argument"
done

exit 0
```

Run:

```bash
bash join_arguments.sh apple banana "red cherry"
```

Output:

```text
Joined with "$*": apple,banana,red cherry
Separate values with "$@":
- apple
- banana
- red cherry
```

### Difference

| Expansion | Behavior |
|---|---|
| `"$*"` | Tamam arguments ko IFS ke first character se join karta hai |
| `"$@"` | Har argument ko separate item ke taur par preserve karta hai |

Script arguments process karne ke liye aam tor par `"$@"` recommended hai.

---

## 15. Simple CSV aur complex CSV

`IFS=','` simple comma-separated records ke liye useful hai:

```text
Ali,25,DevOps
```

Lekin real CSV mein quoted commas ho sakte hain:

```text
Ali,25,"Chicago, Illinois"
```

Simple `IFS=','` quoted comma ko bhi separator samjhega aur data galat split ho sakta hai.

Complex CSV features:

- Quoted commas
- Escaped quotes
- Empty fields
- Multiline fields
- Newlines inside quoted values

In situations mein proper CSV parser use karein, misal ke taur par Python ka `csv` module. `IFS` simple delimiter-separated data ke liye best hai, complete CSV standard ke liye nahin.

---

## 16. Common mistakes

### Mistake 1: Poore script ka `IFS` badal dena

Risky:

```bash
IFS=','
```

Better:

```bash
IFS=',' read -r first second third <<< "$data"
```

### Mistake 2: `read -r` use na karna

Less safe:

```bash
IFS=',' read first second third
```

Recommended:

```bash
IFS=',' read -r first second third
```

### Mistake 3: File ko command substitution se read karna

Avoid:

```bash
for line in $(cat file.txt)
do
    echo "$line"
done
```

Problems:

- Whitespace par unwanted splitting hoti hai.
- Blank lines lose ho sakti hain.
- Wildcard characters expand ho sakte hain.
- Poori lines preserve nahin rehtin.

Recommended:

```bash
while IFS= read -r line
do
    echo "$line"
done < file.txt
```

### Mistake 4: Variables ko quote na karna

Avoid:

```bash
echo $line
```

Recommended:

```bash
echo "$line"
```

### Mistake 5: Complex CSV ko simple `IFS` se parse karna

`IFS` quoted CSV rules ko understand nahin karta. Complex CSV ke liye proper parser use karein.

### Mistake 6: `"$*"` aur `"$@"` ko same samajhna

`"$*"` arguments ko join karta hai. `"$@"` unhein separate preserve karta hai.

### Mistake 7: `IFS=` ko space samajhna

```bash
IFS=
```

empty separator hai.

```bash
IFS=' '
```

space separator hai.

---

## 17. Best practices

- File lines ke liye `while IFS= read -r line` use karein.
- Custom delimiter ko sirf required command tak limit karein.
- `read` ke saath aam tor par `-r` use karein.
- Variables aur array expansions ko double quotes mein rakhein.
- Simple delimiter-separated records ke liye `IFS` use karein.
- Complex CSV ke liye proper CSV parser use karein.
- Function mein custom separator ke liye `local IFS=':'` use karein.
- Script arguments process karne ke liye `"$@"` prefer karein.
- Input format aur expected field count validate karein.
- Empty fields aur extra fields ke behavior ko test karein.
- Global `IFS` change karne se pehle us ke side effects samjhein.

---

## 18. Quick-reference table

| Requirement | Recommended syntax | Meaning |
|---|---|---|
| Comma par split | `IFS=',' read -r a b c <<< "$data"` | Comma-separated fields variables mein rakhta hai |
| Colon par split | `IFS=':' read -r a b c <<< "$data"` | Colon-separated fields parse karta hai |
| Pipe par split | `IFS='|' read -r a b c <<< "$data"` | Pipe-separated fields parse karta hai |
| Poori line preserve | `IFS= read -r line` | Splitting/trimming se bachata hai |
| Fields ko array mein store | `IFS=',' read -r -a array <<< "$data"` | Split fields indexed array mein rakhta hai |
| File line by line read | `while IFS= read -r line; do ...; done < file` | File ko safely process karta hai |
| Function-local separator | `local IFS=':'` | Change ko function tak limit karta hai |
| Original value save | `old_ifs=$IFS` | Current `IFS` save karta hai |
| Original value restore | `IFS=$old_ifs` | Previous `IFS` wapas lagata hai |
| Arguments join | `"$*"` | First IFS character ke saath arguments join karta hai |
| Arguments separate | `"$@"` | Har argument separately preserve karta hai |
| Default IFS inspect | `printf '%q\n' "$IFS"` | Invisible separators readable form mein dikhata hai |

---

## 19. Practice tasks

### Task 1 — Student record

Is record ko comma par split karein:

```text
Sara,22,Linux
```

`name`, `age`, aur `course` variables print karein.

### Task 2 — Server record

Is record ko pipe `|` par split karein:

```text
web01|running|72
```

Server name, status aur disk usage print karein.

### Task 3 — Safe line reader

Ek file banayein jis mein spaces aur backslashes hon. `while IFS= read -r line` se har line safely print karein.

### Task 4 — Fruit array

User se comma-separated fruits lein aur `read -a` ke zariye array banayein. Har item ko number ke saath print karein.

### Task 5 — `/etc/passwd`

`/etc/passwd` se sirf username, UID, home directory aur shell print karein.

### Task 6 — Arguments

Ek script banayein jo pehle `"$*"` se arguments join kare aur phir `"$@"` ke through har argument separately print kare.

---

## 20. Final summary

`IFS` Bash ko batata hai ke input ko fields mein kahan se split karna hai.

```bash
IFS=',' read -r name age role <<< "$data"
```

Is command ka matlab hai:

> `data` ko comma ki bunyaad par divide karo aur fields ko `name`, `age`, aur `role` variables mein store karo.

File ko safely line by line read karne ka sab se important pattern:

```bash
while IFS= read -r line
do
    echo "$line"
done < "$input_file"
```

Yaad rakhein:

- Default `IFS` space, tab aur newline use karta hai.
- Custom `IFS` comma, colon, pipe ya koi aur delimiter use kar sakta hai.
- `IFS=` field splitting ko disable karta hai.
- `read -r` backslashes preserve karta hai.
- Temporary ya local `IFS` global change se zyada safe hota hai.
- `"$*"` IFS ke first character se arguments join karta hai.
- `"$@"` har argument ko separately preserve karta hai.
- Complex CSV ke liye sirf `IFS` par depend nahin karna chahiye.

