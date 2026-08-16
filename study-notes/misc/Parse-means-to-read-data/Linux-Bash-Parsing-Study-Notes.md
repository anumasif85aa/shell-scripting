# Linux Bash Parsing — Study Notes

## Topic

Understanding the word **parse** in Linux and Bash.

---

## 1. What Does Parse Mean?

**Parse** means to read data, break it into useful parts, understand its structure, and extract the required information.

Simple definition:

```text
Parse = read data and extract the information you need
```

### Roman Urdu

> Parse ka matlab data ko parhna, uske hisson ko samajhna, aur us mein se zaroori information nikalna hai.

---

## 2. Simple Example

Suppose a log file contains:

```text
2026-07-31 INFO Application started
2026-07-31 ERROR Database connection failed
2026-07-31 WARNING Disk usage is high
```

To extract the line containing `ERROR`:

```bash
grep "ERROR" application.log
```

Output:

```text
2026-07-31 ERROR Database connection failed
```

The command reads the log and returns the required information.

---

## 3. What Does “Parse Logs and Configurations” Mean?

For a Linux Administrator, **parse logs and configurations** means:

- Read log or configuration files.
- Search for important entries.
- Separate fields or columns.
- Extract errors, usernames, IP addresses, ports, or settings.
- Convert raw data into useful reports.
- Use the extracted information for troubleshooting or automation.

### Roman Urdu

> Log aur configuration files ko parh kar un mein se required information nikalna parsing kehlata hai.

---

## 4. Common Linux Parsing Tools

| Tool | Main Purpose | Simple Example |
|---|---|---|
| `grep` | Find matching lines | `grep "ERROR" app.log` |
| `awk` | Process fields and columns | `awk '{print $1}' file` |
| `cut` | Extract selected fields | `cut -d: -f1 /etc/passwd` |
| `sed` | Search, transform, or replace text | `sed 's/error/ERROR/g' file` |
| `sort` | Arrange lines | `sort names.txt` |
| `uniq` | Remove or count repeated lines | `uniq -c` |
| `tr` | Translate or remove characters | `tr 'a-z' 'A-Z'` |
| `jq` | Parse JSON data | `jq '.name' data.json` |

---

## SORT:


[`Sort` Explanation](./md/Linux-Sort-and-Parsing-Study-Notes.md)

[`Sort` Explanation-roman-Urdu](./md/Linux-Sort-and-Parsing-Study-Notes-Roman-Urdu.md)

## Uniq

[`Uniq` Explanation](./md/Linux-Uniq-and-Parsing-Study-Notes.md)

[`Uniq` Explanation-roman-Urdu](./md/Linux-Uniq-and-Parsing-Study-Notes-Roman-Urdu.md)

## TR

[`TR` Explanation](./md/Linux-TR-and-Parsing-Study-Notes.md)

[`TR` Explanation-roman-Urdu](./md/Linux-TR-and-Parsing-Study-Notes-Roman-Urdu.md)

---

## 5. Parsing with `grep`

[`grep` Explanation](./md/Linux-Grep-and-Parsing-Study-Notes.md)

[`grep` Explanation-roman-Urdu](./md/Linux-Grep-and-Parsing-Study-Notes-Roman-Urdu.md)

`grep` finds lines containing a word or pattern.

Example:

```bash
grep "failed" /var/log/syslog
```

Case-insensitive search:

```bash
grep -i "error" application.log
```

Show matching line numbers:

```bash
grep -n "ERROR" application.log
```

### Meaning

The file may contain thousands of lines, but `grep` extracts only the lines you need.

---

## 6. Parsing with `cut`

[`Cut` Explanation](./md/Linux-Cut-and-Parsing-Study-Notes.md)

[`Cut` Explanation-roman-Urdu](./md/Linux-Cut-and-Parsing-Study-Notes-Roman-Urdu.md)



The `/etc/passwd` file uses a colon (`:`) as its field separator:

```text
khalid:x:1000:1000:Khalid:/home/khalid:/bin/bash
```

Extract the first field, which contains the username:

```bash
cut -d: -f1 /etc/passwd
```

Explanation:

| Part | Meaning |
|---|---|
| `-d:` | Use `:` as the delimiter |
| `-f1` | Display field number 1 |
| `/etc/passwd` | Input file |

---

## 7. Parsing with `awk`

[`AWK` Explanation](./md/Linux-AWK-and-Parsing-Study-Notes.md)

[`awk` Explanation-roman-Urdu](./md/Linux-AWK-and-Parsing-Study-Notes-Roman-Urdu.md)

Suppose `servers.txt` contains:

```text
web01 running 25
web02 stopped 80
db01 running 65
```

Display the first column:

```bash
awk '{print $1}' servers.txt
```

Output:

```text
web01
web02
db01
```

Display the server name and status:

```bash
awk '{print $1, $2}' servers.txt
```

Display only stopped servers:

```bash
awk '$2 == "stopped" {print $1}' servers.txt
```

Output:

