# Linux `sed` Command and Parsing — Study Notes

## Learning objectives

After studying these notes, you should be able to:

- Explain what `sed` is and how stream editing works.
- Search, replace, print, delete, insert, append, and change text.
- Use line addresses, ranges, patterns, flags, and regular expressions.
- Preview edits and modify files safely with backups.
- Use `sed` in Linux-administrator pipelines.
- Decide when to use `grep`, `cut`, `awk`, or `sed`.

---

## 1. What is `sed`?

`sed` stands for:

```text
Stream Editor
```

It is a Linux text-processing command used to:

- Search for text.
- Replace text.
- Delete lines.
- Print selected lines.
- Insert or append text.
- Transform command output.
- Automate repeated file edits.

In simple words:

> `sed` reads text as a stream, applies editing instructions, and displays the transformed result.

A stream can come from a file, pipe, command output, or standard input.

---

## 2. Why is it called a stream editor?

An interactive editor such as `vim` or `nano` opens a file so you can edit it manually. `sed` processes text automatically:

```text
Input stream → sed instruction → transformed output
```

Example:

```bash
echo "I like Linux" | sed 's/Linux/Bash/'
```

Output:

```text
I like Bash
```

---

## 3. Is `sed` a parsing tool?

`sed` is mainly a stream editor and text-transformation tool. It can participate in parsing by:

- Finding patterns.
- Selecting records.
- Removing unwanted text.
- Extracting matching portions.
- Replacing delimiters.
- Cleaning input before another tool processes it.

However, it is not primarily a field-processing tool like AWK.

```text
grep = search or filter lines
cut  = extract simple fields
awk  = parse fields, calculate, and format
sed  = search, replace, and transform text
```

---

## 4. Basic syntax and behavior

```bash
sed [OPTIONS] 'COMMAND' FILE
```

Example:

```bash
sed 's/Linux/Bash/' notes.txt
```

| Part | Meaning |
|---|---|
| `sed` | Runs the stream editor |
| `'...'` | Contains the instruction |
| `s` | Substitute command |
| `Linux` | Search pattern |
| `Bash` | Replacement text |
| `notes.txt` | Input file |

By default, `sed`:

1. Reads one line.
2. Applies the instruction.
3. Prints the resulting line.
4. Repeats for every line.

Unless in-place editing is requested, the original file is not modified.

---

## 5. Create a practice file

```bash
cat > servers.txt <<'EOF'
web01 running 25
web02 stopped 80
db01 running 65
EOF
```

> The redirection operator `>` saves the here-document content in `servers.txt`. The final `EOF` must appear alone on its line.

---

## 6. The substitute command

The most common `sed` instruction is substitution:

```text
s/search/replacement/flags
```

| Part | Meaning |
|---|---|
| `s` | Substitute |
| `search` | Text or pattern to find |
| `replacement` | New text |
| `flags` | Optional controls |

### Replace the first match on each line

```bash
sed 's/running/active/' servers.txt
```

Output:

```text
web01 active 25
web02 stopped 80
db01 active 65
```

### First occurrence only

```bash
echo "Linux Linux Linux" | sed 's/Linux/Bash/'
```

Output:

```text
Bash Linux Linux
```

### Every occurrence with `g`

```bash
echo "Linux Linux Linux" | sed 's/Linux/Bash/g'
```

Output:

```text
Bash Bash Bash
```

> The `g` flag means every matching occurrence on each processed line, not “the whole file.”

### Common substitution flags

| Flag | Meaning |
|---|---|
| `g` | Replace every occurrence on each line |
| `I` | Ignore letter case in GNU `sed` |
| `p` | Print a line when substitution succeeds |
| Number | Replace only that numbered occurrence |

### Ignore letter case with GNU `sed`

```bash
echo "Linux LINUX linux" | sed 's/linux/Bash/gI'
```

### Replace only the second occurrence

```bash
echo "Linux Linux Linux" | sed 's/Linux/Bash/2'
```

Output:

```text
Linux Bash Linux
```

---

## 7. Choosing a delimiter

The slash is the traditional delimiter:

```bash
sed 's/old/new/' file
```

Another character may be clearer for paths:

