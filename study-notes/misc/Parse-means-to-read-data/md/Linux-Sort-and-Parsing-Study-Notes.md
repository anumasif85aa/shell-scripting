# Linux `sort` Command and Parsing — Study Notes

## Learning objectives

After studying these notes, you should be able to:

- Explain the purpose of `sort`.
- Sort text alphabetically, numerically, and in reverse order.
- Sort records using one or more field keys.
- Use custom delimiters and specialized comparison modes.
- Remove or count duplicate records.
- Handle headings, locale, stable sorting, and output files safely.
- Use `sort` in Linux Administrator pipelines.

---

## 1. What is `sort`?

`sort` is a Linux text-processing command used to arrange lines in a requested order.

It can sort data:

- Alphabetically
- Numerically
- In reverse order
- By a specific field
- By month name
- By human-readable size
- By version number
- While removing duplicate records

In simple words:

> `sort` reads records, compares them, and displays them in the requested order.

`sort` is not an acronym. It is called `sort` because it sorts or arranges data.

---

## 2. Is `sort` a parsing command?

`sort` is mainly an ordering command, but it is commonly used in parsing and text-processing pipelines. It can:

- Recognize fields.
- Use a delimiter.
- Select a field as a sorting key.
- Compare numeric or textual values.
- Remove duplicate records.
- Prepare data for reporting.

It does not normally extract or modify fields.

```text
grep = search or filter lines
cut  = extract simple fields
awk  = parse, calculate, and format
sed  = edit and transform text
sort = arrange records in order
```

---

## 3. Basic syntax and behavior

```bash
sort [OPTIONS] [FILE]
```

If no file is supplied, `sort` reads standard input:

```bash
printf '%s\n' banana apple mango | sort
```

Output:

```text
apple
banana
mango
```

Processing model:

```text
Input records → comparison → ordered output
```

By default, the original file is not modified.

---

## 4. Create a practice file

```bash
cat > servers.txt <<'EOF'
web01 running 25
web02 stopped 80
db01 running 65
app01 running 10
EOF
```

> The redirection operator `>` saves the here-document content in `servers.txt`. The final `EOF` must appear alone on its line.

---

## 5. Default and reverse sorting

### Default sorting

```bash
sort servers.txt
```

Output:

```text
app01 running 10
db01 running 65
web01 running 25
web02 stopped 80
```

The complete lines are compared from their beginning.

### Reverse sorting with `-r`

```bash
sort -r servers.txt
```

Output:

```text
web02 stopped 80
web01 running 25
db01 running 65
app01 running 10
```

---

## 6. Numeric sorting with `-n`

Suppose `numbers.txt` contains:

```text
5
100
25
8
```

Normal text sorting:

```bash
sort numbers.txt
```

Possible output:

```text
100
25
5
8
```

The values are being compared as text. Use numeric sorting:

```bash
sort -n numbers.txt
```

Output:

```text
5
8
25
100
```

### Reverse numeric sorting

```bash
sort -nr numbers.txt
```

Output:

```text
100
25
8
5
```

Options may be combined:

```text
-n  = numeric
-r  = reverse
-nr = reverse numeric
```

---

## 7. Sorting by a field with `-k`

For `servers.txt`, the fields are:

| Field | Information |
|---:|---|
| 1 | Server name |
| 2 | Status |
| 3 | Usage value |

### Sort by field 2

```bash
sort -k2,2 servers.txt
```

The key specification `-k2,2` means:

- Start at field 2.
- End at field 2.
- Compare only field 2.

`-k2` alone starts at field 2 and continues through the end of the record. For one exact field, prefer `-k2,2`.

### Sort field 3 numerically

```bash
sort -k3,3n servers.txt
```

Output:

```text
app01 running 10
web01 running 25
db01 running 65
web02 stopped 80
```

You may also write:

```bash
sort -n -k3,3 servers.txt
```

### Reverse numeric sort by field 3

```bash
sort -k3,3nr servers.txt
```

Output:

```text
web02 stopped 80
db01 running 65
web01 running 25
app01 running 10
```

---

## 8. Multiple sorting keys

Sort first by status and then numerically by usage:

```bash
sort -k2,2 -k3,3n servers.txt
```

The first key is the primary key. The next key resolves records whose primary keys compare equally.

Example result:

```text
app01 running 10
web01 running 25
db01 running 65
db02 stopped 30
web02 stopped 80
```

---

## 9. Use a delimiter with `-t`

