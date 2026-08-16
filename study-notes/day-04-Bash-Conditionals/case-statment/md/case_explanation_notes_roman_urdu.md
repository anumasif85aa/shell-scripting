# Study Notes: Bash Script Ki Tafseel (Explanation)

## Script Ka Khulasa (Overview)
Yeh script yeh check karta hai ke Linux system par **Nginx service** active hai ya nahi. Yeh kaam user ke interactive input (`y/n`) par depend karta hai.

---

## Poora Script Code

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

## Line-by-Line Tafseel (Breakdown)

### 1. Initial Setup aur Variable Declaration
```bash
service_name="nginx"
```
* **Tafseel:** `service_name` variable ko `"nginx"` par set karta hai. Iska faida yeh hai ke aap sirf ek line badal kar kisi doosri service (jaise `apache2` ya `docker`) ko check kar sakte hain.

---

### 2. User Input Safely Read Karna
```bash
if ! read -r -p "Check $service_name status? (y/n): " answer; then
    echo >&2
    echo "Error: could not read the response." >&2
    exit 1
fi
```
* **Istemaal hone wale Flags:**
  * `-r`: Backslash escaping ko disable karta hai taake characters waise hi read hon jaise type kiye gaye hain.
  * `-p`: User se input lene se pehle prompt screen par dikhata hai (`Check nginx status? (y/n): `).
* **Error Handling:** `if !` yeh check karta hai ke agar `read` command fail ho jaye (maslan agar script background mein chal rahi ho). Agar fail ho jaye toh error message `stderr` (`>&2`) par print hoga aur script code `1` ke sath exit ho jayegi.

---

### 3. `case` Pattern Matching ke Sath Input Process Karna

```bash
case "$answer" in
```
* User ke saved jawab (`$answer`) par pattern matching shuru karta hai.

#### Option A: Haan wale Jawab (`y|Y|yes|Yes|YES`)
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
* **Logic:** "Yes" ke tamam aam taraiqon ko accept karta hai.
* **`systemctl is-active --quiet "$service_name"`**:
  * Check karta hai ke service filhal chal rahi hai ya nahi.
  * `--quiet` flag ki waja se extra status text screen par print nahi hota.
* **Result:**
  * Agar active hai: Print karega `nginx is active.` aur `0` (Success) ke sath exit hoga.
  * Agar active nahi hai: Print karega `nginx is not active.` (stderr par) aur `1` (Failure) ke sath exit hoga.

#### Option B: Naa wale Jawab (`n|N|no|No|NO`)
```bash
    n|N|no|No|NO)
        echo "Skipped."
        exit 0
        ;;
```
* **Logic:** Agar user check nahi karna chahta, toh `"Skipped."` print karega aur safai se `0` (Success) ke sath exit hoga.

#### Option C: Galat Input (`*`)
```bash
    *)
        echo "Error: enter y or n." >&2
        exit 1
        ;;
esac
```
* **Logic:** Wildcard `*` kisi bhi ghalat input (jaise numbers ya doosre characters) ko pakadta hai.
* Error message stderr par bhejta hai aur `1` ke sath exit ho jata hai.

---

## Khaas Baatein aur Syntax Reference

| Code / Concept | Matlab aur Maqsad |
| :--- | :--- |
| **`>&2`** | Output ko Standard Output (`stdout`) se Standard Error (`stderr`) par bhejta hai. Errors dikhane ke liye best practice hai. |
| **`exit 0`** | Script ko Success status code ke sath khatam karta hai. |
| **`exit 1`** | Script ko Error/Failure status code ke sath stop karta hai. |
| **`systemctl is-active`** | Linux systemd ka command jo service chalne ki state check karta hai. |
| **`case ... esac`** | Bar bar `if / elif` likhne ka aasan aur saaf-sutahra mautabadil (alternative). |
