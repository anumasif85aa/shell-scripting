# Bash Conditionals — Roman Urdu Summary

## Conditional kya hota hai?

Conditional Bash ko decision lene deta hai:

```text
Agar condition true hai → aik kaam karo
Warna → doosra kaam karo
```

## Basic structure

```bash
if [[ condition ]]; then
    echo "Condition true hai"
else
    echo "Condition false hai"
fi
```

- `if` pehli condition check karta hai.
- `elif` doosri condition check karta hai.
- `else` fallback hai.
- `fi` conditional ko band karta hai.

## True aur false

Bash mein:

- Exit status `0` = success / true
- Non-zero exit status = failure / false

```bash
ls /etc/passwd
echo "$?"
```

`$?` ko command ke foran baad check karein.

## String comparison

```bash
if [[ "$name" == "Ali" ]]; then
    echo "Name match ho gaya"
fi
```

| Operator | Meaning |
|---|---|
| `==` | Barabar |
| `!=` | Barabar nahin |
| `-z` | Value empty hai |
| `-n` | Value empty nahin |

## Number comparison

| Operator | Meaning |
|---|---|
| `-eq` | Equal |
| `-ne` | Not equal |
| `-gt` | Greater than |
| `-ge` | Greater than or equal |
| `-lt` | Less than |
| `-le` | Less than or equal |

Example:

```bash
if [[ "$age" -ge 18 ]]; then
    echo "Adult"
else
    echo "Minor"
fi
```

Arithmetic ke liye yeh bhi use hota hai:

```bash
if (( age >= 18 )); then
    echo "Adult"
fi
```

## File tests

| Test | Meaning |
|---|---|
| `-e` | Path mojood hai |
| `-f` | Regular file hai |
| `-d` | Directory hai |
| `-s` | File empty nahin |
| `-r` | Readable hai |
| `-w` | Writable hai |
| `-x` | Executable hai |

## Conditions combine karna

```bash
if [[ "$role" == "admin" && "$active" == "yes" ]]; then
    echo "Access allowed"
fi
```

- `&&` = dono conditions true hon
- `||` = kam az kam aik true ho
- `!` = result ko reverse karta hai

## Command ko direct condition banana

```bash
if grep -q "ERROR" app.log; then
    echo "Error mila"
else
    echo "Error nahin mila"
fi
```

Bash `grep` ka exit status check karta hai.

## Safe DevOps flow

```text
Input → Validate → Current state check → Action → Verify
```

Production action se pehle:

- Input validate karein.
- Required file check karein.
- Approval check karein.
- Error ko `>&2` par bhejein.
- Failure par `exit 1` karein.
- Success par naturally `0` return hota hai ya `exit 0` likh sakte hain.

## Common mistakes

Wrong:

```bash
if [["$name" == "Ali"]]; then
```

Correct:

```bash
if [[ "$name" == "Ali" ]]; then
```

`[[`, condition, aur `]]` ke darmiyan spaces zaroori hain.

## Final advice

Pehle weather aur traffic-light scripts banayein. Phir strings, numbers, files, arguments, command exit status, aur DevOps preflight ki taraf move karein.
