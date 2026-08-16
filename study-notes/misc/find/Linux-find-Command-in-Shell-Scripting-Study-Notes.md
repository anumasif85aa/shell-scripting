# Linux `find` Command in Shell Scripting — Study Notes

## Table of Contents

1. [Introduction](#1-introduction)
2. [Basic Syntax](#2-basic-syntax)
3. [Search by Name](#3-search-by-name)
4. [Search by File Type](#4-search-by-file-type)
5. [Control Search Depth](#5-control-search-depth)
6. [Search by Size](#6-search-by-size)
7. [Search by Modification Time](#7-search-by-modification-time)
8. [Find Empty Items](#8-find-empty-items)
9. [Search by Owner or Group](#9-search-by-owner-or-group)
10. [Combine Conditions](#10-combine-conditions)
11. [Perform Actions with `-exec`](#11-perform-actions-with--exec)
12. [Copy Matching Files](#12-copy-matching-files)
13. [Delete Matching Files Safely](#13-delete-matching-files-safely)
14. [Use `find` in a Shell Script](#14-use-find-in-a-shell-script)
15. [Count Matching Files](#15-count-matching-files)
16. [Process Filenames Safely](#16-process-filenames-safely)
17. [Real-World Log-Cleanup Script](#17-real-world-log-cleanup-script)
18. [Common Mistakes](#18-common-mistakes)
19. [Quick Reference](#19-quick-reference)
20. [Summary](#20-summary)

---

## 1. Introduction

The Linux `find` command searches through a directory tree. It can select files and directories according to conditions such as:

- Name
- File type
- Size
- Owner or group
- Modification time
- Permissions
- Directory depth

It can also perform actions on the matching paths, such as printing, copying, inspecting, or deleting them.

> The `find` command searches the filesystem. It is different from the shell's wildcard expansion, such as `*.txt`.

---

## 2. Basic Syntax

```bash
find STARTING_PATH CONDITIONS ACTION
```

Example:

```bash
find /home/khalid -type f -name "*.sh" -print
```

Meaning:

> Start at `/home/khalid` and recursively display regular files whose names end with `.sh`.

### Command breakdown

| Part | Meaning |
|---|---|
| `find` | Search command |
| `/home/khalid` | Starting directory |
| `-type f` | Select regular files |
| `-name "*.sh"` | Select names ending in `.sh` |
| `-print` | Display matching paths |

### Common starting paths

| Path | Search area |
|---|---|
| `.` | Current directory and its descendants |
| `..` | Parent directory and its descendants |
| `/tmp` | The `/tmp` directory tree |
| `"$HOME"` | Current user's home directory |
| `/` | Entire filesystem; permissions and mounted filesystems require care |

---

## 3. Search by Name

### Find `.txt` items

```bash
find . -name "*.txt"
```

This can match both regular files and directories whose names end with `.txt`.

To select only regular files:

```bash
find . -type f -name "*.txt"
```

### Why quote the wildcard?

Use:

```bash
find . -name "*.txt"
```

Do not depend on:

```bash
find . -name *.txt
```

Without quotes, the shell may expand `*.txt` before `find` receives it. If multiple files match in the current directory, the resulting command can become invalid or produce unexpected results.

### Case-insensitive search

```bash
find . -type f -iname "*.jpg"
```

`-iname` ignores uppercase and lowercase differences. It can match:

```text
photo.jpg
PHOTO.JPG
Image.Jpg
```

### Match an exact name

```bash
find . -type f -name "configuration.conf"
```

### Match names beginning with text

```bash
find . -type f -name "backup*"
```

---

## 4. Search by File Type

### Regular files

```bash
find . -type f
```

### Directories

```bash
find . -type d
```

### Symbolic links

```bash
find . -type l
```

### Common file-type tests

| Test | Meaning |
|---|---|
| `-type f` | Regular file |
| `-type d` | Directory |
| `-type l` | Symbolic link |
| `-type b` | Block device |
| `-type c` | Character device |
| `-type p` | Named pipe |
| `-type s` | Socket |

### Find directories named `backup`

```bash
find . -type d -name "backup"
```

### Find symbolic links

```bash
find /usr/local -type l -print
```

---

## 5. Control Search Depth

By default, `find` recursively searches all accessible descendants of the starting directory.

### Search only the starting directory

```bash
find . -maxdepth 1 -type f
```

`-maxdepth 1` prevents `find` from descending into subdirectories.

### Require a minimum depth

```bash
find . -mindepth 2 -type f
```

Results must be at least two levels below the starting directory.

### Search a limited number of levels

```bash
find . -mindepth 1 -maxdepth 2 -type f
```

### Practical example

```bash
find /var/log -maxdepth 1 -type f -name "*.log"
```

This searches for `.log` files directly inside `/var/log` without entering its subdirectories.

> `-maxdepth` and `-mindepth` are widely available with GNU `find`, which is standard on most Linux systems. They are not specified by basic POSIX `find`.

---

## 6. Search by Size

### Files larger than 10 MiB

```bash
find . -type f -size +10M
```

### Files smaller than 1 MiB

```bash
find . -type f -size -1M
```

### Files in a specific size unit

```bash
find . -type f -size 100k
```

Because `find` rounds in units, an exact-looking size test means the file occupies the indicated number of size units, not necessarily an exact byte count.

### Common size suffixes

| Suffix | Unit |
|---|---|
| `c` | Bytes |
| `k` | KiB units |
| `M` | MiB units |
| `G` | GiB units |

Examples:

```bash
find /var/log -type f -size +100M
find "$HOME" -type f -size +1G
```

---

## 7. Search by Modification Time

`-mtime` works in 24-hour periods, while `-mmin` works in minutes.

### Modified within the last seven 24-hour periods

```bash
find . -type f -mtime -7
```

### Modified more than seven full 24-hour periods ago

```bash
find . -type f -mtime +7
```

### Modified within the current 24-hour age bucket

```bash
find . -type f -mtime 0
```

### Modified within approximately the last 30 minutes

```bash
find . -type f -mmin -30
```

### Common time tests

| Test | Meaning |
|---|---|
| `-mtime` | Data modification time in 24-hour periods |
| `-mmin` | Data modification time in minutes |
| `-atime` | Last access time in 24-hour periods |
| `-amin` | Last access time in minutes |
| `-ctime` | Metadata-change time in 24-hour periods |
| `-cmin` | Metadata-change time in minutes |

> On Linux, `ctime` is the inode metadata-change time. It is not the file-creation time.

---

## 8. Find Empty Items

### Empty regular files

```bash
find . -type f -empty
```

### Empty directories

```bash
find . -type d -empty
```

### Non-empty regular files

```bash
find . -type f ! -empty
```

---

## 9. Search by Owner or Group

### Files owned by a user

```bash
find /home -type f -user khalid
```

### Files belonging to a group

```bash
find /shared -type f -group developers
```

### Files with no valid username

```bash
find /home -nouser
```

This can help locate files whose numeric owner UID no longer maps to an account.

### Files with no valid group name

```bash
find /home -nogroup
```

---

## 10. Combine Conditions

### AND behavior

Conditions written next to each other normally use an implicit AND:

```bash
find . -type f -name "*.log" -size +10M
```

Meaning:

> Find items that are regular files, have names ending in `.log`, and are larger than 10 MiB.

### OR with `-o`

```bash
find . -type f \( -name "*.txt" -o -name "*.md" \)
```

This finds regular files ending in `.txt` or `.md`.

The parentheses are escaped:

```bash
\( ... \)
```

This prevents the shell from interpreting them.

### NOT with `!`

Find files that do not end in `.txt`:

```bash
find . -type f ! -name "*.txt"
```

### Why grouping matters

The expression:

```bash
find . -type f -name "*.txt" -o -name "*.md"
```

does not apply `-type f` equally to both name tests because AND has higher precedence than OR. Group the name alternatives instead:

```bash
find . -type f \( -name "*.txt" -o -name "*.md" \)
```

---

## 11. Perform Actions with `-exec`

### Run one command per matching pathname

```bash
find . -type f -name "*.sh" -exec ls -l -- {} \;
```

| Part | Meaning |
|---|---|
| `-exec` | Run a command on matching paths |
| `ls -l` | Command to run |
| `--` | End command options before pathnames |
| `{}` | Current matched pathname |
| `\;` | End the action and run once per match |

The semicolon is escaped because the shell normally treats `;` as a command separator.

### Process several matches per command

```bash
find . -type f -name "*.sh" -exec ls -l -- {} +
```

Difference:

| Ending | Behavior |
|---|---|
| `\;` | Runs the command separately for each match |
| `+` | Passes multiple matches to fewer command executions |

The `+` form is normally more efficient when the called command accepts multiple pathnames.

### Ask before executing

```bash
find . -type f -name "*.bak" -ok rm -- {} \;
```

`-ok` asks for confirmation before each command. Its prompts and accepted responses can vary by implementation and locale.

---

## 12. Copy Matching Files

```bash
destination="/tmp/script-backup"

mkdir -p -- "$destination"

find . -type f -name "*.sh" \
    -exec cp -- {} "$destination" \;
```

This copies matching shell scripts into the destination directory.

### Important name-collision warning

Suppose these files exist:

```text
project-a/start.sh
project-b/start.sh
```

Copying both into one directory can cause one `start.sh` to overwrite the other. Use a structure-preserving tool or design unique target names when duplicate basenames are possible.

---

## 13. Delete Matching Files Safely

### Step 1: Preview

```bash
find /tmp -type f -name "*.tmp" -print
```

Carefully verify:

- The starting path
- The file type
- The name pattern
- The complete result list

### Step 2: Delete only after verification

```bash
find /tmp -type f -name "*.tmp" -delete
```

### Safer script pattern

```bash
target_directory="/tmp/application-cache"

echo "Files selected for deletion:"
find "$target_directory" -type f -name "*.tmp" -print

read -r -p "Enter yes to delete these files: " answer

if [[ "$answer" == "yes" ]]; then
    find "$target_directory" -type f -name "*.tmp" -delete
    echo "Cleanup completed."
else
    echo "Cleanup cancelled."
fi
```

> `-delete` is destructive. A wrong starting path or condition can remove important data. Always preview first.

---

## 14. Use `find` in a Shell Script

```bash
#!/bin/bash

# Title: Find Shell Scripts
# Usage: bash find_scripts.sh DIRECTORY

search_directory="${1:-}"

if [[ -z "$search_directory" ]]; then
    echo "Usage: $0 DIRECTORY" >&2
    exit 1
fi

if [[ ! -d "$search_directory" ]]; then
    echo "Error: directory does not exist: $search_directory" >&2
    exit 1
fi

if [[ ! -r "$search_directory" ]]; then
    echo "Error: directory is not readable: $search_directory" >&2
    exit 1
fi

echo "Shell scripts found:"

find "$search_directory" -type f -name "*.sh" -print

exit 0
```

Run it:

```bash
bash find_scripts.sh /home/khalid
```

### Why quote the variable?

```bash
find "$search_directory"
```

Quotes preserve a directory pathname containing spaces as one argument and prevent wildcard expansion.

---

## 15. Count Matching Files

### GNU/Linux method safe from newline-containing filenames

```bash
count=$(find "$search_directory" -type f -name "*.sh" -printf '.' | wc -c)

echo "Total shell scripts: $count"
```

GNU `find` prints one dot for every match, and `wc -c` counts those dots.

> `-printf` is a GNU `find` feature and is not available in every Unix implementation.

### Bash loop method

```bash
count=0

while IFS= read -r -d '' file
do
    ((count += 1))
done < <(find "$search_directory" -type f -name "*.sh" -print0)

echo "Total shell scripts: $count"
```

Process substitution keeps the loop in the current Bash process, so the final `count` remains available after the loop.

---

## 16. Process Filenames Safely

### Unsafe approach

```bash
for file in $(find . -type f -name "*.txt")
do
    echo "$file"
done
```

This is unsafe because command substitution and the `for` loop split results on whitespace. A pathname such as:

```text
student notes.txt
```

could be incorrectly treated as two separate items.

### Safe null-separated loop

```bash
while IFS= read -r -d '' file
do
    echo "Processing: $file"
done < <(find . -type f -name "*.txt" -print0)
```

### Explanation

| Part | Purpose |
|---|---|
| `-print0` | Separates pathnames with a null character |
| `< <(...)` | Sends process-substitution output into the loop |
| `IFS=` | Prevents unwanted whitespace trimming |
| `read -r` | Prevents backslash interpretation |
| `-d ''` | Reads until a null separator |
| `"$file"` | Preserves the pathname as one argument |

The null byte is the only character that cannot appear inside a Unix pathname, making this approach safe for unusual filenames, including those containing spaces, tabs, or newlines.

### When `-exec` is simpler

If an external command can directly process the results, this may be simpler than a shell loop:

```bash
find . -type f -name "*.txt" -exec chmod 640 -- {} +
```

---

## 17. Real-World Log-Cleanup Script

```bash
#!/bin/bash

# Title: Safe Log Cleanup
# Usage: bash cleanup_logs.sh LOG_DIRECTORY RETENTION_DAYS

set -Eeuo pipefail

log_directory="${1:-}"
retention_days="${2:-}"

if [[ -z "$log_directory" || -z "$retention_days" ]]; then
    echo "Usage: $0 LOG_DIRECTORY RETENTION_DAYS" >&2
    exit 1
fi

if [[ ! -d "$log_directory" ]]; then
    echo "Error: directory not found: $log_directory" >&2
    exit 1
fi

if [[ ! -r "$log_directory" ]]; then
    echo "Error: directory is not readable: $log_directory" >&2
    exit 1
fi

if [[ ! "$retention_days" =~ ^[0-9]+$ ]]; then
    echo "Error: retention days must be a non-negative whole number." >&2
    exit 1
fi

echo "Log files selected for deletion:"

find "$log_directory" \
    -type f \
    -name "*.log" \
    -mtime "+$retention_days" \
    -print

echo
read -r -p "Delete these files? Enter yes to continue: " answer

if [[ "$answer" == "yes" ]]; then
    find "$log_directory" \
        -type f \
        -name "*.log" \
        -mtime "+$retention_days" \
        -delete

    echo "Cleanup completed."
else
    echo "Cleanup cancelled."
fi

exit 0
```

### Script workflow

1. Receives a log directory and retention period.
2. Confirms that both arguments were supplied.
3. Confirms that the directory exists and is readable.
4. Validates the retention period with a digits-only regular expression.
5. Displays the files selected for deletion.
6. Requests explicit confirmation.
7. Deletes only when the user enters exactly `yes`.
8. Returns a clear exit status.

### Example

```bash
bash cleanup_logs.sh /var/tmp/application-logs 30
```

This targets `.log` files whose modification age is more than 30 complete 24-hour periods.

---

## 18. Common Mistakes

### Mistake 1: Leaving the pattern unquoted

```bash
find . -name *.txt
```

Correct:

```bash
find . -name "*.txt"
```

### Mistake 2: Using command substitution for filenames

```bash
for file in $(find . -type f)
```

Use `-print0` with a null-separated loop or use `-exec` instead.

### Mistake 3: Forgetting the starting path

Incorrect:

```bash
find -name "*.log"
```

GNU `find` may accept some omitted-path forms, but portable and readable scripts should supply the starting path explicitly:

```bash
find . -name "*.log"
```

### Mistake 4: Confusing `-mtime` with calendar dates

`-mtime` uses rounded 24-hour age periods. For precise timestamps, investigate GNU `find` options such as `-newermt` or compare against reference files.

### Mistake 5: Deleting without previewing

Always run the same expression with `-print` before replacing it with `-delete`.

### Mistake 6: Ignoring permissions errors

When searching protected directories, `find` may report `Permission denied` on `stderr`. Do not automatically hide those errors unless the script intentionally accepts incomplete results.

### Mistake 7: Incorrect OR grouping

Use escaped parentheses when combining alternatives:

```bash
find . -type f \( -name "*.txt" -o -name "*.md" \)
```

---

## 19. Quick Reference

| Task | Command |
|---|---|
| Find all regular files | `find . -type f` |
| Find all directories | `find . -type d` |
| Find shell scripts | `find . -type f -name "*.sh"` |
| Ignore filename case | `find . -type f -iname "*.txt"` |
| Find symbolic links | `find . -type l` |
| Search current level only | `find . -maxdepth 1 -type f` |
| Find empty files | `find . -type f -empty` |
| Find empty directories | `find . -type d -empty` |
| Find files larger than 100 MiB | `find . -type f -size +100M` |
| Modified recently | `find . -type f -mtime -7` |
| Older files | `find . -type f -mtime +30` |
| Modified in last 30 minutes | `find . -type f -mmin -30` |
| Find files owned by `khalid` | `find . -type f -user khalid` |
| Match `.txt` or `.md` | `find . -type f \( -name "*.txt" -o -name "*.md" \)` |
| Exclude `.txt` files | `find . -type f ! -name "*.txt"` |
| Run a command efficiently | `find . -type f -exec ls -l -- {} +` |
| Preview deletion | `find . -type f -name "*.tmp" -print` |
| Delete matches | `find . -type f -name "*.tmp" -delete` |
| Produce null-separated output | `find . -type f -print0` |

---

## 20. Summary

The `find` command is one of the most useful tools for Linux administration and shell scripting. Its basic structure is:

```bash
find PATH TESTS ACTIONS
```

A reliable `find` command should clearly define:

1. Where the search begins
2. Which paths should match
3. What action should be performed

Important habits:

- Quote wildcard patterns such as `"*.log"`.
- Quote variable expansions such as `"$directory"`.
- Use `-type f` or `-type d` when the object type matters.
- Group OR expressions using `\(` and `\)`.
- Prefer `-exec ... {} +` when an external command accepts multiple paths.
- Use `-print0` and a null-separated loop for safe Bash processing.
- Preview results before any destructive action.

The most important safety rule is:

> Always verify the starting path and preview the complete result set before using `-delete` or a destructive `-exec` command.
