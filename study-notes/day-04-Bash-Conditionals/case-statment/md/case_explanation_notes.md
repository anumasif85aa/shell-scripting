# Study Notes: Bash Script Explanation

## Script Overview
This script checks whether the **Nginx service** is active on a Linux system, depending on interactive user input (`y/n`).

---

## Complete Script Code

```bash
#!/bin/bash

service_name="nginx"

if ! read -r -p "Check $service_name status? (y/n): " answer; then
    echo >&2
    echo "Error: could not read the response." >&2
    exit 1
fi

case "$answer" in
    y|Y|yes|Yes|YES)
        if systemctl is-active --quiet "$service_name"; then
            echo "$service_name is active."
            exit 0
        else
            echo "$service_name is not active." >&2
            exit 1
        fi
        ;;
    n|N|no|No|NO)
        echo "Skipped."
        exit 0
        ;;
    *)
        echo "Error: enter y or n." >&2
        exit 1
        ;;
esac
```

---

## Detailed Line-by-Line Breakdown

### 1. Initial Setup & Variable Declaration
```bash
service_name="nginx"
```
* **English:** Sets the variable `service_name` to `"nginx"`. This makes the script easily adaptable to other services (e.g., `apache2`, `docker`) by changing just one line.
* **Roman Urdu:** Variable `service_name` banaya gaya hai jisme service ka naam (`nginx`) store kiya hai.

---

### 2. Reading User Input Safely
```bash
if ! read -r -p "Check $service_name status? (y/n): " answer; then
    echo >&2
    echo "Error: could not read the response." >&2
    exit 1
fi
```
* **Flags Used:**
  * `-r`: Disables backslash escaping so input characters are read literally.
  * `-p`: Displays the prompt string (`Check nginx status? (y/n): `) before reading input.
* **Error Handling:** The `if !` wrapper checks if `read` fails (for example, if the script is run non-interactively or stdin is closed). If `read` fails, it prints an error to `stderr` (`>&2`) and exits with code `1`.
* **Roman Urdu:** User se prompt pucha jata hai. Agar input read karne mein masla ho, toh error message print karke script fail (`exit 1`) ho jati hai.

---

### 3. Processing Input with `case` Pattern Matching

```bash
case "$answer" in
```
* Initiates pattern matching on the user's stored response (`$answer`).

#### Option A: Affirmative Inputs (`y|Y|yes|Yes|YES`)
```bash
    y|Y|yes|Yes|YES)
        if systemctl is-active --quiet "$service_name"; then
            echo "$service_name is active."
            exit 0
        else
            echo "$service_name is not active." >&2
            exit 1
        fi
        ;;
```
* **Logic:** Accepts common variations for "yes".
* **`systemctl is-active --quiet "$service_name"`**:
  * Checks if the service unit is currently running/active.
  * `--quiet` suppresses standard output so `systemctl` doesn't print extra status text.
* **Returns:**
  * If active: Prints `nginx is active.` and exits with `0` (Success).
  * If inactive: Prints `nginx is not active.` to stderr and exits with `1` (Failure).

#### Option B: Negative Inputs (`n|N|no|No|NO`)
```bash
    n|N|no|No|NO)
        echo "Skipped."
        exit 0
        ;;
```
* **Logic:** If the user chooses not to check, prints `"Skipped."` and cleanly exits with `0` (Success).

#### Option C: Wildcard Catch-All (`*`)
```bash
    *)
        echo "Error: enter y or n." >&2
        exit 1
        ;;
esac
```
* **Logic:** The `*` pattern matches any invalid input (e.g., numbers, random letters).
* Prints an error message to stderr and exits with `1`.

---

## Key Takeaways & Syntax Reference

| Code / Concept | Meaning & Purpose |
| :--- | :--- |
| **`>&2`** | Redirects standard output (`stdout`) to standard error (`stderr`). Good practice for error messages. |
| **`exit 0`** | Terminates script with success exit code. |
| **`exit 1`** | Terminates script with error/failure exit code. |
| **`systemctl is-active`** | Built-in systemd command to check service state programmatically. |
| **`case ... esac`** | Clean alternative to multiple `if / elif` statements for pattern matching string options. |
