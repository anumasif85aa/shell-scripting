# Linux `grep` Command and Parsing — Study Notes

## Learning objectives

After studying these notes, you should be able to:

- Explain the purpose and origin of `grep`.
- Search files and command output for text or patterns.
- Use common `grep` options.
- Use basic and extended regular expressions.
- Combine `grep` with `cut` and other Linux commands.
- Apply `grep` during Linux administration and troubleshooting.

---

## 1. What is `grep`?

`grep` is a Linux command used to **search for matching text or patterns** in files or command output.

In simple words:

> `grep` finds and displays lines containing the required word or pattern.

Unlike `cut`, which normally extracts selected fields or characters, `grep` normally selects and displays **complete matching lines**.

---

## 2. What does `grep` stand for?

The name comes from an old `ed` text-editor command:

```text
g/re/p
```

| Part | Meaning |
|---|---|
| `g` | Globally |
| `re` | Regular expression |
| `p` | Print |

In simple words:

> Globally search for a regular expression and print the matching lines.

---

## 3. Basic syntax

```bash
grep [OPTIONS] "PATTERN" FILE
```

Example:

```bash
grep "root" /etc/passwd
```

Possible output:

```text
root:x:0:0:root:/root:/bin/bash
```

### Command breakdown

| Part | Meaning |
|---|---|
| `grep` | Runs the search command |
| `"root"` | Text or pattern to search for |
| `/etc/passwd` | File to search |

In plain English:

> Search `/etc/passwd` and display every line containing `root`.

---

## 4. Create a practice file

```bash
cat > servers.txt <<'EOF'
web01 running 25
web02 stopped 80
db01 running 65
EOF
```

> The redirection operator `>` saves the here-document content in `servers.txt`. The final `EOF` must appear alone on its line.

Search for `running`:

```bash
grep "running" servers.txt
```

Output:

```text
web01 running 25
db01 running 65
```

`grep` displays every line containing the search pattern.

---

## 5. Searching command output

A pipe (`|`) sends the output of one command to another command.

```bash
ps aux | grep "sshd"
```

Processing steps:

1. `ps aux` displays running processes.
2. `|` sends that output to `grep`.
3. `grep "sshd"` displays lines containing `sshd`.

Other examples:

```bash
ip address | grep "inet"
```

```bash
systemctl list-units --type=service | grep "running"
```

---

## 6. Common `grep` options

| Option | Meaning |
|---|---|
| `-i` | Ignores uppercase and lowercase differences |
| `-v` | Displays lines that do not match |
| `-n` | Displays line numbers |
| `-c` | Counts matching lines |
| `-w` | Matches a complete word |
| `-x` | Matches a complete line |
| `-r` or `-R` | Searches directories recursively |
| `-l` | Displays only filenames containing matches |
| `-L` | Displays filenames that do not contain matches |
| `-o` | Displays only the matching part |
| `-E` | Uses extended regular expressions |
| `-F` | Treats the pattern as fixed, plain text |
| `-q` | Quiet mode; produces no normal output |
| `-A` | Displays lines after a match |
| `-B` | Displays lines before a match |
| `-C` | Displays lines before and after a match |

---

## 7. Important option examples

### Ignore case with `-i`

```bash
grep -i "error" app.log
```

This can match:

```text
error
Error
ERROR
```

### Display line numbers with `-n`

```bash
grep -n "failed" app.log
```

Example output:

```text
15:Login failed
28:Backup failed
```

Here, `15` and `28` are line numbers.

### Count matching lines with `-c`

```bash
grep -c "running" servers.txt
```

Output:

```text
2
```

> `grep -c` counts matching lines, not necessarily the total number of matching words.

### Display nonmatching lines with `-v`

```bash
grep -v "running" servers.txt
```

Output:

```text
web02 stopped 80
```

The `-v` option inverts the match.

### Match a complete word with `-w`

Suppose a file contains:

```text
user
username
superuser
```

Run:

```bash
grep -w "user" file.txt
```

Output:

```text
user
```

Without `-w`, the pattern `user` could match all three lines.

### Match the complete line with `-x`

```bash
grep -x "running" status.txt
```

This matches a line only if its complete content is exactly `running`.

### Display only the matching part with `-o`

```bash
echo "Server IP is 192.168.1.10" | grep -o "192.168.1.10"
```

Output:

```text
192.168.1.10
```

Normally, `grep` displays the complete matching line. The `-o` option displays only the matching portion.

### Use fixed-string matching with `-F`

```bash
grep -F "192.168.1.10" network.txt
```

With `-F`, characters such as dots are treated literally instead of as regular-expression symbols.

### Quiet mode with `-q`