```bash
echo "/home/ali/scripts" | sed 's|/home/ali|/opt/admin|'
```

Output:

```text
/opt/admin/scripts
```

Possible delimiters include `|`, `#`, `@`, and `:`.

---

## 8. Printing selected lines

By default, `sed` automatically prints each processed line. The `-n` option disables automatic printing, and `p` prints only selected lines.

### Print line 2

```bash
sed -n '2p' servers.txt
```

Output:

```text
web02 stopped 80
```

Without `-n`, this prints line 2 twice:

```bash
sed '2p' servers.txt
```

### Print lines 1 through 2

```bash
sed -n '1,2p' servers.txt
```

### Print the last line

```bash
sed -n '$p' servers.txt
```

### Print matching lines

```bash
sed -n '/running/p' servers.txt
```

Output:

```text
web01 running 25
db01 running 65
```

This is similar to:

```bash
grep "running" servers.txt
```

---

## 9. Deleting lines

The `d` command deletes selected records from the output.

### Delete line 2

```bash
sed '2d' servers.txt
```

### Delete lines 1 through 2

```bash
sed '1,2d' servers.txt
```

### Delete the last line

```bash
sed '$d' servers.txt
```

### Delete matching lines

```bash
sed '/stopped/d' servers.txt
```

### Delete blank or whitespace-only lines

```bash
sed '/^[[:space:]]*$/d' file.txt
```

### Delete comment lines

```bash
sed '/^[[:space:]]*#/d' configuration.conf
```

### Delete comments and blank lines

```bash
sed -E '/^[[:space:]]*(#|$)/d' configuration.conf
```

This is useful for displaying active configuration lines.

---

## 10. Addresses and ranges

An **address** tells `sed` which line or pattern should receive a command.

### Replace text only on line 2

```bash
sed '2s/stopped/maintenance/' servers.txt
```

### Replace only on lines 1 through 2

```bash
sed '1,2s/running/active/' servers.txt
```

### Replace only on lines matching `web`

```bash
sed '/web/s/running/active/' servers.txt
```

Processing:

1. Select records containing `web`.
2. Run the substitution only on those records.

### Print from one pattern through another

```bash
sed -n '/START/,/END/p' file.txt
```

This prints from a record matching `START` through a record matching `END`.

---

## 11. Insert, append, and change

### Insert text before a line with `i`

```bash
sed '1i Server Status Report' servers.txt
```

### Append text after a line with `a`

```bash
sed '$a End of Report' servers.txt
```

### Insert before a matching record

```bash
sed '/web02/i Attention: Check the next server' servers.txt
```

### Append after a matching record

```bash
sed '/web02/a Investigation required' servers.txt
```

### Change a complete line with `c`

```bash
sed '2c web02 maintenance 80' servers.txt
```

### Change every matching line

```bash
sed '/stopped/c Server unavailable' servers.txt
```

---

## 12. Multiple commands

### Multiple `-e` options

```bash
sed -e 's/running/active/g' \
    -e 's/stopped/inactive/g' servers.txt
```

### Semicolon-separated commands

```bash
sed 's/running/active/g; s/stopped/inactive/g' servers.txt
```

### Multiline command block

```bash
sed '
s/running/active/g
s/stopped/inactive/g
' servers.txt
```

---

## 13. Regular expressions

Use `-E` for extended regular expressions:

```bash
sed -E 's/error|failed/PROBLEM/g' application.log
```

### Common regex symbols

| Symbol | Meaning |
|---|---|
| `^` | Beginning of a line |
| `$` | End of a line |
| `.` | Any single character |
| `*` | Zero or more repetitions |
| `+` | One or more repetitions with `-E` |
| `?` | Zero or one occurrence with `-E` |
| `[abc]` | One character from the set |
| `[^abc]` | One character not in the set |
| `[0-9]` | One digit |
| `( )` | Grouping with `-E` |
| `|` | OR with `-E` |

### Add a prefix to each line

```bash
sed 's/^/SERVER: /' servers.txt
```

### Add a suffix to each line

```bash
sed 's/$/ checked/' servers.txt
```

### Remove leading whitespace

```bash
sed 's/^[[:space:]]*//' file.txt
```

