# Bash Conditionals Cheat Sheet

## Basic syntax

```bash
if [[ condition ]]; then
    command
elif [[ another_condition ]]; then
    another_command
else
    fallback_command
fi
```

## String tests

| Test | Meaning |
|---|---|
| `[[ "$a" == "$b" ]]` | Equal |
| `[[ "$a" != "$b" ]]` | Not equal |
| `[[ -z "$a" ]]` | Empty |
| `[[ -n "$a" ]]` | Not empty |
| `[[ "$file" == *.log ]]` | Pattern match |
| `[[ "$name" =~ regex ]]` | Regular-expression match |

## Numeric tests

| Test | Meaning |
|---|---|
| `-eq` | Equal |
| `-ne` | Not equal |
| `-gt` | Greater than |
| `-ge` | Greater than or equal |
| `-lt` | Less than |
| `-le` | Less than or equal |

```bash
if (( score >= 80 )); then
    echo "Passed"
fi
```

## File tests

| Test | Meaning |
|---|---|
| `-e` | Exists |
| `-f` | Regular file |
| `-d` | Directory |
| `-s` | Non-empty file |
| `-r` | Readable |
| `-w` | Writable |
| `-x` | Executable |

## Logical operators

| Operator | Meaning |
|---|---|
| `&&` | Both true |
| `||` | At least one true |
| `!` | Reverse the test |

## Command status

```bash
if grep -q "ERROR" app.log; then
    echo "Error found"
fi
```

## Argument count

```bash
if [[ "$#" -ne 2 ]]; then
    echo "Usage: $0 ARG1 ARG2" >&2
    exit 1
fi
```

## Numeric input validation

```bash
if [[ "$value" =~ ^[0-9]+$ ]]; then
    echo "Digits only"
fi
```

## Safe workflow

```text
Validate input → Check state → Perform action → Verify result
```

## Testing

```bash
bash -n script.sh
bash script.sh
echo "$?"
```