```bash
grep -q "sshd" services.txt
echo $?
```

- Exit status `0`: A match was found.
- Exit status `1`: No match was found.
- Exit status greater than `1`: An error occurred.

Quiet mode is useful in shell-script conditions:

```bash
if grep -q "running" servers.txt; then
    echo "At least one running server was found"
fi
```

---

## 8. Searching for multiple patterns

### Use multiple `-e` options

```bash
grep -e "error" -e "failed" app.log
```

This displays lines containing either `error` or `failed`.

### Use an extended regular expression

```bash
grep -E "error|failed" app.log
```

Inside an extended regular expression, `|` means **OR**.

Ignore letter case too:

```bash
grep -Ei "error|failed" app.log
```

---

## 9. Searching directories recursively

Search files under `/etc/ssh/` and its subdirectories:

```bash
grep -r "PermitRootLogin" /etc/ssh/
```

Include line numbers:

```bash
grep -rn "PermitRootLogin" /etc/ssh/
```

Ignore letter case:

```bash
grep -rni "error" /var/log/
```

Display only filenames containing a match:

```bash
grep -rl "PermitRootLogin" /etc/ssh/
```

Display filenames that do not contain a match:

```bash
grep -rL "PermitRootLogin" /etc/ssh/
```

> Permissions may prevent a normal user from reading some system files. Use `sudo` only when authorized and necessary.

---

## 10. Displaying context around a match

Context options are helpful when investigating logs.

### Display two lines after a match

```bash
grep -A 2 "ERROR" app.log
```

### Display two lines before a match

```bash
grep -B 2 "ERROR" app.log
```

### Display two lines before and after a match

```bash
grep -C 2 "ERROR" app.log
```

---

## 11. `grep` and regular expressions

A **regular expression**, often called a regex, is a pattern that describes text.

### Match the beginning of a line with `^`

```bash
grep "^root" /etc/passwd
```

This matches lines beginning with `root`.

### Match the end of a line with `$`

```bash
grep "bash$" /etc/passwd
```

This matches lines ending with `bash`.

### Match any single character with `.`

```bash
grep "web0." servers.txt
```

The dot represents any one character, so the pattern can match `web01` and `web02`.

### Match one character from a set with brackets

```bash
grep "web0[12]" servers.txt
```

This matches `web01` or `web02`.

### Match lines beginning with a comment

```bash
grep "^#" configuration.conf
```

### Display blank lines

```bash
grep "^$" configuration.conf
```

### Ignore blank lines and comments

```bash
grep -vE '^[[:space:]]*(#|$)' configuration.conf
```

This removes:

- Blank lines
- Lines containing only whitespace
- Comment lines whose first non-space character is `#`

This command is useful when reviewing configuration files.

---

## 12. Linux administration examples

### Find users with a Bash login shell

```bash
grep "/bin/bash$" /etc/passwd
```

### Find a specific user

```bash
grep "^ali:" /etc/passwd
```

For an exact account lookup, this command is often more appropriate:

```bash
getent passwd ali
```

### Find failed SSH login attempts on RHEL-based systems

```bash
sudo grep "Failed password" /var/log/secure
```

### Find failed SSH login attempts on Ubuntu-based systems

```bash
sudo grep "Failed password" /var/log/auth.log
```

### Check an SSH configuration setting

```bash
grep "^PermitRootLogin" /etc/ssh/sshd_config
```

### Find errors in an application log

```bash
grep -i "error" application.log
```

### Search for a process while avoiding the `grep` line

```bash
ps aux | grep "[s]shd"
```

The pattern `[s]shd` matches `sshd` but usually prevents the `grep` command itself from appearing.

For an exact process lookup, this is often cleaner:

```bash
pgrep -a sshd
```

### Search current boot logs

```bash
journalctl -b | grep -i "error"
```

---

## 13. Is `grep` a parsing command?

`grep` is part of Linux text processing, but its main job is **searching and filtering lines**, not extracting fields.

Suppose `servers-colon.txt` contains:

```text
web01:running:25
web02:stopped:80
db01:running:65
```

### Use `grep` to select matching lines

```bash
grep "running" servers-colon.txt
```

Output:

```text
web01:running:25
db01:running:65
```

### Use `cut` to extract a field

```bash
cut -d: -f1 servers-colon.txt
```

Output:

```text
web01
web02
db01
```

### Combine `grep` and `cut`

Display only the names of running servers:

```bash
grep "running" servers-colon.txt | cut -d: -f1
```

Output:

```text
web01
db01
```

Processing flow:

```text
File → grep selects matching lines → cut extracts the required field
```

---

## 14. `grep` versus `cut` versus `awk`