### Remove trailing whitespace

```bash
sed 's/[[:space:]]*$//' file.txt
```

### Remove leading and trailing whitespace

```bash
sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' file.txt
```

---

## 14. Capturing groups and backreferences

Capturing groups allow `sed` to remember matched portions.

```bash
echo "Khalid Khan" | sed -E 's/([A-Za-z]+) ([A-Za-z]+)/\2, \1/'
```

Output:

```text
Khan, Khalid
```

Explanation:

- The first `([A-Za-z]+)` captures the first word.
- The second group captures the second word.
- `\1` refers to group 1.
- `\2` refers to group 2.

### Reuse the complete match with `&`

```bash
echo "Server web01 is running" | sed 's/web01/[&]/'
```

Output:

```text
Server [web01] is running
```

In replacement text, `&` represents the complete matched text.

---

## 15. Extracting part of a line

Although `sed` is not primarily a field extractor, substitution plus `-n` and `p` can extract matching text.

```bash
echo "User: khalid" | sed -n 's/^User: //p'
```

Output:

```text
khalid
```

Why it works:

1. `s/^User: //` removes the prefix.
2. `p` prints only when substitution succeeds.
3. `-n` disables automatic printing.

Extract an IP-like value:

```bash
echo "Server IP: 192.168.1.10" |
sed -nE 's/^Server IP: ([0-9.]+)$/\1/p'
```

Output:

```text
192.168.1.10
```

---

## 16. Transforming delimiters

### Convert colons to commas

```bash
echo "web01:running:25" | sed 's/:/,/g'
```

Output:

```text
web01,running,25
```

### Convert one or more whitespace characters to commas

```bash
sed -E 's/[[:space:]]+/,/g' servers.txt
```

Output:

```text
web01,running,25
web02,stopped,80
db01,running,65
```

---

## 17. Safe in-place editing

By default, `sed` displays transformed text without changing the file.

To edit directly:

```bash
sed -i 's/running/active/g' servers.txt
```

### Create a backup during editing

```bash
sed -i.bak 's/running/active/g' servers.txt
```

This creates:

```text
servers.txt
servers.txt.bak
```

Safe workflow:

```bash
# 1. Preview
sed 's/running/active/g' servers.txt

# 2. Edit with a backup
sed -i.bak 's/running/active/g' servers.txt

# 3. Verify
cat servers.txt
```

> In-place editing syntax differs between some GNU/Linux and BSD/macOS implementations. These notes primarily describe GNU `sed`, normally used on Linux.

---

## 18. Use a `sed` script file

For multiple reusable instructions, create `cleanup.sed`:

```sed
/^[[:space:]]*#/d
/^[[:space:]]*$/d
s/[[:space:]]*$//
s/running/active/g
```

Run it:

```bash
sed -f cleanup.sed configuration.txt
```

The `-f` option reads instructions from a file.

---

## 19. Shell variables and quoting

Suppose:

```bash
old_status="running"
new_status="active"
```

Use double quotes when shell variables must expand:

```bash
sed "s/$old_status/$new_status/g" servers.txt
```

For fixed instructions, prefer single quotes:

```bash
sed 's/running/active/g' servers.txt
```

If variables can contain delimiters, backslashes, `&`, or untrusted text, they require careful validation and escaping. Do not insert untrusted data directly into a `sed` program.

---

## 20. Linux Administrator examples

### Display active SSH configuration lines

```bash
sed -E '/^[[:space:]]*(#|$)/d' /etc/ssh/sshd_config
```

### Preview an SSH configuration replacement

```bash
sed 's/^PermitRootLogin.*/PermitRootLogin no/' \
    /etc/ssh/sshd_config
```

Before editing a production configuration:

1. Create a backup.
2. Preview the change.
3. Confirm the exact target.
4. Edit safely.
5. Validate the configuration.
6. Reload the service only after successful validation.

Validate SSH configuration:

```bash
sudo sshd -t
```

### Mask IPv4-like text in a log

```bash
sed -E 's/([0-9]{1,3}\.){3}[0-9]{1,3}/[IP-REMOVED]/g' \
    application.log
```

> This recognizes IPv4-like text but does not prove every octet is between 0 and 255.

