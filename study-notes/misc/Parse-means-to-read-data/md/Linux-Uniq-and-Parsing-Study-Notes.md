# Linux `uniq` Command and Parsing — Study Notes

## Learning objectives

After studying these notes, you should be able to:

- Explain what `uniq` does and why input order matters.
- Remove, count, and report adjacent duplicate records.
- Distinguish `uniq -u`, `uniq -d`, `uniq -D`, and `sort -u`.
- Compare records while ignoring case, fields, or characters.
- Preserve first-occurrence order when required.
- Use `uniq` in Linux Administrator and log-analysis pipelines.

---

## 1. What is `uniq`?

`uniq` is a Linux text-processing command used to detect, remove, or count **adjacent duplicate lines**.

In simple words:

> `uniq` compares neighboring records and processes repeated groups.

The command is named `uniq` because it works with unique and duplicate records. It is not an acronym.

---

## 2. The most important rule

`uniq` recognizes duplicate records only when they are next to one another.

Suppose `colors.txt` contains:

```text
red
blue
red
green
blue
```

This may leave duplicates:

```bash
uniq colors.txt
```

Correct approach:

```bash
sort colors.txt | uniq
```

Output:

```text
blue
green
red
```

Processing:

1. `sort` places equal records together.
2. `uniq` processes the adjacent duplicate groups.

---

## 3. Basic syntax

```bash
uniq [OPTIONS] [INPUT_FILE] [OUTPUT_FILE]
```

Example:

```bash
uniq colors.txt
```

A more common pipeline is:

```bash
sort colors.txt | uniq
```

---

## 4. Create a practice file

```bash
cat > colors.txt <<'EOF'
red
blue
red
green
blue
red
yellow
EOF
```

---

## 5. Remove duplicate records

```bash
sort colors.txt | uniq
```

Output:

```text
blue
green
red
yellow
```

The shorter equivalent is:

```bash
sort -u colors.txt
```

---

## 6. Count records with `-c`

```bash
sort colors.txt | uniq -c
```

Output:

```text
      2 blue
      1 green
      3 red
      1 yellow
```

The number at the beginning is the occurrence count.

### Highest counts first

```bash
sort colors.txt |
uniq -c |
sort -nr
```

Possible output:

```text
      3 red
      2 blue
      1 yellow
      1 green
```

Processing flow:

```text
Input → sort groups records → uniq -c counts groups → sort -nr ranks counts
```

---

## 7. Display duplicate records with `-d`

```bash
sort colors.txt | uniq -d
```

Output:

```text
blue
red
```

`-d` displays one copy of each record occurring more than once.

---

## 8. Display records occurring exactly once with `-u`

```bash
sort colors.txt | uniq -u
```

Output:

```text
green
yellow
```

Important distinction:

```text
sort -u = one copy of every distinct comparison key
uniq -u = only records occurring exactly once
```

---

## 9. Display all repeated records with `-D`

```bash
sort colors.txt | uniq -D
```

Possible output:

```text
blue
blue
red
red
red
```

| Option | Result |
|---|---|
| `-d` | One copy from every duplicate group |
| `-D` | Every record belonging to duplicate groups |

`-D` is commonly available in GNU `uniq` on Linux.

---

## 10. Ignore letter case with `-i`

Suppose `names.txt` contains:

```text
Ali
ali
Khalid
khalid
Sara
```

Use compatible case-insensitive sorting and comparison:

```bash
sort -f names.txt | uniq -i
```

`-i` makes `uniq` treat uppercase and lowercase equivalents as equal.

If only `uniq -i` is used, equal values may not be adjacent. That is why `sort -f` is useful before it.

---

## 11. Skip fields with `-f`

Suppose `logs.txt` contains:

```text
10:00 INFO Server started
10:01 INFO Server started
10:02 ERROR Backup failed
10:03 ERROR Backup failed
```

Skip the first whitespace-separated field during comparison:

```bash
uniq -f 1 logs.txt
```

