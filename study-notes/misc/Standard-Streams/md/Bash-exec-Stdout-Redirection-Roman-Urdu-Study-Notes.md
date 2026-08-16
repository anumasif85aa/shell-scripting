# Bash `exec` Stdout Redirection — Roman Urdu Study Notes

## Table of Contents

- [1. Command](#1-command)
- [2. Seedha Matlab](#2-seedha-matlab)
- [3. Command Breakdown](#3-command-breakdown)
- [4. `exec` Yahan Kya Karta Hai?](#4-exec-yahan-kya-karta-hai)
- [5. `>>` Ka Meaning](#5--ka-meaning)
- [6. Complete Example](#6-complete-example)
- [7. Stdout aur Stderr](#7-stdout-aur-stderr)
- [8. Dono Streams Ko Redirect Karna](#8-dono-streams-ko-redirect-karna)
- [9. Log Directory Validation](#9-log-directory-validation)
- [10. Terminal Output Restore Karna](#10-terminal-output-restore-karna)
- [11. `exec` With Command vs Redirection](#11-exec-with-command-vs-redirection)
- [12. Common Mistakes](#12-common-mistakes)
- [13. Practice Lab](#13-practice-lab)
- [14. Quick Summary](#14-quick-summary)

---

## 1. Command

```bash
exec >> logs/stdout.log
```

---

## 2. Seedha Matlab

Yeh command current script ke **tamam aglay normal output** ko terminal ke bajaye `logs/stdout.log` file mein append kar deti hai.

Simple alfaaz mein:

> Is line ke baad script ka stdout `logs/stdout.log` mein bhejo aur file ka purana content delete na karo.

---

## 3. Command Breakdown

| Part | Meaning |
|---|---|
| `exec` | Current shell ya script ki input/output redirection change karta hai. |
| `>>` | Output ko file ke end mein append karta hai. |
| `logs/` | Log files rakhne wali directory hai. |
| `stdout.log` | Woh file hai jahan normal output save hoga. |

Is command ka explicit form hai:

```bash
exec 1>> logs/stdout.log
```

Yahan file descriptor `1` stdout ko represent karta hai.

---

## 4. `exec` Yahan Kya Karta Hai?

Aam tor par har command ko separately redirect kiya ja sakta hai:

```bash
echo "Script started" >> logs/stdout.log
date >> logs/stdout.log
whoami >> logs/stdout.log
```

Lekin:

```bash
exec >> logs/stdout.log
```

stdout ki destination ko ek martaba change kar deta hai. Is line ke baad script ki normal-output commands ko individually redirect karne ki zaroorat nahi rehti.

```text
exec se pehle:

Command -> stdout -> Terminal

exec ke baad:

Command -> stdout -> logs/stdout.log
```

Important: yeh change current script ya shell ke remaining execution ke liye hota hai.

---

## 5. `>>` Ka Meaning

```bash
exec >> logs/stdout.log
```

`>>` append redirection hai:

- File missing ho to create kar sakta hai, agar parent directory available ho.
- File existing ho to purana content preserve karta hai.
- Naya output file ke end mein add karta hai.

Agar `>` use karein:

```bash
exec > logs/stdout.log
```

to file ka purana content overwrite ho jayega.

| Syntax | Result |
|---|---|
| `exec > file` | stdout redirect karke file overwrite karta hai. |
| `exec >> file` | stdout redirect karke file append karta hai. |

---

## 6. Complete Example

```bash
#!/bin/bash

mkdir -p logs

echo "Before redirection"

exec >> logs/stdout.log

echo "Script started"
date
whoami
echo "Script finished"
```

### Terminal Output

```text
Before redirection
```

`exec` ke baad wala output terminal par nazar nahi aayega, kyun ke stdout file ki taraf redirect ho chuka hai.

Log file check karein:

```bash
cat logs/stdout.log
```

Possible output:

```text
Script started
Tue Aug 11 06:30:00 PM CDT 2026
khalid
Script finished
```

Script ko dobara chalane par naya output file ke end mein add hoga.

---

## 7. Stdout aur Stderr

Yeh command sirf stdout redirect karti hai:

```bash
exec >> logs/stdout.log
```

Standard streams:

| File Descriptor | Stream | Purpose |
|---:|---|---|
| `0` | stdin | Input receive karta hai. |
| `1` | stdout | Normal output bhejta hai. |
| `2` | stderr | Errors aur warnings bhejta hai. |

Is liye script ke errors ab bhi terminal par nazar aa sakte hain.

Example:

```bash
#!/bin/bash

mkdir -p logs
exec >> logs/stdout.log

echo "Normal message"
ls /missing-directory
```

Result:

- `Normal message` file mein jayega.
- `ls` ka error terminal par nazar aayega.

---

## 8. Dono Streams Ko Redirect Karna

stdout aur stderr ko separate files mein bhejne ke liye:

```bash
exec 1>> logs/stdout.log
exec 2>> logs/stderr.log
```

Ab:

```text
Normal output -> logs/stdout.log
Error output  -> logs/stderr.log
```

Complete example:

```bash
#!/bin/bash

mkdir -p logs

exec 1>> logs/stdout.log
exec 2>> logs/stderr.log

echo "Script started"
ls /etc/passwd
ls /missing-directory
echo "Script finished"
```

stdout aur stderr ko ek hi file mein append karne ke liye:

```bash
exec >> logs/combined.log 2>&1
```

Yahan:

1. stdout `combined.log` mein append hota hai.
2. stderr stdout ki current destination par bheja jata hai.
3. Dono streams ek hi log file mein chali jati hain.

---

## 9. Log Directory Validation

`logs` directory pehle available honi chahiye. Agar directory missing ho to Bash `logs/stdout.log` create nahi kar sakta.

Basic approach:

```bash
mkdir -p logs
exec >> logs/stdout.log
```

Error-handling ke saath:

```bash
if ! mkdir -p logs; then
    echo "Error: logs directory create nahi hui." >&2
    exit 1
fi

if ! exec >> logs/stdout.log; then
    echo "Error: stdout log open nahi hua." >&2
    exit 1
fi
```

Important: agar `exec` redirection fail ho jaye to stdout ki destination change nahi hogi. Error ko stderr par bhejna is liye useful hai.

---

## 10. Terminal Output Restore Karna

Kabhi script mein stdout ko temporary taur par log file mein bhejna aur phir terminal par restore karna hota hai.

```bash
#!/bin/bash

mkdir -p logs

# Original stdout ko file descriptor 3 par save karein.
exec 3>&1

# Stdout ko log file mein redirect karein.
exec 1>> logs/stdout.log

echo "This goes to the log file"
date

# Original stdout restore karein.
exec 1>&3

# File descriptor 3 close karein.
exec 3>&-

echo "This appears on the terminal"
```

Explanation:

| Command | Meaning |
|---|---|
| `exec 3>&1` | Original stdout ko descriptor `3` par save karta hai. |
| `exec 1>> file` | stdout ko log file mein redirect karta hai. |
| `exec 1>&3` | stdout ko saved terminal destination par restore karta hai. |
| `exec 3>&-` | Extra descriptor `3` ko close karta hai. |

Yeh intermediate-to-advanced pattern hai. Beginner scripts mein aksar whole-script redirection hi sufficient hoti hai.

---

## 11. `exec` With Command vs Redirection

`exec` do important forms mein nazar aa sakta hai.

### Sirf redirection ke saath

```bash
exec >> logs/stdout.log
```

Yahan koi external command nahi di gayi. Bash current shell ki stdout redirection change karta hai aur script continue karti hai.

### Command ke saath

```bash
exec bash another_script.sh
```

Yahan current shell process ko `bash another_script.sh` replace kar deta hai. Jab replacement command finish hoti hai, purani script mein wapas nahi aati.

| Form | Behavior |
|---|---|
| `exec redirection` | Current shell ke file descriptors change karta hai. |
| `exec command` | Current shell process ko command se replace karta hai. |

---

## 12. Common Mistakes

### Mistake 1: Directory Create Na Karna

```bash
exec >> logs/stdout.log
```

Agar `logs` directory missing ho to redirection fail ho jayegi.

Better:

```bash
mkdir -p logs || exit 1
exec >> logs/stdout.log
```

### Mistake 2: Terminal Par Output Expect Karna

```bash
exec >> logs/stdout.log
echo "Hello"
```

`Hello` terminal par nahi, file mein jayega.

### Mistake 3: Samajhna Ke Errors Bhi Redirect Ho Gaye

```bash
exec >> logs/stdout.log
```

Sirf stdout redirect hota hai. stderr ke liye:

```bash
exec 2>> logs/stderr.log
```

### Mistake 4: `>` aur `>>` Ko Same Samajhna

```bash
exec > logs/stdout.log
```

Old content overwrite karta hai.

```bash
exec >> logs/stdout.log
```

Old content preserve karke append karta hai.

### Mistake 5: Redirection Ke Baad Success Message Terminal Par Bhejna

```bash
exec >> logs/stdout.log
echo "Logging enabled"
```

Yeh message bhi log file mein jayega. Agar terminal par message chahiye to redirection se pehle print karein ya original stdout save aur restore karein.

---

## 13. Practice Lab

Create `exec_logging_demo.sh` jo:

1. `logs` directory safely create kare.
2. Redirection se pehle terminal par `Logging is starting` print kare.
3. `exec` se stdout ko `logs/stdout.log` mein append kare.
4. stderr ko `logs/stderr.log` mein append kare.
5. `date`, `whoami`, aur `pwd` ka normal output generate kare.
6. `ls /missing-directory` se ek controlled error generate kare.
7. Script ke baad dono log files display karke verify kare.

Suggested solution:

```bash
#!/bin/bash

if ! mkdir -p logs; then
    echo "Error: logs directory create nahi hui." >&2
    exit 1
fi

echo "Logging is starting"

exec 1>> logs/stdout.log
exec 2>> logs/stderr.log

echo "[$(date)] Script started"
echo "User: $(whoami)"
echo "Directory: $(pwd)"

ls /missing-directory

echo "[$(date)] Script finished"
exit 0
```

Run:

```bash
bash exec_logging_demo.sh
```

Review:

```bash
cat logs/stdout.log
cat logs/stderr.log
```

---

## 14. Quick Summary

```bash
exec >> logs/stdout.log
```

Roman Urdu meaning:

> Current script ke is point ke baad tamam normal output ko `logs/stdout.log` ke end mein add karte raho.

Remember:

```text
exec      = current shell ki redirection change karta hai
1         = stdout
2         = stderr
>         = overwrite
>>        = append
```

Common whole-script logging pattern:

```bash
mkdir -p logs || exit 1
exec 1>> logs/stdout.log
exec 2>> logs/stderr.log
```

