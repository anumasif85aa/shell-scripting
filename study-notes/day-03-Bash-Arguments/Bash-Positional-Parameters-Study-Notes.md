# Bash Positional Parameters – Study Notes

## Topics Covered
- What are positional parameters?
- `$0`, `$1`, `$2`, and `$#`
- `${0##*/}`
- `${1-}` and `${2-}`
- Best practices
- Interview questions
- Roman Urdu summary

---

## Positional Parameters

Positional parameters are special Bash variables that receive values passed to a script.

Example:

```bash
./demo.sh apple banana
```

| Variable | Value |
|---|---|
| `$0` | `./demo.sh` |
| `$1` | `apple` |
| `$2` | `banana` |
| `$#` | `2` |

---

## `$0`

`$0` contains the script name or the path used to execute it.

```bash
echo "$0"
```

---

## `${0##*/}`

```bash
script_name=${0##*/}
```

This removes everything before the last `/`, leaving only the filename.

Example:

```text
/home/khalid/scripts/demo.sh
```

becomes

```text
demo.sh
```

---

## `$1` and `$2`

```bash
first=${1-}
second=${2-}
```

These store the first and second command-line arguments.

Using `${1-}` safely returns an empty string if no argument was provided.

---

## `$#`

```bash
argument_count=$#
```

Stores the total number of arguments.

---

## Complete Example

```bash
#!/bin/bash

script_name=${0##*/}
first=${1-}
second=${2-}
argument_count=$#

echo "Script Name   : $script_name"
echo "First Arg     : $first"
echo "Second Arg    : $second"
echo "Argument Count: $argument_count"
```

Run:

```bash
./demo.sh apple banana orange
```

Output:

```text
Script Name   : demo.sh
First Arg     : apple
Second Arg    : banana
Argument Count: 3
```

---

## Best Practices

- Use descriptive variable names.
- Validate arguments with `$#`.
- Use `${1-}` when arguments may be optional.
- Display usage messages when required arguments are missing.

---

## Interview Questions

1. What is `$0`?
2. What does `${0##*/}` do?
3. Why use `${1-}`?
4. What does `$#` return?
5. How do positional parameters work?

---

## Roman Urdu Summary

- `$0` script ka naam ya path rakhta hai.
- `${0##*/}` sirf filename nikalta hai.
- `$1` pehla argument hota hai.
- `$2` doosra argument hota hai.
- `${1-}` missing argument ko safely handle karta hai.
- `$#` total arguments ki ginti batata hai.

## One-Line Summary

Positional parameters make Bash scripts flexible by accepting command-line arguments.
