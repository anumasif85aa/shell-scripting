# Keeping a Bash Function in a Separate File — English Study Notes

## Table of Contents

1. [Introduction](#1-introduction)
2. [Benefits of This Design](#2-benefits-of-this-design)
3. [Required Folder Structure](#3-required-folder-structure)
4. [Function Library File](#4-function-library-file)
5. [Master Menu Script](#5-master-menu-script)
6. [`source` Command Explained](#6-source-command-explained)
7. [Finding the Script Directory Reliably](#7-finding-the-script-directory-reliably)
8. [Verifying That the Function Loaded](#8-verifying-that-the-function-loaded)
9. [Complete Execution Flow](#9-complete-execution-flow)
10. [Running the Files](#10-running-the-files)
11. [Difference Between `return` and `exit`](#11-difference-between-return-and-exit)
12. [Common Mistakes](#12-common-mistakes)
13. [Testing and Troubleshooting](#13-testing-and-troubleshooting)
14. [Security Notes](#14-security-notes)
15. [Quick Reference](#15-quick-reference)
16. [Final Summary](#16-final-summary)

---

## 1. Introduction

Yes, it is completely possible to keep a Bash function in a separate file outside the master script.

In this design:

- The function is defined in a separate file.
- The master script loads the function file with `source`.
- The function file does not execute the function automatically.
- The master script calls the function only when it is needed.

Basic idea:

```text
create_user_function.sh
        |
        | defines create_user()
        v
service_action_menue.sh
        |
        | loads the function with source
        v
create_user runs when y is selected from the menu
```

---

## 2. Benefits of This Design

If all the user-creation code is placed inside the `y)` branch of a `case` statement, the master script becomes long and difficult to maintain.

Keeping the function in a separate file provides several benefits:

- Code does not need to be repeated.
- The master menu remains short and readable.
- The function can be reused by other scripts.
- The function can be tested separately.
- Changes need to be made in only one function file.
- Each part of the program has a clear responsibility.

In programming, these ideas are called **separation of concerns** and **reusability**.

---

## 3. Required Folder Structure

Keep both files in the same directory:

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

If the downloaded master file has this name:

```text
service_action_menue (1).sh
```

you can give it a cleaner name:

```bash
mv -- "service_action_menue (1).sh" service_action_menue.sh
```

The `--` marker tells `mv` that command options have ended. The quotes keep a filename containing spaces together as one argument.

---

## 4. Function Library File

Filename: `create_user_function.sh`

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

### Important point

Do not place this line at the end of the function file:

```bash
create_user
```

If this line is present, the function will run immediately when the master script sources the file.

Correct function-library behavior:

```text
File is sourced
      ↓
Function is defined
      ↓
Function has not run yet
      ↓
Function runs when the master script calls it
```

---

## 5. Master Menu Script

Filename: `service_action_menue.sh`

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

The complete user-creation code is no longer repeated inside the menu's `y)` branch. The branch only calls the function:

```bash
if ! create_user; then
    echo "The user-creation operation was not completed." >&2
fi
```

---

## 6. `source` Command Explained

The main command is:

```bash
source "$function_file"
```

`source` reads and executes another Bash file inside the current Bash process.

As a result:

- Variables from the sourced file can become available in the current shell.
- Functions from the sourced file are defined in the current shell.
- A separate child process is not started.

The short form of `source` is a single dot:

```bash
. "$function_file"
```

These commands perform the same basic task:

```bash
source "$function_file"
```

```bash
. "$function_file"
```

For beginners, `source` is usually easier to read.

### Why not use `bash file.sh`?

This command:

```bash
bash create_user_function.sh
```

runs the file in a separate Bash process. The function is defined only in that child process and does not become available to the parent master script.

| Command | What happens? | Is the function available to the master script? |
|---|---|---:|
| `source file.sh` | Loads the file in the current shell | Yes |
| `. file.sh` | Loads the file in the current shell | Yes |
| `bash file.sh` | Starts a new Bash process | No |

---

## 7. Finding the Script Directory Reliably

The master script uses:

```bash
script_directory="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
```

Its purpose is to find the actual directory containing the master script.

### Explanation of each part

| Part | Meaning |
|---|---|
| `${BASH_SOURCE[0]}` | Path of the current Bash script |
| `dirname` | Removes the filename from a path and returns the directory |
| `cd -- DIRECTORY` | Changes to that directory |
| `pwd` | Prints the absolute directory path |
| `$(...)` | Captures command output in the variable assignment |

The complete function-file path is then created:

```bash
function_file="$script_directory/create_user_function.sh"
```

### Benefit of this approach

Suppose the files are stored here:

```text
/home/khalid/user-management/
```

You can run the master script from another directory:

```bash
cd /tmp
bash /home/khalid/user-management/service_action_menue.sh
```

The master script still loads the correct function file:

```text
/home/khalid/user-management/create_user_function.sh
```

This version is less reliable:

```bash
source ./create_user_function.sh
```

That is because `./` represents the current working directory, which is not necessarily the directory containing the master script.

---

## 8. Verifying That the Function Loaded

Before sourcing the function file, verify that it is readable:

```bash
if [[ ! -r "$function_file" ]]; then
    echo "Error: function file is not readable: $function_file" >&2
    exit 1
fi
```

The `-r` test checks whether the file is readable by the current user.

After sourcing the file, verify the function:

```bash
if ! declare -F create_user >/dev/null; then
    echo "Error: create_user function was not loaded." >&2
    exit 1
fi
```

`declare -F create_user` checks whether a function named `create_user` is defined in the current Bash process.

| Result | Meaning |
|---:|---|
| Status `0` | The function is defined |
| Non-zero status | The function is not defined |

`>/dev/null` hides the command's normal output because the script only needs its exit status.

---

## 9. Complete Execution Flow

```text
Master script starts
        ↓
Calculate its own directory
        ↓
Build the function-file path
        ↓
Is the function file readable?
   ├── No → Error → exit 1
   └── Yes
        ↓
Load function file with source
        ↓
Is the create_user function defined?
   ├── No → Error → exit 1
   └── Yes
        ↓
Display menu
        ↓
   ┌────┼─────────────┐
   y    n             q
   ↓    ↓             ↓
create  skip       Goodbye
user    action     break loop
   ↓
Function return status
   ├── 0 → Success
   └── 1 → Failure message
```

---

## 10. Running the Files

Place both files in the same folder:

```bash
ls -l
```

Expected filenames:

```text
create_user_function.sh
service_action_menue.sh
```

Check their syntax:

```bash
bash -n create_user_function.sh
bash -n service_action_menue.sh
```

No output normally means that Bash did not detect a syntax error.

Make the master script executable:

```bash
chmod +x service_action_menue.sh
```

Run it:

```bash
./service_action_menue.sh
```

Or run it through Bash:

```bash
bash service_action_menue.sh
```

The function library does not need executable permission. The master script only needs read permission for that file.

Suggested permission:

```bash
chmod 644 create_user_function.sh
```

---

## 11. Difference Between `return` and `exit`

The function library uses `return 1` when an operation fails:

```bash
return 1
```

The master script uses `exit 1` for a fatal error:

```bash
exit 1
```

| Command | What does it end? |
|---|---|
| `return 0` | Ends the function and reports success |
| `return 1` | Ends the function and reports failure |
| `exit 0` | Ends the entire script successfully |
| `exit 1` | Ends the entire script with failure |

Memory rule:

```text
Return from a function.
Exit from a script.
```

---

## 12. Common Mistakes

### Mistake 1: Calling the function at the end of the function file

Incorrect:

```bash
create_user()
{
    # commands
}

create_user
```

The function runs immediately when the file is sourced.

Correct:

```bash
create_user()
{
    # commands
}
```

### Mistake 2: Running the function file with `bash`

Incorrect:

```bash
bash create_user_function.sh
create_user
```

The master shell will not know the function when it reaches the second line.

Correct:

```bash
source create_user_function.sh
create_user
```

### Mistake 3: Keeping the files in different folders

By default, this design expects the following file inside the master script's directory:

```text
create_user_function.sh
```

If you store it elsewhere, update `function_file` with the correct location.

### Mistake 4: Function filename mismatch

The master script expects:

```bash
function_file="$script_directory/create_user_function.sh"
```

The actual filename must match exactly:

```text
create_user_function.sh
```

Linux filenames are case-sensitive.

### Mistake 5: Using `exit 1` inside the function

Inside a reusable function, `exit 1` can terminate the entire master script. In most cases, `return 1` is more appropriate.

### Mistake 6: Using the wrong shebang

Incorrect:

```bash
#!bin/bash
```

Correct:

```bash
#!/bin/bash
```

---

## 13. Testing and Troubleshooting

### Load and verify the function manually

```bash
source ./create_user_function.sh
declare -F create_user
```

Expected output:

```text
create_user
```

### Check whether the function file is readable

```bash
[[ -r create_user_function.sh ]]
echo "$?"
```

Status `0` means the file is readable.

### Trace mode

```bash
bash -x service_action_menue.sh
```

Trace mode displays expanded commands as Bash executes them. Use `bash -x` carefully when a script contains passwords or sensitive variables.

### Error: function file is not readable

Check the file:

```bash
ls -l create_user_function.sh
```

Verify its exact name, location, and read permission.

### Error: create_user function was not loaded

Check the function name inside the file:

```bash
rg 'create_user' create_user_function.sh
```

If `rg` is not installed:

```bash
grep 'create_user' create_user_function.sh
```

### Test for an existing user

The function uses:

```bash
id "$username" >/dev/null 2>&1
```

If the user already exists, the function returns status `1` and does not run `useradd` again.

---

## 14. Security Notes

The lab script creates a temporary password:

```bash
initial_password="${username}@123"
```

It then requires the user to change the password at the first login:

```bash
sudo chage -d 0 -- "$username"
```

This is easy to understand in a controlled learning lab, but predictable passwords are not secure for production systems.

Better production approaches include:

- Let an administrator set the password interactively with `sudo passwd USERNAME`.
- Generate a secure random temporary password.
- Do not expose passwords in the terminal, logs, or source code.
- Follow the organization's password and identity policies.
- Allow only authorized administrators to create user accounts.

---

## 15. Quick Reference

| Task | Syntax |
|---|---|
| Define a function | `create_user() { ...; }` |
| Load a file in the current shell | `source file.sh` |
| Short form of `source` | `. file.sh` |
| Current Bash source path | `${BASH_SOURCE[0]}` |
| Extract a directory from a path | `dirname -- PATH` |
| Print the absolute current directory | `pwd` |
| Check whether a file is readable | `[[ -r "$file" ]]` |
| Check whether a function exists | `declare -F create_user` |
| Report function success | `return 0` |
| Report function failure | `return 1` |
| End the script with failure | `exit 1` |
| Check Bash syntax | `bash -n script.sh` |
| Show a debugging trace | `bash -x script.sh` |

---

## 16. Final Summary

The basic separate function-file design is:

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
1. Define the function in a separate file.
2. Do not call the function at the end of the function file.
3. Use source in the master script.
4. Keep both files in the same folder unless you update the path.
5. Use return inside a function and exit in the master script.
6. Verify the loaded function with declare -F.
```

Final flow:

```text
Separate function file
        ↓ source
Function becomes available to the master script
        ↓ menu choice y
Function executes
        ↓
Success returns 0 or failure returns 1
```
