# Bash `case` Statement — Complete Roman Urdu Study Notes

## Table of Contents

1. [`case` Statement Kya Hai?](#1-case-statement-kya-hai)
2. [Basic Syntax](#2-basic-syntax)
3. [Har Hissay ka Matlab](#3-har-hissay-ka-matlab)
4. [Simple Yes-or-No Example](#4-simple-yes-or-no-example)
5. [`|` ke Saath Multiple Patterns](#5--ke-saath-multiple-patterns)
6. [Default `*` Pattern](#6-default--pattern)
7. [Service-Checker Example](#7-service-checker-example)
8. [Menu Example](#8-menu-example)
9. [Useful Pattern Symbols](#9-useful-pattern-symbols)
10. [`case` vs `if`](#10-case-vs-if)
11. [`case` Loop Nahin Hai](#11-case-loop-nahin-hai)
12. [Exit-Status Behavior](#12-exit-status-behavior)
13. [Common Mistakes](#13-common-mistakes)
14. [Practice Tasks](#14-practice-tasks)
15. [Final Summary](#15-final-summary)

---

## 1. `case` Statement Kya Hai?

Bash ka `case` statement aik **conditional** ya decision-making structure hai.

Yeh aik value ko mukhtalif patterns ke saath compare karta hai aur pehla matching command block run karta hai.

`case` khas tor par in kaamon ke liye useful hai:

- Yes-or-No input handle karna
- Menu selections
- `start`, `stop`, `restart` aur `status` actions
- Operating-system names check karna
- File extensions identify karna
- Command-line options handle karna

> `case` loop nahin hai. Yeh sirf aik command block select karta hai; commands ko automatically repeat nahin karta.

---

## 2. Basic Syntax

```bash
case "$variable" in
    pattern1)
        commands
        ;;
    pattern2)
        commands
        ;;
    *)
        default_commands
        ;;
esac
```

Execution flow:

1. Bash `case` ke baad wali value read karta hai.
2. Patterns ko top se bottom check karta hai.
3. Pehla matching block run hota hai.
4. `;;` us branch ko end karta hai.
5. Bash `esac` ke baad wali command par chala jata hai.

---

## 3. Har Hissay ka Matlab

| Hissa | Matlab |
|---|---|
| `case` | Decision statement start karta hai. |
| `"$variable"` | Woh value jis ko Bash check karega. |
| `in` | Patterns ki list start karta hai. |
| `pattern)` | Possible value ya wildcard pattern. |
| `commands` | Pattern match hone par chalne wali commands. |
| `;;` | Current pattern branch ko end karta hai. |
| `*` | Default pattern; pehle match na hone wali har value ko pakarta hai. |
| `esac` | `case` statement end karta hai; yeh `case` ulta likha hua hai. |

Closing keywords yaad rakhein:

```text
if   → fi
case → esac
```

---

## 4. Simple Yes-or-No Example

**script name:** `yes_no_prompt.sh`

```bash
#!/bin/bash

read -r -p "Enter y or n: " answer

case "$answer" in
    y)
        echo "You selected Yes."
        ;;
    n)
        echo "You selected No."
        ;;
    *)
        echo "Invalid answer." >&2
        ;;
esac

exit 0
```

### Input `y`

```text
You selected Yes.
```

### Input `n`

```text
You selected No.
```

### Koi Aur Input

```text
Invalid answer.
```

Value ko normally quote karna chahiye:

```text
case "$answer" in
```

Quotes empty input, spaces aur wildcard characters ko safely preserve karti hain.

---

## 5. `|` ke Saath Multiple Patterns

`case` pattern ke andar pipe `|` ka matlab **or** hota hai:

```text
y|Y)
```

Yeh lowercase `y` ya uppercase `Y` dono match karta hai.

Complete words bhi accept kiye ja sakte hain:

**script name:** `yes_no_multiple_patterns.sh`

```bash
case "$answer" in
    y|Y|yes|Yes|YES)
        echo "You selected Yes."
        ;;
    n|N|no|No|NO)
        echo "You selected No."
        ;;
    *)
        echo "Invalid response." >&2
        exit 1
        ;;
esac
```

Yahan `|` command pipeline nahin hai. Yeh alternative patterns ko separate karta hai.

---

## 6. Default `*` Pattern

```text
*)
    echo "Invalid response." >&2
    ;;
```

Asterisk `*` wildcard hai. Yeh pehle branches se match na hone wali har value ko match karta hai.

Agar sirf `y` aur `n` define hon, default branch in values ko pakar sakti hai:

```text
yes
no
maybe
apple
empty answer
```

`*` ko hamesha last mein rakhein. Agar yeh pehle ho, to har value isi se match ho jayegi aur specific branches tak execution nahin pohanchega.

---

## 7. Service-Checker Example

**script name:** `nginx_service_status_checker.sh`

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
[For Detailed Explanation in roman Urdu Cliclk here](md/case_explanation_notes_roman_urdu.md)

[For Detailed Explanation in Cliclk here](md/case_explanation_notes.md)

### Branch Behavior

| Input | Branch | Result |
|---|---|---|
| `y`, `Y` ya accepted Yes word | Pehli branch | Service check hoti hai. |
| `n`, `N` ya accepted No word | Doosri branch | `Skipped.` print hota hai. |
| Koi aur input | Default branch | Error print hota hai. |

### Nested `if`

`case` branch ke andar `if` statement bhi ho sakta hai.

`case` decide karta hai ke user service check karna chahta hai ya nahin. Nested `if` decide karta hai ke service active hai ya nahin.

---

## 8. Menu Example

**script name:** `system_information_menu.sh`

```bash
#!/bin/bash

echo "1. Show date"
echo "2. Show current directory"
echo "3. Show current user"
echo "4. Exit"

read -r -p "Select an option: " choice

case "$choice" in
    1)
        date
        ;;
    2)
        pwd
        ;;
    3)
        whoami
        ;;
    4)
        echo "Goodbye."
        exit 0
        ;;
    *)
        echo "Error: choose a number from 1 to 4." >&2
        exit 1
        ;;
esac

exit 0
```

Yeh menu sirf aik martaba run hota hai. Menu ko repeat karne ke liye `case` ko loop ke andar rakhein.

---

## 9. Useful Pattern Symbols

Bash `case` shell patterns use karta hai, regular expressions nahin.

| Pattern | Matlab | Example Match |
|---|---|---|
| `*` | Zero ya zyada characters | Har value |
| `?` | Exactly aik character | `a`, `7`, `-` |
| `[abc]` | Listed characters mein se aik | `a`, `b`, ya `c` |
| `[0-9]` | Aik digit | `0` se `9` |
| `a*` | `a` se start | `apple`, `admin` |
| `*.txt` | `.txt` par end | `notes.txt` |
| `y|Y` | Dono mein se aik pattern | `y` ya `Y` |

### File-Extension Example

**script name:** `file_type_classifier.sh`

```bash
case "$filename" in
    *.txt)
        echo "Text file"
        ;;
    *.sh)
        echo "Shell script"
        ;;
    *.md)
        echo "Markdown file"
        ;;
    *)
        echo "Unknown file type"
        ;;
esac
```

### Glob vs Regex

```text
*.txt
```

Yeh shell glob pattern hai. `case` branch `=~` regex operator use nahin karti.

Regex matching ke liye:

```bash
[[ "$value" =~ REGEX ]]
```

---

## 10. `case` vs `if`

Dono decisions banate hain, lekin mukhtalif situations mein useful hain.

| Requirement | Behtar Structure |
|---|---|
| Aik value ko multiple choices ke saath match karna | `case` |
| Menu options handle karna | `case` |
| `start`, `stop`, `restart`, `status` handle karna | `case` |
| File extensions ya wildcard patterns match karna | `case` |
| Numbers compare karna | `if` with `(( ... ))` |
| Files ko `-f`, `-d`, `-e` se test karna | `if` with `[[ ... ]]` |
| Multiple logical conditions combine karna | `if` |
| Command ka exit status check karna | `if command; then` |

### `if` Version

**script name:** `yes_no_if_example.sh`

```bash
if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    echo "Yes"
elif [[ "$answer" == "n" || "$answer" == "N" ]]; then
    echo "No"
else
    echo "Invalid"
fi
```

### Equivalent `case` Version

**script name:** `yes_no_case_example.sh`

```bash
case "$answer" in
    y|Y)
        echo "Yes"
        ;;
    n|N)
        echo "No"
        ;;
    *)
        echo "Invalid"
        ;;
esac
```

Multiple exact choices ke liye `case` aksar zyada readable hota hai.

---

## 11. `case` Loop Nahin Hai

`case` value ko aik martaba check karta hai:

```text
Aik value read karo
    ↓
Pehla matching pattern dhoondo
    ↓
Us branch ko run karo
    ↓
esac ke baad continue karo
```

Loop commands ko repeat karta hai:

**script name:** `infinite_loop_demo.sh`

```bash
while true
do
    echo "Running..."
    sleep 2
done
```

**script name:** `infinite_loop_with_tip.sh`

```bash
#!/bin/bash

# ==============================================================================
# PRO-TIP: To safely stop a running infinite loop in your terminal,
#          press Ctrl + C.
# ==============================================================================

# Print Pro-Tip to the terminal before entering the loop
echo -e "\033[01;33m[PRO-TIP]\033[00m Press \033[01;31mCtrl + C\033[00m at any time to safely stop this loop.\n"

while true; do                         # Loop forever
    echo "Running..."                  # Output status message
    sleep 2                            # Wait 2 seconds before next iteration
done                               
```

**script name:** `interruptible_infinite_loop.sh`

```bash
#!/bin/bash

# Function triggered when user presses Ctrl+C
cleanup() {
    echo -e "\n\033[01;32m[INFO] Loop stopped safely. Goodbye!\033[00m"
    exit 0
}

# Trap SIGINT (Ctrl+C) and run the cleanup function
trap cleanup SIGINT

echo "Press Ctrl+C to exit."

while true; do
    echo "Running..."
    sleep 2
done
```

Repeated menu ke liye loop aur `case` ko combine karein:

**script name:** `service_action_menu.sh`

```bash
while true
do
    read -r -p "Enter start, stop, or quit: " action

    case "$action" in
        start)
            echo "Starting..."
            ;;
        stop)
            echo "Stopping..."
            ;;
        quit)
            echo "Goodbye."
            break
            ;;
        *)
            echo "Unknown action." >&2
            ;;
    esac
done
```

Yahan:

- `while` repetition karta hai.
- `case` action select karta hai.
- `break` user ke `quit` enter karne par loop end karta hai.

---

## 12. Exit-Status Behavior

`case` statement normally selected branch ki last executed command ka status deta hai. Agar koi pattern match na ho aur default branch bhi na ho, status `0` hota hai.

Clear behavior ke liye appropriate exit statuses explicitly use karein:

**script name:** `case_exit_status_demo.sh`

```bash
case "$answer" in
    y|Y)
        echo "Approved."
        exit 0
        ;;
    n|N)
        echo "Declined."
        exit 0
        ;;
    *)
        echo "Invalid response." >&2
        exit 1
        ;;
esac
```

Intentional No error nahin hai, is liye `0` return karta hai. Invalid input `1` return karta hai.

---

## 13. Common Mistakes

### Mistake 1: `esac` Missing Hona

Agar `esac` na ho, Bash file ke end par bhi `case` close hone ka wait karta rahega aur syntax error dega.

### Mistake 2: `;;` Missing Hona

Har ordinary branch ko normally is se end karein:

```text
;;
```

### Mistake 3: Pattern ke Baad `)` Bhool Jana

Correct:

```text
y|Y)
```

### Mistake 4: `*` ko Pehle Rakhna

Default wildcard har cheez match kar lega aur baqi patterns unreachable ho jayenge.

### Mistake 5: `|` ko Pipeline Samajhna

`y|Y)` mein pipe alternative patterns separate karta hai. Yeh command output ko doosri command tak nahin le jata.

### Mistake 6: `case` ko Loop Kehna

`case` aik branch choose karta hai. Repetition ke liye `for`, `while`, ya `until` use karein.

### Mistake 7: Regex Expect Karna

`case` shell patterns use karta hai. Bash regex ke liye `[[ value =~ regex ]]` use hota hai.

---

## 14. Practice Tasks

### Task 1 — Yes or No

User se poochhein ke woh continue karna chahta hai ya nahin. Lowercase aur uppercase `y` aur `n` accept karein. Doosray responses reject karein.

### Task 2 — Service Action

In actions mein se aik input lein:

```text
start
stop
restart
status
```

Abhi real service command na chalayein; sirf selected action print karein.

### Task 3 — File Type

Filename le kar `.txt`, `.sh`, aur `.md` extensions ko `case` patterns ke saath classify karein.

### Task 4 — Repeating Menu

`while` loop ke andar `case` menu banayein. `quit` option mein `break` use karein.

### Task 5 — Exit Status

Accepted choice ke liye `0` aur invalid input ke liye `1` return karein. Status foran check karein:

```bash
echo "$?"
```

---

## 15. Final Summary

```text
case       → Decision statement start
"$value"   → Check hone wali value
in         → Pattern list start
y|Y)       → y ya Y match
*)         → Default pattern
;;         → Aik branch end
esac       → case statement end
```

Yaad rakhein:

> `case` pehli matching branch select karta hai. Yeh commands ko repeat nahin karta jab tak isay loop ke andar na rakha jaye.