| Command | Main purpose |
|---|---|
| `grep` | Finds or filters matching lines |
| `cut` | Extracts fields, characters, or bytes |
| `awk` | Performs advanced field processing, conditions, and calculations |

Examples:

```bash
# Find running-server records
grep "running" servers-colon.txt

# Extract every server name
cut -d: -f1 servers-colon.txt

# Display names only when the status is exactly running
awk -F: '$2 == "running" {print $1}' servers-colon.txt
```

---

## 15. Quoting patterns

Patterns should usually be enclosed in quotes:

```bash
grep "Failed password" auth.log
```

Single quotes are especially useful for regular expressions because the shell does not expand characters inside them:

```bash
grep -E 'error|failed' app.log
```

Use double quotes when the pattern must include a shell variable:

```bash
search_word="running"
grep "$search_word" servers.txt
```

---

## 16. Understanding the exit status

After running `grep`, check its exit status:

```bash
grep "running" servers.txt
echo $?
```

| Exit status | Meaning |
|---:|---|
| `0` | One or more matches were found |
| `1` | No match was found |
| `2` or greater | An error occurred |

The exit status is particularly important in shell scripting.

---

## 17. Thinking process before using `grep`

Ask these questions:

1. Where is my input: a file or command output?
2. What text or pattern am I searching for?
3. Should the search be case-sensitive?
4. Do I need matching or nonmatching lines?
5. Do I need line numbers, a count, or surrounding context?
6. Am I searching one file or an entire directory?

Basic flow:

```text
Input → search pattern → grep options → matching lines
```

---

## 18. Practice lab

Create a practice log:

```bash
cat > application.log <<'EOF'
2026-07-31 INFO Application started
2026-07-31 WARNING Disk usage is 80 percent
2026-07-31 ERROR Backup failed
2026-07-31 INFO User logged in
2026-07-31 error Network connection failed
2026-07-31 INFO Application stopped
EOF
```

Complete these tasks:

1. Display lines containing uppercase `ERROR`.
2. Display all error lines regardless of letter case.
3. Display matching line numbers.
4. Count error lines regardless of letter case.
5. Display lines that do not contain `INFO`.
6. Display one line before and after each error.
7. Search for either `ERROR` or `WARNING`.
8. Display only the word `failed`, ignoring case.

### Solutions

```bash
# 1. Uppercase ERROR only
grep "ERROR" application.log

# 2. All error lines, ignoring case
grep -i "error" application.log

# 3. Matching line numbers
grep -in "error" application.log

# 4. Count matching lines
grep -ic "error" application.log

# 5. Lines that do not contain INFO
grep -v "INFO" application.log

# 6. One line before and after each error
grep -iC 1 "error" application.log

# 7. ERROR or WARNING
grep -E "ERROR|WARNING" application.log

# 8. Display only the matching word
grep -io "failed" application.log
```

---

## 19. Quick knowledge check

1. What is the main purpose of `grep`?
2. Where does the name `grep` come from?
3. What does `grep -i` do?
4. What is the purpose of `grep -v`?
5. What is the difference between `-w` and `-x`?
6. Does `grep -c` count matching lines or matching words?
7. What do `^` and `$` mean in regular expressions?
8. How do you search a directory recursively?
9. What do the `-A`, `-B`, and `-C` options display?
10. What do `grep` exit statuses `0` and `1` mean?
11. Explain the difference between `grep`, `cut`, and `awk`.
12. Explain this pipeline:

```bash
grep "running" servers-colon.txt | cut -d: -f1
```

---

## 20. Quick reference

```bash
# Basic search
grep "pattern" file

# Ignore case
grep -i "pattern" file

# Display line numbers
grep -n "pattern" file

# Count matching lines
grep -c "pattern" file

# Display nonmatching lines
grep -v "pattern" file

# Match a complete word
grep -w "word" file

# Display only the matching part
grep -o "pattern" file

# Use extended regular expressions
grep -E 'error|failed' file

# Use a fixed-string search
grep -F "literal.text" file

# Search recursively
grep -rn "pattern" directory/

# Display context around a match
grep -C 2 "pattern" file

# Match the beginning of a line
grep '^pattern' file

# Match the end of a line
grep 'pattern$' file

# Search command output
command | grep "pattern"

# Quiet check for shell scripts
grep -q "pattern" file
```

## Final summary

`grep` searches files or command output and displays lines matching a word or pattern.

```bash
grep "running" servers.txt
```

This means:

> Search `servers.txt` and display every line containing `running`.

Remember:

```text
grep = find or filter lines
cut  = extract fields or characters
awk  = advanced text processing
```
