# `00-manage_users.sh` — Main Controller Explanation

## Table of Contents

- [1. Purpose](#1-purpose)
- [2. Complete Script](#2-complete-script)
- [3. Username Array](#3-username-array)
- [4. Root Check](#4-root-check)
- [5. Locating the Script Directory](#5-locating-the-script-directory)
- [6. Calling the Child Scripts](#6-calling-the-child-scripts)
- [7. Error Propagation](#7-error-propagation)
- [8. Successful Completion](#8-successful-completion)
- [9. Execution Example](#9-execution-example)
- [10. Key Lessons](#10-key-lessons)

---

## 1. Purpose

`00-manage_users.sh` is the main controller. It does not create accounts directly. Instead, it:

1. Defines the usernames.
2. Verifies root privileges.
3. Finds the other scripts reliably.
4. Calls each child script in order.
5. Stops if a critical stage fails.

---

## 2. Complete Script

```bash
#!/bin/bash

# Title: Modular Linux User Management
# Purpose: Call separate scripts to create users, assign passwords,
#          and optionally grant administrative privileges.

usernames=("apple" "banana" "mango" "orange" "red_cherry")

if [[ "$EUID" -ne 0 ]]; then
    echo "Error: run this script with sudo or as root." >&2
    exit 1
fi

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)

echo "Step 1: Creating user accounts"

if ! bash "$script_dir/01-create_users.sh" "${usernames[@]}"; then
    echo "Error: the user-creation step failed." >&2
    exit 1
fi

echo
echo "Step 2: Assigning passwords"

if ! bash "$script_dir/02-assign_passwords.sh" "${usernames[@]}"; then
    echo "Error: the password-assignment step failed." >&2
    exit 1
fi

echo
echo "Step 3: Asking about administrative privileges"

if ! bash "$script_dir/03-grant_admin_privileges.sh" "${usernames[@]}"; then
    echo "Error: the privilege-management step failed." >&2
    exit 1
fi

echo
echo "All requested user-management steps are complete."
exit 0
```

---

## 3. Username Array

```bash
usernames=("apple" "banana" "mango" "orange" "red_cherry")
```

This creates an indexed Bash array containing five usernames.

The child scripts receive every element through:

```bash
"${usernames[@]}"
```

The quotes preserve the array elements as separate arguments.

---

## 4. Root Check

```bash
if [[ "$EUID" -ne 0 ]]; then
```

- `EUID` is the effective user ID.
- Root has effective UID `0`.
- `-ne` means “not numerically equal.”

The condition means:

> If the current process is not running as root, execute the error block.

```bash
echo "Error: run this script with sudo or as root." >&2
exit 1
```

The message goes to stderr, and status `1` reports failure.

---

## 5. Locating the Script Directory

```bash
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
```

This important line finds the absolute directory containing the controller.

| Part | Meaning |
|---|---|
| `${BASH_SOURCE[0]}` | Path used to load the current Bash script. |
| `dirname -- ...` | Removes the filename and returns its directory portion. |
| `cd -- ...` | Changes to that directory inside command substitution. |
| `&& pwd` | Prints the absolute directory only if `cd` succeeds. |
| `$(...)` | Captures the output in `script_dir`. |

Why is it useful? The controller can locate its child scripts even when it is launched from another working directory.

---

## 6. Calling the Child Scripts

Example:

```bash
bash "$script_dir/01-create_users.sh" "${usernames[@]}"
```

This starts a new Bash process for the child script and passes all usernames as arguments.

The complete order is:

```text
01-create_users.sh
02-assign_passwords.sh
03-grant_admin_privileges.sh
```

Account creation comes first because passwords and privileges can only be assigned to accounts that exist.

---

## 7. Error Propagation

```bash
if ! bash "$script_dir/01-create_users.sh" "${usernames[@]}"; then
```

`!` reverses the child script's status for the `if` condition:

| Child status | Meaning | Result after `!` | Controller action |
|---:|---|---|---|
| `0` | Success | False | Continue |
| Nonzero | Failure | True | Run error block |

The controller then reports the failed stage and exits:

```bash
echo "Error: the user-creation step failed." >&2
exit 1
```

This prevents later stages from running after a critical failure.

---

## 8. Successful Completion

```bash
echo "All requested user-management steps are complete."
exit 0
```

This point is reached only when all three child scripts return status `0`.

---

## 9. Execution Example

Run:

```bash
sudo bash 00-manage_users.sh
```

Possible flow:

```text
Step 1: Creating user accounts
User created successfully: apple
...

Step 2: Assigning passwords
Set or reset the password for apple? [y/N]:
...

Step 3: Asking about administrative privileges
Grant administrative privileges to apple? [y/N]:
...
```

---

## 10. Key Lessons

- Use arrays to manage multiple values.
- Use `"${array[@]}"` to pass array elements safely.
- Use `BASH_SOURCE` to find related scripts reliably.
- Use child exit statuses to control the parent workflow.
- Stop the workflow when a critical stage fails.

