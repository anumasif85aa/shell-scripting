# Bash Regular Expressions — Quick Reference Cheat Sheet

**Roman Urdu | POSIX Extended Regular Expressions (ERE) | Fast Lookup**

> Yeh file sirf Bash regular expressions ke liye hai. Is mein globbing, `case` patterns, file tests aur parameter-expansion patterns shamil nahi hain.

## Quick Navigation

- [1. Sab se zaroori syntax](#1-sab-se-zaroori-syntax)
- [2. Regex symbols](#2-regex-symbols)
- [3. POSIX character classes](#3-posix-character-classes)
- [4. Anchors aur matching scope](#4-anchors-aur-matching-scope)
- [5. Quantifiers](#5-quantifiers)
- [6. Groups, alternatives aur captures](#6-groups-alternatives-aur-captures)
- [7. Ready-to-use validation patterns](#7-ready-to-use-validation-patterns)
- [8. Quoting aur escaping rules](#8-quoting-aur-escaping-rules)
- [9. Match result aur exit status](#9-match-result-aur-exit-status)
- [10. Case-insensitive matching](#10-case-insensitive-matching)
- [11. Common mistakes](#11-common-mistakes)
- [12. Debugging quick reference](#12-debugging-quick-reference)
- [13. Bash ERE limitations](#13-bash-ere-limitations)
- [14. Copy-and-use templates](#14-copy-and-use-templates)
- [15. Final one-screen reference](#15-final-one-screen-reference)

---

## 1. Sab se zaroori syntax

### Core Bash regex table

| Maqsad | Syntax | Natija |
|---|---|---|
| Regex match check karein | `[[ "$value" =~ $regex ]]` | Match ho to true |
| Regex match ko reverse karein | `[[ ! "$value" =~ $regex ]]` | Match na ho to true |
| Inline regex use karein | `[[ "$value" =~ ^[0-9]+$ ]]` | Digits-only validation |
| Regex variable use karein | `regex='^[0-9]+$'` | Complex regex readable rehti hai |
| Pura match hasil karein | `${BASH_REMATCH[0]}` | Complete matched text |
| Pehla group hasil karein | `${BASH_REMATCH[1]}` | Pehle `(...)` ka match |
| Doosra group hasil karein | `${BASH_REMATCH[2]}` | Doosre `(...)` ka match |

### Recommended form

```bash
regex='^[0-9]+$'

if [[ "$value" =~ $regex ]]; then
    echo "Valid"
else
    echo "Invalid"
fi
```

### Important rule

```bash
[[ "$value" =~ $regex ]]    # Sahi
[[ "$value" =~ "$regex" ]]  # Ghalat: regex literal text ban sakti hai
```

Left-side data ko quote karein. Right-side regex variable ko quote na karein.

---

## 2. Regex symbols

### Metacharacters quick-reference table

| Symbol | Naam | Matlab | Example | Example kisay match karega? |
|---|---|---|---|---|
| `^` | Start anchor | String ka start | `^Error` | `Error` se start honay wali value |
| `$` | End anchor | String ka end | `[.]log$` | `.log` par end honay wali value |
| `.` | Dot | Koi bhi aik character | `c.t` | `cat`, `cut`, `c9t` |
| `[abc]` | Character class | Listed characters mein se aik | `^[abc]$` | `a`, `b`, ya `c` |
| `[^abc]` | Negated class | Listed characters ke ilawa aik | `^[^0-9]$` | Koi aik non-digit |
| `[a-z]` | Range | Range mein se aik character | `^[a-z]$` | Aik lowercase letter |
| `*` | Zero or more | Pichla item 0 ya zyada dafa | `ab*` | `a`, `ab`, `abb` |
| `+` | One or more | Pichla item 1 ya zyada dafa | `[0-9]+` | Aik ya zyada digits |
| `?` | Optional | Pichla item 0 ya 1 dafa | `-?` | Minus sign optional |
| `{n}` | Exact count | Bilkul `n` martaba | `[0-9]{4}` | Bilkul 4 digits |
| `{n,m}` | Count range | `n` se `m` martaba | `[0-9]{2,4}` | 2, 3, ya 4 digits |
| `{n,}` | Minimum count | Kam az kam `n` martaba | `[a-z]{3,}` | Kam az kam 3 letters |
| `(...)` | Group | Items ko group aur capture kare | `(yes|no)` | `yes` ya `no` |
| `|` | Alternation | Left ya right expression | `cat|dog` | `cat` ya `dog` |
| `\` | Escape | Special symbol ko literal banaye | `\.` | Actual dot `.` |

### Literal special characters

| Literal character chahiye | Regex form | Alternative readable form |
|---|---|---|
| `.` | `\.` | `[.]` |
| `*` | `\*` | `[*]` |
| `+` | `\+` | `[+]` |
| `?` | `\?` | `[?]` |
| `(` | `\(` | `[(]` |
| `)` | `\)` | `[)]` |
| `[` | `\[` | `[[]` |
| `]` | `\]` | `[]]` |
| `^` | `\^` | `[^]` portability ke liye avoid karein |
| `$` | `\$` | `[$]` |
| `|` | `\|` | `[|]` |
| `\` | `\\` | Engine aur quoting ke mutabiq test karein |

> Regex variables mein `[.]`, `[+]` aur `[*]` jaisi forms aksar backslash confusion kam karti hain.

---

## 3. POSIX character classes

### Character-class table

| Class | Matlab | Example regex | Matches |
|---|---|---|---|
| `[[:digit:]]` | Digit | `^[[:digit:]]+$` | `12345` |
| `[[:alpha:]]` | Letter | `^[[:alpha:]]+$` | `Khalid` |
| `[[:alnum:]]` | Letter ya digit | `^[[:alnum:]]+$` | `user25` |
| `[[:lower:]]` | Lowercase letter | `^[[:lower:]]+$` | `linux` |
| `[[:upper:]]` | Uppercase letter | `^[[:upper:]]+$` | `RHEL` |
| `[[:space:]]` | Whitespace | `^[[:space:]]*$` | Spaces, tabs, newline |
| `[[:blank:]]` | Space ya tab | `^[[:blank:]]*$` | Horizontal whitespace |
| `[[:xdigit:]]` | Hexadecimal digit | `^[[:xdigit:]]+$` | `09AFbe` |
| `[[:punct:]]` | Punctuation | `^[[:punct:]]+$` | `!?.,` |
| `[[:print:]]` | Printable character | `^[[:print:]]+$` | Visible text aur spaces |
| `[[:graph:]]` | Visible non-space character | `^[[:graph:]]+$` | Printable text without spaces |
| `[[:cntrl:]]` | Control character | `[[:cntrl:]]` | Tab/newline jaisay controls |

### Correct nesting

```bash
regex='^[[:digit:]]+$'  # Sahi
regex='^[:digit:]+$'    # Ghalat
```

POSIX class ko outer brackets ke andar likhna zaroori hai: `[[:digit:]]`.

---

## 4. Anchors aur matching scope

### Anchor behavior table

| Regex | Meaning | `abc123xyz` par result |
|---|---|---|
| `[0-9]+` | Kahin bhi digits dhoonde | Match: `123` |
| `^[0-9]+` | Digits se start ho | No match |
| `[0-9]+$` | Digits par end ho | No match |
| `^[0-9]+$` | Poori value sirf digits ho | No match |

### Substring search

```bash
[[ "abc123xyz" =~ [0-9]+ ]]
```

Result: true, kyun ke string ke andar `123` mojood hai.

### Whole-string validation

```bash
[[ "123" =~ ^[0-9]+$ ]]
```

Result: true, kyun ke start se end tak sirf digits hain.

### Quick rule

| Zaroorat | Anchors |
|---|---|
| String ke andar search | Aksar anchors nahi |
| Prefix check | `^pattern` |
| Suffix check | `pattern$` |
| Poori input validation | `^pattern$` |

---

## 5. Quantifiers

### Quantifier table

| Quantifier | Minimum | Maximum | Empty value allow? | Example |
|---|---:|---:|---:|---|
| `*` | 0 | Unlimited | Haan | `[0-9]*` |
| `+` | 1 | Unlimited | Nahi | `[0-9]+` |
| `?` | 0 | 1 | Pichla item optional | `[+-]?` |
| `{3}` | 3 | 3 | Nahi | `[0-9]{3}` |
| `{2,5}` | 2 | 5 | Nahi | `[a-z]{2,5}` |
| `{2,}` | 2 | Unlimited | Nahi | `[a-z]{2,}` |

### `*` versus `+`

```bash
empty=""

[[ "$empty" =~ ^[0-9]*$ ]]  # True: zero digits allowed
[[ "$empty" =~ ^[0-9]+$ ]]  # False: at least one digit required
```

### Optional sign

| Allowed values | Regex |
|---|---|
| Sirf non-negative integers | `^[0-9]+$` |
| Optional minus sign | `^-?[0-9]+$` |
| Optional plus ya minus sign | `^[+-]?[0-9]+$` |

---

## 6. Groups, alternatives aur captures

### Grouping aur alternation

```bash
regex='^(start|stop|restart|status)$'

if [[ "$action" =~ $regex ]]; then
    echo "Valid action"
fi
```

### `BASH_REMATCH` table

| Array element | Kya rakhta hai? |
|---|---|
| `${BASH_REMATCH[0]}` | Pura match |
| `${BASH_REMATCH[1]}` | Pehla capture group |
| `${BASH_REMATCH[2]}` | Doosra capture group |
| `${BASH_REMATCH[n]}` | Group number `n` |

### Date parts capture karna

```bash
value="2026-08-15"
regex='^([0-9]{4})-([0-9]{2})-([0-9]{2})$'

if [[ "$value" =~ $regex ]]; then
    full_match=${BASH_REMATCH[0]}
    year=${BASH_REMATCH[1]}
    month=${BASH_REMATCH[2]}
    day=${BASH_REMATCH[3]}

    echo "Full: $full_match"
    echo "Year: $year"
    echo "Month: $month"
    echo "Day: $day"
fi
```

### Version capture karna

```bash
tag="v2.15.7"
regex='^v?([0-9]+)[.]([0-9]+)[.]([0-9]+)$'

if [[ "$tag" =~ $regex ]]; then
    major=${BASH_REMATCH[1]}
    minor=${BASH_REMATCH[2]}
    patch=${BASH_REMATCH[3]}
fi
```

> Har successful ya failed `=~` test `BASH_REMATCH` ko change kar sakta hai. Required groups ko foran variables mein copy karein.

---

## 7. Ready-to-use validation patterns

### Numbers

| Validation | Regex | Valid examples | Invalid examples |
|---|---|---|---|
| Digits only | `^[0-9]+$` | `0`, `25`, `008` | `-2`, `2.5`, empty |
| Signed integer | `^[+-]?[0-9]+$` | `25`, `-7`, `+9` | `2.5`, `--2` |
| Positive integer, zero excluded | `^[+]?[1-9][0-9]*$` | `1`, `25`, `+8` | `0`, `-2`, `01` |
| Strict decimal | `^[+-]?[0-9]+([.][0-9]+)?$` | `5`, `-2.75` | `.5`, `5.`, `1.2.3` |
| Flexible decimal | `^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$` | `5`, `.5`, `5.`, `-2.7` | `.`, `--2` |
| Exactly four digits | `^[0-9]{4}$` | `2026`, `0042` | `26`, `20260` |
| Two to five digits | `^[0-9]{2,5}$` | `12`, `12345` | `1`, `123456` |

> Regex number ka format check karta hai. Minimum aur maximum range `(( ... ))` se separately check karein.

### Text

| Validation | Regex | Valid examples | Invalid examples |
|---|---|---|---|
| Letters only | `^[[:alpha:]]+$` | `Khalid` | `Khalid25`, empty |
| Letters and spaces | `^[[:alpha:] ]+$` | `Ali Khan` | `Ali_25` |
| Alphanumeric only | `^[[:alnum:]]+$` | `server25` | `server-25` |
| Lowercase only | `^[[:lower:]]+$` | `linux` | `Linux`, `rhel9` |
| Uppercase only | `^[[:upper:]]+$` | `RHEL` | `Rhel`, `RHEL9` |
| Non-empty value | `^.+$` | `anything` | empty |
| Empty or whitespace only | `^[[:space:]]*$` | empty, spaces | `text` |
| Contains a digit | `[0-9]` | `user2` | `user` |
| Contains whitespace | `[[:space:]]` | `Ali Khan` | `AliKhan` |
| Contains non-digit | `[^0-9]` | `12a` | `123` |

### Names, identifiers aur choices

| Validation | Regex | Note |
|---|---|---|
| Simple Bash variable name | `^[a-zA-Z_][a-zA-Z0-9_]*$` | Digit se start nahi ho sakta |
| Simple Linux username | `^[a-z_][a-z0-9_-]{0,31}$` | Teaching pattern; local policy different ho sakti hai |
| Environment name | `^(dev|test|stage|prod)$` | Sirf listed choices |
| Service action | `^(start|stop|restart|reload|status)$` | Controlled command choice |
| Yes/no | `^([Yy]([Ee][Ss])?|[Nn][Oo]?)$` | `y`, `yes`, `n`, `no` |
| Simple identifier | `^[a-zA-Z][a-zA-Z0-9_-]*$` | Letter se start |

### Dates, times aur versions

| Validation | Regex | Format only? |
|---|---|---:|
| Date | `^[0-9]{4}-[0-9]{2}-[0-9]{2}$` | Haan |
| Time | `^[0-9]{2}:[0-9]{2}:[0-9]{2}$` | Haan |
| Year | `^[0-9]{4}$` | Haan |
| Semantic-version shape | `^v?[0-9]+[.][0-9]+[.][0-9]+$` | Haan |
| Release tag capture | `^v?([0-9]+)[.]([0-9]+)[.]([0-9]+)$` | Haan |

> `2026-99-99` date regex ki shape match kar sakta hai. Calendar validity separately check karein.

### Network aur system formats

| Validation | Regex | Important note |
|---|---|---|
| IPv4 shape | `^([0-9]{1,3}[.]){3}[0-9]{1,3}$` | Har octet `0–255` separately check karein |
| Port-number shape | `^[0-9]{1,5}$` | Range `1–65535` separately check karein |
| MAC address | `^([[:xdigit:]]{2}:){5}[[:xdigit:]]{2}$` | Colon-separated format |
| UUID shape | `^[[:xdigit:]]{8}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{4}-[[:xdigit:]]{12}$` | Hexadecimal shape |
| Simple hostname label | `^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?$` | Aik DNS label; full FQDN nahi |
| Hex value | `^(0[xX])?[[:xdigit:]]+$` | Optional `0x` prefix |

### File-like strings aur email shape

| Validation | Regex | Important note |
|---|---|---|
| Ends with `.log` | `[.]log$` | String suffix check |
| Ends with `.sh` | `[.]sh$` | Actual file existence check nahi |
| Basic filename characters | `^[a-zA-Z0-9._-]+$` | Slashes aur spaces reject |
| Simple email shape | `^[[:alnum:]._%+-]+@[[:alnum:].-]+[.][[:alpha:]]{2,}$` | Complete email standard validator nahi |

---

## 8. Quoting aur escaping rules

### Quoting quick-reference table

| Item | Recommended | Avoid | Wajah |
|---|---|---|---|
| Input value | `"$value"` | `$value` | Data ko safely represent karta hai |
| Regex variable definition | `regex='^[0-9]+$'` | Unquoted assignment | Shell interpretation se bachata hai |
| Regex variable in `=~` | `[[ "$value" =~ $regex ]]` | `[[ "$value" =~ "$regex" ]]` | Quoted right side literal ho sakti hai |
| Literal dot | `[.]` ya `\.` | `.` | Dot otherwise any character hai |
| Complex inline regex | Pehle variable mein store karein | Bohat zyada inline escaping | Readability aur debugging behtar hoti hai |

### Best pattern

```bash
value="${1:-}"
regex='^[+-]?[0-9]+$'

if [[ "$value" =~ $regex ]]; then
    echo "Valid integer"
fi
```

### Literal dot example

```bash
regex='^[0-9]+[.][0-9]+$'
```

Yeh `2.5` match karta hai, lekin `2x5` nahi.

---

## 9. Match result aur exit status

### Status table

| Exit status | Meaning |
|---:|---|
| `0` | Regex matched |
| `1` | Regex did not match |
| `2` | Regex syntax invalid thi |

### Status safely capture karna

```bash
if [[ "$value" =~ $regex ]]; then
    echo "Matched"
else
    status=$?

    if (( status == 1 )); then
        echo "No match"
    else
        echo "Invalid regex: status $status" >&2
        exit "$status"
    fi
fi
```

### `!` ke saath validation

```bash
if [[ ! "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: age must contain digits only." >&2
    exit 1
fi
```

Meaning: agar `$age` poori tarah digits-only regex ko match **na** kare to error block run karo.

---

## 10. Case-insensitive matching

Bash option `nocasematch` enable karke `=~` matching case-insensitive ban sakti hai.

```bash
shopt -s nocasematch

if [[ "ERROR" =~ ^error$ ]]; then
    echo "Matched without case sensitivity"
fi

shopt -u nocasematch
```

| Command | Kaam |
|---|---|
| `shopt -s nocasematch` | Case-insensitive matching enable |
| `shopt -u nocasematch` | Normal case-sensitive matching restore |

Option ko kaam ke baad disable karna behtar hai, taake baqi script unexpectedly affect na ho.

---

## 11. Common mistakes

### Mistakes quick-reference table

| Mistake | Ghalat | Sahi | Problem |
|---|---|---|---|
| Regex variable quote karna | `[[ "$v" =~ "$regex" ]]` | `[[ "$v" =~ $regex ]]` | Pattern literal ban sakta hai |
| Whole validation mein anchors bhoolna | `[0-9]+` | `^[0-9]+$` | Mixed text bhi match ho jata hai |
| Dot escape na karna | `^[0-9]+.[0-9]+$` | `^[0-9]+[.][0-9]+$` | `.` any character match karta hai |
| Empty input allow kar dena | `^[0-9]*$` | `^[0-9]+$` | `*` zero characters allow karta hai |
| PCRE shorthand use karna | `^\d+$` | `^[0-9]+$` | Bash ERE mein `\d` reliable nahi |
| Non-capturing group use karna | `(?:yes|no)` | `(yes|no)` | Bash ERE `(?:...)` support nahi karta |
| Regex ko range validator samajhna | `^[0-9]{1,3}$` | Regex + arithmetic test | `999` bhi shape match karta hai |
| `BASH_REMATCH` late read karna | Doosre match ke baad read | Match ke foran baad copy | Array overwrite ho sakti hai |
| Invalid dynamic regex ignore karna | Sirf match/no-match | Status `2` handle karein | Syntax error no-match jaisi lag sakti hai |

---

## 12. Debugging quick reference

| Debugging need | Command | Purpose |
|---|---|---|
| Hidden characters dekhein | `printf 'value=<%q>\n' "$value"` | Spaces aur special characters reveal |
| Regex print karein | `printf 'regex=<%s>\n' "$regex"` | Actual stored expression dekhein |
| Condition status dekhein | `[[ "$value" =~ $regex ]]; echo "$?"` | `0`, `1`, ya `2` |
| Pura match dekhein | `printf '%s\n' "${BASH_REMATCH[0]}"` | Complete match inspect |
| Capture groups dekhein | `declare -p BASH_REMATCH` | Puri capture array display |
| Script syntax check | `bash -n script.sh` | Execute kiye baghair syntax check |
| Execution trace | `bash -x script.sh` | Commands execution ke waqt display |

### Table-driven regex test

```bash
regex='^[0-9]+$'
tests=("25" "0" "08" "-5" "12.5" "25 years" "")

for value in "${tests[@]}"
do
    if [[ "$value" =~ $regex ]]; then
        printf 'MATCH:    <%s>\n' "$value"
    else
        printf 'NO MATCH: <%s>\n' "$value"
    fi
done
```

Expected classification:

| Value | Result |
|---|---|
| `25` | Match |
| `0` | Match |
| `08` | Match |
| `-5` | No match |
| `12.5` | No match |
| `25 years` | No match |
| Empty | No match |

---

## 13. Bash ERE limitations

Bash `[[ ... =~ ... ]]` **POSIX Extended Regular Expressions (ERE)** use karta hai, PCRE nahi.

### Avoid these PCRE constructs

| PCRE construct | Bash ERE alternative |
|---|---|
| `\d` | `[0-9]` ya `[[:digit:]]` |
| `\w` | `[[:alnum:]_]` |
| `\s` | `[[:space:]]` |
| `(?:...)` | `(...)` |
| `(?=...)` | Multiple Bash conditions use karein |
| `(?<=...)` | Capture groups ya separate processing |
| Lazy quantifier `.*?` | Bash ERE mein direct equivalent nahi |

### Portability table

| Environment | Regex support |
|---|---|
| Bash `[[ =~ ]]` | POSIX ERE |
| `grep -E` | POSIX ERE |
| `sed -E` | POSIX ERE-style extended syntax |
| `awk` | ERE-style regex |
| POSIX `/bin/sh` | `[[ =~ ]]` available nahi |

Regex wala script Bash ke saath run karein:

```bash
#!/bin/bash
```

---

## 14. Copy-and-use templates

### Required argument + regex validation

```bash
#!/bin/bash

value="${1:-}"
regex='^[0-9]+$'

if [[ -z "$value" ]]; then
    echo "Usage: $0 NUMBER" >&2
    exit 2
fi

if [[ ! "$value" =~ $regex ]]; then
    echo "Error: enter a non-negative whole number." >&2
    exit 1
fi

echo "Valid number: $value"
exit 0
```

### Format then range validation

```bash
#!/bin/bash

age="${1:-}"
regex='^[0-9]+$'

if [[ ! "$age" =~ $regex ]]; then
    echo "Error: age must contain digits only." >&2
    exit 1
fi

age_number=$((10#$age))

if (( age_number < 1 || age_number > 120 )); then
    echo "Error: age must be between 1 and 120." >&2
    exit 1
fi

echo "Valid age: $age_number"
```

### Capture structured input

```bash
#!/bin/bash

release="${1:-}"
regex='^v?([0-9]+)[.]([0-9]+)[.]([0-9]+)$'

if [[ ! "$release" =~ $regex ]]; then
    echo "Usage: $0 vMAJOR.MINOR.PATCH" >&2
    exit 2
fi

major=${BASH_REMATCH[1]}
minor=${BASH_REMATCH[2]}
patch=${BASH_REMATCH[3]}

echo "Major: $major"
echo "Minor: $minor"
echo "Patch: $patch"
```

---

## 15. Final one-screen reference

### Essential syntax

| Need | Use |
|---|---|
| Match | `[[ "$value" =~ $regex ]]` |
| Reject match failure | `[[ ! "$value" =~ $regex ]]` |
| Whole string | `^...$` |
| Any one character | `.` |
| One digit | `[0-9]` |
| One letter | `[[:alpha:]]` |
| One or more | `+` |
| Zero or more | `*` |
| Optional | `?` |
| Exact count | `{n}` |
| Alternatives | `(one|two)` |
| Literal dot | `[.]` |
| Full match | `${BASH_REMATCH[0]}` |
| First capture | `${BASH_REMATCH[1]}` |

### Most-used patterns

| Need | Regex |
|---|---|
| Digits only | `^[0-9]+$` |
| Signed integer | `^[+-]?[0-9]+$` |
| Decimal | `^[+-]?[0-9]+([.][0-9]+)?$` |
| Letters only | `^[[:alpha:]]+$` |
| Alphanumeric | `^[[:alnum:]]+$` |
| Bash variable name | `^[a-zA-Z_][a-zA-Z0-9_]*$` |
| Controlled action | `^(start|stop|restart|status)$` |
| Date shape | `^[0-9]{4}-[0-9]{2}-[0-9]{2}$` |
| Version shape | `^v?[0-9]+[.][0-9]+[.][0-9]+$` |
| IPv4 shape | `^([0-9]{1,3}[.]){3}[0-9]{1,3}$` |

### Five rules yaad rakhein

1. Bash ka `=~` operator POSIX ERE regex use karta hai.
2. Input value ko quote karein: `"$value"`.
3. Regex variable ko match ke waqt quote na karein: `$regex`.
4. Poori input validation ke liye aam tor par `^...$` use karein.
5. Regex format check karta hai; numeric range aur real-world validity separately check karein.
