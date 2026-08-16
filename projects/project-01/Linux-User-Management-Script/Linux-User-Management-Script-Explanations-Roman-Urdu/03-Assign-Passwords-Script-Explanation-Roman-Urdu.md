# `02-assign_passwords.sh` — Password Assignment ki Roman Urdu Explanation

## Table of Contents

- [1. Script ka Maqsad](#1-script-ka-maqsad)
- [2. Complete Script](#2-complete-script)
- [3. Initial Validation](#3-initial-validation)
- [4. Account Check](#4-account-check)
- [5. Confirmation Read Karna](#5-confirmation-read-karna)
- [6. Case Statement](#6-case-statement)
- [7. Secure Password Assignment](#7-secure-password-assignment)
- [8. Skip aur Failure Behavior](#8-skip-aur-failure-behavior)
- [9. Example Run](#9-example-run)
- [10. Key Lessons](#10-key-lessons)

## 1. Script ka Maqsad

Yeh script existing Linux users ke passwords set ya reset karti hai. Har account ke liye pehle confirmation leti hai, phir standard `passwd` command use karti hai.

Password variable, command-line argument ya script file mein store nahin hota.

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

## 3. Initial Validation

Script do initial checks karti hai:

```bash
if [[ "$EUID" -ne 0 ]]; then
```

Password change karne ke liye controller workflow ko root privileges chahiye.

```bash
if [[ "$#" -eq 0 ]]; then
```

Koi username argument na mile to usage show hoti hai aur script failure status ke saath rukti hai.

## 4. Account Check

```bash
if ! id "$username" &> /dev/null; then
```

- `id` check karta hai ke account exist karta hai ya nahin.
- `&> /dev/null` normal aur error output dono hide karta hai.
- `!` result reverse karta hai.
- Account missing ho to warning show hoti hai aur `continue` next username par le jata hai.

Is check ke baghair `passwd` missing user par unnecessary error de ga.

## 5. Confirmation Read Karna

```bash
read -r -p "Set or reset the password for $username? [y/N]: " answer
```

| Hissa | Matlab |
|---|---|
| `read` | User se input leta hai. |
| `-r` | Backslash ko escape character ki tarah interpret nahin karta. |
| `-p` | Input se pehle prompt show karta hai. |
| `answer` | User ka jawab is variable mein save hota hai. |
| `[y/N]` | Default jawab No hai. |

`if ! read ...` EOF ya input failure ko detect karta hai. Aisi surat mein script `exit 1` karti hai.

## 6. Case Statement

```bash
case "$answer" in
    y|Y|yes|YES|Yes)
```

Pipe `|` ka matlab yahan multiple accepted patterns hai. In mein se koi bhi match ho to password block run hota hai.

```bash
*)
```

`*` default pattern hai. Enter, `n`, `no`, ya koi unknown jawab password action skip kar deta hai. Sensitive action ke liye safe default **No** rakhna achi practice hai.

## 7. Secure Password Assignment

```bash
passwd "$username"
```

`passwd` terminal par password securely mangta hai. Type karte waqt characters screen par show nahin hote.

Yeh approaches avoid karein:

```bash
password="Secret123"
echo "$password" | passwd username
```

Plaintext password script, history, process information ya logs mein expose ho sakta hai. Interactive learning script ke liye direct `passwd` safer hai.

## 8. Skip aur Failure Behavior

| Situation | Behavior |
|---|---|
| User missing | Account skip, loop continue. |
| Answer No/Enter | Password skip, loop continue. |
| `read` fail | Script `exit 1`. |
| `passwd` fail | Script `exit 1`. |
| Tamam requested actions complete | Script `exit 0`. |

User ka No kehna error nahin hai. Lekin approved password operation ka fail hona critical error hai.

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
passwd: password updated successfully
Password updated successfully: ali
Set or reset the password for sara? [y/N]:
Skipped password assignment: sara
```

Password ki actual value output ya script mein show nahin hoti.

## 10. Key Lessons

- Password operation se pehle account existence check karein.
- `read -r -p` se clear interactive confirmation lein.
- `case` multiple accepted answers ko cleanly handle karta hai.
- Sensitive action ka default No rakhein.
- Plaintext passwords ko variables ya scripts mein store na karein.
- `passwd` ka status check karke failure controller tak pohanchayein.
