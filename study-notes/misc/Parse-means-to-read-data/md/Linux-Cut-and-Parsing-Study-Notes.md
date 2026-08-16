# Linux `cut` Command and Parsing — Study Notes

## Learning objectives

After studying these notes, you should be able to:

- Explain parsing in simple words.
- Identify delimiters and fields in structured text.
- Use `cut` to extract fields, characters, and bytes.
- Parse files and piped command output.
- Decide when to use `cut` and when to use `awk`.

---

## 1. What is parsing?

**Parsing** means reading structured data and separating it into useful parts.

Consider this record:

```text
khalid:LinuxAdmin:Chicago
```

The colon (`:`) separates the record into three fields:

| Field number | Value |
|---:|---|
| 1 | `khalid` |
| 2 | `LinuxAdmin` |
| 3 | `Chicago` |

Here, `:` is the **delimiter**.

### Important terms

- **Input:** The original text being processed.
- **Delimiter:** The character separating one field from another.
- **Field:** One section of a structured record.
- **Parsing:** Separating or analyzing input to obtain useful information.

---

## 2. What is the `cut` command?

The Linux `cut` command extracts selected fields, characters, or bytes from each line of input.

### Basic syntax

```bash
cut OPTION FILE
```

It can also process output received through a pipe:

```bash
command | cut OPTION
```

### Common options

| Option | Purpose |
|---|---|
| `-d` | Specifies the field delimiter |
| `-f` | Selects one or more fields |
| `-c` | Selects characters by position |
| `-b` | Selects bytes by position |
| `--complement` | Selects everything except the specified fields or positions |
| `-s` | Suppresses lines that do not contain the delimiter |
| `--output-delimiter` | Changes the delimiter displayed in the output |

> `-d` and `-f` are normally used together.

---

## 3. Understanding `/etc/passwd`

The `/etc/passwd` file stores basic user-account information. Its fields are separated by colons.

Example record:

```text
ali:x:1001:1001:Ali Khan:/home/ali:/bin/bash
```

| Field | Meaning | Example |
|---:|---|---|
| 1 | Username | `ali` |
| 2 | Password placeholder | `x` |
| 3 | User ID (UID) | `1001` |
| 4 | Primary group ID (GID) | `1001` |
| 5 | User information/comment | `Ali Khan` |
| 6 | Home directory | `/home/ali` |
| 7 | Login shell | `/bin/bash` |

### Display usernames

```bash
cut -d: -f1 /etc/passwd
```

The same command can be written more explicitly:

```bash
cut -d ':' -f 1 /etc/passwd
```

Command breakdown:

| Part | Meaning |
|---|---|
| `cut` | Runs the command |
| `-d ':'` | Uses the colon as the delimiter |
| `-f 1` | Selects field 1 |
| `/etc/passwd` | Provides the input file |

In plain English:

> Read every line of `/etc/passwd`, split it at each colon, and display the first field.

Example output:

```text
root
daemon
ali
```

---

## 4. Selecting fields

### Select one field

Display login shells:

```bash
cut -d: -f7 /etc/passwd
```

### Select multiple fields

Display usernames and login shells:

```bash
cut -d: -f1,7 /etc/passwd
```

Example output:

```text
root:/bin/bash
daemon:/usr/sbin/nologin
ali:/bin/bash
```

### Select a field range

Display fields 1 through 3:

```bash
cut -d: -f1-3 /etc/passwd
```

### Select from a field to the end

Display field 3 and all fields after it:

```bash
cut -d: -f3- /etc/passwd
```

### Select everything up to a field

Display fields 1 through 4:

```bash
cut -d: -f-4 /etc/passwd
```

### Select everything except a field

Display every field except field 2:

```bash
cut -d: -f2 --complement /etc/passwd
```

---

## 5. Parsing text received through a pipe

The pipe operator (`|`) sends the output of one command to another command.

### Example 1: Extract a job title

```bash
echo "khalid:LinuxAdmin:Chicago" | cut -d: -f2
```

Output:

```text
LinuxAdmin
```

### Example 2: Extract server name and status

```bash
echo "server01,running,75" | cut -d, -f1,2
```

Output:

```text
server01,running
```

### Example 3: Extract the login name from `whoami`-style data

```bash
echo "khalid@server01" | cut -d@ -f1
```

Output:

```text
khalid
```

---

## 6. Extracting characters with `-c`

Use `-c` when you want characters based on their positions rather than fields.

### Select the first character

```bash
echo "LinuxAdmin" | cut -c1
```

Output:

```text
L
```

### Select characters 1 through 5

```bash
echo "LinuxAdmin" | cut -c1-5
```

Output:

```text
Linux
```

### Select character 6 through the end

```bash
echo "LinuxAdmin" | cut -c6-
```

Output:

```text
Admin
```

### Select separate character positions

```bash
echo "LinuxAdmin" | cut -c1,6
```

Output:

```text
LA
```

---

## 7. Extracting bytes with `-b`

Use `-b` to select bytes by position:

```bash
echo "Linux" | cut -b1-3
```

Output:

```text
Lin
```

For ordinary English text, character and byte positions often appear identical. They can differ when the text contains multibyte Unicode characters.

