# `01-create_users.sh` — Users Create Karne ki Roman Urdu Explanation

## Table of Contents

- [1. Script ka Maqsad](#1-script-ka-maqsad)
- [2. Complete Script](#2-complete-script)
- [3. Initial Checks](#3-initial-checks)
- [4. Arguments Process Karna](#4-arguments-process-karna)
- [5. Username Validation](#5-username-validation)
- [6. Existing User Check](#6-existing-user-check)
- [7. Account Create Karna](#7-account-create-karna)
- [8. Success aur Failure](#8-success-aur-failure)
- [9. Example Runs](#9-example-runs)
- [10. Key Lessons](#10-key-lessons)

## 1. Script ka Maqsad

Yeh script command-line arguments mein diye gaye Linux usernames ko process karti hai. Valid aur missing accounts ko `useradd` ke zariye create karti hai, home directory banati hai aur Bash shell assign karti hai.

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

## 3. Initial Checks

Root check:

```bash
[[ "$EUID" -ne 0 ]]
```

`useradd` system account database change karta hai, is liye root privileges required hain.

Argument check:

```bash
if [[ "$#" -eq 0 ]]; then
```

- `$#` arguments ki total tadaad hai.
- `-eq 0` ka matlab count zero hai.
- Koi username na mile to script usage message de kar rukti hai.

## 4. Arguments Process Karna

```bash
for username in "$@"
```

`"$@"` tamam positional arguments ko separate values ki tarah expand karta hai. Har loop iteration mein next username `username` variable mein ata hai.

Example:

```bash
sudo bash 01-create_users.sh ali sara hamza
```

Loop pehle `ali`, phir `sara`, phir `hamza` process kare ga.

## 5. Username Validation

```bash
if [[ ! "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
```

| Regex Hissa | Matlab |
|---|---|
| `^` | String ka start. |
| `[a-z_]` | Pehla character lowercase letter ya underscore. |
| `[a-z0-9_-]*` | Baqi zero ya zyada lowercase letters, digits, underscore ya hyphen. |
| `$` | String ka end. |
| `=~` | Left value ko regex se match karta hai. |
| `!` | Result reverse karta hai; invalid match par block run hota hai. |

Invalid username par `exit 1` script ko foran failure status ke saath rokta hai. Is se controller bhi workflow rok deta hai aur invalid input aglay sensitive steps tak nahin jata.

## 6. Existing User Check

```bash
if id "$username" &> /dev/null; then
```

`id` user account ko search karta hai. Account exist kare to status `0` milta hai. `&> /dev/null` stdout aur stderr dono hide karta hai kyun ke script ko sirf status chahiye.

Existing user ko dobara create karna error hota, is liye message ke baad `continue` use hua hai.

## 7. Account Create Karna

```bash
useradd -m -s /bin/bash "$username"
```

| Hissa | Kaam |
|---|---|
| `useradd` | Naya local account create karta hai. |
| `-m` | User ki home directory create karta hai. |
| `-s /bin/bash` | Login shell Bash set karta hai. |
| `"$username"` | Validated account name hai. |

Quotes variable expansion ko aik safe argument rakhti hain.

## 8. Success aur Failure

```bash
if useradd ...; then
```

Bash direct `useradd` ka exit status check karta hai:

- Status `0`: success message.
- Nonzero: error `stderr` par aur `exit 1`.

Existing username ko skip karna non-critical hai. Invalid username ya valid account ko create na kar pana critical failure maana gaya hai.

## 9. Example Runs

```bash
sudo bash 01-create_users.sh ali sara
```

Possible output:

```text
User created successfully: ali
User created successfully: sara
```

Dobara run karne par:

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

## 10. Key Lessons

- System changes se pehle root authority check karein.
- `$#` se required arguments validate karein.
- Multiple arguments ke liye quoted `"$@"` use karein.
- Username ko use karne se pehle regex se validate karein.
- `id` se existing account check karein.
- `useradd -m -s /bin/bash` account, home aur shell set karta hai.