Suppose `servers-colon.txt` contains:

```text
web01:running:25
web02:stopped:80
db01:running:65
app01:running:10
```

Sort numerically by field 3:

```bash
sort -t: -k3,3n servers-colon.txt
```

Output:

```text
app01:running:10
web01:running:25
db01:running:65
web02:stopped:80
```

Breakdown:

| Part | Meaning |
|---|---|
| `-t:` | Use `:` as the field separator |
| `-k3,3` | Use only field 3 as the key |
| `n` | Compare the key numerically |

You can also write:

```bash
sort -t ':' -k3,3n servers-colon.txt
```

The separator supplied to `-t` is normally one character.

---

## 10. Parsing `/etc/passwd`

`/etc/passwd` uses colons as delimiters:

```text
ali:x:1001:1001:Ali Khan:/home/ali:/bin/bash
```

| Field | Information |
|---:|---|
| 1 | Username |
| 3 | UID |
| 4 | GID |
| 6 | Home directory |
| 7 | Login shell |

### Sort by username

```bash
sort -t: -k1,1 /etc/passwd
```

### Sort numerically by UID

```bash
sort -t: -k3,3n /etc/passwd
```

### Display usernames and UIDs after sorting

```bash
sort -t: -k3,3n /etc/passwd |
awk -F: '{print $1, $3}'
```

Processing flow:

```text
/etc/passwd → sort by numeric UID → awk displays username and UID
```

---

## 11. Remove duplicate records with `-u`

Suppose `colors.txt` contains:

```text
red
blue
red
green
blue
```

```bash
sort -u colors.txt
```

Output:

```text
blue
green
red
```

`sort -u` sorts and outputs one record for each equal comparison key.

This also works:

```bash
sort colors.txt | uniq
```

### `sort -u` versus `uniq`

`uniq` removes only adjacent duplicate records. Therefore, unsorted duplicates may remain:

```bash
uniq colors.txt
```

Use:

```bash
sort colors.txt | uniq
```

or:

```bash
sort -u colors.txt
```

### Count repeated values

```bash
sort colors.txt | uniq -c
```

Sort the highest counts first:

```bash
sort colors.txt |
uniq -c |
sort -nr
```

---

## 12. Case, blanks, and specialized comparisons

### Ignore letter case with `-f`

```bash
sort -f names.txt
```

The `-f` option folds lowercase letters into uppercase equivalents during comparison.

### Ignore leading blanks with `-b`

```bash
sort -b fruits.txt
```

This ignores leading spaces and tabs when comparing records.

### Human-readable sizes with `-h`

For:

```text
900K
2G
50M
1G
```

Run:

```bash
sort -h sizes.txt
```

Output:

```text
900K
50M
1G
2G
```

Largest first:

```bash
sort -hr sizes.txt
```

Example:

```bash
du -h /var/log/* 2>/dev/null | sort -hr
```

### Month names with `-M`

```bash
sort -M months.txt
```

For `Mar`, `Jan`, `Dec`, and `Feb`, the result is:

```text
Jan
Feb
Mar
Dec
```

### Version numbers with `-V`

```bash
sort -V versions.txt
```

For:

```text
app-1.2
app-1.10
app-1.3
app-2.0
```

the result is:

```text
app-1.2
app-1.3
app-1.10
app-2.0
```

### General numeric comparison with `-g`

```bash
printf '%s\n' 1e3 25 4.5 2e2 | sort -g
```

Output:

```text
4.5
25
2e2
1e3
```

For ordinary integers and decimal values, `-n` is usually sufficient.

---

## 13. Check whether input is sorted

Use `-c`:

```bash
sort -c names.txt
```

If the file is correctly sorted, the command normally displays nothing and returns exit status `0`.

Check the status:

```bash
sort -c names.txt
echo $?
```

Use `-C` for a quiet check that does not report the first disorder:

```bash
sort -C names.txt
```

---

## 14. Save sorted output safely

### Redirect to another file

```bash
sort names.txt > sorted-names.txt
```

### Use `-o`

```bash
sort names.txt -o sorted-names.txt
```

### Safely replace the input file

Do not use:

```bash
sort names.txt > names.txt
```

The shell may empty `names.txt` before `sort` reads it.

Use:

```bash
sort names.txt -o names.txt
```

For an important file, create a backup first:

```bash
cp names.txt names.txt.bak
sort names.txt -o names.txt
```

---

## 15. Stable sorting with `-s`

