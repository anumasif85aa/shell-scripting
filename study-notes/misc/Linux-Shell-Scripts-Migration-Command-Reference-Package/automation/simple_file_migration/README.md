# Simple File Migration Script

A beginner-friendly Bash project for copying selected files from one directory into an existing Linux user's home directory.

The script is reusable. It is not limited to one username or only `.sh` files. The source directory, target user, destination folder, and filename pattern are supplied as command-line arguments.

## Table of Contents

- [Project Purpose](#project-purpose)
- [What the Script Does](#what-the-script-does)
- [Requirements](#requirements)
- [Script Name](#script-name)
- [Command Syntax](#command-syntax)
- [Arguments](#arguments)
- [Setup](#setup)
- [Usage Examples](#usage-examples)
- [How the Script Works](#how-the-script-works)
- [Example Output](#example-output)
- [Verification](#verification)
- [Safety Features](#safety-features)
- [Important Limitations](#important-limitations)
- [Troubleshooting](#troubleshooting)
- [Learning Outcomes](#learning-outcomes)

## Project Purpose

This project demonstrates how a Linux administrator can automate a simple file-migration task while still validating input and checking for common errors.

It can be used to copy files such as:

- Bash scripts: `*.sh`
- Python programs: `*.py`
- Markdown notes: `*.md`
- Configuration files: `*.conf`
- Text files: `*.txt`
- All ordinary files: `*`

## What the Script Does

The script:

1. Accepts four command-line arguments.
2. Confirms that it is running with root privileges.
3. Checks that the source directory exists.
4. Checks that the target user exists.
5. Obtains the user's home directory and primary group.
6. Displays the files selected by the pattern.
7. Requests confirmation from the administrator.
8. Creates the destination directory with controlled ownership and permissions.
9. Copies the selected files.
10. Displays the total number of successfully copied files.

The script copies files instead of moving them, so the original files remain available.

## Requirements

- A Linux system
- Bash
- Root or `sudo` access
- An existing target user
- A valid source directory
- Standard Linux commands including `id`, `getent`, `find`, and `install`

## Script Name

Save the Bash script as:

```text
simple_file_migration.sh
```

## Command Syntax

```bash
sudo ./simple_file_migration.sh SOURCE USER FOLDER PATTERN
```

## Arguments

| Position | Name | Purpose | Example |
|---:|---|---|---|
| `$1` | `SOURCE` | Directory containing the original files | `/root` |
| `$2` | `USER` | Existing user who will receive the files | `khan` |
| `$3` | `FOLDER` | Destination folder beneath the user's home | `shell-scripts` |
| `$4` | `PATTERN` | Selects the required filenames | `'*.sh'` |

For example:

```bash
sudo ./simple_file_migration.sh /root khan shell-scripts '*.sh'
```

This means:

- Read files from `/root`.
- Select ordinary files ending in `.sh`.
- Copy them for the existing user `khan`.
- Store them under `/home/khan/shell-scripts`.

> Always quote patterns such as `'*.sh'`. The quotes prevent the current shell from expanding the wildcard before the script receives it.

## Setup

Make the script executable:

```bash
chmod +x simple_file_migration.sh
```

Check its Bash syntax:

```bash
bash -n simple_file_migration.sh
```

No output from `bash -n` normally means that no syntax error was detected.

## Usage Examples

### Copy Bash scripts

```bash
sudo ./simple_file_migration.sh \
    /root \
    khan \
    shell-scripts \
    '*.sh'
```

### Copy Markdown study notes

```bash
sudo ./simple_file_migration.sh \
    /root \
    ali \
    study-notes \
    '*.md'
```

### Copy Python files

```bash
sudo ./simple_file_migration.sh \
    /opt/training \
    student \
    python-practice \
    '*.py'
```

### Copy configuration files

```bash
sudo ./simple_file_migration.sh \
    /opt/project \
    developer \
    project-config \
    '*.conf'
```

### Copy every ordinary file

```bash
sudo ./simple_file_migration.sh \
    /root \
    khan \
    migrated-files \
    '*'
```

The pattern `'*'` selects every ordinary file directly inside the source directory.

## How the Script Works

```text
Receive arguments
       ↓
Check root privileges
       ↓
Validate source directory and user
       ↓
Find matching files
       ↓
Ask for confirmation
       ↓
Create destination directory
       ↓
Copy files and set ownership
       ↓
Display the final summary
```

### Exit on invalid usage

```bash
if [[ "$#" -ne 4 ]]; then
```

`$#` contains the number of command-line arguments. The script requires exactly four.

### Check administrative permission

```bash
if [[ "$EUID" -ne 0 ]]; then
```

Root normally has an effective user ID of `0`. The script needs elevated permission when reading protected directories or creating files for another user.

### Validate the user

```bash
if ! id "$target_user" &>/dev/null; then
```

The `id` command checks whether the account exists. The `!` operator means the error block runs when that check fails.

### Obtain account information

```bash
target_home=$(getent passwd "$target_user" | cut -d: -f6)
target_group=$(id -gn "$target_user")
```

These commands obtain the user's home directory and primary group instead of assuming they are both named after the username.

### Find files safely

```bash
find "$source_dir" -maxdepth 1 -type f -name "$pattern" -print0
```

- `-maxdepth 1` prevents recursive searching.
- `-type f` selects ordinary files.
- `-name` applies the supplied pattern.
- `-print0` safely separates filenames, including names containing spaces.

### Create the destination

```bash
install -d -o "$target_user" -g "$target_group" -m 750 "$destination"
```

This creates the directory and assigns its owner, group, and permission mode in one command.

### Copy each file

```bash
install \
    -o "$target_user" \
    -g "$target_group" \
    -m 750 \
    "$file" \
    "$destination/"
```

Each copied file receives the target user's ownership and permission mode `750`.

## Example Output

```text
Files selected for copying:
/root/backup.sh
/root/report.sh

Continue with the copy? (yes/no): yes
Copied: /root/backup.sh
Copied: /root/report.sh

Destination: /home/khan/shell-scripts
Files copied: 2
```

## Verification

Check the destination directory:

```bash
sudo ls -ld /home/khan/shell-scripts
sudo ls -l /home/khan/shell-scripts
```

Verify access as the target user:

```bash
sudo -iu khan
cd ~/shell-scripts
pwd
ls -la
```

Check the syntax of copied Bash scripts:

```bash
for script in ./*.sh
do
    bash -n "$script" || exit 1
done
```

## Safety Features

- Requires exactly four arguments.
- Verifies root privileges.
- Verifies the source directory.
- Verifies the target user.
- Rejects an absolute destination folder.
- Rejects a destination containing `..`.
- Shows matching files before copying.
- Requires confirmation before making changes.
- Quotes variables to protect paths containing spaces.
- Uses `--` where appropriate to prevent filenames from being treated as options.
- Copies rather than moves, preserving the source files.

## Important Limitations

This is intentionally a fresher-level script:

- It accepts one filename pattern per run.
- It searches only the top level of the source directory.
- It does not copy subdirectories.
- It assigns mode `750` to every copied file.
- An existing destination file with the same name can be replaced.
- It does not create the target user.
- It does not configure sudo access.
- It is intended for controlled practice before production use.

For ordinary documents, mode `640` is often more appropriate than `750`. Executable scripts may use `750` when execution is required.

## Troubleshooting

### Permission denied

Run the script with `sudo`:

```bash
sudo ./simple_file_migration.sh /root khan shell-scripts '*.sh'
```

### User does not exist

Verify the username:

```bash
id khan
getent passwd khan
```

### No files appear in the preview

Check the source and pattern:

```bash
find /root -maxdepth 1 -type f -name '*.sh' -print
```

### The wildcard expanded unexpectedly

Use quotes:

```bash
'*.sh'
```

Do not pass an unquoted pattern when calling the script.

## Learning Outcomes

After completing this project, a student should understand:

- Command-line arguments: `$1`, `$2`, `$3`, `$4`, and `$#`
- Variables and quoting
- `if` conditionals
- Exit statuses and `exit 1`
- User and directory validation
- Command substitution
- `find` patterns
- `while` loops
- Root permissions
- Linux ownership and permission modes
- Basic file-migration automation
- Post-change verification

## Final Lesson

> Good automation validates its inputs, previews its targets, asks before making changes, reports failures clearly, and verifies the final result.

