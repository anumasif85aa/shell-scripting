# Bash Control Flow aur Exit Commands — Roman Urdu Study Notes

## Table of Contents

1. [Introduction](#1-introduction)
2. [Quick Reference Table](#2-quick-reference-table)
3. [Control-Flow Diagram](#3-control-flow-diagram)
4. [`exit 0` — Script ko Kamyabi ke Sath Band Karna](#4-exit-0--script-ko-kamyabi-ke-sath-band-karna)
5. [`exit 1` — Script ko Failure ke Sath Band Karna](#5-exit-1--script-ko-failure-ke-sath-band-karna)
6. [`exit N` — Apna Exit Status Dena](#6-exit-n--apna-exit-status-dena)
7. [`return` — Function se Bahar Ana](#7-return--function-se-bahar-ana)
8. [`break` — Loop ko Band Karna](#8-break--loop-ko-band-karna)
9. [`continue` — Ek Iteration ko Skip Karna](#9-continue--ek-iteration-ko-skip-karna)
10. [`break 2` aur `continue 2`](#10-break-2-aur-continue-2)
11. [`true` — Hamesha Success](#11-true--hamesha-success)
12. [`false` — Hamesha Failure](#12-false--hamesha-failure)
13. [`:` — Null Command](#13---null-command)
14. [Exit Status aur `$?`](#14-exit-status-aur-)
15. [Mukammal Practical Example](#15-mukammal-practical-example)
16. [Common Mistakes](#16-common-mistakes)
17. [Final Summary](#17-final-summary)

---

## 1. Introduction

Bash mein kuch commands script ka flow control karti hain. Yani yeh decide karti hain ke agla command chalega, function rukega, loop rukega, ya poori script band ho jayegi.

- `exit` poori script ko band karta hai.
- `return` current function se bahar lata hai.
- `break` current loop ko band karta hai.
- `continue` current iteration ka baqi hissa skip karta hai.
- `true` hamesha success status deta hai.
- `false` hamesha failure status deta hai.
- `:` koi kaam nahi karta, lekin success status deta hai.

Yeh tamam control-flow commands hain, lekin inka kaam ek jaisa nahi hai.

---

## 2. Quick Reference Table

| Command | Kahan use hota hai? | Kya karta hai? | Kya poori script band hoti hai? | Status |
|---|---|---|---|---:|
| `exit 0` | Script ya function mein | Poori script ko successfully band karta hai | Haan | `0` |
| `exit 1` | Script ya function mein | Poori script ko failure ke sath band karta hai | Haan | `1` |
| `exit N` | Script ya function mein | Script ko selected status ke sath band karta hai | Haan | `N` |
| `return 0` | Function ya sourced file mein | Function se success ke sath bahar lata hai | Aam tor par nahi | `0` |
| `return 1` | Function ya sourced file mein | Function se failure ke sath bahar lata hai | Aam tor par nahi | `1` |
| `break` | Loop mein | Sab se qareebi loop ko band karta hai | Nahi | — |
| `break 2` | Nested loops mein | Do loop levels se bahar lata hai | Nahi | — |
| `continue` | Loop mein | Current iteration ka baqi hissa skip karta hai | Nahi | — |
| `continue 2` | Nested loops mein | Doosray enclosing loop ki next iteration shuru karta hai | Nahi | — |
| `true` | Kahin bhi | Jaan boojh kar success return karta hai | Nahi | `0` |
| `false` | Kahin bhi | Jaan boojh kar failure return karta hai | Nahi | `1` |
| `:` | Kahin bhi | Kuch nahi karta aur success return karta hai | Nahi | `0` |

> **Important:** `break` aur `continue` poori script ko band nahi karte. Yeh sirf loops ka flow control karte hain.

---

## 3. Control-Flow Diagram

```text
Script shuru hoti hai
        |
        v
Commands aur conditions chalti hain
        |
        +-- exit N ----------> Poori script band
        |
        +-- function
        |      |
        |      +-- return N -> Function band,
        |                       script function call ke baad jari
        |
        +-- loop
               |
               +-- break ----> Loop band
               |
               +-- continue -> Next iteration shuru
```

Asan tareeqay se yaad rakhein:

| Command | Seedha matlab |
|---|---|
| `exit` | Poori script chhor do |
| `return` | Current function chhor do |
| `break` | Current loop chhor do |
| `continue` | Current iteration skip karke next par jao |

---

## 4. `exit 0` — Script ko Kamyabi ke Sath Band Karna

Suggested script name: `successful_backup.sh`

```bash
#!/bin/bash

echo "Backup completed successfully."
exit 0
```

`exit 0` ka matlab hai ke script ka kaam successfully complete ho gaya.

Script run karke status check karein:

```bash
bash successful_backup.sh
echo "$?"
```

Expected output:

```text
Backup completed successfully.
0
```

Yahan `0` success ko represent karta hai.

---

## 5. `exit 1` — Script ko Failure ke Sath Band Karna

Suggested script name: `source_file_check.sh`

```bash
#!/bin/bash

source_file="missing.txt"

if [[ ! -f "$source_file" ]]; then
    echo "Error: source file does not exist." >&2
    exit 1
fi

echo "The source file exists."
exit 0
```

### Is script ka flow

1. `[[ ! -f "$source_file" ]]` check karta hai ke path regular file **nahi** hai.
2. Agar file nahi milti, error message `stderr` par bheja jata hai.
3. `exit 1` poori script ko foran band kar deta hai.
4. Failure ke baad success message execute nahi hota.

`exit 1` aam failure ko represent karta hai.

---

## 6. `exit N` — Apna Exit Status Dena

Suggested script name: `argument_validator.sh`

```bash
#!/bin/bash

if (( $# != 2 )); then
    echo "Usage: $0 SOURCE DESTINATION" >&2
    exit 2
fi

echo "Source: $1"
echo "Destination: $2"
exit 0
```

Is example mein:

- `exit 0` ka matlab successful completion hai.
- `exit 2` ka matlab command-line arguments ka ghalat istemal hai.

Agar aap apne status codes banate hain, unka matlab script ke comments ya README mein zaroor document karein.

### Common exit-status convention

| Status | Aam matlab |
|---:|---|
| `0` | Success |
| `1` | General failure |
| `2` | Ghalat usage ya invalid arguments |
| `126` | Command mila, lekin execute nahi ho saka |
| `127` | Command nahi mila |
| `128 + N` | Process signal number `N` ki wajah se band hua |

Yeh common conventions hain. Har command apne exit statuses ka alag matlab define kar sakta hai.

---

## 7. `return` — Function se Bahar Ana

Suggested script name: `function_file_check.sh`

```bash
#!/bin/bash

check_file()
{
    local file="${1:-}"

    if [[ -f "$file" ]]; then
        return 0
    fi

    return 1
}

if check_file "abc.txt"; then
    echo "The file exists."
else
    echo "The file does not exist."
fi

echo "The script is still running."
exit 0
```

### Important difference

| Command | Nateeja |
|---|---|
| `return 1` | Sirf function se bahar aata hai aur failure report karta hai |
| `exit 1` | Poori script ko band karta hai aur failure report karta hai |

Function `0` se `255` tak status return kar sakta hai. Bash function aam programming languages ki tarah normal text ko `return` se wapas nahi bhejta.

Text produce karne ke liye `printf` ya `echo` use kiya jata hai:

```bash
get_name()
{
    printf '%s\n' "Khalid"
}

name="$(get_name)"
echo "$name"
```

---

## 8. `break` — Loop ko Band Karna

Suggested script name: `break_loop_demo.sh`

```bash
#!/bin/bash

for number in {1..10}
do
    if (( number == 5 )); then
        echo "Stopping the loop at $number."
        break
    fi

    echo "$number"
done

echo "The script continues after the loop."
exit 0
```

Expected output:

```text
1
2
3
4
Stopping the loop at 5.
The script continues after the loop.
```

Jab number `5` hota hai, `break` loop ko band kar deta hai. Poori script band nahi hoti; Bash `done` ke baad wala command chalata hai.

---

## 9. `continue` — Ek Iteration ko Skip Karna

Suggested script name: `continue_loop_demo.sh`

```bash
#!/bin/bash

for number in {1..5}
do
    if (( number == 3 )); then
        continue
    fi

    echo "$number"
done

exit 0
```

Expected output:

```text
1
2
4
5
```

Jab number `3` hota hai, `continue` current iteration ke baqi commands skip kar deta hai. Loop band nahi hota; next iteration mein number `4` aa jata hai.

### Practical example: missing files skip karna

```bash
for file in *.log
do
    [[ -e "$file" ]] || continue
    echo "Processing: $file"
done
```

`[[ -e "$file" ]] || continue` ka matlab hai:

> Agar yeh path exist nahi karta, current iteration skip karke next iteration par chale jao.

---

## 10. `break 2` aur `continue 2`

### `break 2`

Suggested script name: `nested_break_demo.sh`

```bash
#!/bin/bash

for server in server1 server2
do
    for port in 80 443
    do
        echo "Checking $server on port $port"

        if [[ "$server" == "server1" && "$port" == "443" ]]; then
            break 2
        fi
    done
done

echo "Both loops have ended."
exit 0
```

`break 2` current inner loop aur uske bahar wala outer loop—dono ko band kar deta hai.

### `continue 2`

Suggested script name: `nested_continue_demo.sh`

```bash
#!/bin/bash

for server in server1 server2
do
    for port in 80 443
    do
        if [[ "$port" == "80" ]]; then
            continue 2
        fi

        echo "$server:$port"
    done
done

exit 0
```

`continue 2` inner loop ka baqi hissa skip karta hai aur doosray enclosing, yani outer loop ki next iteration shuru karta hai.

Numbered forms useful hain, lekin beginner scripts mein simple loop structure samajhna aur maintain karna zyada asan hota hai.

---

## 11. `true` — Hamesha Success

Suggested script name: `true_condition_demo.sh`

```bash
#!/bin/bash

if true; then
    echo "Success"
else
    echo "Failure"
fi
```

Expected output:

```text
Success
```

### Yeh `Success` kyun print karta hai?

`true` Bash ka aik command hai jo hamesha exit status `0` return karta hai.

Bash ka `if` kisi command ka exit status check karta hai:

- Status `0` ho to condition successful hoti hai aur `then` block chalta hai.
- Status non-zero ho to condition unsuccessful hoti hai aur `else` block chalta hai.

Is liye is example mein `then` block hamesha chalega. `else` block tab tak nahi chalega jab tak `true` ko kisi fail hone wale command se replace na kiya jaye.

Status verify karein:

```bash
true
echo "$?"
```

Output:

```text
0
```

### Practical use: infinite loop

```bash
while true
do
    echo "Monitoring..."
    sleep 5
done
```

Kyunke `true` hamesha successful hota hai, loop lagatar chalta rehta hai. Isay `Ctrl+C`, kisi condition ke andar `break`, ya process signal se roka ja sakta hai.

---

## 12. `false` — Hamesha Failure

Suggested script name: `false_condition_demo.sh`

```bash
#!/bin/bash

if false; then
    echo "Success"
else
    echo "Failure"
fi
```

Expected output:

```text
Failure
```

`false` hamesha status `1` return karta hai. Is liye Bash `else` block chalata hai.

Status verify karein:

```bash
false
echo "$?"
```

Output:

```text
1
```

`false` error-handling aur failure paths ko test karne ke liye useful hai.

---

## 13. `:` — Null Command

Colon `:` ko Bash mein null command kehte hain. Yeh koi action nahi karta, lekin status `0` return karta hai.

Suggested script name: `null_command_demo.sh`

```bash
#!/bin/bash

if [[ -f "abc.txt" ]]; then
    :
else
    echo "The file does not exist."
fi
```

Yahan agar `abc.txt` regular file ho, `:` success ke sath kuch bhi nahi karta.

Isay infinite loop mein bhi use kiya ja sakta hai:

```bash
while :
do
    echo "Running..."
    sleep 2
done
```

Is context mein `:` ka behavior `true` jaisa hai.

---

## 14. Exit Status aur `$?`

Har Bash command complete hone par aik exit status produce karta hai.

- `0` ka matlab success hai.
- Non-zero value failure ya kisi special result ko represent karti hai.

`$?` sab se recent foreground command ka status rakhta hai.

```bash
ls /tmp
echo "$?"
```

### Status foran save karein

```bash
ls /missing
status=$?
echo "Status: $status"
```

`$?` ko foran save karna zaroori hai, kyunke agla command iski value replace kar deta hai.

Ghalat approach:

```bash
ls /missing
echo "Checking the result"
echo "$?"
```

Aakhri `echo "$?"`, `ls` ka status nahi dikhayega. Yeh previous `echo` ka status dikhayega.

### Jahan mumkin ho command ko directly test karein

Kam behtar approach:

```bash
cp -- "$source" "$destination"

if [[ "$?" -eq 0 ]]; then
    echo "Copy completed."
fi
```

Behtar approach:

```bash
if cp -- "$source" "$destination"; then
    echo "Copy completed."
else
    echo "Error: copy failed." >&2
    exit 1
fi
```

Direct approach zyada clear hai aur `$?` ko ghalti se overwrite hone se bachata hai.

---

## 15. Mukammal Practical Example

Suggested script name: `log_file_processor.sh`

```bash
#!/bin/bash

# Sirf aik argument required hai.
if (( $# != 1 )); then
    echo "Usage: $0 LOG_FILE" >&2
    exit 2
fi

log_file="$1"

# Check karein ke diya gaya path regular file hai.
if [[ ! -f "$log_file" ]]; then
    echo "Error: regular file not found: $log_file" >&2
    exit 1
fi

process_log()
{
    local file="$1"

    grep -q "ERROR" "$file"
}

if process_log "$log_file"; then
    echo "ERROR entries were found."
else
    status=$?

    if (( status == 1 )); then
        echo "No ERROR entries were found."
    else
        echo "Error: grep failed with status $status." >&2
        exit "$status"
    fi
fi

echo "Processing finished."
exit 0
```

### Script ka flow

```text
Argument count check
        |
        +-- Ghalat --> exit 2
        |
        v
Regular file check
        |
        +-- File nahi mili --> exit 1
        |
        v
Function call
        |
        +-- status 0 --> ERROR mila
        |
        +-- status 1 --> ERROR nahi mila
        |
        +-- status 2+ -> grep ki actual error, script exit
        |
        v
Kaam complete --> exit 0
```

### `grep` statuses

| Status | Matlab |
|---:|---|
| `0` | Matching line mil gayi |
| `1` | Matching line nahi mili |
| `2` ya zyada | `grep` ko actual error hui |

Yeh distinction important hai: no match hamesha operational error nahi hota.

---

## 16. Common Mistakes

### Mistake 1: Function ke andar ghalti se `exit` use karna

```bash
check_file()
{
    [[ -f "$1" ]] || exit 1
}
```

Yeh poori script band kar dega. Agar caller ko decision lena ho to `return` use karein:

```bash
check_file()
{
    [[ -f "$1" ]] || return 1
}
```

### Mistake 2: Yeh samajhna ke `break` poori script band karega

`break` sirf loop band karta hai. Poori script band karne ke liye `exit` use hota hai.

### Mistake 3: `continue` ko loop ke bahar use karna

`continue` sirf `for`, `while`, `until`, ya `select` loop ke andar valid hota hai.

### Mistake 4: Har non-zero status ko bilkul aik jaisa samajhna

Non-zero aam tor par unsuccessful result hai, lekin mukhtalif numbers ke mukhtalif meanings ho sakte hain. Misal ke tor par `grep` ka status `1` no match hota hai, jabke `2` actual error hoti hai.

### Mistake 5: Yeh samajhna ke `if` ko sirf `true` ya `false` text chahiye

Bash `if` Boolean text nahi, command ka exit status check karta hai:

```bash
if mkdir backup; then
    echo "Directory created."
else
    echo "Directory creation failed." >&2
fi
```

Yahan `mkdir` khud condition hai:

- `mkdir` successful ho to `then` chalega.
- `mkdir` fail ho to `else` chalega.

### Mistake 6: `exit 1` ke baad commands chalne ki umeed rakhna

```bash
echo "Before exit"
exit 1
echo "After exit"
```

`After exit` print nahi hoga, kyunke `exit 1` par script band ho chuki hogi.

---

## 17. Final Summary

| Term | Is tarah yaad rakhein | Main use |
|---|---|---|
| `exit 0` | Successfully band karo | Script ka successful completion |
| `exit 1` | Failure ke sath band karo | General script error |
| `exit N` | Selected result ke sath band karo | Documented error categories |
| `return N` | Function se bahar ao | Function ki success ya failure report karna |
| `break` | Loop se bahar ao | Loop ko jaldi rokna |
| `continue` | Yeh iteration skip karo | Aik item ignore karke loop jari rakhna |
| `true` | Hamesha success | Testing aur infinite loops |
| `false` | Hamesha failure | Failure-handling test karna |
| `:` | Kuch na karo, success do | Placeholder ya infinite loop |

### Central lesson

```text
exit     -> poori script control karta hai
return   -> function control karta hai
break    -> loop kab band hoga, yeh control karta hai
continue -> kaunsi iteration poori hogi, yeh control karta hai
```

### Golden rule

```text
Status 0     = Success
Status non-0 = Failure ya command ka special result
```

Script likhte waqt pehle decide karein:

1. Kya poori script band karni hai? — `exit`
2. Kya sirf function se bahar ana hai? — `return`
3. Kya loop rokna hai? — `break`
4. Kya sirf current item skip karna hai? — `continue`

