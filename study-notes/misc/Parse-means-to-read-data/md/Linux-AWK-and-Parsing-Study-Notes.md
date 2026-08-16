# Linux `awk` Command and Parsing — Study Notes

## Learning objectives

After studying these notes, you should be able to:

- Explain what AWK is and where its name came from.
- Understand records, fields, patterns, and actions.
- Extract and filter fields from structured text.
- Use AWK variables, conditions, regex, calculations, and formatting.
- Parse `/etc/passwd`, logs, whitespace data, and simple CSV files.
- Decide when to use `grep`, `cut`, or `awk`.

---

## 1. What is `awk`?

`awk` is a powerful Linux text-processing tool and programming language. It can:

- Read text line by line.
- Divide each line into fields.
- Search and filter records.
- Extract selected columns.
- Apply conditions.
- Perform calculations.
- Reformat data and generate reports.

In simple words:

> `awk` reads structured text, separates it into fields, processes those fields, and displays the required result.

---

## 2. What does `awk` stand for?

The name comes from the surnames of its three original developers:

- **A**lfred Aho
- Peter **W**einberger
- Brian **K**ernighan

```text
Aho + Weinberger + Kernighan = AWK
```

AWK is more than a search command—it is a small programming language designed for processing text.

---

## 3. Records and fields

Suppose `servers.txt` contains:

```text
web01 running 25
web02 stopped 80
db01 running 65
```

By default, AWK treats every line as a **record** and separates fields using whitespace.

For this record:

```text
web01 running 25
```

| AWK reference | Value |
|---|---|
| `$0` | Complete line: `web01 running 25` |
| `$1` | First field: `web01` |
| `$2` | Second field: `running` |
| `$3` | Third field: `25` |

Important:

- `$0` means the complete record.
- `$1`, `$2`, and so on mean individual field values.

---

## 4. Basic syntax

```bash
awk 'PATTERN { ACTION }' FILE
```

| Part | Purpose |
|---|---|
| `PATTERN` | Decides which records to process |
| `{ ACTION }` | Decides what to do with matching records |

Example:

```bash
awk '{print $1}' servers.txt
```

Output:

```text
web01
web02
db01
```

Command breakdown:

| Part | Meaning |
|---|---|
| `awk` | Runs AWK |
| `'...'` | Contains the AWK program |
| `{print $1}` | Displays field 1 |
| `servers.txt` | Input file |

---

## 5. Create the practice file

```bash
cat > servers.txt <<'EOF'
web01 running 25
web02 stopped 80
db01 running 65
EOF
```

> The redirection operator `>` saves the here-document content in `servers.txt`. The final `EOF` must appear alone on its line.

---

## 6. Printing fields

### Display the complete line

```bash
awk '{print $0}' servers.txt
```

This shorter form produces the same result:

```bash
awk '{print}' servers.txt
```

### Display the first field

```bash
awk '{print $1}' servers.txt
```

### Display the second field

```bash
awk '{print $2}' servers.txt
```

### Display multiple fields

```bash
awk '{print $1, $3}' servers.txt
```

Output:

```text
web01 25
web02 80
db01 65
```

A comma in `print` inserts the output field separator, which is a space by default.

### Add labels to the output

```bash
awk '{print "Server:", $1, "Status:", $2}' servers.txt
```

Output:

```text
Server: web01 Status: running
Server: web02 Status: stopped
Server: db01 Status: running
```

---

## 7. Field separators

### Default whitespace separator

By default, AWK treats consecutive spaces and tabs as one separator. Therefore, both records are parsed correctly:

```text
web01 running 25
web02       stopped       80
```

```bash
awk '{print $2}' servers.txt
```

This is an advantage over:

```bash
cut -d' ' -f2 servers.txt
```

Repeated spaces can create empty fields for `cut`, while AWK handles them naturally.

### Specify a delimiter with `-F`

For colon-separated data:

```text
web01:running:25
web02:stopped:80
db01:running:65
```

Use:

```bash
awk -F: '{print $1}' servers-colon.txt
```

You may also write:

```bash
awk -F ':' '{print $1}' servers-colon.txt
```

---

## 8. Parsing `/etc/passwd`

An example `/etc/passwd` record is:

```text
ali:x:1001:1001:Ali Khan:/home/ali:/bin/bash
```

| Field | Information |
|---:|---|
| `$1` | Username |
| `$2` | Password placeholder |
| `$3` | UID |
| `$4` | GID |
| `$5` | User information |
| `$6` | Home directory |
| `$7` | Login shell |

### Display usernames

```bash
awk -F: '{print $1}' /etc/passwd
```

### Display usernames and UIDs

```bash
awk -F: '{print $1, $3}' /etc/passwd
```

### Display formatted user information

