# Linux `find` Command — Six-Question Flow Lab

## Student Lab

### Scenario

You are a junior Linux administrator supporting a small application server. The application workspace contains current and archived logs, scripts, configuration files, reports, cache files, empty items, and a symbolic link.

Your job is to inspect the supplied data, identify important files, generate an audit report, and perform a controlled cleanup.

The six questions form one continuous workflow. Complete them in order because later questions use knowledge and output from earlier questions.

## Learning Objectives

By completing this lab, you will practise:

- Selecting safe starting paths
- Searching by name and file type
- Limiting search depth
- Filtering by size, age, and empty status
- Combining tests with AND, OR, and NOT
- Using `-exec` efficiently
- Processing unusual filenames safely
- Previewing and controlling destructive actions

## Estimated Time

45–60 minutes

## Rules

1. Work only inside the supplied `find-lab-data` directory.
2. Do not use `sudo`.
3. Quote all variables and wildcard patterns.
4. Do not use `for file in $(find ...)`.
5. Preview every destructive selection with `-print`.
6. Do not delete anything before Question 6.
7. Save the commands you use in `student-commands.txt`.

## Start the Lab

From the package directory:

```bash
cd supplied-data/find-lab-data
pwd
```

Create your command record:

```bash
touch student-commands.txt
```

You should use the current lab directory as your starting point whenever practical:

```bash
find . ...
```

## Supplied Data Overview

The dataset contains these categories:

| Area | Purpose |
|---|---|
| `logs/current/` | Current application logs |
| `logs/archive/` | Older logs, including uppercase extensions and an empty log |
| `scripts/` | Bash scripts, including a filename containing spaces |
| `configs/` | Application configuration files |
| `reports/` | Text and Markdown reports |
| `cache/` | Temporary files and one file that must be kept |
| `empty-directory/` | An intentionally empty directory |
| `links/` | A symbolic link pointing to a current log |

Some files have intentionally old modification times. One log file is larger than 1 MiB, and several pathnames contain spaces.

---

## Question 1 — Build the Initial Inventory

The first step in an investigation is to understand the environment without changing it.

Write and run `find` commands that:

1. Display every item under the current lab directory.
2. Display only regular files.
3. Display only directories.
4. Display only symbolic links.
5. Search only the current level using `-maxdepth 1`.

Then record:

- Total number of regular files
- Total number of directories
- Total number of symbolic links
- The pathname and target of the symbolic link

### Required evidence

Append your final commands and counts to:

```text
student-commands.txt
```

### Checkpoint

Before continuing, confirm that your commands correctly distinguish regular files, directories, and symbolic links.

---

## Question 2 — Locate Scripts, Logs, and Documents

Now identify files according to their names and extensions.

Write `find` commands that:

1. Find every `.sh` regular file.
2. Find every log file regardless of whether the extension is `.log` or `.LOG`.
3. Find every file whose name begins with `daily`.
4. Find `.conf` files only inside the `configs` directory.
5. Find regular files located directly inside `scripts` without descending further.

### Required thinking

Explain in two or three sentences:

- Why should patterns such as `"*.sh"` be quoted?
- Why is `-iname` useful for the supplied logs?

Append your explanation to `student-commands.txt`.

### Checkpoint

Your script search must correctly handle the file named `daily report.sh` as one pathname.

---

## Question 3 — Audit Size, Age, and Empty Items

Operations teams often need to identify large files, old files, and empty artifacts.

Write `find` commands that:

1. Find regular files larger than 1 MiB.
2. Find regular files modified more than 30 complete 24-hour periods ago.
3. Find regular files modified within approximately the last seven days.
4. Find empty regular files.
5. Find empty directories.

### Required output

Create a file named:

```text
audit-summary.txt
```

It must contain these headings:

```text
=== LARGE FILES ===
=== OLD FILES ===
=== EMPTY FILES ===
=== EMPTY DIRECTORIES ===
```

Place the matching pathnames under the correct headings.

### Checkpoint

Use `ls -lh` and `stat` on selected results to verify that the size and modification-time filters are working as intended.

---

## Question 4 — Build Precise Logical Expressions