### Convert `/etc/passwd` delimiters in displayed output

```bash
sed 's/:/ | /g' /etc/passwd
```

### Display a section between two markers

```bash
sed -n '/START/,/END/p' file.txt
```

---

## 21. `sed` in pipelines

### Transform command output

```bash
systemctl list-units --type=service |
sed 's/loaded/AVAILABLE/g'
```

### Remove percent symbols from disk output

```bash
df -P | sed 's/%//g'
```

### Clean data before AWK processes it

```bash
sed -E 's/[[:space:]]+/:/g' servers.txt |
awk -F: '$2 == "running" {print $1}'
```

In this example, AWK alone is simpler:

```bash
awk '$2 == "running" {print $1}' servers.txt
```

Use pipelines when each command adds genuine value.

---

## 22. Command summary

| Command | Purpose |
|---|---|
| `s` | Substitute text |
| `p` | Print selected lines |
| `d` | Delete selected lines |
| `i` | Insert text before a line |
| `a` | Append text after a line |
| `c` | Change the complete selected line |
| `q` | Quit processing |
| `=` | Display line numbers |

### Stop after a selected line

```bash
sed '5q' file.txt
```

This displays through line 5 and stops processing, which can help with large streams.

---

## 23. Common mistakes

### Mistake 1: Forgetting `-n` with `p`

```bash
sed '2p' file.txt
```

Line 2 appears twice. Correct:

```bash
sed -n '2p' file.txt
```

### Mistake 2: Expecting the file to change

```bash
sed 's/old/new/' file.txt
```

This only displays transformed output. To edit with a backup:

```bash
sed -i.bak 's/old/new/' file.txt
```

### Mistake 3: Forgetting `g`

```bash
sed 's/Linux/Bash/' file.txt
```

Only the first occurrence on each line changes. For all occurrences:

```bash
sed 's/Linux/Bash/g' file.txt
```

### Mistake 4: Using `/` for path replacement

Hard to read:

```bash
sed 's/\/home\/ali/\/opt\/ali/' file.txt
```

Clearer:

```bash
sed 's|/home/ali|/opt/ali|' file.txt
```

### Mistake 5: Editing before previewing

Risky:

```bash
sed -i 's/old/new/g' important.conf
```

Safer:

```bash
sed 's/old/new/g' important.conf
sed -i.bak 's/old/new/g' important.conf
```

---

## 24. `grep`, `cut`, `awk`, and `sed`

| Command | Main purpose |
|---|---|
| `grep` | Search and filter matching lines |
| `cut` | Extract simple fields or characters |
| `awk` | Parse fields, apply conditions, calculate, and format |
| `sed` | Search, replace, delete, insert, and transform text |

Using colon-separated server data:

```text
web01:running:25
web02:stopped:80
db01:running:65
```

```bash
# grep: find running records
grep "running" servers-colon.txt

# cut: extract server names
cut -d: -f1 servers-colon.txt

# awk: select running servers and print their names
awk -F: '$2 == "running" {print $1}' servers-colon.txt

# sed: replace running with active
sed 's/running/active/g' servers-colon.txt
```

---

## 25. When should you use `sed`?

Use `sed` when:

- You need to search and replace text.
- You need to delete matching records.
- You need to insert or append lines.
- You need to clean or transform a text stream.
- You need to automate repeated text edits.
- You need to preview configuration changes.
- You need to change delimiters or remove prefixes and suffixes.

Use `grep` for simple line searching, `cut` for simple field extraction, and AWK for field-based conditions, calculations, and reports.

---

## 26. Thinking process before using `sed`

Follow this process:

1. Examine the input.
2. Identify the text or pattern.
3. Decide what transformation is required.
4. Decide whether one occurrence or all occurrences should change.
5. Preview without `-i`.
6. If editing a file, create a backup.
7. Verify the result.
8. Validate any affected configuration or service.

Basic flow:

```text
Input → address or pattern → sed command → transformed output
```

Example:

```bash
sed 's/running/active/g' servers.txt
```

Breakdown:

- Input: `servers.txt`
- Command: `s` for substitute
- Search pattern: `running`
- Replacement: `active`
- Flag: `g` for every occurrence on each line