Possible output:

```text
10:00 INFO Server started
10:02 ERROR Backup failed
```

The complete selected line is still displayed; the first field is ignored only during comparison.

Input still needs equivalent records to be adjacent.

---

## 12. Skip or limit characters

### Skip characters with `-s`

For:

```text
001-error
002-error
003-warning
```

Ignore the first four characters:

```bash
uniq -s 4 file.txt
```

### Compare only a limited width with `-w`

```bash
uniq -w 3 file.txt
```

For:

```text
web01
web02
db01
```

Possible output:

```text
web01
db01
```

`web01` and `web02` compare as equal because their first three compared characters are both `web`.

---

## 13. Common options

| Option | Purpose |
|---|---|
| `-c` | Prefix records with occurrence counts |
| `-d` | Display one copy of each duplicate group |
| `-D` | Display every record in duplicate groups |
| `-u` | Display records occurring exactly once |
| `-i` | Ignore letter case |
| `-f N` | Skip the first `N` fields |
| `-s N` | Skip the first `N` characters |
| `-w N` | Compare only `N` characters |

---

## 14. `uniq` versus `sort -u`

### `sort -u`

```bash
sort -u colors.txt
```

This sorts and displays one record for each distinct comparison key.

### `sort | uniq`

```bash
sort colors.txt | uniq
```

This sorts the input and then removes adjacent duplicates.

Both normally produce similar distinct-record output. `uniq` also provides specialized analysis options:

```bash
uniq -c
uniq -d
uniq -D
uniq -u
```

---

## 15. Preserve original order

Sorting changes record order. To remove duplicates while preserving the first occurrence, AWK is often more suitable:

```bash
awk '!seen[$0]++' colors.txt
```

For:

```text
red
blue
red
green
blue
```

Output:

```text
red
blue
green
```

This keeps the first occurrence of each complete line.

---

## 16. Is `uniq` a parsing command?

`uniq` participates in parsing and analysis pipelines. Its main jobs are:

- Compare adjacent records.
- Detect repeated groups.
- Remove duplicates.
- Count occurrences.
- Display duplicate-only or single-occurrence records.

```text
Input → group identical records → uniq operation → result
```

---

## 17. Linux Administrator examples

### Count login shells

```bash
getent passwd |
cut -d: -f7 |
sort |
uniq -c |
sort -nr
```

### Count logged-in usernames

```bash
who |
awk '{print $1}' |
sort |
uniq -c |
sort -nr
```

### Count client-address fields in a web log

If field 1 contains the client address:

```bash
awk '{print $1}' access.log |
sort |
uniq -c |
sort -nr |
head
```

Always verify the log format before assuming a field’s meaning.

### Count HTTP status-code fields

For a format where field 9 contains the status code:

```bash
awk '{print $9}' access.log |
sort |
uniq -c |
sort -nr
```

### Find duplicate records

```bash
sort users.txt | uniq -d
```

### Find records appearing exactly once

```bash
sort users.txt | uniq -u
```

---

## 18. Work with colon-separated data

Suppose `servers.txt` contains:

```text
web01:running:25
web02:stopped:80
db01:running:65
app01:running:10
```

Extract and count statuses:

```bash
cut -d: -f2 servers.txt |
sort |
uniq -c |
sort -nr
```

Output:

```text
      3 running
      1 stopped
```

Processing:

```text
cut extracts status → sort groups statuses → uniq -c counts → sort -nr ranks
```

---

## 19. Save output

Using redirection:

```bash
sort colors.txt |
uniq > unique-colors.txt
```

`uniq` can also accept an output filename:

```bash
uniq sorted-colors.txt unique-colors.txt
```

For the direct form to be useful, the input must already contain adjacent duplicate groups.

---

## 20. Common mistakes

### Using `uniq` on unsorted data

```bash
uniq colors.txt
```

Nonadjacent duplicates remain. Correct:

```bash
sort colors.txt | uniq
```

