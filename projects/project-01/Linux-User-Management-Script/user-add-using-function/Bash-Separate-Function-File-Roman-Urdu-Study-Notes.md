# Bash Function ko Separate File Mein Rakhna — Roman Urdu Study Notes

## Table of Contents

1. [Introduction](#1-introduction)
2. [Is Design ka Faida](#2-is-design-ka-faida)
3. [Required Folder Structure](#3-required-folder-structure)
4. [Function Library File](#4-function-library-file)
5. [Master Menu Script](#5-master-menu-script)
6. [`source` Command ki Explanation](#6-source-command-ki-explanation)
7. [Script Directory ka Robust Path](#7-script-directory-ka-robust-path)
8. [Function Load Honay ki Verification](#8-function-load-honay-ki-verification)
9. [Complete Execution Flow](#9-complete-execution-flow)
10. [Files ko Run Karna](#10-files-ko-run-karna)
11. [`return` aur `exit` ka Farq](#11-return-aur-exit-ka-farq)
12. [Common Mistakes](#12-common-mistakes)
13. [Testing aur Troubleshooting](#13-testing-aur-troubleshooting)
14. [Security Notes](#14-security-notes)
15. [Quick Reference](#15-quick-reference)
16. [Final Summary](#16-final-summary)

---

## 1. Introduction

Ji haan, Bash function ko master script se bahar aik separate file mein rakhna bilkul mumkin hai.

Is design mein:

- Function aik separate file mein define hota hai.
- Master script `source` command se function file load karti hai.
- Function file khud function ko execute nahi karti.
- Master script zaroorat ke waqt function call karti hai.

Basic idea:

```text
create_user_function.sh
        |
        | create_user() define karta hai
        v
service_action_menue.sh
        |
        | source se function load karta hai
        v
Menu mein y select honay par create_user call hota hai
```

---

## 2. Is Design ka Faida

Agar poora user-creation code `case` ke `y)` block ke andar likha jaye, to script lambi aur mushkil ho jati hai.

Function ko separate file mein rakhne ke faiday:

- Code repeat nahi hota.
- Master menu chhoti aur readable rehti hai.
- Function ko doosri scripts mein bhi reuse kiya ja sakta hai.
- Function ko alag test karna asan hota hai.
- Changes sirf aik function file mein karni hoti hain.
- Script ka har hissa aik clear responsibility rakhta hai.

Is principle ko programming mein **separation of concerns** aur **reusability** kehte hain.

---

## 3. Required Folder Structure

Dono files ko aik hi directory mein rakhein:

```text
user-management/
├── create_user_function.sh
└── service_action_menue.sh
```

Example commands:

```bash
mkdir -p user-management
cd user-management
```

Agar downloaded master file ka name yeh ho:

```text
service_action_menue (1).sh
```

to clean name ke liye rename kar saktay hain:

```bash
mv -- "service_action_menue (1).sh" service_action_menue.sh
```

`--` batata hai ke command options khatam ho gaye hain. Quotes filename ke spaces ko aik argument rakhti hain.

---

## 4. Function Library File

File name: `create_user_function.sh`

```bash
#!/bin/bash

# Title: Create User Function Library
# Purpose: Provide the reusable create_user function.
# Important: This file defines the function but does not call it.

create_user()
{
    local username
    local initial_password

    # Read a username; return failure if input cannot be read.
    if ! read -r -p "Enter username: " username; then
        echo "Error: could not read the username." >&2
        return 1
    fi

    # Reject an empty username.
    if [[ -z "$username" ]]; then
        echo "Error: username cannot be empty." >&2
        return 1
    fi

    # Do not create an account that already exists.
    if id "$username" >/dev/null 2>&1; then
        echo "Error: user already exists: $username" >&2
        return 1
    fi

    # Temporary lab password; the user must change it at first login.
    initial_password="${username}@123"

    if ! sudo useradd -m -s /bin/bash -- "$username"; then
        echo "Error: user creation failed: $username" >&2
        return 1
    fi

    if ! printf '%s:%s\n' "$username" "$initial_password" | sudo chpasswd; then
        echo "Error: password assignment failed for: $username" >&2
        return 1
    fi

    if ! sudo chage -d 0 -- "$username"; then
        echo "Error: could not require a password change for: $username" >&2
        return 1
    fi

    # Verify and display the newly created account.
    id "$username"
    getent passwd "$username"

    echo "New user added: $username"
    echo "The user must change the password at first login."
    return 0
}
```

### Aham baat

Function file ke end par yeh line nahi honi chahiye:

```bash
create_user
```

Agar yeh line function file mein ho, to master script jaisay hi file ko `source` karegi, function foran execute ho jayega.

Sahi function-library behavior:

```text
File source hui
      ↓
Function define hua
      ↓
Function abhi execute nahi hua
      ↓
Master script jab call karegi tab execute hoga
```

---

## 5. Master Menu Script

File name: `service_action_menue.sh`

```bash
#!/bin/bash

# Title: User Creation Menu
# Purpose: Load a reusable function from another file and show a menu.
# Usage: bash service_action_menue.sh

# Find the directory where this master script is stored.
script_directory="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
function_file="$script_directory/create_user_function.sh"

# Confirm that the function library can be read.
if [[ ! -r "$function_file" ]]; then
    echo "Error: function file is not readable: $function_file" >&2
    exit 1
fi

# Load create_user() into the current Bash process.
# shellcheck source=create_user_function.sh
source "$function_file"

# Confirm that sourcing the file defined the expected function.
if ! declare -F create_user >/dev/null; then
    echo "Error: create_user function was not loaded." >&2
    exit 1
fi

# Keep showing the menu until the user chooses q.
while true
do
    echo

    if ! read -r -p "Create a new user? Enter y, n, or q to quit: " action; then
        echo
        echo "Error: could not read the menu choice." >&2
        exit 1
    fi

    case "$action" in
        y|Y)
            # Call the function instead of repeating its complete code.
            if ! create_user; then
                echo "The user-creation operation was not completed." >&2
            fi
            ;;

        n|N)
            echo "User creation skipped."
            ;;

        q|Q)
            echo "Goodbye."
            break
            ;;

        *)
            echo "Unknown action: $action" >&2
            ;;
    esac
done

exit 0
```

Menu ke `y)` branch mein ab poora user-creation code repeat nahi hota. Sirf function call hota hai:

```bash
if ! create_user; then
    echo "The user-creation operation was not completed." >&2
fi
```

---

## 6. `source` Command ki Explanation

Main command:

```bash
source "$function_file"
```

`source` doosri Bash file ko current Bash process ke andar read aur execute karta hai.

Iska nateeja:

- Variables current shell mein available ho saktay hain.
- Functions current shell mein define ho jatay hain.
- Separate child process start nahi hota.

`source` ki short form aik dot `.` hai:

```bash
. "$function_file"
```

Dono commands ka basic kaam aik jaisa hai:

```bash
source "$function_file"
```

```bash
. "$function_file"
```

Beginner ke liye `source` zyada readable hai.

### `bash file.sh` kyun nahi?

Yeh command:

```bash
bash create_user_function.sh
```

function file ko separate Bash process mein chalati hai. Function us child process mein define hota hai aur parent master script ko available nahi hota.

Comparison:

| Command | Kya hota hai? | Function master script ko milta hai? |
|---|---|---:|
| `source file.sh` | Current shell mein file load hoti hai | Haan |
| `. file.sh` | Current shell mein file load hoti hai | Haan |
| `bash file.sh` | Naya Bash process start hota hai | Nahi |

---

## 7. Script Directory ka Robust Path

Master script mein yeh command use hui hai:

```bash
script_directory="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
```

Iska maqsad master script ki actual directory maloom karna hai.

### Parts ki explanation

| Part | Matlab |
|---|---|
| `${BASH_SOURCE[0]}` | Current Bash script ka path |
| `dirname` | Path se filename hata kar directory deta hai |
| `cd -- DIRECTORY` | Us directory mein jata hai |
| `pwd` | Absolute directory path deta hai |
| `$(...)` | Command output variable mein capture karta hai |

Phir function file ka complete path banta hai:

```bash
function_file="$script_directory/create_user_function.sh"
```

### Is approach ka faida

Suppose files yahan hain:

```text
/home/khalid/user-management/
```

Aap kisi doosri directory se master script run karein:

```bash
cd /tmp
bash /home/khalid/user-management/service_action_menue.sh
```

Master script phir bhi function file ko sahi jagah se load karegi:

```text
/home/khalid/user-management/create_user_function.sh
```

Sirf yeh likhna kam reliable hai:

```bash
source ./create_user_function.sh
```

Kyunke `./` current working directory ko represent karta hai, zaroori nahi ke master script ki directory ko.

---

## 8. Function Load Honay ki Verification

Function file read honay se pehle check:

```bash
if [[ ! -r "$function_file" ]]; then
    echo "Error: function file is not readable: $function_file" >&2
    exit 1
fi
```

`-r` check karta hai ke file current user ke liye readable hai.

File source honay ke baad:

```bash
if ! declare -F create_user >/dev/null; then
    echo "Error: create_user function was not loaded." >&2
    exit 1
fi
```

`declare -F create_user` check karta hai ke `create_user` naam ka function current Bash process mein defined hai.

| Result | Matlab |
|---:|---|
| Status `0` | Function defined hai |
| Non-zero status | Function defined nahi hai |

`>/dev/null` normal output ko hide karta hai, kyunke humein sirf command ka status chahiye.

---

## 9. Complete Execution Flow

```text
Master script start
        ↓
Apni directory calculate kare
        ↓
Function file ka path banaye
        ↓
Kya function file readable hai?
   ├── Nahi → Error → exit 1
   └── Haan
        ↓
source se function file load kare
        ↓
Kya create_user function defined hai?
   ├── Nahi → Error → exit 1
   └── Haan
        ↓
Menu display
        ↓
   ┌────┼─────────────┐
   y    n             q
   ↓    ↓             ↓
create  skip       Goodbye
user    menu       break loop
   ↓
Function return status
   ├── 0 → Success
   └── 1 → Failure message
```

---

## 10. Files ko Run Karna

Dono files aik folder mein rakhein:

```bash
ls -l
```

Expected names:

```text
create_user_function.sh
service_action_menue.sh
```

Syntax check karein:

```bash
bash -n create_user_function.sh
bash -n service_action_menue.sh
```

No output aam tor par matlab hai ke Bash ko syntax error nahi mila.

Master script executable banayein:

```bash
chmod +x service_action_menue.sh
```

Run karein:

```bash
./service_action_menue.sh
```

Ya:

```bash
bash service_action_menue.sh
```

Function library ko executable banana zaroori nahi. Master script ko us file ki read permission chahiye.

Suggested permission:

```bash
chmod 644 create_user_function.sh
```

---

## 11. `return` aur `exit` ka Farq

Function library mein errors par `return 1` use hota hai:

```bash
return 1
```

Master script mein fatal errors par `exit 1` use hota hai:

```bash
exit 1
```

| Command | Kya band karta hai? |
|---|---|
| `return 0` | Function ko success ke sath end karta hai |
| `return 1` | Function ko failure ke sath end karta hai |
| `exit 0` | Poori script successfully end karta hai |
| `exit 1` | Poori script failure ke sath end karta hai |

Memory rule:

```text
Function se return
Script se exit
```

---

## 12. Common Mistakes

### Mistake 1: Function file ke end par function call karna

Ghalat:

```bash
create_user()
{
    # commands
}

create_user
```

File source hotay hi function execute ho jayega.

Sahi:

```bash
create_user()
{
    # commands
}
```

### Mistake 2: `bash` se function file chalana

Ghalat:

```bash
bash create_user_function.sh
create_user
```

Doosri line par master shell function ko nahi janay ga.

Sahi:

```bash
source create_user_function.sh
create_user
```

### Mistake 3: Dono files mukhtalif folders mein rakhna

Master script default tor par yeh file apne folder mein dhoondti hai:

```text
create_user_function.sh
```

### Mistake 4: Function file ka name mismatch

Master script mein:

```bash
function_file="$script_directory/create_user_function.sh"
```

Actual filename bhi bilkul yahi hona chahiye:

```text
create_user_function.sh
```

Linux filenames case-sensitive hotay hain.

### Mistake 5: Function ke andar `exit 1` use karna

Reusable function mein `exit 1` poori master script band kar sakta hai. Aksar `return 1` zyada munasib hota hai.

### Mistake 6: Wrong shebang

Ghalat:

```bash
#!bin/bash
```

Sahi:

```bash
#!/bin/bash
```

---

## 13. Testing aur Troubleshooting

### Function manually load karke verify karein

```bash
source ./create_user_function.sh
declare -F create_user
```

Expected output:

```text
create_user
```

### Function file readable check karein

```bash
[[ -r create_user_function.sh ]]
echo "$?"
```

Status `0` ka matlab readable hai.

### Trace mode

```bash
bash -x service_action_menue.sh
```

Trace expanded commands dikhata hai. Passwords ya sensitive variables hon to `bash -x` ehtiyat se use karein.

### Error: function file is not readable

Check karein:

```bash
ls -l create_user_function.sh
```

Correct name aur location verify karein.

### Error: create_user function was not loaded

Function file mein function name check karein:

```bash
rg 'create_user' create_user_function.sh
```

Agar `rg` installed na ho:

```bash
grep 'create_user' create_user_function.sh
```

### Existing user test

Function yeh command use karti hai:

```bash
id "$username" >/dev/null 2>&1
```

Agar user already exist karta ho to function `return 1` karti hai aur dobara `useradd` nahi chalati.

---

## 14. Security Notes

Lab script temporary password banati hai:

```bash
initial_password="${username}@123"
```

Aur user ko first login par password change karwati hai:

```bash
sudo chage -d 0 -- "$username"
```

Yeh controlled learning lab ke liye samajhnay mein asan hai, lekin production systems ke liye predictable password secure nahi hai.

Production mein behtar options:

- `sudo passwd USERNAME` se administrator interactive password set kare.
- Secure random temporary password generate kiya jaye.
- Password ko terminal, logs ya source code mein expose na kiya jaye.
- Organization ki password aur identity policy follow ki jaye.
- Sirf authorized administrator user accounts create kare.

---

## 15. Quick Reference

| Task | Syntax |
|---|---|
| Function define karna | `create_user() { ...; }` |
| File current shell mein load karna | `source file.sh` |
| `source` ki short form | `. file.sh` |
| Script ka path | `${BASH_SOURCE[0]}` |
| Directory nikalna | `dirname -- PATH` |
| Absolute current directory | `pwd` |
| File readable check | `[[ -r "$file" ]]` |
| Function existence check | `declare -F create_user` |
| Function success | `return 0` |
| Function failure | `return 1` |
| Script failure | `exit 1` |
| Syntax check | `bash -n script.sh` |
| Debug trace | `bash -x script.sh` |

---

## 16. Final Summary

Separate function-file design ka basic pattern:

### Function library

```bash
create_user()
{
    # Function logic
    return 0
}
```

### Master script

```bash
script_directory="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_directory/create_user_function.sh"

create_user
```

Golden rules:

```text
1. Function ko separate file mein define karein.
2. Function file ke end par function call na karein.
3. Master script mein source use karein.
4. Dono files ko aik folder mein rakhein.
5. Function mein return aur master script mein exit use karein.
6. Function load honay ke baad declare -F se verify karein.
```

Final flow:

```text
Separate function file
        ↓ source
Master script mein function available
        ↓ menu y
Function execute
        ↓
Success return 0 ya failure return 1
```

