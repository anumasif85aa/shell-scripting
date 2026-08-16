# Linux `find` Command — Six-Question Flow Lab Solutions

## Instructor Answer Guide

These solutions assume the student begins with a clean copy of the supplied `find-lab-data` directory.

> Student-created files such as `student-commands.txt`, `audit-summary.txt`, and solution scripts will increase later file counts. The initial expected counts apply only before those files are created.

## Table of Contents

1. [Question 1 — Initial Inventory](#question-1--initial-inventory)
2. [Question 2 — Scripts, Logs, and Documents](#question-2--scripts-logs-and-documents)
3. [Question 3 — Size, Age, and Empty Items](#question-3--size-age-and-empty-items)
4. [Question 4 — Logical Expressions](#question-4--logical-expressions)
5. [Question 5 — Safe Actions and Reporting](#question-5--safe-actions-and-reporting)
6. [Question 6 — Controlled Cache Cleanup](#question-6--controlled-cache-cleanup)
7. [Verification Summary](#verification-summary)

---

## Question 1 — Initial Inventory

### 1. Display every item

```bash
find . -print
```

`find` includes the starting directory `.` in its output.

### 2. Display regular files

```bash
find . -type f -print
```

### 3. Display directories

```bash
find . -type d -print
```

### 4. Display symbolic links

```bash
find . -type l -print
```

Expected symbolic link:

```text
./links/latest-application.log
```

Display its target:

```bash
find . -type l -exec ls -l -- {} +
```

Expected relationship:

```text
./links/latest-application.log -> ../logs/current/application.log
```

### 5. Search only the current level

```bash
find . -maxdepth 1 -print
```

### Initial counts

Using GNU `find`, print one dot per match and count the bytes:

```bash
regular_files=$(find . -type f -printf '.' | wc -c)
directories=$(find . -type d -printf '.' | wc -c)
symbolic_links=$(find . -type l -printf '.' | wc -c)

echo "Regular files: $regular_files"
echo "Directories: $directories"
echo "Symbolic links: $symbolic_links"
```

Expected clean-dataset result:

```text
Regular files: 19
Directories: 11
Symbolic links: 1
```

The directory count includes the starting directory itself.

---

## Question 2 — Scripts, Logs, and Documents

### 1. Find every `.sh` regular file

```bash
find . -type f -name "*.sh" -print
```

Expected supplied-data matches:

```text
./scripts/backup.sh
./scripts/cleanup.sh
./scripts/daily report.sh
./scripts/tools/health-check.sh
```

### 2. Find log files case-insensitively

```bash
find . -type f -iname "*.log" -print
```

This includes `error-2026-06-15.LOG` because `-iname` ignores letter case.

The symbolic link named `latest-application.log` is not included because `-type f` does not select a symbolic link when `find` is not following links.

### 3. Find names beginning with `daily`

```bash
find . -type f -name "daily*" -print
```

Expected supplied-data matches:

```text
./scripts/daily report.sh
./reports/daily report.txt
```

### 4. Find `.conf` files inside `configs`

```bash
find configs -type f -name "*.conf" -print
```

Expected matches:

```text
configs/application.conf
configs/database.conf
```

### 5. Find files directly inside `scripts`

```bash
find scripts -maxdepth 1 -type f -print
```

This excludes `scripts/tools/health-check.sh` because that file is one level deeper.

### Explanation

The wildcard pattern must be quoted so the shell does not expand it before `find` receives it. `-iname` is useful because the supplied dataset contains both `.log` and uppercase `.LOG` extensions.

---

## Question 3 — Size, Age, and Empty Items

### 1. Files larger than 1 MiB

```bash
find . -type f -size +1M -print
```

Expected match:

```text
./logs/archive/large-debug.log
```

Verify it:

```bash
ls -lh -- ./logs/archive/large-debug.log
```

### 2. Files older than 30 complete days

```bash
find . -type f -mtime +30 -print
```

Expected supplied-data matches include:

```text
./logs/archive/application-2026-06-01.log
./logs/archive/error-2026-06-15.LOG
./logs/archive/empty.log
./logs/archive/large-debug.log
./cache/session-001.tmp
./cache/old session.tmp
```

### 3. Files modified within approximately seven days

```bash
find . -type f -mtime -7 -print
```

The exact list grows after students create their answer files. This is expected.

### 4. Empty regular files

```bash
find . -type f -empty -print
```

Expected initial match:

```text
./logs/archive/empty.log
```

### 5. Empty directories

```bash
find . -type d -empty -print
```

Expected match:

```text
./empty-directory
```

### Create `audit-summary.txt`

```bash
{
    echo "=== LARGE FILES ==="
    find . -type f -size +1M -print

    echo "=== OLD FILES ==="
    find . -type f -mtime +30 -print

    echo "=== EMPTY FILES ==="
    find . -type f -empty -print

    echo "=== EMPTY DIRECTORIES ==="
    find . -type d -empty -print
} > audit-summary.txt
```

Inspect the report:

```bash
cat audit-summary.txt
```

Verify timestamps:

```bash
stat -- ./logs/archive/application-2026-06-01.log
stat -- ./logs/current/application.log
```

---

## Question 4 — Logical Expressions

### 1. Regular `.txt` or `.md` files

```bash
find . -type f \( -name "*.txt" -o -name "*.md" \) -print
```

The escaped parentheses ensure that `-type f` applies to the complete OR expression.

### 2. Non-empty log files, case-insensitively

```bash
find . -type f -iname "*.log" ! -empty -print
```

`! -empty` means the matching file must not be empty.

### 3. Logs older than 30 days or larger than 1 MiB

```bash
find logs -type f \( -mtime +30 -o -size +1M \) -print
```

Both alternative tests are grouped so they remain under the `-type f` requirement.

### 4. Regular files that do not end in `.conf`

```bash
find . -type f ! -name "*.conf" -print
```

### 5. Temporary files inside `cache`

```bash
find cache -type f -name "*.tmp" -print
```

Expected matches:

```text
cache/session-001.tmp
cache/session-002.tmp
cache/old session.tmp
```

`cache/keep.txt` is correctly excluded.

### Explanation

- `\(` and `\)` pass parentheses to `find` rather than allowing the shell to interpret them.
- `-o` means OR.
- Adjacent tests use implicit AND.
- `!` negates the following test.
- Grouping prevents logical-precedence mistakes.

---

## Question 5 — Safe Actions and Reporting

### Part A — Efficient `-exec`

```bash
find . -type f -name "*.sh" -exec ls -lh -- {} +
```

Difference:

| Ending | Behavior |
|---|---|
| `-exec command {} \;` | Runs the command separately for each match |
| `-exec command {} +` | Passes several matches to fewer command executions |

The `+` form is normally more efficient when the called command accepts multiple pathnames.

### Part B — `build-file-report.sh`

Use the supplied solution script:

```bash
#!/bin/bash

set -Eeuo pipefail

search_directory="${1:-}"
output_file="${2:-file-report.txt}"

if [[ -z "$search_directory" ]]; then
    echo "Usage: $0 SEARCH_DIRECTORY [OUTPUT_FILE]" >&2
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

search_absolute=$(realpath -e -- "$search_directory") || exit 1
output_absolute=$(realpath -m -- "$output_file") || exit 1

if [[ -d "$output_file" ]]; then
    echo "Error: output path is a directory: $output_file" >&2
    exit 1
fi

: > "$output_file"

printf '%s\n' "SIZE | PATH" > "$output_file"
printf '%s\n' "-----|-----" >> "$output_file"

while IFS= read -r -d '' file
do
    size_bytes=$(stat -c '%s' -- "$file")
    human_size=$(numfmt --to=iec-i --suffix=B "$size_bytes")
    printf '%s | %s\n' "$human_size" "$file" >> "$output_file"
done < <(
    find "$search_absolute" \
        -type f \
        ! -path "$output_absolute" \
        -print0
)

echo "Report created: $output_file"
exit 0
```

The downloadable script contains fuller error messages around path resolution and output creation.

### Verification

```bash
bash -n build-file-report.sh
bash build-file-report.sh .
cat file-report.txt
```

The report should contain intact entries for:

```text
scripts/daily report.sh
reports/daily report.txt
cache/old session.tmp
```

The script deliberately excludes `file-report.txt` from its own search results.

---

## Question 6 — Controlled Cache Cleanup

Use the supplied `cleanup-cache.sh` solution.

### Syntax check

```bash
bash -n cleanup-cache.sh
```

### Dry run

```bash
bash cleanup-cache.sh cache
```

Expected selection:

```text
cache/session-001.tmp
cache/session-002.tmp
cache/old session.tmp
```

Expected final message:

```text
Dry run: no files were deleted.
```

Verify that all files remain:

```bash
find cache -maxdepth 1 -type f -print
```

### Cancel the apply operation

```bash
printf 'no\n' | bash cleanup-cache.sh cache --apply
```

Expected message:

```text
Cleanup cancelled.
```

No file should be deleted.

### Confirm the apply operation

```bash
printf 'yes\n' | bash cleanup-cache.sh cache --apply
```

The three `.tmp` files are deleted.

### Final verification

```bash
find cache -maxdepth 1 -type f -print
```

Expected supplied-data result:

```text
cache/keep.txt
```

### Safety checks

These calls must fail without deleting anything:

```bash
bash cleanup-cache.sh ""
bash cleanup-cache.sh / --apply
bash cleanup-cache.sh "$HOME" --apply
bash cleanup-cache.sh missing-directory --apply
bash cleanup-cache.sh cache --unknown
```

### Why the solution is safer

- Dry-run is the default mode.
- `--apply` must be supplied explicitly.
- The target must exist and be readable.
- `realpath` resolves symbolic and relative paths before safety comparisons.
- `/` and the home directory are refused.
- Only regular files matching `*.tmp` are selected.
- Apply mode requires the exact word `yes`.
- `keep.txt` cannot match the deletion expression.

---

## Verification Summary

| Requirement | Expected result |
|---|---|
| Clean regular-file count | 19 |
| Clean directory count | 11, including `.` |
| Symbolic-link count | 1 |
| Files larger than 1 MiB | `large-debug.log` |
| Empty regular file | `empty.log` |
| Empty directory | `empty-directory` |
| Case-insensitive log search | Includes uppercase `.LOG` |
| Space-safe processing | All three supplied space-containing names remain intact |
| Cleanup dry run | Deletes nothing |
| Cancelled apply | Deletes nothing |
| Confirmed apply | Deletes three `.tmp` files |
| Protected cache file | `cache/keep.txt` remains |

## Instructor Note

Alternative commands can be correct if they safely produce the required result. Grade students on selection accuracy, quoting, filename safety, validation, explanation, and destructive-action controls—not only on whether their command resembles this guide exactly.