```bash
awk -F: '{print "User:", $1, "UID:", $3, "Shell:", $7}' /etc/passwd
```

---

## 9. Filtering with conditions

Conditions are one reason AWK is more powerful than `cut`.

### Display running servers

```bash
awk '$2 == "running" {print $0}' servers.txt
```

The shorter form is:

```bash
awk '$2 == "running" {print}' servers.txt
```

### Display only their names

```bash
awk '$2 == "running" {print $1}' servers.txt
```

Output:

```text
web01
db01
```

### Display usage values greater than 50

```bash
awk '$3 > 50 {print $1, $3}' servers.txt
```

Output:

```text
web02 80
db01 65
```

### Comparison operators

| Operator | Meaning |
|---|---|
| `==` | Equal to |
| `!=` | Not equal to |
| `>` | Greater than |
| `<` | Less than |
| `>=` | Greater than or equal to |
| `<=` | Less than or equal to |
| `~` | Matches a regular expression |
| `!~` | Does not match a regular expression |

### Combine conditions with AND

Use `&&` when both conditions must be true:

```bash
awk '$2 == "running" && $3 > 50 {print $1}' servers.txt
```

Output:

```text
db01
```

### Combine conditions with OR

Use `||` when either condition may be true:

```bash
awk '$1 == "web01" || $1 == "db01" {print}' servers.txt
```

### Test for not equal

```bash
awk '$2 != "running" {print}' servers.txt
```

Output:

```text
web02 stopped 80
```

---

## 10. Regular expressions in AWK

### Match records containing `running`

```bash
awk '/running/ {print}' servers.txt
```

This is similar to:

```bash
grep "running" servers.txt
```

### Match a specific field

```bash
awk '$2 ~ /running/ {print $1}' servers.txt
```

Here:

- `$2` is the second field.
- `~` means “matches the regular expression.”
- `/running/` is the regex pattern.

### Display fields that do not match

```bash
awk '$2 !~ /running/ {print}' servers.txt
```

### Match the beginning of a field

```bash
awk '$1 ~ /^web/ {print}' servers.txt
```

This selects records whose first field begins with `web`.

---

## 11. Important built-in variables

| Variable | Meaning |
|---|---|
| `NR` | Current record or line number across the input |
| `FNR` | Current line number within the current file |
| `NF` | Number of fields in the current record |
| `FS` | Input field separator |
| `OFS` | Output field separator |
| `RS` | Input record separator |
| `ORS` | Output record separator |
| `FILENAME` | Name of the current input file |

### Display line numbers with `NR`

```bash
awk '{print NR, $0}' servers.txt
```

Output:

```text
1 web01 running 25
2 web02 stopped 80
3 db01 running 65
```

### Display only line 2

```bash
awk 'NR == 2 {print}' servers.txt
```

### Display lines 2 through 3

```bash
awk 'NR >= 2 && NR <= 3 {print}' servers.txt
```

### Display the number of fields

```bash
awk '{print "Fields:", NF, "Line:", $0}' servers.txt
```

### Display the last field

```bash
awk '{print $NF}' servers.txt
```

`NF` contains the number of the last field; `$NF` means the value of that field.

### Display the second-last field

```bash
awk '{print $(NF-1)}' servers.txt
```

---

## 12. `FS` and `OFS`

### Set the input field separator

```bash
awk 'BEGIN {FS=":"} {print $1, $7}' /etc/passwd
```

This is equivalent to:

```bash
awk -F: '{print $1, $7}' /etc/passwd
```

### Set the output field separator

```bash
awk -F: 'BEGIN {OFS=" -> "} {print $1, $7}' /etc/passwd
```

Example output:

```text
root -> /bin/bash
ali -> /bin/bash
```

---

## 13. `BEGIN` and `END`

### `BEGIN`

The `BEGIN` block runs once **before** AWK reads the input.

```bash
awk 'BEGIN {print "Server Report"} {print $1, $2}' servers.txt
```

Use `BEGIN` to:

- Print headings.
- Set separators.
- Initialize variables.

### `END`

The `END` block runs once **after** AWK finishes reading the input.

```bash
awk '{print $1} END {print "Processing complete"}' servers.txt
```

Use `END` to:

- Print totals.
- Print summaries.
- Print final messages.

---

## 14. Variables and calculations

### Count running servers

```bash
awk '$2 == "running" {count++}
     END {print "Running servers:", count}' servers.txt
```

Output:

```text
Running servers: 2
```

### Add values

```bash
awk '{sum += $3} END {print "Total:", sum}' servers.txt
```

Output:

```text
Total: 170
```

### Calculate an average

```bash
awk '{sum += $3}
     END {if (NR > 0) print "Average:", sum / NR}' servers.txt
```

