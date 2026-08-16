# Bash `IFS` — Complete Study Notes

## Table of Contents

1. [What is `IFS`?](#1-what-is-ifs)
2. [Default `IFS`](#2-default-ifs)
3. [Basic example](#3-basic-example)
4. [Using a custom delimiter](#4-using-a-custom-delimiter)
5. [Parsing a comma-separated record](#5-parsing-a-comma-separated-record)
6. [Colon-separated data and `/etc/passwd`](#6-colon-separated-data-and-etcpasswd)
7. [Meaning of `IFS= read -r line`](#7-meaning-of-ifs-read--r-line)
8. [Reading a file safely, line by line](#8-reading-a-file-safely-line-by-line)
9. [`IFS=` versus `IFS=' '`](#9-ifs-versus-ifs-)
10. [Converting text into an array](#10-converting-text-into-an-array)
11. [Splitting user input](#11-splitting-user-input)
12. [Behavior of the final `read` variable](#12-behavior-of-the-final-read-variable)
13. [Temporary, global, and local `IFS`](#13-temporary-global-and-local-ifs)
14. [`IFS`, `"$*"`, and `"$@"`](#14-ifs-and)
15. [Simple CSV versus complex CSV](#15-simple-csv-versus-complex-csv)
16. [Common mistakes](#16-common-mistakes)
17. [Best practices](#17-best-practices)
18. [Quick-reference table](#18-quick-reference-table)
19. [Practice tasks](#19-practice-tasks)
20. [Final summary](#20-final-summary)

---

## 1. What is `IFS`?

`IFS` stands for:

```text
Internal Field Separator
```

`IFS` is a special Bash variable that tells the shell which characters should separate text into fields.

In simple terms:

> `IFS` tells Bash where input should be split.

For example, consider this comma-separated record:

```text
Ali,25,DevOps
```

The comma can be used as the field separator:

```bash
IFS=',' read -r name age role <<< "$data"
```

The result is:

| Variable | Value |
|---|---|
| `name` | `Ali` |
| `age` | `25` |
| `role` | `DevOps` |

`IFS` is commonly used with:

- `read`
- `while` loops
- Arrays
- Positional parameters
- Simple delimiter-separated records

---

## 2. Default `IFS`

The default Bash `IFS` normally contains these whitespace characters:

- Space
- Tab
- Newline

Therefore, Bash can normally split fields at whitespace.

Display the current value in a readable form:

```bash
printf '%q\n' "$IFS"
```

Possible output:

```text
$' \t\n'
```

| Representation | Meaning |
|---|---|
| Space | Normal space character |
| `\t` | Tab |
| `\n` | Newline |

Running `echo "$IFS"` is not very informative because the characters being displayed are invisible whitespace.

---

## 3. Basic example

The default `IFS` allows `read` to split words at spaces:

```bash
text="apple banana cherry"

read -r fruit1 fruit2 fruit3 <<< "$text"

echo "$fruit1"
echo "$fruit2"
echo "$fruit3"
```

[IFS=',' read -r name age role <<< "$data" Explaination](md/bash_read_command_study_notes.md)

Output:

```text
apple
banana
cherry
```

No custom separator was specified, so `read` used the default whitespace separators.

---

## 4. Using a custom delimiter

A delimiter is a character that separates fields.

| Data | Delimiter |
|---|---|
| `Ali,25,DevOps` | Comma `,` |
| `khalid:x:1000` | Colon `:` |
| `web01|running|80` | Pipe `|` |
| `apple;banana;mango` | Semicolon `;` |

General syntax:

```bash
IFS='DELIMITER' read -r variable1 variable2 variable3 <<< "$data"
```

### Pipe-separated example

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

## 5. Parsing a comma-separated record

**Suggested script name:** `split_student_record.sh`

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

### Command breakdown

```bash
IFS=',' read -r name age course <<< "$data"
```

| Part | Meaning |
|---|---|
| `IFS=','` | Uses comma as the field separator |
| `read` | Reads input |
| `-r` | Prevents backslashes from being treated as escapes |
| `name age course` | Variables that receive the fields |
| `<<< "$data"` | Sends the variable's contents to `read` |

The `IFS=','` assignment applies to this `read` command. It does not permanently change `IFS` for the rest of the script.

---

## 6. Colon-separated data and `/etc/passwd`

The Linux `/etc/passwd` file uses colon-separated fields.

Example record:

```text
khalid:x:1000:1000:Khalid:/home/khalid:/bin/bash
```

| Position | Field |
|---:|---|
| 1 | Username |
| 2 | Password placeholder |
| 3 | UID |
| 4 | GID |
| 5 | Comment/GECOS field |
| 6 | Home directory |
| 7 | Login shell |

### Parse one record

```bash
line="khalid:x:1000:1000:Khalid:/home/khalid:/bin/bash"

IFS=':' read -r username password uid gid comment home shell <<< "$line"

echo "Username: $username"
echo "UID: $uid"
echo "Home: $home"
echo "Shell: $shell"
```

### Parse the complete `/etc/passwd` file

**Suggested script name:** `parse_passwd_file.sh`

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

1. `while` reads each line from `/etc/passwd`.
2. `IFS=':'` splits the line at colons.
3. Each field is assigned to its corresponding variable.
4. The selected values are displayed.
5. The loop ends when the file reaches end-of-file.

---

## 7. Meaning of `IFS= read -r line`

This is one of the most important Bash file-reading patterns:

```bash
IFS= read -r line
```

### `IFS=`

An empty `IFS` means:

> Do not split or trim the input line using field separators.

It helps preserve leading and trailing whitespace.

### `read`

```bash
read
```

Reads one line of input.

### `-r`

```bash
read -r
```

Prevents backslash `\` from being interpreted as an escape character.

For example, it preserves:

```text
C:\Users\Khalid
```

### `line`

The complete input line is stored in the variable named `line`.

---

## 8. Reading a file safely, line by line

**Suggested script name:** `read_file_safely.sh`

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

Benefits:

- Preserves each complete line
- Preserves leading spaces
- Preserves backslashes
- Handles text containing spaces safely
- Avoids unnecessary `cat` and command substitution

### Process a final line without a newline

Some files end with a final line that has no newline character. Use this advanced pattern when that line must also be processed:

```bash
while IFS= read -r line || [[ -n "$line" ]]
do
    echo "$line"
done < "$input_file"
```

The second condition processes a non-empty final line even when `read` reaches end-of-file before encountering a newline.

---

## 9. `IFS=` versus `IFS=' '`

These assignments are not equivalent.

### Empty `IFS`

```bash
IFS=
```

Meaning:

> Do not use a character for field splitting.

### Space as `IFS`

```bash
IFS=' '
```

Meaning:

> Split input at spaces.

| Setting | Result |
|---|---|
| `IFS=` | Disables field splitting for the operation |
| `IFS=' '` | Splits at spaces |
| `IFS=','` | Splits at commas |
| `IFS=':'` | Splits at colons |

---

## 10. Converting text into an array

`read -a` stores the resulting fields in an indexed array.

**Suggested script name:** `split_fruits_array.sh`

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

### Important syntax

| Syntax | Meaning |
|---|---|
| `read -a fruit_array` | Stores fields in an array |
| `${#fruit_array[@]}` | Returns the number of elements |
| `"${fruit_array[@]}"` | Preserves each element separately |

`red cherry` remains one array element because the delimiter is a comma, not a space.

---

## 11. Splitting user input

**Suggested script name:** `parse_fruit_input.sh`

```bash
#!/bin/bash

# Title: Fruit Input Parser
# Purpose: Read three comma-separated fruits from the user.

if ! read -r -p "Enter three fruits separated by commas: " input; then
    echo >&2
    echo "Error: input could not be read." >&2
    exit 1
fi

if [[ -z "$input" ]]; then
    echo "Error: input cannot be empty." >&2
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

## 12. Behavior of the final `read` variable

If the input contains more fields than the number of supplied variable names, the final variable receives the remaining data.

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

It is therefore important to understand the expected data format and field count.

### Ignoring fields

An underscore variable is commonly used when a field is not needed:

```bash
IFS=':' read -r username _ uid gid _ home shell <<< "$line"
```

The reused `_` variable is overwritten, which is acceptable when those values are intentionally ignored.

---

## 13. Temporary, global, and local `IFS`

### Temporary `IFS` — recommended

```bash
IFS=',' read -r first second third <<< "$data"
```

The custom separator is limited to the `read` command.

### Global `IFS` — use carefully

```bash
IFS=','
```

This changes `IFS` for later operations in the current shell or script.

If a broader change is necessary, save and restore the original value:

```bash
old_ifs=$IFS
IFS=','

read -r first second third <<< "$data"

IFS=$old_ifs
```

A command-specific assignment is usually simpler and safer.

### Function-local `IFS`

**Suggested script name:** `parse_record_function.sh`

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

`local IFS=':'` limits the change to the function. The original value remains available outside the function.

---

## 14. `IFS`, `"$*"`, and `"$@"`

Quoted `"$*"` joins all positional arguments into one string. It uses the first character of `IFS` between arguments.

**Suggested script name:** `join_arguments.sh`

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
| `"$*"` | Joins all arguments using the first `IFS` character |
| `"$@"` | Preserves every argument as a separate item |

For processing script arguments, `"$@"` is usually the recommended expansion.

---

## 15. Simple CSV versus complex CSV

`IFS=','` is useful for simple comma-separated records:

```text
Ali,25,DevOps
```

However, real CSV can contain quoted commas:

```text
Ali,25,"Chicago, Illinois"
```

A simple `IFS=','` operation treats the comma inside the quoted field as another separator and may split the record incorrectly.

Complex CSV may include:

- Quoted commas
- Escaped quotes
- Empty fields
- Multiline fields
- Newlines inside quoted values

Use a proper CSV parser, such as Python's `csv` module, for those cases. `IFS` is appropriate for simple delimiter-separated data, not the complete CSV standard.

---

## 16. Common mistakes

### Mistake 1: Changing `IFS` for the entire script

Risky:

```bash
IFS=','
```

Better:

```bash
IFS=',' read -r first second third <<< "$data"
```

### Mistake 2: Omitting `read -r`

Less safe:

```bash
IFS=',' read first second third
```

Recommended:

```bash
IFS=',' read -r first second third
```

### Mistake 3: Reading a file through command substitution

Avoid:

```bash
for line in $(cat file.txt)
do
    echo "$line"
done
```

Problems:

- Unwanted splitting occurs at whitespace.
- Blank lines may be lost.
- Wildcard characters can expand.
- Complete lines are not preserved.

Recommended:

```bash
while IFS= read -r line
do
    echo "$line"
done < file.txt
```

### Mistake 4: Leaving variables unquoted

Avoid:

```bash
echo $line
```

Recommended:

```bash
echo "$line"
```

### Mistake 5: Parsing complex CSV with simple `IFS`

`IFS` does not understand quoted CSV rules. Use a proper parser for complex CSV.

### Mistake 6: Treating `"$*"` and `"$@"` as identical

`"$*"` joins arguments. `"$@"` preserves them separately.

### Mistake 7: Treating empty `IFS` as a space

```bash
IFS=
```

means no separator.

```bash
IFS=' '
```

means a space separator.

---

## 17. Best practices

- Use `while IFS= read -r line` when reading files line by line.
- Limit a custom `IFS` to the command that needs it.
- Normally use `-r` with `read`.
- Double-quote variable and array expansions.
- Use `IFS` for simple delimiter-separated records.
- Use a real CSV parser for complex CSV.
- Use `local IFS=':'` when a function needs a custom separator.
- Prefer `"$@"` when processing script arguments.
- Validate the expected input format and field count.
- Test empty fields and extra fields.
- Understand the side effects before changing `IFS` globally.

---

## 18. Quick-reference table

| Requirement | Recommended syntax | Meaning |
|---|---|---|
| Split at commas | `IFS=',' read -r a b c <<< "$data"` | Assigns comma-separated fields to variables |
| Split at colons | `IFS=':' read -r a b c <<< "$data"` | Parses colon-separated fields |
| Split at pipes | `IFS='|' read -r a b c <<< "$data"` | Parses pipe-separated fields |
| Preserve the complete line | `IFS= read -r line` | Avoids field splitting and backslash processing |
| Store fields in an array | `IFS=',' read -r -a array <<< "$data"` | Places split fields in an indexed array |
| Read a file line by line | `while IFS= read -r line; do ...; done < file` | Processes a file safely |
| Use a function-local separator | `local IFS=':'` | Limits the change to the function |
| Save the current value | `old_ifs=$IFS` | Stores the current `IFS` |
| Restore the previous value | `IFS=$old_ifs` | Restores the saved `IFS` |
| Join arguments | `"$*"` | Joins arguments with the first `IFS` character |
| Preserve arguments separately | `"$@"` | Keeps every argument separate |
| Inspect default `IFS` | `printf '%q\n' "$IFS"` | Displays invisible separators readably |

---

## 19. Practice tasks

### Task 1 — Student record

Split this record at commas:

```text
Sara,22,Linux
```

Display the `name`, `age`, and `course` fields.

### Task 2 — Server record

Split this record at the pipe character:

```text
web01|running|72
```

Display the server name, status, and disk usage.

### Task 3 — Safe line reader

Create a file containing spaces and backslashes. Read each line safely with `while IFS= read -r line`.

### Task 4 — Fruit array

Ask the user for comma-separated fruits and create an array with `read -a`. Display each item with a number.

### Task 5 — `/etc/passwd`

Display only the username, UID, home directory, and shell from `/etc/passwd`.

### Task 6 — Arguments

Create a script that first joins arguments with `"$*"` and then displays every argument separately with `"$@"`.

---

## 20. Final summary

`IFS` tells Bash where input should be split into fields.

```bash
IFS=',' read -r name age role <<< "$data"
```

This means:

> Split `data` at commas and assign the fields to `name`, `age`, and `role`.

The most important safe file-reading pattern is:

```bash
while IFS= read -r line
do
    echo "$line"
done < "$input_file"
```

Remember:

- The default `IFS` uses space, tab, and newline.
- A custom `IFS` can use a comma, colon, pipe, or another delimiter.
- `IFS=` disables field splitting for the operation.
- `read -r` preserves backslashes.
- Temporary or local `IFS` changes are safer than global changes.
- `"$*"` joins arguments using the first `IFS` character.
- `"$@"` preserves each argument separately.
- Do not rely only on `IFS` for complex CSV data.

