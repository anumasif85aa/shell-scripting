# `00-manage_users.sh` — Main Controller ki Roman Urdu Explanation

## Table of Contents

- [1. Script ka Maqsad](#1-script-ka-maqsad)
- [2. Complete Script](#2-complete-script)
- [3. Username Array](#3-username-array)
- [4. Root Check](#4-root-check)
- [5. Script Directory Locate Karna](#5-script-directory-locate-karna)
- [6. Child Scripts Call Karna](#6-child-scripts-call-karna)
- [7. Error Propagation](#7-error-propagation)
- [8. Successful Completion](#8-successful-completion)
- [9. Run Karne ki Example](#9-run-karne-ki-example)
- [10. Key Lessons](#10-key-lessons)

## 1. Script ka Maqsad

Yeh package ki main controller script hai. Yeh khud `useradd`, `passwd` ya `usermod` nahin chalati. Is ka kaam hai:

1. Usernames define karna.
2. Root privileges verify karna.
3. Child scripts ka reliable path banana.
4. Child scripts ko correct order mein call karna.
5. Kisi critical step ke fail hone par workflow rokna.

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

## 3. Username Array

```bash
usernames=("apple" "banana" "mango" "orange" "red_cherry")
```

Yeh indexed Bash array hai. Har quoted value aik separate element hai. Linux username mein space use karna theek nahin, is liye `red cherry` ki jagah `red_cherry` use hua hai.

Array ke tamam elements pass karne ka syntax:

```bash
"${usernames[@]}"
```

Quotes zaroori hain: yeh har element ko separate argument rakhti hain.

## 4. Root Check

```bash
if [[ "$EUID" -ne 0 ]]; then
```

- `EUID` current process ka effective user ID hai.
- Root ka EUID `0` hota hai.
- `-ne` ka matlab **not equal** hai.

Condition ka matlab: agar script root authority ke saath nahin chal rahi, error show karke `exit 1` kare.

```bash
echo "Error: run this script with sudo or as root." >&2
```

`>&2` error ko standard error stream par bhejta hai.

## 5. Script Directory Locate Karna

```bash
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
```

Is expression ko andar se bahar samjhein:

| Hissa | Kaam |
|---|---|
| `${BASH_SOURCE[0]}` | Current Bash script ka path deta hai. |
| `dirname` | Filename hata kar directory path deta hai. |
| `cd --` | Us directory mein jata hai; `--` option parsing band karta hai. |
| `&& pwd` | `cd` successful ho to absolute path print karta hai. |
| `$(...)` | Output ko `script_dir` variable mein save karta hai. |

Is se controller ko kisi bhi current working directory se run kiya ja sakta hai.

## 6. Child Scripts Call Karna

Example:

```bash
bash "$script_dir/01-create_users.sh" "${usernames[@]}"
```

- `bash` child script chalata hai.
- Quoted path spaces aur special characters se protection deta hai.
- Array ke tamam usernames separate positional arguments bante hain.

Order important hai: pehle accounts create hon, phir passwords set hon, phir privileges di jayen.

## 7. Error Propagation

```bash
if ! bash "$script_dir/01-create_users.sh" "${usernames[@]}"; then
```

Child script status `0` return kare to success hai. Nonzero return kare to `!` result reverse karta hai aur error block run hota hai.

```bash
exit 1
```

Controller ko failure ke saath band karta hai. Is tarah next sensitive step galat state mein run nahin hota.

## 8. Successful Completion

```bash
echo "All requested user-management steps are complete."
exit 0
```

Yeh lines tabhi execute hoti hain jab tamam child scripts successful status return karein. `exit 0` overall success report karta hai.

## 9. Run Karne ki Example

Syntax check:

```bash
bash -n 00-manage_users.sh
```

Run:

```bash
sudo bash 00-manage_users.sh
```

Status check:

```bash
echo "$?"
```

`0` success aur nonzero failure show kare ga.

## 10. Key Lessons

- Controller orchestration karta hai; system changes child scripts karti hain.
- `"${array[@]}"` array elements ko safe separate arguments rakhta hai.
- `EUID` privileged execution check karta hai.
- `BASH_SOURCE` se reliable script directory milti hai.
- Child script ka exit status complete workflow control karta hai.