The `NR > 0` check avoids division by zero when the input is empty.

### Find the highest value

```bash
awk 'NR == 1 || $3 > max {max=$3; server=$1}
     END {print "Highest:", server, max}' servers.txt
```

Output:

```text
Highest: web02 80
```

---

## 15. Formatted output with `printf`

`print` is simple, while `printf` offers precise formatting.

```bash
awk '{printf "%-10s %-10s %5s\n", $1, $2, $3}' servers.txt
```

Possible output:

```text
web01      running       25
web02      stopped       80
db01       running       65
```

Common format specifiers:

| Specifier | Meaning |
|---|---|
| `%s` | String |
| `%d` | Integer |
| `%f` | Decimal number |
| `%.2f` | Decimal number with two decimal places |
| `\n` | New line |

Example:

```bash
awk '{printf "Server: %-8s Usage: %d%%\n", $1, $3}' servers.txt
```

---

## 16. Processing simple CSV data

Create a CSV file:

```bash
cat > employees.csv <<'EOF'
101,Khalid,Linux Administrator,Chicago,75000
102,Ali,DevOps Engineer,Dallas,90000
103,Sara,Cloud Engineer,Houston,85000
EOF
```

### Display employee names

```bash
awk -F, '{print $2}' employees.csv
```

### Display names and job titles

```bash
awk -F, '{print $2, $3}' employees.csv
```

### Display salaries greater than 80,000

```bash
awk -F, '$5 > 80000 {print $2, $3, $5}' employees.csv
```

### Calculate the total salary

```bash
awk -F, '{sum += $5} END {print "Total salary:", sum}' employees.csv
```

> Simple `awk -F,` processing is appropriate for basic comma-separated data. It is not a complete CSV parser and may fail when quoted fields contain commas.

---

## 17. Shell variables and quoting

Suppose a shell variable contains the required status:

```bash
status="running"
```

Pass it safely to AWK using `-v`:

```bash
awk -v required_status="$status" \
    '$2 == required_status {print $1}' servers.txt
```

AWK programs are normally enclosed in single quotes:

```bash
awk '{print $1}' servers.txt
```

If double quotes are used carelessly, the shell may try to expand `$1` before AWK receives it.

Recommended pattern:

```bash
awk -v name="$username" '$1 == name {print}' users.txt
```

---

## 18. AWK in Linux-administrator pipelines

### Display filesystem names and usage

```bash
df -P | awk 'NR > 1 {print $1, $5}'
```

`NR > 1` skips the heading.

### Report filesystems above 80 percent

```bash
df -P | awk 'NR > 1 {
    usage=$5
    sub(/%/, "", usage)
    if (usage > 80)
        print $1, usage "%"
}'
```

### Display usernames and login shells

```bash
getent passwd | awk -F: '{print $1, $7}'
```

### Display listening TCP addresses

```bash
ss -lnt | awk 'NR > 1 {print $4}'
```

### Classify server usage with `if` and `else`

```bash
awk '{
    if ($3 >= 80)
        print $1, "High usage"
    else
        print $1, "Normal usage"
}' servers.txt
```

---

## 19. AWK program file

For a longer AWK program, save the program separately.

Create `report.awk`:

```awk
BEGIN {
    print "Server Status Report"
    print "--------------------"
}

{
    printf "%-10s %-10s %s%%\n", $1, $2, $3
    total += $3
}

END {
    print "--------------------"
    print "Total usage:", total
}
```

Run it:

```bash
awk -f report.awk servers.txt
```

The `-f` option tells AWK to read its program from a file.

---

## 20. Is AWK a parsing tool?

Yes. AWK is commonly used to parse structured text.

It uses this processing model:

```text
Input → records → fields → conditions → actions → output
```

For ordinary text input:

- Each line is a **record**.
- Each word or delimited section is a **field**.

Example:

```bash
awk -F: '$3 >= 1000 {print $1, $3}' /etc/passwd
```

This means:

1. Read `/etc/passwd`.
2. Use `:` as the field delimiter.
3. Check whether field 3 is at least `1000`.
4. Display fields 1 and 3 for matching records.

> A UID threshold alone is not a universal test for a human user; account policies vary between systems.

---

## 21. `grep` versus `cut` versus `awk`

| Command | Main purpose |
|---|---|
| `grep` | Searches and filters matching lines |
| `cut` | Extracts simple fields, characters, or bytes |
| `awk` | Parses fields, checks conditions, calculates, and formats output |

For this data:

```text
web01:running:25
web02:stopped:80
db01:running:65
```

### `grep`: select matching lines

```bash
grep "running" servers-colon.txt
```

### `cut`: extract one field

```bash
cut -d: -f1 servers-colon.txt
```

### `awk`: check one field and extract another

