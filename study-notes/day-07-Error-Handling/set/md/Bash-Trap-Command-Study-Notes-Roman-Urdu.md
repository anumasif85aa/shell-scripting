# Bash `trap` Command — Roman Urdu Study Notes

## Table of Contents

1. [`trap` kya hai?](#1-trap-kya-hai)
2. [`trap` kyun use hota hai?](#2-trap-kyun-use-hota-hai)
3. [Basic syntax](#3-basic-syntax)
4. [Common events aur signals](#4-common-events-aur-signals)
5. [`EXIT` trap](#5-exit-trap)
6. [`INT` aur `Ctrl+C`](#6-int-aur-ctrlc)
7. [`TERM` signal](#7-term-signal)
8. [`ERR` trap](#8-err-trap)
9. [Temporary file cleanup](#9-temporary-file-cleanup)
10. [Original exit status preserve karna](#10-original-exit-status-preserve-karna)
11. [`set -E`, `set -e` aur `trap`](#11-set--e-set--e-aur-trap)
12. [Trap ko dekhna, remove aur reset karna](#12-trap-ko-dekhna-remove-aur-reset-karna)
13. [Kaun se signals trap nahi ho sakte?](#13-kaun-se-signals-trap-nahi-ho-sakte)
14. [Complete practical script](#14-complete-practical-script)
15. [Common mistakes](#15-common-mistakes)
16. [Best practices](#16-best-practices)
17. [Quick-reference table](#17-quick-reference-table)
18. [Practice exercises](#18-practice-exercises)
19. [Summary](#19-summary)

---

## 1. `trap` kya hai?

`trap` Bash ka built-in command hai. Yeh script ko kisi khaas **event** ya **signal** ke aane par automatically koi command ya function chalane deta hai.

Asaan alfaaz mein:

> `trap` script ko batata hai: “Agar yeh event aaye, to yeh kaam karna.”

Example:

```bash
trap 'echo "Script band ho rahi hai."' EXIT
```

Jab script khatam hogi, `echo` command automatically chalegi.

---

## 2. `trap` kyun use hota hai?

`trap` commonly in kaamon ke liye use hota hai:

- Temporary files delete karna
- Temporary directories remove karna
- `Ctrl+C` ko safely handle karna
- Script terminate hone par cleanup karna
- Error ki line aur status report karna
- Lock files remove karna
- Log file mein shutdown message likhna
- Background processes stop karna
- Adhoora kaam safely close karna

`trap` error ko prevent nahi karta. Yeh error ya event hone ke baad required action chalata hai.

---

## 3. Basic syntax

```bash
trap 'commands' SIGNAL
```

Example:

```bash
trap 'echo "Cleanup chal rahi hai."' EXIT
```

Multiple signals ke liye:

```bash
trap 'echo "Script interrupt hui."' INT TERM
```

Function ko trap ke saath register karna:

```bash
cleanup()
{
    echo "Cleanup chal rahi hai."
}

trap cleanup EXIT
```

Long commands ke liye function use karna zyada readable aur maintainable hota hai.

---

## 4. Common events aur signals

| Event/Signal | Full name | Kab hota hai? | Common use |
|---|---|---|---|
| `EXIT` | Shell exit event | Script kisi bhi wajah se khatam ho | Cleanup |
| `ERR` | Error event | Eligible command non-zero status de | Error report |
| `INT` | `SIGINT` | User `Ctrl+C` press kare | Safe interruption |
| `TERM` | `SIGTERM` | Process ko termination request mile | Graceful shutdown |
| `HUP` | `SIGHUP` | Terminal/session disconnect ho | Reload ya cleanup |
| `DEBUG` | Debug event | Har eligible command se pehle | Advanced debugging |
| `RETURN` | Return event | Function ya sourced file return kare | Advanced tracing |

Signal names ko `SIG` prefix ke saath bhi likha ja sakta hai:

```bash
trap 'echo "Interrupted"' SIGINT
```

Yeh is ke barabar hai:

```bash
trap 'echo "Interrupted"' INT
```

---

## 5. `EXIT` trap

`EXIT` trap script khatam hone se pehle chalta hai, chahe script:

- Successfully complete ho
- `exit 1` se fail ho
- `set -e` ki wajah se ruk jaye
- Kisi handled signal ki wajah se exit kare

### Example

```bash
#!/bin/bash

trap 'echo "Script complete ho gayi."' EXIT

echo "Kaam shuru ho raha hai..."
echo "Kaam mukammal ho gaya."
```

Output:

```text
Kaam shuru ho raha hai...
Kaam mukammal ho gaya.
Script complete ho gayi.
```

### Important point

`EXIT` koi operating-system signal nahi hai. Yeh Bash ka special pseudo-signal ya event hai.

---

## 6. `INT` aur `Ctrl+C`

Jab user terminal mein `Ctrl+C` press karta hai, running process ko aam tor par `SIGINT` signal milta hai.

```bash
#!/bin/bash

handle_interrupt()
{
    echo
    echo "Script ko user ne interrupt kiya." >&2
    exit 130
}

trap handle_interrupt INT

while true
do
    echo "Script chal rahi hai..."
    sleep 2
done
```

### `exit 130` kyun?

Signals ki wajah se termination ka common exit-status formula hai:

```text
128 + signal number
```

`SIGINT` ka signal number `2` hai:

```text
128 + 2 = 130
```

Is liye `Ctrl+C` handle karne ke baad `exit 130` meaningful status deta hai.

---

## 7. `TERM` signal

`SIGTERM` kisi process ko gracefully band hone ki request deta hai.

Example script:

```bash
#!/bin/bash

handle_termination()
{
    echo "Termination request receive hui." >&2
    exit 143
}

trap handle_termination TERM

while true
do
    echo "Working..."
    sleep 3
done
```

Doosre terminal se signal bhejein:

```bash
kill -TERM PROCESS_ID
```

`SIGTERM` ka number `15` hai:

```text
128 + 15 = 143
```

---

## 8. `ERR` trap

`ERR` trap eligible command ke non-zero exit status return karne par chalta hai.

```bash
#!/bin/bash

trap 'echo "Error line $LINENO par aaya." >&2' ERR

cp missing.txt backup.txt
```

Possible output:

```text
cp: cannot stat 'missing.txt': No such file or directory
Error line 5 par aaya.
```

### Useful Bash variables

| Variable | Meaning |
|---|---|
| `$?` | Pichhli command ka exit status |
| `$LINENO` | Current line number |
| `$BASH_COMMAND` | Woh command jo execute ho rahi thi |
| `${BASH_SOURCE[0]}` | Current script ka naam/path |

Detailed handler:

```bash
report_error()
{
    local status=$?
    local line_number=$1

    echo "Error: line $line_number par command fail hui." >&2
    echo "Command: $BASH_COMMAND" >&2
    echo "Status: $status" >&2

    return "$status"
}

trap 'report_error "$LINENO"' ERR
```

### Important limitation

`ERR` trap har non-zero status par nahi chalta. Misal ke taur par commands jo condition check kar rahi hon, un ka non-zero status expected ho sakta hai:

```bash
if grep -q "ERROR" application.log; then
    echo "ERROR mila."
fi
```

Yahan `grep` ka status `if` condition ka hissa hai, is liye Bash usay normal decision ke taur par treat karta hai.

---

## 9. Temporary file cleanup

Temporary file create karke usay script exit par remove karne ka safe pattern:

```bash
#!/bin/bash

temporary_file=$(mktemp)

cleanup()
{
    echo "Temporary file remove ki ja rahi hai."
    rm -f -- "$temporary_file"
}

trap cleanup EXIT

echo "Temporary data" > "$temporary_file"
echo "Temporary file: $temporary_file"
```

### Commands ki explanation

| Command | Explanation |
|---|---|
| `mktemp` | Unique aur safe temporary file banata hai |
| `rm -f` | File ko bina unnecessary prompt ke remove karta hai |
| `--` | Options ka end mark karta hai; unusual filename se protection deta hai |
| `trap cleanup EXIT` | Script exit par `cleanup` function chalata hai |

---

## 10. Original exit status preserve karna

Cleanup command khud exit status ko change kar sakti hai. Is liye original status ko sab se pehle save karna achhi practice hai.

```bash
#!/bin/bash

temporary_file=$(mktemp)

cleanup()
{
    local status=$?

    rm -f -- "$temporary_file"

    exit "$status"
}

trap cleanup EXIT

cp missing.txt backup.txt
```

### Flow

1. Command fail hoti hai.
2. Bash exit process start karta hai.
3. `EXIT` trap `cleanup` function chalata hai.
4. `local status=$?` original exit status save karta hai.
5. Temporary file remove hoti hai.
6. `exit "$status"` original result wapas deta hai.

### Important rule

Trap function ke andar `$?` ko sab se pehle capture karein:

```bash
local status=$?
```

Agar is se pehle koi aur command chal gayi, to `$?` us command ka status ban jayega.

---

## 11. `set -E`, `set -e` aur `trap`

Common strict-mode line:

```bash
set -Eeuo pipefail
```

| Option | Meaning |
|---|---|
| `-e` | Eligible unhandled command failure par script exit karti hai |
| `-E` | `ERR` trap ko functions, command substitutions aur subshell contexts mein inherit karne mein madad karta hai |
| `-u` | Unset variable use hone par error deta hai |
| `pipefail` | Pipeline ko fail karta hai agar us ki koi command fail ho |

Example:

```bash
#!/bin/bash

set -Eeuo pipefail

report_error()
{
    local status=$?
    local line_number=$1

    echo "Error: line $line_number par failure hui." >&2
    return "$status"
}

trap 'report_error "$LINENO"' ERR

grep "ERROR" missing.log | wc -l

echo "Pipeline complete."
```

`missing.log` na hone par:

- `grep` fail hoga.
- `pipefail` poori pipeline ko failed banayega.
- `ERR` trap error report karega.
- `set -e` script ko rok dega.
- `Pipeline complete.` print nahi hoga.

### Caution

`set -e` aur `ERR` ke rules context-dependent hain. Expected failures ko explicit `if` condition ke saath handle karna zyada clear hota hai:

```bash
if cp -- "$source" "$destination"; then
    echo "Copy successful."
else
    echo "Error: copy failed." >&2
    exit 1
fi
```

---

## 12. Trap ko dekhna, remove aur reset karna

### Registered traps dekhna

```bash
trap -p
```

Specific trap dekhna:

```bash
trap -p EXIT
```

### Default behavior restore karna

```bash
trap - EXIT
```

Multiple signals reset karna:

```bash
trap - INT TERM
```

### Signal ignore karna

```bash
trap '' INT
```

Is se `Ctrl+C` ignore ho sakta hai.

Default behavior dobara restore karne ke liye:

```bash
trap - INT
```

Signals ko ignore karna carefully use karein. User ko script stop karne ka reasonable tareeqa milna chahiye.

---

## 13. Kaun se signals trap nahi ho sakte?

Yeh do signals trap, block ya ignore nahi kiye ja sakte:

```text
SIGKILL
SIGSTOP
```

Is liye yeh kaam nahi karega:

```bash
trap 'echo "Process killed"' SIGKILL
```

`SIGKILL` operating system ko process foran terminate karne ke liye kehta hai. Script ko cleanup ka chance nahi milta.

Is wajah se important data ko sirf final cleanup par depend nahi karna chahiye. Long-running script ko intermediate state bhi safely save karni chahiye.

---

## 14. Complete practical script

Yeh script ek source file ko temporary file mein process karti hai aur phir final output banati hai.

```bash
#!/bin/bash

# Title: Safe File Processor
# Usage: ./safe_processor.sh SOURCE_FILE

set -Eeuo pipefail

temporary_file=""

cleanup()
{
    local status=$?

    if [[ -n "$temporary_file" && -f "$temporary_file" ]]; then
        rm -f -- "$temporary_file"
    fi

    exit "$status"
}

report_error()
{
    local status=$?
    local line_number=$1

    echo "Error: line $line_number par command fail hui." >&2
    echo "Command: $BASH_COMMAND" >&2

    return "$status"
}

handle_interrupt()
{
    echo "Error: script interrupt ki gayi." >&2
    exit 130
}

trap cleanup EXIT
trap 'report_error "$LINENO"' ERR
trap handle_interrupt INT TERM

if (( $# != 1 )); then
    echo "Usage: $0 SOURCE_FILE" >&2
    exit 2
fi

source_file=$1

if [[ ! -f "$source_file" ]]; then
    echo "Error: regular source file nahi mili: $source_file" >&2
    exit 1
fi

temporary_file=$(mktemp)

grep "ERROR" "$source_file" > "$temporary_file"

output_file="error-report.txt"
mv -- "$temporary_file" "$output_file"
temporary_file=""

echo "Report create ho gayi: $output_file"
exit 0
```

### Script flow

1. Strict error handling enable hoti hai.
2. Cleanup, error aur interruption functions define hote hain.
3. Functions ko `trap` events ke saath register kiya jata hai.
4. Argument count validate hota hai.
5. Source file check hoti hai.
6. Temporary file create hoti hai.
7. Matching data temporary file mein likha jata hai.
8. Successful processing par temporary file final report ban jati hai.
9. Script exit par cleanup function run hota hai.

### Note about `grep`

Agar koi `ERROR` line na mile to `grep` status `1` return karta hai. Agar “no match” normal result hai, to usay explicitly handle karein. Misal:

```bash
if grep "ERROR" "$source_file" > "$temporary_file"; then
    echo "ERROR entries mil gayin."
else
    status=$?

    if (( status == 1 )); then
        echo "Koi ERROR entry nahi mili."
        : > "$temporary_file"
    else
        echo "Error: grep status $status ke saath fail hua." >&2
        exit "$status"
    fi
fi
```

---

## 15. Common mistakes

### Mistake 1: Cleanup ko manually har jagah repeat karna

```bash
rm -f "$temporary_file"
exit 1
```

Har failure path par same commands repeat karne ke bajaye:

```bash
trap cleanup EXIT
```

use karein.

### Mistake 2: `$?` late capture karna

Incorrect:

```bash
cleanup()
{
    echo "Cleaning..."
    status=$?
}
```

Yahan `status` ko `echo` ka result milega.

Correct:

```bash
cleanup()
{
    local status=$?
    echo "Cleaning..."
    exit "$status"
}
```

### Mistake 3: Variable ko quote na karna

Incorrect:

```bash
rm -f $temporary_file
```

Correct:

```bash
rm -f -- "$temporary_file"
```

### Mistake 4: `SIGKILL` trap karne ki koshish

```bash
trap cleanup SIGKILL
```

`SIGKILL` trap nahi ho sakta.

### Mistake 5: Sirf `ERR` trap ko complete error handling samajhna

`ERR` trap useful hai, lekin input validation aur expected failures ke liye `if`, `else` aur explicit status handling bhi zaroori hai.

### Mistake 6: Ek hi signal par naya trap laga kar purana overwrite karna

```bash
trap 'echo "First"' EXIT
trap 'echo "Second"' EXIT
```

Doosra trap pehle `EXIT` trap ko replace kar dega. Dono kaam ek function mein combine karein.

---

## 16. Best practices

- Cleanup logic ko named function mein rakhein.
- `trap` definitions ko script ke shuru ke qareeb rakhein.
- Temporary files aur directories ke liye `mktemp` use karein.
- Cleanup function ke start mein original `$?` capture karein.
- Paths aur variables ko double quotes mein rakhein.
- File commands ke saath `--` use karein.
- `INT` aur `TERM` ko graceful shutdown ke liye handle karein.
- `SIGKILL` aur `SIGSTOP` ko trap karne ki koshish na karein.
- Expected non-zero statuses ko explicit `if` blocks mein handle karein.
- `ERR` handler mein useful context dein: line, command aur status.
- Cleanup ko idempotent banayein, yani dobara chale to bhi unnecessary failure na ho.
- Cleanup mein undefined ya empty paths ke saath destructive commands na chalayein.
- Script ko success, failure aur `Ctrl+C` tino scenarios mein test karein.

---

## 17. Quick-reference table

| Task | Syntax | Meaning |
|---|---|---|
| Exit par command chalana | `trap 'command' EXIT` | Script end par command chalegi |
| Exit par function chalana | `trap cleanup EXIT` | Script end par cleanup function chalega |
| `Ctrl+C` handle karna | `trap handler INT` | `SIGINT` ko handler receive karega |
| Termination handle karna | `trap handler TERM` | `SIGTERM` ko handler receive karega |
| Error report karna | `trap handler ERR` | Eligible failure par handler chalega |
| Multiple signals | `trap handler INT TERM` | Ek handler dono signals handle karega |
| Traps list karna | `trap -p` | Registered traps dikhata hai |
| Specific trap dekhna | `trap -p EXIT` | `EXIT` trap dikhata hai |
| Trap reset karna | `trap - EXIT` | Default `EXIT` behavior restore karta hai |
| Signal ignore karna | `trap '' INT` | `SIGINT` ko ignore karta hai |
| Signal name use karna | `trap handler SIGINT` | `INT` ka full signal name |
| Safe temporary file | `file=$(mktemp)` | Unique temporary file create karta hai |
| Exit status capture | `local status=$?` | Previous status ko save karta hai |
| Error line | `$LINENO` | Current Bash line number |
| Failed command context | `$BASH_COMMAND` | Current/failing command ki information |

---

## 18. Practice exercises

### Exercise 1: Simple exit message

Ek script banayein jo `EXIT` trap ke zariye yeh message print kare:

```text
Script finished.
```

### Exercise 2: Temporary file cleanup

`mktemp` se file create karein, us mein data likhein aur `EXIT` trap se delete karein.

### Exercise 3: `Ctrl+C` handler

Infinite loop banayein aur `INT` trap ke through `Ctrl+C` par meaningful message aur `exit 130` use karein.

### Exercise 4: Error report

Missing file ko `cp` karne ki koshish karein. `ERR` trap ke through line number aur exit status print karein.

### Exercise 5: Pipeline failure

`set -Eeuo pipefail` ke saath missing log file par `grep | wc -l` pipeline run karein aur observe karein ke final success message print hota hai ya nahi.

---

## 19. Summary

`trap` Bash script ko events aur signals handle karne deta hai.

Sab se common pattern:

```bash
cleanup()
{
    local status=$?
    # Cleanup commands
    exit "$status"
}

trap cleanup EXIT
```

Is ka matlab hai:

> Script jab bhi khatam ho, `cleanup` function chalao aur original exit status preserve rakho.

Yaad rakhein:

- `EXIT` cleanup ke liye useful hai.
- `INT` `Ctrl+C` ko handle karta hai.
- `TERM` graceful termination ke liye use hota hai.
- `ERR` eligible command failures report karta hai.
- `SIGKILL` aur `SIGSTOP` trap nahi ho sakte.
- `trap` validation ka replacement nahi; yeh reliable cleanup aur signal handling ka tool hai.