The initial audit is complete. Now create more precise searches by combining conditions.

Write a single `find` command for each requirement:

1. Find regular files ending in `.txt` **or** `.md`.
2. Find log files case-insensitively, but exclude empty files.
3. Find files inside `logs` that are either older than 30 days **or** larger than 1 MiB.
4. Find regular files that do **not** end in `.conf`.
5. Find `.tmp` files only inside `cache`.

### Required thinking

In `student-commands.txt`, explain:

- Why escaped parentheses are required around OR expressions
- Why `-type f` should apply to the complete `.txt` or `.md` expression
- What `!` does in a `find` expression

### Checkpoint

Run each command first with `-print`. Check that no directory is accidentally included when the requirement says regular files.

---

## Question 5 — Perform Safe Actions and Create a Report

You now need to gather detailed information and safely process each result.

### Part A — Efficient `-exec`

Use `find` with `-exec ... {} +` to display long-format information for every `.sh` file.

Then explain the practical difference between:

```bash
-exec command {} \;
```

and:

```bash
-exec command {} +
```

### Part B — Safe filename loop

Create a Bash script named:

```text
build-file-report.sh
```

The script must:

1. Use `#!/bin/bash`.
2. Use `set -Eeuo pipefail`.
3. Accept the search directory as `$1`.
4. Validate that the argument is a readable directory.
5. Use `find ... -print0`.
6. Read results using `while IFS= read -r -d '' file`.
7. Write one line per regular file to `file-report.txt`.
8. Include the pathname and human-readable size on each line.
9. Correctly process filenames containing spaces.

Run the script against the current lab directory.

### Required verification

```bash
bash -n build-file-report.sh
bash build-file-report.sh .
```

Inspect the report and confirm that pathnames containing spaces remain intact.

---

## Question 6 — Controlled Cache Cleanup

The final stage is to remove obsolete `.tmp` files without touching `keep.txt` or anything outside `cache`.

Create a script named:

```text
cleanup-cache.sh
```

The script must support two modes:

```bash
bash cleanup-cache.sh cache
bash cleanup-cache.sh cache --apply
```

### Dry-run mode

When `--apply` is not supplied, the script must:

1. Validate that the target is an existing, readable directory.
2. Refuse `/`, `$HOME`, and an empty target.
3. Find only regular files ending in `.tmp` inside the target.
4. Display every selected pathname.
5. Display `Dry run: no files were deleted.`
6. Exit successfully.

### Apply mode

When `--apply` is supplied, the script must:

1. Run the same validated selection.
2. Ask the user to enter exactly `yes`.
3. Delete matching regular files only after confirmation.
4. Leave `cache/keep.txt` untouched.
5. Print a completion or cancellation message.

### Required test flow

Run these checks in order:

```bash
bash -n cleanup-cache.sh
bash cleanup-cache.sh cache
find cache -maxdepth 1 -type f -print
bash cleanup-cache.sh cache --apply
find cache -maxdepth 1 -type f -print
```

### Final evidence

Submit:

- `student-commands.txt`
- `audit-summary.txt`
- `build-file-report.sh`
- `file-report.txt`
- `cleanup-cache.sh`
- The final `find cache -maxdepth 1 -type f -print` output

---

## Completion Checklist

- [ ] Question 1 inventory completed
- [ ] Question 2 name searches completed
- [ ] Question 3 audit report created
- [ ] Question 4 logical expressions verified
- [ ] Question 5 safe report script passed `bash -n`
- [ ] Question 6 cleanup script passed dry-run and apply tests
- [ ] `keep.txt` still exists
- [ ] All required files are ready for submission

## Assessment Guide

| Area | Marks |
|---|---:|
| Question 1 — Inventory | 10 |
| Question 2 — Names and depth | 15 |
| Question 3 — Size, age, and empty items | 15 |
| Question 4 — Logical expressions | 20 |
| Question 5 — Safe actions and reporting | 20 |
| Question 6 — Controlled cleanup | 20 |
| **Total** | **100** |

## Safety Reminder

The cleanup exercise is designed only for the supplied lab data. Never test deletion logic against a real system directory until the selection has been thoroughly validated and reviewed.

