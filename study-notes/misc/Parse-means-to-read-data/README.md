# Linux Bash Parsing Study Notes

Beginner-friendly study material explaining how Linux Administrators read, filter, extract, and transform information from logs, configuration files, command output, and JSON data.

The notes are available in both English and Roman Urdu. Both editions contain the same commands, examples, automation script, safety guidance, mini lab, and revision questions.

## Study Notes

| Edition | Description | Open Notes |
|---|---|---|
| English | Complete explanations and practical Linux examples in English | [English Study Notes](Linux-Bash-Parsing-Study-Notes.md) |
| Roman Urdu | The same material explained in beginner-friendly Roman Urdu | [Roman Urdu Study Notes](Linux-Bash-Parsing-Study-Notes-Roman-Urdu.md) |

## What Does Parse Mean?

To **parse** means to read data, understand its structure, and extract the information you need.

```text
Parse = read data and extract useful information
```

Roman Urdu:

```text
Parse ka matlab data ko parh kar us mein se zaroori information nikalna hai.
```

## Topics Covered

- Meaning of parsing in Linux and Bash
- Parsing logs and configuration files
- Searching for errors and important entries
- Extracting fields and columns
- Processing command output
- Parsing JSON data
- Using parsed values in Bash decisions
- Building command pipelines
- Safe and reliable parsing practices
- Real Linux Administrator examples
- Mini practice lab
- Revision questions

## Tools Covered

| Tool | Purpose | Example |
|---|---|---|
| `grep` | Find matching lines | `grep "ERROR" application.log` |
| `awk` | Process fields and columns | `awk '{print $1}' file` |
| `cut` | Extract selected fields | `cut -d: -f1 /etc/passwd` |
| `sed` | Search or transform text | `sed 's/error/ERROR/g' file` |
| `sort` | Arrange lines | `sort names.txt` |
| `uniq` | Count or remove repeated lines | `uniq -c` |
| `tr` | Translate or remove characters | `tr 'a-z' 'A-Z'` |
| `jq` | Parse JSON data | `jq -r '.name' data.json` |

## Learning Objectives

After completing these notes, students should be able to:

- Explain what parsing means.
- Find errors and patterns inside log files.
- Extract usernames from `/etc/passwd`.
- Select fields and columns with `awk` and `cut`.
- Transform text with `sed` and `tr`.
- Count repeated values with `sort` and `uniq`.
- Extract values from JSON with `jq`.
- Combine commands in pipelines.
- Validate parsed values before using them.
- Use parsing inside Bash automation scripts.

## Quick Examples

### Find Error Lines

```bash
grep "ERROR" application.log
```

### Extract Usernames

```bash
cut -d: -f1 /etc/passwd
```

### Display Filesystem Usage Fields

```bash
df -h | awk 'NR > 1 {print $1, $5, $6}'
```

### Find SSH Port Information

```bash
ss -tulnp | grep ':22'
```

### Extract a JSON Value

```bash
jq -r '.name' server.json
```

## Real Linux Administrator Use Cases

Linux Administrators use parsing to:

- Investigate authentication failures.
- Find application and service errors.
- Check disk usage and filesystem thresholds.
- Inspect listening ports.
- Read SSH and service configuration settings.
- Count requests from IP addresses.
- Generate health and audit reports.
- Process API responses.
- Make automated decisions in Bash scripts.

## Recommended Learning Path

1. Read the meaning of parsing.
2. Practise `grep` with a sample log file.
3. Learn field extraction with `cut`.
4. Practise column processing with `awk`.
5. Transform text with `sed` and `tr`.
6. Count repeated values with `sort` and `uniq`.
7. Parse JSON with `jq`.
8. Complete the mini practice lab.
9. Study the Bash disk-usage automation example.
10. Answer the revision questions without checking the notes.

## Mini Lab Overview

The included lab uses a sample `application.log` file. Students practise:

1. Displaying error lines
2. Counting errors
3. Extracting log levels
4. Counting each log level

Example command:

```bash
awk '{print $2}' application.log | sort | uniq -c
```

## Requirements

- Linux, WSL, or a Linux virtual machine
- Bash
- A text editor such as Vim, Nano, or VS Code
- Standard Linux text-processing commands
- `jq` for the JSON examples

Install `jq` on Ubuntu or Debian:

```bash
sudo apt update
sudo apt install -y jq
```

Install `jq` on RHEL-family systems:

```bash
sudo dnf install -y jq
```

## Safety Guidelines

- Read commands before running them.
- Practise with sample files first.
- Quote variable expansions in scripts.
- Do not assume that input always has the expected structure.
- Validate extracted values before using them.
- Prefer stable machine-readable output when available.
- Use `jq` for JSON instead of parsing JSON as ordinary text.
- Avoid modifying important files while learning.

## Key Lesson

Parsing turns raw system data into useful information:

```text
Logs / Commands / Configurations / JSON
                    ↓
          Search and extract data
                    ↓
       Troubleshooting and automation
```

For a Linux Administrator, parsing is the connection between system information and automated action.

## Author

Created for Linux and Bash scripting practice by **Muhammad Khalid Khan**.