```text
web02
```

---

## 8. Parsing with `sed`

[`SED` Explanation](./md/Linux-SED-and-Parsing-Study-Notes.md)

[`sed` Explanation-roman-Urdu](./md/Linux-SED-and-Parsing-Study-Notes-Roman-Urdu.md)

`sed` can search and transform text.

Replace `error` with `ERROR` while displaying the result:

```bash
sed 's/error/ERROR/g' application.log
```

This does not modify the original file unless an in-place option such as `-i` is used.

Display only lines containing `ERROR`:

```bash
sed -n '/ERROR/p' application.log
```

---

## 9. Parsing JSON with `jq`

[`JQ-and-JSON` Explanation](./md/Linux-JQ-and-JSON-Parsing-Study-Notes.md)

[`jq` Explanation-roman-Urdu](./md/Linux-JQ-and-JSON-Parsing-Study-Notes-Roman-Urdu.md)

Suppose `server.json` contains:

```json
{
  "name": "web01",
  "status": "running",
  "ip": "192.168.1.10"
}
```

Extract the server name:

```bash
jq -r '.name' server.json
```

Output:

```text
web01
```

Extract the IP address:

```bash
jq -r '.ip' server.json
```

`jq` is especially useful when Bash scripts work with APIs and JSON output.

---

## 10. Real Linux Administrator Examples

### Find Authentication Failures

```bash
grep -i "failed" /var/log/auth.log
```

On some RHEL-family systems:

```bash
grep -i "failed" /var/log/secure
```

### Extract Filesystem Usage

```bash
df -h | awk 'NR > 1 {print $1, $5, $6}'
```

### Find Listening Ports

```bash
ss -tulnp
```

Filter for port `22`:

```bash
ss -tulnp | grep ':22'
```

### Read a Configuration Setting

```bash
grep '^PermitRootLogin' /etc/ssh/sshd_config
```

### Count Repeated IP Addresses in a Log

```bash
awk '{print $1}' access.log | sort | uniq -c | sort -nr
```

This pipeline:

1. Extracts the first field.
2. Sorts the values.
3. Counts repeated values.
4. Sorts the counts from highest to lowest.

---

## 11. How Parsing Fits into Bash Automation

A Bash script can parse command output and make a decision.

Example:

```bash
#!/bin/bash

usage=$(df / | awk 'NR == 2 {gsub("%", "", $5); print $5}')

if (( usage >= 80 )); then
    echo "Warning: root filesystem usage is ${usage}%" >&2
else
    echo "Disk usage is normal: ${usage}%"
fi
```

The script:

1. Runs `df /`.
2. Uses `awk` to select the required line and field.
3. Removes the `%` symbol.
4. Stores the result in `usage`.
5. Compares the number with the threshold.
6. Prints a normal or warning message.

This is a practical example of parsing data and using the result for automation.

---

## 12. Parse, Search, Filter, and Transform

These words are related but not exactly the same:

| Term | Meaning |
|---|---|
| Parse | Understand structured data and extract useful parts |
| Search | Find matching text or patterns |
| Filter | Keep only the required lines or values |
| Transform | Change data into another form |

A single command pipeline may perform all four operations.

---

## 13. Important Safety Notes

- Read a command before running it.
- Quote variable expansions in scripts.
- Test parsing commands with sample data first.
- Do not assume that every file has the expected structure.
- Validate extracted values before using them.
- Use `grep`, `awk`, `cut`, `sed`, or `jq` according to the data format.
- Avoid parsing human-formatted output when a stable machine-readable format is available.
- Use `jq` for JSON instead of treating JSON as ordinary text.

---

## 14. Mini Practice Lab

Create a file:

```bash
vim application.log
```

Add:

```text
2026-07-31 INFO Web service started
2026-07-31 ERROR Database connection failed
2026-07-31 WARNING Disk usage reached 75 percent
2026-07-31 ERROR Backup job failed
```

### Task 1: Display Error Lines

```bash
grep "ERROR" application.log
```

### Task 2: Count Error Lines

```bash
grep -c "ERROR" application.log
```

### Task 3: Display the Log Level

```bash
awk '{print $2}' application.log
```

### Task 4: Count Each Log Level

```bash
awk '{print $2}' application.log | sort | uniq -c
```

---

## 15. Practice Questions

1. What does parse mean?
2. Why do Linux Administrators parse logs?
3. Which command finds matching lines?
4. Which command processes fields and columns?
5. What do `-d:` and `-f1` mean in `cut`?
6. Which tool should be used to parse JSON?
7. How is parsing used in Bash automation?
8. Why should extracted values be validated?

---

## Final Summary

**Parse** means to read data, understand its structure, and extract useful information.

Common Linux parsing tools include:

```text
grep  awk  cut  sed  sort  uniq  tr  jq
```

Simple example:

```bash
grep "ERROR" application.log
```

Best one-line Roman Urdu definition:

```text
Parse ka matlab data ko parh kar us mein se zaroori information nikalna hai.
```