```bash
awk -F: '$2 == "running" {print $1}' servers-colon.txt
```

Output:

```text
web01
db01
```

---

## 22. When should you use AWK?

Use AWK when:

- You need to process fields or columns.
- The input contains inconsistent whitespace.
- You need numeric or string conditions.
- You need totals, counts, averages, or other calculations.
- You need formatted reports.
- You need to transform structured text.

Use `grep` when you only need to find matching lines.

Use `cut` when you only need to extract fields using a simple, consistent delimiter.

---

## 23. Thinking process before writing AWK

Follow this process:

1. Examine the input data.
2. Identify one record or line.
3. Identify the field separator.
4. Number the fields from left to right.
5. Decide whether a condition is required.
6. Decide what should be printed or calculated.
7. Test the command using sample data.

Basic formula:

```text
awk -F'DELIMITER' 'CONDITION {ACTION}' FILE
```

Example:

```bash
awk -F: '$2 == "running" {print $1}' servers-colon.txt
```

Breakdown:

- Delimiter: `:`
- Condition: Field 2 must equal `running`
- Action: Print field 1
- Input: `servers-colon.txt`

---

## 24. Practice lab

Create the practice file:

```bash
cat > employees.txt <<'EOF'
101 Khalid LinuxAdmin Chicago 75000
102 Ali DevOpsEngineer Dallas 90000
103 Sara CloudEngineer Houston 85000
104 Ahmed SupportEngineer Chicago 65000
EOF
```

Complete these tasks:

1. Display employee names.
2. Display names and job titles.
3. Display employees located in Chicago.
4. Display employees earning more than 80,000.
5. Display names and salaries with a heading.
6. Calculate the total salary.
7. Calculate the average salary.
8. Display the highest-paid employee.
9. Count employees located in Chicago.
10. Display each employee’s name and field count.

### Solutions

```bash
# 1. Employee names
awk '{print $2}' employees.txt

# 2. Names and job titles
awk '{print $2, $3}' employees.txt

# 3. Employees in Chicago
awk '$4 == "Chicago" {print}' employees.txt

# 4. Salaries greater than 80,000
awk '$5 > 80000 {print $2, $5}' employees.txt

# 5. Names and salaries with a heading
awk 'BEGIN {print "Name Salary"} {print $2, $5}' employees.txt

# 6. Total salary
awk '{sum += $5} END {print "Total:", sum}' employees.txt

# 7. Average salary
awk '{sum += $5}
     END {if (NR > 0) print "Average:", sum / NR}' employees.txt

# 8. Highest-paid employee
awk 'NR == 1 || $5 > max {max=$5; name=$2}
     END {print name, max}' employees.txt

# 9. Count Chicago employees
awk '$4 == "Chicago" {count++}
     END {print "Chicago employees:", count}' employees.txt

# 10. Name and field count
awk '{print $2, NF}' employees.txt
```

---

## 25. Quick knowledge check

1. What does the name AWK represent?
2. What does `$0` mean?
3. What does `$1` mean?
4. What is the difference between `NR` and `NF`?
5. What does `$NF` display?
6. What does the `-F` option do?
7. When do the `BEGIN` and `END` blocks run?
8. What is the difference between `FS` and `OFS`?
9. How do you count matching records?
10. How do you pass a shell variable safely into AWK?
11. Why are AWK programs normally enclosed in single quotes?
12. How is AWK different from `grep` and `cut`?

---

## 26. Quick reference

```bash
# Display the complete line
awk '{print $0}' file

# Display field 1
awk '{print $1}' file

# Display multiple fields
awk '{print $1, $3}' file

# Use a colon delimiter
awk -F: '{print $1}' file

# Apply a string condition
awk '$2 == "running" {print $1}' file

# Apply a numeric condition
awk '$3 > 50 {print $1, $3}' file

# Display line numbers
awk '{print NR, $0}' file

# Display the last field
awk '{print $NF}' file

# Display the second-last field
awk '{print $(NF-1)}' file

# Print a heading
awk 'BEGIN {print "Report"} {print}' file

# Print a record count
awk '{count++} END {print count}' file

# Add values
awk '{sum += $3} END {print sum}' file

# Set an output delimiter
awk -F: 'BEGIN {OFS=" -> "} {print $1, $2}' file

# Use a regular expression
awk '$2 ~ /running/ {print}' file

# Pass a shell variable
awk -v value="$variable" '$1 == value {print}' file

# Run an AWK program file
awk -f program.awk file
```

## Final summary

AWK is a powerful text-processing and parsing language. It reads input as records, divides records into fields, applies conditions, performs calculations, and formats the output.

Remember:

```text
grep = search or filter lines
cut  = extract simple fields or characters
awk  = parse, filter, calculate, and format
```