When selected keys compare equally, `sort` may otherwise use the rest of each line as a final comparison.

```bash
sort -s -k2,2 records.txt
```

The `-s` option disables that last-resort comparison and preserves the original order of records whose selected keys compare equally.

---

## 16. Sort data while preserving a heading

Suppose `employees.txt` contains:

```text
Name Department Salary
Khalid IT 75000
Ali DevOps 90000
Sara Cloud 85000
```

Keep the heading and sort only the data:

```bash
{
    head -n 1 employees.txt
    tail -n +2 employees.txt | sort -k3,3n
}
```

Output:

```text
Name Department Salary
Khalid IT 75000
Sara Cloud 85000
Ali DevOps 90000
```

---

## 17. Locale and sorting order

Sorting behavior can depend on the current locale. Uppercase, lowercase, punctuation, and language-specific characters may be compared differently.

Check the locale:

```bash
locale
```

For predictable byte-based ordering:

```bash
LC_ALL=C sort names.txt
```

This can be useful for scripts, tests, comparisons, and reproducible reports.

---

## 18. Understanding key syntax

General form:

```text
-k START_FIELD,END_FIELD
```

Examples:

```bash
# Field 2 only
sort -k2,2 file

# Field 2 through field 3
sort -k2,3 file

# Field 3 only, numeric comparison
sort -k3,3n file

# Field 2 primary; field 3 numeric reverse secondary
sort -k2,2 -k3,3nr file
```

For one exact field, use both the start and end field numbers.

---

## 19. Linux Administrator examples

### Largest directories first

```bash
du -h /var/* 2>/dev/null |
sort -hr |
head
```

### Highest CPU processes first

```bash
ps -eo user,pid,comm,%cpu --no-headers |
sort -k4,4nr |
head
```

### Highest memory processes first

```bash
ps -eo user,pid,comm,%mem --no-headers |
sort -k4,4nr |
head
```

### Count common login shells

```bash
getent passwd |
cut -d: -f7 |
sort |
uniq -c |
sort -nr
```

### Count client fields from a log

If the first whitespace-separated field contains the client address:

```bash
awk '{print $1}' access.log |
sort |
uniq -c |
sort -nr |
head
```

Verify the log format before assuming field 1 contains an IP address.

### Largest log files first

```bash
find /var/log -type f -printf '%s %p\n' 2>/dev/null |
sort -k1,1nr |
head
```

---

## 20. Parsing pipelines

### Running servers ordered by usage

```bash
awk '$2 == "running" {print}' servers.txt |
sort -k3,3n
```

### Display only server names after sorting

```bash
sort -k3,3n servers.txt |
awk '{print $1}'
```

### Transform whitespace, then sort a colon-delimited field

```bash
sed -E 's/[[:space:]]+/:/g' servers.txt |
sort -t: -k3,3n
```

Processing flow:

```text
Input → sed transforms delimiters → sort orders numeric field 3 → output
```

---

## 21. Important options

| Option | Purpose |
|---|---|
| `-r` | Reverse the result |
| `-n` | Numeric comparison |
| `-h` | Human-readable number comparison |
| `-g` | General numeric comparison |
| `-M` | Month comparison |
| `-V` | Version comparison |
| `-f` | Ignore letter case during comparison |
| `-b` | Ignore leading blanks |
| `-u` | Output one record for each equal key |
| `-t` | Set the field separator |
| `-k` | Define sorting keys |
| `-c` | Check order and report disorder |
| `-C` | Quietly check order |
| `-o` | Write the result to a file |
| `-s` | Stable sorting |

---

## 22. Common mistakes

### Mistake 1: Sorting numbers as text

```bash
sort numbers.txt
```

Correct:

```bash
sort -n numbers.txt
```

### Mistake 2: Using an incomplete key

This continues from field 3 through the end:

```bash
sort -k3 file.txt
```

To use only field 3:

```bash
sort -k3,3 file.txt
```

### Mistake 3: Forgetting numeric comparison

```bash
sort -k3,3 servers.txt
```

Correct:

```bash
sort -k3,3n servers.txt
```

### Mistake 4: Overwriting input with redirection

Risky:

```bash
sort file.txt > file.txt
```

Correct:

```bash
sort file.txt -o file.txt
```

### Mistake 5: Expecting the input file to change

```bash
sort names.txt
```

This displays ordered output only. Save it with redirection to another file or with `-o`.

### Mistake 6: Ignoring locale differences

For predictable ordering:

