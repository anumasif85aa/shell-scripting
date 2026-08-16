# `01-create_users.sh` — Create Users Explanation

## Table of Contents

- [1. Purpose](#1-purpose)
- [2. Complete Script](#2-complete-script)
- [3. Root and Argument Checks](#3-root-and-argument-checks)
- [4. Processing All Arguments](#4-processing-all-arguments)
- [5. Username Validation](#5-username-validation)
- [6. Existing-User Check](#6-existing-user-check)
- [7. Creating the Account](#7-creating-the-account)
- [8. Success and Failure](#8-success-and-failure)
- [9. Example Runs](#9-example-runs)
- [10. Key Lessons](#10-key-lessons)

---

## 1. Purpose

This script accepts one or more usernames, validates them, skips accounts that already exist, and creates missing accounts with home directories and Bash login shells.

---

## 2. Complete Script

```bash
#!/bin/bash

# Title: Create Linux Users
# Purpose: Create local users and their home directories.

if [[ "$EUID" -ne 0 ]]; then
    echo "Error: this script requires root privileges." >&2
    exit 1
fi

if [[ "$#" -eq 0 ]]; then
    echo "Usage: $0 USERNAME [USERNAME ...]" >&2
    exit 1
fi

for username in "$@"
do
    if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
        echo "Error: invalid username: $username" >&2
        exit 1
    fi

    if id "$username" &> /dev/null; then
        echo "Skipped: user already exists: $username"
        continue
    fi

    if useradd -m -s /bin/bash "$username"; then
        echo "User created successfully: $username"
    else
        echo "Error: could not create user: $username" >&2
        exit 1
    fi
done

exit 0
```

---

## 3. Root and Argument Checks

Root check:

```bash
if [[ "$EUID" -ne 0 ]]; then
```

`useradd` modifies system account files, so administrative authority is required.

Argument-count check:

```bash
if [[ "$#" -eq 0 ]]; then
```

- `$#` is the number of arguments.
- `-eq 0` means numerically equal to zero.

If no username is received, the script prints:

```text
Usage: 01-create_users.sh USERNAME [USERNAME ...]
```

---

## 4. Processing All Arguments

```bash
for username in "$@"
```

Quoted `"$@"` expands every argument as a separate item.

Run:

```bash
sudo bash 01-create_users.sh ali sara omar
```

Loop values:

```text
First iteration  -> ali
Second iteration -> sara
Third iteration  -> omar
```

---

## 5. Username Validation

```bash
if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
```

This uses a regular expression.

| Regex part | Meaning |
|---|---|
| `^` | Start of the value |
| `[a-z_]` | First character must be lowercase or underscore |
| `[a-z0-9_-]*` | Remaining characters may be lowercase letters, digits, underscores, or hyphens |
| `$` | End of the value |
| `!` | Reject values that do not match |

Examples:

| Username | Accepted? |
|---|---|
| `ali` | Yes |
| `red_cherry` | Yes |
| `user-2` | Yes |
| `Red` | No |
| `2user` | No |
| `red cherry` | No |

Note: distributions can impose additional username policies or length limits. The regex is a simple classroom validation rule.

---

## 6. Existing-User Check

```bash
if id "$username" &> /dev/null; then
```

`id` returns status `0` if the account exists. Its stdout and stderr are discarded because the script needs only the status.

```bash
echo "Skipped: user already exists: $username"
continue
```

`continue` skips the remaining commands for the current username and starts the next loop iteration.

---

## 7. Creating the Account

```bash
useradd -m -s /bin/bash "$username"
```

| Part | Meaning |
|---|---|
| `useradd` | Creates the local account. |
| `-m` | Creates the user's home directory. |
| `-s /bin/bash` | Sets Bash as the login shell. |
| `"$username"` | Supplies the validated username. |

For `ali`, the account normally receives a home directory such as `/home/ali`.

---

## 8. Success and Failure

```bash
if useradd ...; then
```

The `if` checks `useradd` directly:

- Status `0`: print success.
- Nonzero status: send an error to stderr and exit.

The script stops on a real creation failure so the controller does not proceed as though all accounts are ready.

---

## 9. Example Runs

Create accounts:

```bash
sudo bash 01-create_users.sh ali sara
```

Possible output:

```text
User created successfully: ali
User created successfully: sara
```

Run again:

```text
Skipped: user already exists: ali
Skipped: user already exists: sara
```

Verify:

```bash
id ali
getent passwd ali
ls -ld /home/ali
```

---

## 10. Key Lessons

- `$#` counts arguments.
- `"$@"` preserves all arguments separately.
- `=~` performs a regex match inside `[[ ... ]]`.
- Command status can be used without displaying command output.
- `continue` skips only the current iteration.
- `useradd -m -s /bin/bash` creates a user, home, and Bash shell.

