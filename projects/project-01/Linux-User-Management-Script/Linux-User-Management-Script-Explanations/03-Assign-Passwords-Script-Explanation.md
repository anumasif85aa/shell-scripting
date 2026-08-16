# `02-assign_passwords.sh` — Password Assignment Explanation

## Table of Contents

- [1. Purpose](#1-purpose)
- [2. Complete Script](#2-complete-script)
- [3. Initial Validation](#3-initial-validation)
- [4. Checking Each Account](#4-checking-each-account)
- [5. Reading Confirmation](#5-reading-confirmation)
- [6. Understanding the Case Statement](#6-understanding-the-case-statement)
- [7. Secure Password Assignment](#7-secure-password-assignment)
- [8. Skip and Failure Behavior](#8-skip-and-failure-behavior)
- [9. Example Run](#9-example-run)
- [10. Key Lessons](#10-key-lessons)

---

## 1. Purpose

This script receives usernames and asks whether the administrator wants to set or reset each password. Approved changes are performed by the standard `passwd` command.

---

## 2. Complete Script

```bash
#!/bin/bash

# Title: Assign Linux User Passwords
# Purpose: Securely set or reset passwords through the passwd command.

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
    if ! id "$username" &> /dev/null; then
        echo "Skipped: user does not exist: $username" >&2
        continue
    fi

    if ! read -r -p "Set or reset the password for $username? [y/N]: " answer; then
        echo >&2
        echo "Error: could not read the response." >&2
        exit 1
    fi

    case "$answer" in
        y|Y|yes|YES|Yes)
            echo "Enter the new password for $username when prompted."

            if passwd "$username"; then
                echo "Password updated successfully: $username"
            else
                echo "Error: password update failed: $username" >&2
                exit 1
            fi
            ;;
        *)
            echo "Skipped password assignment: $username"
            ;;
    esac
done

exit 0
```

---

## 3. Initial Validation

The script first requires root privileges and at least one username.

```bash
[[ "$EUID" -ne 0 ]]
```

checks whether the process is not root.

```bash
[[ "$#" -eq 0 ]]
```

checks whether no arguments were provided.

---

## 4. Checking Each Account

```bash
if ! id "$username" &> /dev/null; then
```

`id` succeeds when the account exists. `!` reverses the result, so the block runs when the account is missing.

```bash
continue
```

skips password handling for the missing user and moves to the next argument.

---

## 5. Reading Confirmation

```bash
read -r -p "Set or reset the password for $username? [y/N]: " answer
```

| Part | Meaning |
|---|---|
| `read` | Reads input from stdin. |
| `-r` | Preserves backslashes literally. |
| `-p` | Displays the prompt before reading. |
| `answer` | Stores the administrator's response. |

The command is tested with `if ! read ...`. Input can fail, for example, if stdin is closed. That is treated as a critical interaction error.

`[y/N]` shows that No is the default.

---

## 6. Understanding the Case Statement

```bash
case "$answer" in
    y|Y|yes|YES|Yes)
        commands
        ;;
    *)
        other_commands
        ;;
esac
```

| Pattern | Meaning |
|---|---|
| `y|Y|yes|YES|Yes` | Any listed approval value |
| `*` | Every other response, including empty input |
| `;;` | Ends the selected branch |
| `esac` | Closes the `case` statement |

Because every unrecognized answer goes to `*`, the safe default is to skip the password change.

---

## 7. Secure Password Assignment

```bash
passwd "$username"
```

`passwd` securely prompts for the new password and confirmation. The typed password is not displayed.

This is safer than:

- Hardcoding passwords in the script.
- Passing plaintext passwords as command-line arguments.
- Saving passwords in shell history.

The `if` checks whether `passwd` completed successfully before printing the success message.

---

## 8. Skip and Failure Behavior

These are noncritical skips:

- The account does not exist.
- The administrator answers No or presses Enter.

The script continues to the next username.

These are critical failures:

- Input cannot be read.
- `passwd` fails.

The script returns status `1`, allowing the controller to stop the workflow.

---

## 9. Example Run

```bash
sudo bash 02-assign_passwords.sh ali sara
```

Possible interaction:

```text
Set or reset the password for ali? [y/N]: y
Enter the new password for ali when prompted.
New password:
Retype new password:
Password updated successfully: ali
Set or reset the password for sara? [y/N]:
Skipped password assignment: sara
```

---

## 10. Key Lessons

- Use `passwd` for interactive password changes.
- Never store plaintext passwords in scripts.
- Use `read -r -p` for interactive confirmation.
- Use `case` when several textual answers are acceptable.
- Use a safe No default for sensitive actions.
- Distinguish an intentional skip from a critical failure.

