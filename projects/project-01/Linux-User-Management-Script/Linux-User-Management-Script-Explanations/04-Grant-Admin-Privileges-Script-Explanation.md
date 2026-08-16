# `03-grant_admin_privileges.sh` — Administrative Privileges Explanation

## Table of Contents

- [1. Purpose](#1-purpose)
- [2. Complete Script](#2-complete-script)
- [3. Detecting the Administrative Group](#3-detecting-the-administrative-group)
- [4. Checking the User](#4-checking-the-user)
- [5. Reading Existing Group Membership](#5-reading-existing-group-membership)
- [6. Membership Test](#6-membership-test)
- [7. Asking for Approval](#7-asking-for-approval)
- [8. Granting Privileges](#8-granting-privileges)
- [9. Why a New Login Is Required](#9-why-a-new-login-is-required)
- [10. Security Notes](#10-security-notes)
- [11. Example Run](#11-example-run)
- [12. Key Lessons](#12-key-lessons)

---

## 1. Purpose

This script optionally adds existing users to the Linux system's standard administrative group:

- `sudo` on Ubuntu and Debian-family systems.
- `wheel` on RHEL, AlmaLinux, Rocky Linux, and related systems.

It asks separately before granting privileges to each account.

---

## 2. Complete Script

```bash
#!/bin/bash

# Title: Grant Administrative Privileges
# Purpose: Optionally add users to the system's sudo or wheel group.

if [[ "$EUID" -ne 0 ]]; then
    echo "Error: this script requires root privileges." >&2
    exit 1
fi

if [[ "$#" -eq 0 ]]; then
    echo "Usage: $0 USERNAME [USERNAME ...]" >&2
    exit 1
fi

if getent group sudo &> /dev/null; then
    admin_group="sudo"
elif getent group wheel &> /dev/null; then
    admin_group="wheel"
else
    echo "Error: neither the sudo group nor the wheel group exists." >&2
    exit 1
fi

echo "Administrative group detected: $admin_group"

for username in "$@"
do
    if ! id "$username" &> /dev/null; then
        echo "Skipped: user does not exist: $username" >&2
        continue
    fi

    user_groups=" $(id -nG "$username") "

    if [[ "$user_groups" == *" $admin_group "* ]]; then
        echo "Skipped: $username is already in the $admin_group group"
        continue
    fi

    if ! read -r -p "Grant administrative privileges to $username? [y/N]: " answer; then
        echo >&2
        echo "Error: could not read the response." >&2
        exit 1
    fi

    case "$answer" in
        y|Y|yes|YES|Yes)
            if usermod -aG "$admin_group" "$username"; then
                echo "Administrative privileges granted: $username"
                echo "The user must sign out and sign in again before using the new group membership."
            else
                echo "Error: could not add $username to $admin_group" >&2
                exit 1
            fi
            ;;
        *)
            echo "Administrative privileges not granted: $username"
            ;;
    esac
done

exit 0
```

---

## 3. Detecting the Administrative Group

```bash
if getent group sudo &> /dev/null; then
    admin_group="sudo"
elif getent group wheel &> /dev/null; then
    admin_group="wheel"
```

`getent group NAME` searches the system's configured group database. This can include local files and configured directory services.

The script checks `sudo` first and then `wheel`. It needs only the status, so output is discarded.

If neither group exists, the script stops instead of inventing or modifying a policy.

---

## 4. Checking the User

```bash
if ! id "$username" &> /dev/null; then
```

The missing-user check prevents `usermod` from being called with a nonexistent account. A missing account is skipped, and the loop continues.

---

## 5. Reading Existing Group Membership

```bash
user_groups=" $(id -nG "$username") "
```

`id -nG` prints the names of all groups associated with the user.

Example:

```text
ali users developers sudo
```

The script adds one space before and after the list. These boundary spaces help perform a whole-group-name match.

---

## 6. Membership Test

```bash
if [[ "$user_groups" == *" $admin_group "* ]]; then
```

The pattern checks for the group name surrounded by spaces.

This avoids confusing a group named `sudo` with a longer name such as `sudoers-training`.

If membership already exists:

```bash
continue
```

skips unnecessary modification.

---

## 7. Asking for Approval

```bash
read -r -p "Grant administrative privileges to $username? [y/N]: " answer
```

Privilege elevation is sensitive, so the script requires an explicit affirmative response. Pressing Enter selects the No default.

The `case` statement accepts common forms of Yes and treats every other response as No.

---

## 8. Granting Privileges

```bash
usermod -aG "$admin_group" "$username"
```

| Part | Meaning |
|---|---|
| `usermod` | Modifies an existing user account. |
| `-a` | Appends the user to supplementary groups. |
| `-G` | Specifies the supplementary group list. |
| `"$admin_group"` | Uses the detected `sudo` or `wheel` group. |
| `"$username"` | Identifies the account being modified. |

### Why `-aG` Matters

Using `-G` without `-a` may replace the user's existing supplementary-group list. `-aG` appends the new membership and preserves existing supplementary memberships.

---

## 9. Why a New Login Is Required

Group memberships are normally established when a login session begins. An already-running shell may keep its old group list.

After the change, the user should sign out and sign in again. Then verify:

```bash
id -nG apple
```

---

## 10. Security Notes

Administrative membership can permit complete system control. Therefore:

- Grant it only to trusted accounts.
- Follow the principle of least privilege.
- Review group membership regularly.
- Prefer command-specific sudo policies when full administration is unnecessary.
- Do not automatically create unrestricted `NOPASSWD:ALL` rules.

The script grants ordinary group-based privileges; actual behavior still depends on the system's sudo configuration.

---

## 11. Example Run

```bash
sudo bash 03-grant_admin_privileges.sh ali sara
```

Possible interaction:

```text
Administrative group detected: sudo
Grant administrative privileges to ali? [y/N]: y
Administrative privileges granted: ali
The user must sign out and sign in again before using the new group membership.
Grant administrative privileges to sara? [y/N]:
Administrative privileges not granted: sara
```

Verify after a new login:

```bash
id -nG ali
sudo -l -U ali
```

---

## 12. Key Lessons

- Use `getent` to query configured account databases.
- Detect distribution conventions instead of hardcoding one group.
- Check existing membership before modifying an account.
- Use `usermod -aG`, not `usermod -G`, when appending one group.
- Require explicit approval for sensitive privilege changes.
- New group membership usually requires a new login session.