### Confusing `uniq -u` and `sort -u`

```text
uniq -u = records occurring exactly once
sort -u = one copy of every distinct key
```

### Using only `uniq -i`

For reliable case-insensitive grouping:

```bash
sort -f names.txt | uniq -i
```

### Expecting input modification

```bash
uniq colors.txt
```

This displays output only. Save it with redirection.

### Forgetting that sorting changes order

To preserve first-occurrence order:

```bash
awk '!seen[$0]++' file.txt
```

---

## 21. Thinking process before using `uniq`

Ask:

1. What counts as one record?
2. Are duplicate records adjacent?
3. Do I need to sort first?
4. Do I want one copy of every value?
5. Do I want only duplicated values?
6. Do I want only values occurring once?
7. Do I need occurrence counts?
8. Should letter case be ignored?
9. Must original order be preserved?
10. Should output be displayed or saved?

Basic flow:

```text
Input → extract required value → sort/group → uniq operation → result
```

Example:

```bash
cut -d: -f2 servers.txt |
sort |
uniq -c |
sort -nr
```

---

## 22. Practice lab

Create a file:

```bash
cat > access-sample.txt <<'EOF'
10.0.0.1
10.0.0.2
10.0.0.1
10.0.0.3
10.0.0.1
10.0.0.2
10.0.0.4
EOF
```

Complete these tasks:

1. Display one copy of each address.
2. Count each address.
3. Display only repeated addresses.
4. Display only addresses appearing exactly once.
5. Display every line belonging to duplicate groups.
6. Display the most frequent address first.
7. Save distinct addresses in another file.
8. Remove duplicates while preserving first-occurrence order.

### Solutions

```bash
# 1. One copy of each address
sort access-sample.txt | uniq

# Shorter alternative
sort -u access-sample.txt

# 2. Count each address
sort access-sample.txt | uniq -c

# 3. Repeated addresses only
sort access-sample.txt | uniq -d

# 4. Addresses appearing exactly once
sort access-sample.txt | uniq -u

# 5. Every record in duplicate groups
sort access-sample.txt | uniq -D

# 6. Most frequent first
sort access-sample.txt |
uniq -c |
sort -nr

# 7. Save distinct addresses
sort -u access-sample.txt > unique-addresses.txt

# 8. Preserve first-occurrence order
awk '!seen[$0]++' access-sample.txt
```

---

## 23. Quick knowledge check

1. What does `uniq` do?
2. Does `uniq` stand for anything?
3. Why does `uniq` usually need sorted input?
4. What does `uniq -c` display?
5. What is the difference between `-d` and `-D`?
6. What does `uniq -u` display?
7. What is the difference between `uniq -u` and `sort -u`?
8. How does `-i` affect comparison?
9. What do `-f`, `-s`, and `-w` do?
10. How can duplicates be removed while preserving order?
11. Does `uniq` modify the original file?
12. How is `uniq` used in log analysis?

---

## 24. Quick reference

```bash
# Remove adjacent duplicates
uniq file

# Sort and remove duplicates
sort file | uniq

# Shorter distinct-record command
sort -u file

# Count occurrences
sort file | uniq -c

# Display duplicate values
sort file | uniq -d

# Display all records in duplicate groups
sort file | uniq -D

# Display values occurring exactly once
sort file | uniq -u

# Ignore letter case
sort -f file | uniq -i

# Skip the first two fields
uniq -f 2 file

# Skip the first four characters
uniq -s 4 file

# Compare only the first five characters
uniq -w 5 file

# Highest occurrence count first
sort file | uniq -c | sort -nr

# Preserve first-occurrence order
awk '!seen[$0]++' file
```

## Final summary

`uniq` detects, removes, or counts adjacent duplicate records.

The most important rule is:

> `uniq` recognizes duplicates only when equal records are next to one another.

Remember:

```text
uniq -c = count occurrences
uniq -d = duplicate values
uniq -u = values occurring exactly once
```
