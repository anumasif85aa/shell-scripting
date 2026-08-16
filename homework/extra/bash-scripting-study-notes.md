# Bash Scripting Study Notes

## 1. Basics

```bash
#!/bin/bash
# ^ shebang, must be first line
echo "Hello, World!"
```

- Make executable: `chmod +x script.sh`
- Run: `./script.sh` or `bash script.sh`
- Comments start with `#`

## 2. Variables

```bash
name="Alice"
echo "Hello, $name"      # or ${name}
readonly PI=3.14          # constant
unset name                # delete variable
```

- No spaces around `=`
- Variables are untyped (treated as strings unless used in arithmetic)
- Use `${var}` when concatenating with other text: `"${name}_suffix"`

## 3. Input & Arguments

```bash
read -p "Enter your name: " name

echo "$0"   # script name
echo "$1"   # first argument
echo "$#"   # number of arguments
echo "$@"   # all arguments (as separate words)
echo "$*"   # all arguments (as single string)
echo "$?"   # exit status of last command
```

## 4. String Operations

```bash
str="Hello World"
echo ${#str}          # length: 11
echo ${str:0:5}       # substring: Hello
echo ${str/World/Bash}  # replace: Hello Bash
echo ${str^^}         # uppercase
echo ${str,,}         # lowercase
```

## 5. Arithmetic

```bash
a=5; b=3
echo $((a + b))       # 8
echo $((a ** b))      # exponent
let c=a+b
c=$(expr $a + $b)     # older style
```

## 6. Conditionals

```bash
if [ "$a" -eq "$b" ]; then
    echo "equal"
elif [ "$a" -gt "$b" ]; then
    echo "a is greater"
else
    echo "b is greater"
fi
```

**Comparison operators**

| Numbers | Strings | Meaning |
|---|---|---|
| `-eq` | `==` | equal |
| `-ne` | `!=` | not equal |
| `-gt` | `>` (in `[[ ]]`) | greater than |
| `-lt` | `<` (in `[[ ]]`) | less than |
| `-ge` | | greater or equal |
| `-le` | | less or equal |

**File tests**
```bash
[ -f file ]   # is a regular file
[ -d dir ]    # is a directory
[ -e path ]   # exists
[ -x file ]   # is executable
[ -r file ]   # readable
[ -w file ]   # writable
```

Use `[[ ]]` (bash-specific) over `[ ]` (POSIX) when possible — supports `&&`, `||`, pattern matching, no word-splitting issues.

## 7. Loops

```bash
# for loop
for i in 1 2 3 4 5; do
    echo $i
done

for i in {1..10}; do echo $i; done
for f in *.txt; do echo "$f"; done

# C-style for
for ((i=0; i<5; i++)); do
    echo $i
done

# while loop
while [ $i -lt 5 ]; do
    echo $i
    ((i++))
done

# until loop
until [ $i -ge 5 ]; do
    echo $i
    ((i++))
done
```

`break` exits the loop, `continue` skips to next iteration.

## 8. Case Statement

```bash
case "$1" in
    start)
        echo "Starting..."
        ;;
    stop)
        echo "Stopping..."
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        ;;
esac
```

## 9. Functions

```bash
greet() {
    local name=$1     # local scope
    echo "Hello, $name"
    return 0           # exit status, not a return value
}

greet "Bob"
result=$(greet "Bob")   # capture output instead
```

- `local` keeps variables scoped to the function
- Functions "return" data via stdout (`echo`) or exit codes via `return`

## 10. Arrays

```bash
arr=(apple banana cherry)
echo ${arr[0]}         # apple
echo ${arr[@]}         # all elements
echo ${#arr[@]}        # length
arr+=(date)             # append

# associative arrays
declare -A map
map[key]="value"
echo ${map[key]}
```

## 11. Input/Output Redirection

```bash
cmd > file        # stdout to file (overwrite)
cmd >> file        # stdout to file (append)
cmd < file          # file as stdin
cmd 2> file         # stderr to file
cmd > file 2>&1     # stdout and stderr to file
cmd &> file         # shorthand for above
cmd 2>/dev/null     # discard errors
```

**Pipes & chaining**
```bash
cmd1 | cmd2         # pipe output of cmd1 to cmd2
cmd1 && cmd2        # run cmd2 only if cmd1 succeeds
cmd1 || cmd2        # run cmd2 only if cmd1 fails
cmd1 ; cmd2         # run sequentially regardless
```

## 12. Command Substitution

```bash
today=$(date)
files=$(ls *.txt)
count=`ls | wc -l`   # older backtick style
```

## 13. Exit Codes

```bash
exit 0    # success
exit 1    # generic error
```
- `$?` holds the exit status of the last command (0 = success)
- `set -e` — exit script immediately if any command fails
- `set -u` — error on unset variables
- `set -x` — print each command before running (debugging)
- `set -euo pipefail` — common "strict mode" combo

## 14. Useful Built-ins & Commands

| Command | Purpose |
|---|---|
| `grep` | search text |
| `sed` | stream editing/substitution |
| `awk` | pattern scanning & processing |
| `cut` | extract columns |
| `sort` / `uniq` | sort and dedupe |
| `xargs` | build commands from input |
| `trap` | catch signals (e.g. `trap 'cleanup' EXIT`) |
| `source` / `.` | run script in current shell |

## 15. Quoting Rules

```bash
'single quotes'    # literal, no expansion
"double quotes"    # allows $var expansion
`backticks`        # command substitution (legacy)
```
Always quote variables (`"$var"`) to avoid word-splitting and glob issues.

## 16. Quick Script Template

```bash
#!/bin/bash
set -euo pipefail

usage() {
    echo "Usage: $0 <arg1> <arg2>"
    exit 1
}

[ $# -lt 2 ] && usage

main() {
    echo "Running with $1 and $2"
}

main "$@"
```

## Common Pitfalls
- Forgetting to quote variables → breaks on spaces/globs
- Using `[ ]` with unquoted empty variables → syntax errors
- Confusing `=` (assignment) with `==` (comparison)
- Off-by-one with array indices (bash arrays are 0-indexed)
- Not checking `$?` or using `set -e` for error handling