---

## 8. Changing the output delimiter

The selected fields normally retain their original delimiter:

```bash
cut -d: -f1,7 /etc/passwd
```

To display a different separator, use `--output-delimiter`:

```bash
cut -d: -f1,7 --output-delimiter=' -> ' /etc/passwd
```

Example output:

```text
root -> /bin/bash
ali -> /bin/bash
```

---

## 9. Practical server-data example

Create a practice file correctly with a here-document:

```bash
cat > servers.txt <<'EOF'
web01:running:25
web02:stopped:80
db01:running:65
EOF
```

> The `>` redirects the here-document content into `servers.txt`. The final `EOF` must appear alone on its line.

Display server names:

```bash
cut -d: -f1 servers.txt
```

Display server status:

```bash
cut -d: -f2 servers.txt
```

Display server names and usage values:

```bash
cut -d: -f1,3 servers.txt
```

Change the output separator:

```bash
cut -d: -f1,2 --output-delimiter=' | ' servers.txt
```

---

## 10. Important limitations of `cut`

### Limitation 1: Only one delimiter character

The field delimiter specified with `-d` must be a single character.

Valid:

```bash
cut -d: -f1 file.txt
```

Not suitable as a multi-character delimiter:

```text
::
```

### Limitation 2: Repeated spaces create empty fields

Consider:

```text
web01 running 25
web02    stopped 80
```

This command may produce inconsistent results:

```bash
cut -d' ' -f2 servers.txt
```

Each space is treated as a delimiter, so repeated spaces introduce empty fields.

For whitespace-separated data, `awk` is usually better:

```bash
awk '{print $2}' servers.txt
```

`awk` treats consecutive whitespace as one separator by default.

### Limitation 3: `cut` does not understand complex conditions

`cut` is excellent for simple extraction, but it does not perform advanced filtering, calculations, or field-based conditions.

---

## 11. `cut` versus `awk`

| Requirement | Recommended tool |
|---|---|
| Extract fields with a consistent single-character delimiter | `cut` |
| Extract fixed character positions | `cut` |
| Process inconsistent or repeated whitespace | `awk` |
| Apply conditions to fields | `awk` |
| Perform calculations | `awk` |
| Reformat complex records | `awk` |

Examples:

```bash
# Consistent colon delimiter: cut is simple and suitable
cut -d: -f1 /etc/passwd

# Variable whitespace: awk is more reliable
awk '{print $2}' servers.txt
```

---

## 12. Thinking process before using `cut`

Follow this sequence:

1. Examine the input data.
2. Identify the delimiter.
3. Count the fields from left to right.
4. Decide which field or fields you need.
5. Build and test the `cut` command.

Formula:

```text
Input → delimiter → field number → extracted result
```

Example:

```bash
cut -d: -f1 /etc/passwd
```

- Input: `/etc/passwd`
- Delimiter: `:`
- Required field: `1`
- Result: usernames

---

## 13. Practice lab

Create the lab file:

```bash
cat > employees.csv <<'EOF'
101,Khalid,Linux Administrator,Chicago
102,Ali,DevOps Engineer,Dallas
103,Sara,Cloud Engineer,Houston
EOF
```

Complete these tasks:

1. Display only employee IDs.
2. Display only employee names.
3. Display names and job titles.
4. Display fields 2 through 4.
5. Display all fields except the employee ID.
6. Display names and cities separated by ` -> `.

### Solutions

```bash
# 1. Employee IDs
cut -d, -f1 employees.csv

# 2. Employee names
cut -d, -f2 employees.csv

# 3. Names and job titles
cut -d, -f2,3 employees.csv

# 4. Fields 2 through 4
cut -d, -f2-4 employees.csv

# 5. Everything except employee ID
cut -d, -f1 --complement employees.csv

# 6. Names and cities with a new output separator
cut -d, -f2,4 --output-delimiter=' -> ' employees.csv
```

---

## 14. Quick knowledge check

1. What is parsing?
2. What is a delimiter?
3. Which option selects fields in `cut`?
4. Which option defines the delimiter?
5. What does `-f1,7` select?
6. What does `-f3-` select?
7. What does `-c1-5` select?
8. Why can `cut -d' '` be unreliable with repeated spaces?
9. When is `awk` more suitable than `cut`?
10. Explain `cut -d: -f1 /etc/passwd` in plain English.

---

## 15. Quick reference

```bash
# One field
cut -d: -f1 file

# Multiple fields
cut -d: -f1,3 file

# Field range
cut -d: -f1-3 file

# From a field to the end
cut -d: -f3- file

# From the beginning through a field
cut -d: -f-3 file

# Exclude a field
cut -d: -f2 --complement file

# Select characters
cut -c1-5 file

# Parse piped output
echo "one:two:three" | cut -d: -f2

# Change the output delimiter
cut -d: -f1,3 --output-delimiter=' | ' file
```

## Final summary

`cut` is a simple Linux text-processing command used to extract fields, characters, or bytes from every input line. It works best when the input has a consistent structure and a clear single-character delimiter. For data with inconsistent whitespace or requirements involving conditions and calculations, `awk` is usually the better tool.
