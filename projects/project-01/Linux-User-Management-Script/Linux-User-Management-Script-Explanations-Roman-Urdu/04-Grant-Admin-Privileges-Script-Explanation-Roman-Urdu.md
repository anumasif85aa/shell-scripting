# `03-grant_admin_privileges.sh` — Admin Privileges ki Roman Urdu Explanation

## Table of Contents

- [1. Script ka Maqsad](#1-script-ka-maqsad)
- [2. Complete Script](#2-complete-script)
- [3. Admin Group Detect Karna](#3-admin-group-detect-karna)
- [4. User Check](#4-user-check)
- [5. Existing Groups Read Karna](#5-existing-groups-read-karna)
- [6. Membership Test](#6-membership-test)
- [7. Approval Lena](#7-approval-lena)
- [8. Privileges Grant Karna](#8-privileges-grant-karna)
- [9. New Login Kyun Chahiye](#9-new-login-kyun-chahiye)
- [10. Security Notes](#10-security-notes)
- [11. Example Run](#11-example-run)
- [12. Key Lessons](#12-key-lessons)

## 1. Script ka Maqsad

Yeh script existing users ko optionally system ke standard administrative group mein add karti hai:

- Ubuntu/Debian family mein aam tor par `sudo`.
- RHEL, AlmaLinux, Rocky Linux aur related systems mein aam tor par `wheel`.

Har user ke liye separate approval mangi jati hai.

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

## 3. Admin Group Detect Karna

```bash
if getent group sudo &> /dev/null; then
    admin_group="sudo"
elif getent group wheel &> /dev/null; then
    admin_group="wheel"
```

`getent group NAME` configured group database mein group search karta hai. Script pehle `sudo`, phir `wheel` check karti hai.

Output ki zaroorat nahin, sirf command status chahiye; is liye `&> /dev/null` use hua hai. Dono groups missing hon to script policy invent karne ki bajaye safely ruk jati hai.

## 4. User Check

```bash
if ! id "$username" &> /dev/null; then
```

Missing account ko `usermod` dene se pehle detect karta hai. Missing user warning ke saath skip hota hai aur loop next account process karta hai.

## 5. Existing Groups Read Karna

```bash
user_groups=" $(id -nG "$username") "
```

`id -nG` user ke tamam group names print karta hai.

Example:

```text
ali users developers sudo
```

Expression output ke start aur end mein aik space add karta hai. Yeh boundary spaces exact group-name match mein help karti hain.

## 6. Membership Test

```bash
if [[ "$user_groups" == *" $admin_group "* ]]; then
```

Yeh pattern admin group ko spaces ke darmiyan search karta hai. Is se `sudo` ko `sudoers-training` jaise longer group name ke andar ghalti se match nahin kiya jata.

Membership already ho to `continue` unnecessary modification skip karta hai.

## 7. Approval Lena

```bash
read -r -p "Grant administrative privileges to $username? [y/N]: " answer
```

Admin access sensitive hai, is liye explicit Yes required hai. Enter press karna default No select karta hai. `case` accepted Yes forms ko approve karta hai aur tamam doosre responses ko No treat karta hai.

## 8. Privileges Grant Karna

```bash
usermod -aG "$admin_group" "$username"
```

| Hissa | Matlab |
|---|---|
| `usermod` | Existing user account modify karta hai. |
| `-a` | Group ko existing supplementary groups ke saath append karta hai. |
| `-G` | Supplementary group specify karta hai. |
| `"$admin_group"` | Detected `sudo` ya `wheel` group. |
| `"$username"` | Target account. |

### `-aG` Dono Kyun Zaroori Hain?

Sirf `-G` use karna user ki existing supplementary group list replace kar sakta hai. `-aG` naya group append karta hai aur purani memberships preserve karta hai.

## 9. New Login Kyun Chahiye

Group memberships aam tor par login session start hote waqt load hoti hain. Pehle se running shell purani list rakh sakti hai.

User sign out aur sign in kare, phir verify kare:

```bash
id -nG apple
```

## 10. Security Notes

Administrative membership user ko complete system control de sakti hai. Is liye:

- Sirf trusted accounts ko grant karein.
- Principle of least privilege follow karein.
- Memberships regularly review karein.
- Full admin ki zaroorat na ho to command-specific sudo policy prefer karein.
- Automatically unrestricted `NOPASSWD:ALL` create na karein.

Script sirf group membership deti hai; actual sudo behavior system ki sudo configuration par depend karta hai.

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

New login ke baad verify karein:

```bash
id -nG ali
sudo -l -U ali
```

## 12. Key Lessons

- `getent` configured account/group databases query karta hai.
- Distribution convention detect karein; sirf aik group hardcode na karein.
- Modification se pehle existing membership check karein.
- Group append karte waqt `usermod -aG` use karein.
- Sensitive privileges ke liye explicit approval lein.
- New membership use karne ke liye aam tor par new login chahiye.