```bash
LC_ALL=C sort file.txt
```

---

## 23. Thinking process before using `sort`

Ask:

1. What does one record look like?
2. Should I sort the complete record or one field?
3. What is the delimiter?
4. Is the key textual, numeric, human-readable, a month, or a version?
5. Should the order be ascending or descending?
6. Are duplicates allowed?
7. Does the input contain a heading?
8. Is locale-independent behavior required?
9. Should the result be displayed or saved?

Basic flow:

```text
Input → delimiter → sorting key → comparison type → order → output
```

Example:

```bash
sort -t: -k3,3nr servers-colon.txt
```

Breakdown:

- Input: `servers-colon.txt`
- Delimiter: `:`
- Key: field 3 only
- Comparison: numeric
- Order: reverse, meaning highest first

---

## 24. Practice lab

Create the file:

```bash
cat > employees.txt <<'EOF'
104:Ahmed:Support:Chicago:65000
102:Ali:DevOps:Dallas:90000
101:Khalid:Linux:Chicago:75000
103:Sara:Cloud:Houston:85000
105:Zain:Support:Chicago:65000
EOF
```

Complete these tasks:

1. Sort complete records alphabetically.
2. Sort employees by name.
3. Sort salaries from lowest to highest.
4. Sort salaries from highest to lowest.
5. Sort by city and then by name.
6. Sort by department and then by salary in descending order.
7. Display unique department names.
8. Count employees in each city.
9. Save salary-sorted output in another file.
10. Check whether the original file is sorted by employee ID.
11. Display the three highest-paid employees.
12. Sort by salary while preserving the original order of equal salaries.

### Solutions

```bash
# 1. Sort complete records
sort employees.txt

# 2. Sort by name
sort -t: -k2,2 employees.txt

# 3. Salary: lowest to highest
sort -t: -k5,5n employees.txt

# 4. Salary: highest to lowest
sort -t: -k5,5nr employees.txt

# 5. City, then name
sort -t: -k4,4 -k2,2 employees.txt

# 6. Department, then salary descending
sort -t: -k3,3 -k5,5nr employees.txt

# 7. Unique departments
cut -d: -f3 employees.txt | sort -u

# 8. Employee count by city
cut -d: -f4 employees.txt |
sort |
uniq -c |
sort -nr

# 9. Save salary-sorted output
sort -t: -k5,5n employees.txt > employees-by-salary.txt

# 10. Check numeric ID order
sort -t: -k1,1n -c employees.txt

# 11. Three highest-paid employees
sort -t: -k5,5nr employees.txt | head -n 3

# 12. Stable salary sort
sort -s -t: -k5,5n employees.txt
```

---

## 25. Quick knowledge check

1. Does `sort` stand for anything?
2. What does `sort` do by default?
3. Why can normal sorting give unexpected results for numbers?
4. What do `-n` and `-r` mean?
5. What is the difference between `-k3` and `-k3,3`?
6. What does `-t:` do?
7. What does `sort -u` do?
8. Why does `uniq` often need ordered input?
9. When should `-h`, `-M`, and `-V` be used?
10. What does `sort -c` check?
11. Why should you not use `sort file > file`?
12. What is stable sorting?
13. Why might `LC_ALL=C` be useful?
14. How is `sort` different from `grep`, `cut`, `awk`, and `sed`?

---

## 26. Quick reference

```bash
# Alphabetical sorting
sort file

# Reverse sorting
sort -r file

# Numeric sorting
sort -n file

# Reverse numeric sorting
sort -nr file

# Sort by exact field 2
sort -k2,2 file

# Sort field 3 numerically
sort -k3,3n file

# Sort a colon-separated numeric field
sort -t: -k3,3n file

# Multiple keys
sort -k2,2 -k3,3n file

# Remove duplicate records
sort -u file

# Ignore letter case
sort -f file

# Human-readable sizes
sort -h file

# Month names
sort -M file

# Version numbers
sort -V file

# Check whether input is sorted
sort -c file

# Save output safely
sort file -o sorted-file

# Stable sorting
sort -s -k2,2 file

# Predictable byte-based ordering
LC_ALL=C sort file
```

## Final summary

`sort` arranges text records in a requested order. It can sort complete records or selected fields using alphabetical, numeric, reverse, human-readable, month, or version comparisons.

Remember:

```text
grep = search or filter lines
cut  = extract simple fields
awk  = parse, calculate, and format
sed  = edit and transform text
sort = arrange records in order
```
