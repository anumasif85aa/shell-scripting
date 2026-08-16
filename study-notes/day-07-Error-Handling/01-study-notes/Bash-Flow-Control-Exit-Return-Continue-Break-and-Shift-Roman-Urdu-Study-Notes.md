# Bash Flow Control — `exit`, `return`, `continue`, `break` aur `shift` (Roman Urdu)

## Table of Contents

1. [Introduction](#1-introduction)
2. [Quick Reference](#2-quick-reference)
3. [`exit 0` — Script ko Success ke Saath Band Karna](#3-exit-0--script-ko-success-ke-saath-band-karna)
4. [`exit 1` aur Doosray Failure Statuses](#4-exit-1-aur-doosray-failure-statuses)
5. [`continue` — Current Loop Item Skip Karna](#5-continue--current-loop-item-skip-karna)
6. [`break` — Loop Band Karna](#6-break--loop-band-karna)
7. [`return` — Function se Bahar Ana](#7-return--function-se-bahar-ana)
8. [`exit` vs `return`](#8-exit-vs-return)
9. [`shift` — Arguments Process Karna](#9-shift--arguments-process-karna)
10. [`true`, `false` aur `:`](#10-true-false-aur-)
11. [`$?` — Previous Command ka Status](#11--previous-command-ka-status)
12. [Complete Practical Example](#12-complete-practical-example)
13. [Common Mistakes](#13-common-mistakes)
14. [Final Summary](#14-final-summary)

---

## 1. Introduction

Bash mein kuch commands script ka execution flow control karti hain. In ke zariye hum:

- Puri script band kar sakte hain.
- Function se bahar aa sakte hain.
- Loop ka current item skip kar sakte hain.
- Pura loop band kar sakte hain.
- Command-line arguments ko aik aik karke process kar sakte hain.
- Success ya failure report kar sakte hain.

Yeh commands aik jaisa kaam nahin karti. Misal ke taur par, `continue` sirf current loop iteration ko affect karta hai, jabke `exit` puri script terminate kar deta hai.

---

## 2. Quick Reference

| Command | Kahan Use Hota Hai | Kya Karta Hai |
|---|---|---|
| `exit 0` | Script | Puri script band karke success report karta hai. |
| `exit 1` | Script | Puri script band karke failure report karta hai. |
| `exit N` | Script | Script ko status number `N` ke saath band karta hai. |
| `continue` | Loop | Current iteration ki baqi commands skip karta hai. |
| `break` | Loop | Loop ko foran band karta hai. |
| `return 0` | Function | Function se success status ke saath bahar ata hai. |
| `return 1` | Function | Function se failure status ke saath bahar ata hai. |
| `return N` | Function | Function se custom status `N` return karta hai. |
| `shift` | Arguments | `$1` remove karke baqi arguments ko left move karta hai. |
| `true` | Kahin bhi | Hamesha status `0` return karta hai. |
| `false` | Kahin bhi | Hamesha status `1` return karta hai. |
| `:` | Kahin bhi | Kuch nahin karta aur aam tor par status `0` deta hai. |

---

## 3. `exit 0` — Script ko Success ke Saath Band Karna

```bash
echo "Installation completed."
exit 0
```

Is ka matlab hai:

> Puri script ko yahan band karo aur successful completion report karo.

`exit` ke baad likhi commands run nahin hotin:

```bash
echo "Before exit"
exit 0
echo "After exit"
```

Output:

```text
Before exit
```

`After exit` print nahin hoga kyun ke script pehle hi terminate ho chuki hai.

Calling shell mein status check karein:

```bash
bash script.sh
echo "$?"
```

Expected status:

```text
0
```

### Kab Use Karein?

`exit 0` us waqt use karein jab script ka required kaam successfully complete ho gaya ho.

---

## 4. `exit 1` aur Doosray Failure Statuses

```bash
if (( EUID != 0 )); then
    echo "Error: run this script with sudo." >&2
    exit 1
fi
```

`exit 1` ka matlab hai:

> Puri script ko foran band karo aur failure report karo.

### General Convention

| Status | Aam Matlab |
|---:|---|
| `0` | Success |
| Nonzero | Failure ya koi exceptional result |

Kuch commonly observed statuses:

| Status | Common Meaning |
|---:|---|
| `1` | General failure |
| `2` | Aksar incorrect usage ya command-specific error |
| `126` | Command mili, lekin execute nahin ho saki |
| `127` | Command nahin mili |
| `128 + N` | Process signal number `N` ki wajah se terminate hua |

Har command apne nonzero statuses ka specific matlab define kar sakti hai. Apni script mein custom statuses use karein to unhein document karein:

```bash
# Exit statuses:
# 1 = invalid input
# 2 = missing source file
# 3 = permission failure
```

Example:

```bash
if [[ ! -f "$source_file" ]]; then
    echo "Error: source file does not exist." >&2
    exit 2
fi
```

Yahan missing file ke liye custom status `2` use hua hai.

---

## 5. `continue` — Current Loop Item Skip Karna

`continue` loop ke andar use hota hai.

Is ka matlab hai:

> Current item ki baqi commands skip karo aur next iteration start karo.

```bash
for package in nginx curl wget
do
    if command -v "$package" >/dev/null 2>&1; then
        echo "$package is already available."
        continue
    fi

    echo "Installing $package..."
done
```

Agar `curl` pehle se available hai:

1. Installed message print hoga.
2. `continue` execute hoga.
3. `Installing curl...` wali line skip hogi.
4. Loop next item `wget` par chala jayega.

### Important

`continue`:

- Loop permanently band nahin karta.
- Function band nahin karta.
- Script band nahin karta.
- Sirf current iteration skip karta hai.

---

## 6. `break` — Loop Band Karna

`break` nearest active loop ko foran end karta hai:

```bash
for server in web01 web02 web03
do
    if [[ "$server" == "web02" ]]; then
        echo "Target found. Stopping the search."
        break
    fi

    echo "Checking $server"
done

echo "The script continues after the loop."
```

Output:

```text
Checking web01
Target found. Stopping the search.
The script continues after the loop.
```

`web03` process nahin hoga kyun ke `break` ne loop band kar diya. Lekin `done` ke baad script continue karti hai.

### `continue` vs `break`

| Command | Effect |
|---|---|
| `continue` | Current iteration skip; loop chalti rehti hai. |
| `break` | Pura current loop band. |

---

## 7. `return` — Function se Bahar Ana

`return` aam tor par function ke andar use hota hai:

```bash
check_file()
{
    if [[ -f "$1" ]]; then
        echo "File exists: $1"
        return 0
    fi

    echo "File does not exist: $1" >&2
    return 1
}
```

Function ko is tarah use karein:

```bash
if check_file "abc.txt"; then
    echo "The file check succeeded."
else
    echo "The file check failed."
fi
```

| Return Status | Matlab |
|---:|---|
| `return 0` | Function successful hui. |
| `return 1` | Function fail hui. |
| `return N` | Function ne custom status `N` diya. |

### Implicit Function Return

Agar explicit `return` na likha ho, Bash function apni last command ka status automatically return karti hai:

```bash
is_installed()
{
    command -v "$1" >/dev/null 2>&1
}
```

Yeh function `command -v` ka status return kare gi:

- Command mil jaye to `0`.
- Command na mile to nonzero.

---

## 8. `exit` vs `return`

| Command | Current Function End? | Entire Script End? |
|---|---:|---:|
| `return` | Yes | No |
| `exit` | Yes | Yes |

### `return` Example

```bash
demo()
{
    echo "Inside the function"
    return 1
    echo "This line will not run"
}

demo
echo "The script is still running"
```

Function `return 1` par end ho jayegi, lekin main script continue kare gi.

### `exit` Example

```bash
demo()
{
    echo "Inside the function"
    exit 1
}

demo
echo "This line will not run"
```

Function ke andar hone ke bawajood `exit 1` puri script terminate kar dega.

---

## 9. `shift` — Arguments Process Karna

`shift` current `$1` remove karta hai aur baqi positional arguments ko aik position left move karta hai.

Suppose script is tarah run hui:

```bash
bash script.sh apple banana cherry
```

Shuru mein:

```text
$1 = apple
$2 = banana
$3 = cherry
$# = 3
```

Aik `shift` ke baad:

```text
$1 = banana
$2 = cherry
$# = 2
```

Example:

```bash
while [[ "$#" -gt 0 ]]
do
    echo "Processing: $1"
    shift
done
```

Output:

```text
Processing: apple
Processing: banana
Processing: cherry
```

Har iteration mein current `$1` process hota hai aur `shift` usay remove kar deta hai. Jab `$#` zero ho jata hai, loop ruk jata hai.

### Multiple Arguments Shift Karna

```bash
shift 2
```

Yeh pehle do positional arguments remove karta hai. Available arguments se zyada shift karna nonzero status return karta hai.

---

## 10. `true`, `false` aur `:`

### `true`

`true` hamesha success return karta hai:

```bash
true
echo "$?"
```

Output:

```text
0
```

Infinite loop mein use ho sakta hai:

```bash
while true
do
    echo "Running..."
    sleep 2
done
```

### `false`

`false` hamesha failure return karta hai:

```bash
false
echo "$?"
```

Output:

```text
1
```

Failure-handling logic test karne ke liye:

```bash
if false; then
    echo "Success"
else
    echo "Failure"
fi
```

### `:` — Null Command

Colon command kuch nahin karta aur aam tor par status `0` return karta hai:

```bash
:
echo "$?"
```

Infinite loop mein bhi use ho sakta hai:

```bash
while :
do
    echo "Running..."
    sleep 2
done
```

---

## 11. `$?` — Previous Command ka Status

`$?` sab se recently complete hui foreground command ka status rakhta hai:

```bash
command -v nginx >/dev/null 2>&1
echo "$?"
```

Possible result:

- `0`: command successful hui.
- Nonzero: command successful nahin hui.

### Foran Check Karein

Har new command `$?` ko replace kar deti hai:

```bash
command -v nginx >/dev/null 2>&1
echo "Checking status"
echo "$?"
```

Final `$?`, `command -v` ka status nahin hoga. Woh pehli `echo` command ka status hoga.

Direct checking zyada clear hoti hai:

```bash
if command -v nginx >/dev/null 2>&1; then
    echo "nginx is available."
else
    echo "nginx is unavailable."
fi
```

---

## 12. Complete Practical Example

```bash
#!/bin/bash

# Demonstrate validation, continue, break, return, and exit.

is_available()
{
    command -v "$1" >/dev/null 2>&1
}

if [[ "$#" -eq 0 ]]; then
    echo "Usage: $0 COMMAND [COMMAND ...]" >&2
    exit 1
fi

missing_command=0

for command_name in "$@"
do
    if [[ "$command_name" == "stop" ]]; then
        echo "Stop request received."
        break
    fi

    if is_available "$command_name"; then
        echo "[AVAILABLE] $command_name"
        continue
    fi

    echo "[MISSING] $command_name" >&2
    missing_command=1
done

if (( missing_command != 0 )); then
    exit 1
fi

exit 0
```

Example:

```bash
bash command_check.sh bash missing-command curl
```

Possible output:

```text
[AVAILABLE] bash
[MISSING] missing-command
[AVAILABLE] curl
```

Kam az kam aik command missing hone ki wajah se script final status `1` return kare gi.

### Is Script Mein Flow-Control Commands

| Command | Kaam |
|---|---|
| `return` implicit hai | `is_available` last command ka status return karti hai. |
| `exit 1` | Missing arguments ya missing command par overall failure. |
| `break` | `stop` argument milne par loop band. |
| `continue` | Available command milne par next item process. |
| `exit 0` | Koi missing command na ho to success. |

---

## 13. Common Mistakes

### Mistake 1: Sirf Loop Rokna Ho, Lekin `exit` Use Karna

`exit` puri script terminate karta hai. Sirf loop end karna ho to `break` use karein.

### Mistake 2: `break` ya `continue` Loop ke Bahar Use Karna

Dono commands ko active loop chahiye. `break` loop end karta hai aur `continue` next iteration start karta hai.

### Mistake 3: Samajhna ke `return 1` Puri Script Band Karega

`return 1` current function se bahar ata hai. Caller failure handle na kare to script continue kar sakti hai.

### Mistake 4: `$?` Der se Check Karna

`$?` ko important command ke foran baad check karein. Behtar hai important command ko direct `if` ke andar check karein.

### Mistake 5: Har Nonzero Status ko Aik Hi Error Samajhna

Nonzero aam tor par ordinary success na hone ko show karta hai, lekin exact meaning command-specific hota hai.

### Mistake 6: `continue` ko Script Exit Samajhna

`continue` script ko band nahin karta. Yeh sirf current loop item ki baqi commands skip karta hai.

---

## 14. Final Summary

```text
exit 0    → Puri script success ke saath band
exit 1    → Puri script failure ke saath band
return 0  → Function se success ke saath bahar
return 1  → Function se failure ke saath bahar
continue  → Current loop iteration skip
break     → Current loop band
shift     → $1 remove aur baqi arguments left move
true      → Hamesha status 0
false     → Hamesha status 1
:          → Kuch nahin karta; aam tor par status 0
$?         → Most recent foreground command ka status
```

Command choose karte waqt yeh sawal poochhein:

> Kya mujhe puri script band karni hai, sirf function se bahar ana hai, aik loop item skip karna hai, ya pura loop rokna hai?

Required behavior ke mutabiq sahi flow-control command select karein.