---

## 27. Practice lab

Create the file:

```bash
cat > employees.txt <<'EOF'
# Employee Data

101:Khalid:LinuxAdmin:Chicago
102:Ali:DevOpsEngineer:Dallas
103:Sara:CloudEngineer:Houston
104:Ahmed:SupportEngineer:Chicago
EOF
```

Complete these tasks:

1. Replace `Chicago` with `Illinois`.
2. Replace every colon with ` | `.
3. Display only lines containing `Engineer`.
4. Delete comment lines.
5. Delete blank lines.
6. Display lines 2 through 4.
7. Add `Employee Report` before the first line.
8. Add `End of Report` after the last line.
9. Replace the complete record containing `Ali`.
10. Remove comments and blank lines with one command.
11. Add `RECORD: ` to the beginning of every data line.
12. Preview replacing `LinuxAdmin` with `LinuxSystemsAdministrator`.

### Solutions

```bash
# 1. Replace Chicago with Illinois
sed 's/Chicago/Illinois/g' employees.txt

# 2. Replace colons with pipes
sed 's/:/ | /g' employees.txt

# 3. Display lines containing Engineer
sed -n '/Engineer/p' employees.txt

# 4. Delete comment lines
sed '/^[[:space:]]*#/d' employees.txt

# 5. Delete blank lines
sed '/^[[:space:]]*$/d' employees.txt

# 6. Display lines 2 through 4
sed -n '2,4p' employees.txt

# 7. Add a heading
sed '1i Employee Report' employees.txt

# 8. Add a footer
sed '$a End of Report' employees.txt

# 9. Replace Ali's complete record
sed '/:Ali:/c 102:Ali:SiteReliabilityEngineer:Dallas' employees.txt

# 10. Remove comments and blank lines
sed -E '/^[[:space:]]*(#|$)/d' employees.txt

# 11. Add a prefix to data lines only
sed '/^[0-9]/s/^/RECORD: /' employees.txt

# 12. Preview a job-title replacement
sed 's/LinuxAdmin/LinuxSystemsAdministrator/g' employees.txt
```

---

## 28. Quick knowledge check

1. What does `sed` stand for?
2. What is a text stream?
3. What does the `s` command do?
4. What does the `g` flag mean?
5. Why is `-n` normally used with `p`?
6. What does the `d` command do?
7. What is the difference between `i`, `a`, and `c`?
8. Does `sed` modify the original file by default?
9. What does `-i.bak` do?
10. Why might `|` be clearer than `/` as a delimiter?
11. What do `\1`, `\2`, and `&` mean in substitutions?
12. How is `sed` different from `grep`, `cut`, and `awk`?

---

## 29. Quick reference

```bash
# Replace the first match on each line
sed 's/old/new/' file

# Replace every match on each line
sed 's/old/new/g' file

# Use another delimiter
sed 's|/old/path|/new/path|g' file

# Print a line
sed -n '2p' file

# Print a line range
sed -n '2,5p' file

# Print matching lines
sed -n '/pattern/p' file

# Delete a line
sed '2d' file

# Delete matching lines
sed '/pattern/d' file

# Delete blank lines
sed '/^[[:space:]]*$/d' file

# Insert before a line
sed '1i Heading' file

# Append after a line
sed '$a Footer' file

# Change a complete line
sed '2c New line' file

# Use extended regular expressions
sed -E 's/error|failed/PROBLEM/g' file

# Edit with a backup
sed -i.bak 's/old/new/g' file

# Run instructions from a script
sed -f commands.sed file

# Add a prefix
sed 's/^/PREFIX: /' file

# Add a suffix
sed 's/$/ :SUFFIX/' file

# Remove leading whitespace
sed 's/^[[:space:]]*//' file

# Remove trailing whitespace
sed 's/[[:space:]]*$//' file

# Print a range between two patterns
sed -n '/START/,/END/p' file
```

## Final summary

`sed` is a stream editor used to search, replace, delete, insert, append, and transform text.

Remember:

```text
grep = search and filter lines
cut  = extract simple fields
awk  = parse, calculate, and format
sed  = edit and transform text streams
```
