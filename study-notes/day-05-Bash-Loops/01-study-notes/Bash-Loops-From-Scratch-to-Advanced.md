# Bash Loops — From Scratch to Advanced

Beginner-friendly study notes with practical Bash and DevOps examples.

> All examples use Bash and `echo`. Check scripts with `bash -n script.sh` before running them.

---

## Learning objectives

By the end of these notes, you should be able to:

- Explain why loops are used.
- Use `for`, C-style `for`, `while`, `until`, and `select`.
- Loop through fruits, numbers, files, arguments, and arrays.
- Control loops with `break` and `continue`.
- Read files safely with `while IFS= read -r`.
- Avoid infinite loops, unsafe word splitting, and pipeline subshell problems.
- Apply loops to simple Linux and DevOps tasks.

---

## 1. What is a loop?

A loop repeats one or more commands.

Without a loop:

```bash
echo "apple"
echo "banana"
echo "cherry"
```

With a loop:

```bash
for fruit in apple banana cherry
do
    echo "$fruit"
done
```
[Code with inline comments click here](md/for_loop_inline_comments.sh)

Output:

```text
apple
banana
cherry
```

### Main Bash loops

| Loop | Best use |
|---|---|
| `for` | Process a known list of items |
| C-style `for` | Count using numbers |
| `while` | Repeat while a condition is true |
| `until` | Repeat until a condition becomes true |
| `select` | Display a simple numbered menu |

---

## 2. Basic `for` loop

### Syntax

```bash
for variable in item1 item2 item3
do
    commands
done
```

### Fruit example

```bash
#!/bin/bash

for fruit in apple banana cherry
do
    echo "Fruit: $fruit"
done
```

During each round, the variable receives the next item:

| Round | Value of `$fruit` |
|---:|---|
| 1 | `apple` |
| 2 | `banana` |
| 3 | `cherry` |

### One-line version

```bash
for fruit in apple banana cherry; do echo "$fruit"; done
```

Use the multiline form in scripts because it is easier to read.

---

## 3. Loop through numbers

```bash
for number in 1 2 3 4 5
do
    echo "Number: $number"
done
```

### Brace expansion

```bash
for number in {1..5}
do
    echo "Number: $number"
done
```

### Custom step

```bash
for number in {2..10..2}
do
    echo "$number"
done
```

Output:

```text
2
4
6
8
10
```

The format is:

```text
{start..end..step}
```

Brace expansion does not use variable values as numeric limits:

```bash
start=1
end=5

# Do not use this:
for number in {$start..$end}
do
    echo "$number"
done
```

Use a C-style loop when the limits come from variables.

---

## 4. C-style `for` loop

### Syntax

```bash
for (( initialization; condition; update ))
do
    commands
done
```

### Counter example

```bash
for (( number=1; number<=5; number++ ))
do
    echo "Number: $number"
done
```

| Part | Meaning |
|---|---|
| `number=1` | Start from 1 |
| `number<=5` | Continue while the number is 5 or less |
| `number++` | Add 1 after every round |

### Countdown

```bash
for (( number=5; number>=1; number-- ))
do
    echo "$number"
done

echo "Go!"
```

### Increment by two

```bash
for (( number=2; number<=10; number+=2 ))
do
    echo "$number"
done
```

---

## 5. Loop through script arguments

Suppose the script is started like this:

```bash
./fruits.sh apple banana cherry
```

Script:

```bash
#!/bin/bash

for fruit in "$@"
do
    echo "Argument: $fruit"
done
```

Output:

```text
Argument: apple
Argument: banana
Argument: cherry
```

Always prefer:

```text
for argument in "$@"
```

Avoid:

```text
for argument in $@
```

Quoting `"$@"` preserves an argument containing spaces:

```bash
./fruits.sh apple "green banana" cherry
```

An alternative shorthand is:

```bash
for argument
do
    echo "$argument"
done
```

If `in ...` is omitted, Bash automatically loops through `"$@"`.

---

## 6. Loop through files

```bash
for file in *.txt
do
    echo "Text file: $file"
done
```

If nothing matches `*.txt`, Bash may keep the pattern unchanged. Check that the file exists:

```bash
for file in *.txt
do
    [[ -e "$file" ]] || continue
    echo "Processing: $file"
done
```

### Using `nullglob`

```bash
shopt -s nullglob

for file in *.txt
do
    echo "Processing: $file"
done
```

With `nullglob`, an unmatched pattern produces zero loop items.

### Preview a rename operation

```bash
for file in *.log
do
    [[ -e "$file" ]] || continue
    new_name="${file%.log}.txt"
    echo "Would rename: $file -> $new_name"
done
```

After verifying the preview:

```bash
for file in *.log
do
    [[ -e "$file" ]] || continue
    new_name="${file%.log}.txt"
    mv -- "$file" "$new_name"
done
```

---

## 7. Basic `while` loop

A `while` loop repeats while its condition remains true.

### Syntax

```bash
while condition
do
    commands
done
```

### Counter example

```bash
counter=1

while [[ "$counter" -le 5 ]]
do
    echo "Counter: $counter"
    counter=$((counter + 1))
done
```

Flow:

1. Check the condition.
2. Run the commands if it is true.
3. Update the counter.
4. Check the condition again.
5. Stop when the condition becomes false.

### Arithmetic form

```bash
counter=1

while (( counter <= 5 ))
do
    echo "Counter: $counter"
    ((counter++))
done
```

---

## 8. User-input loop

```bash
answer=""

while [[ "$answer" != "yes" ]]
do
    read -r -p "Enter yes to continue: " answer
done

echo "Thank you"
```

### Validate input

```bash
while true
do
    read -r -p "Enter red, yellow, or green: " light

    if [[ "$light" == "red" || "$light" == "yellow" || "$light" == "green" ]]; then
        echo "Valid color: $light"
        break
    else
        echo "Invalid color. Try again."
    fi
done
```

---

## 9. Infinite loop

```bash
while true
do
    echo "This loop continues forever"
done
```

Press `Ctrl+C` to interrupt it.

A controlled infinite loop:

```bash
while true
do
    read -r -p "Enter quit to stop: " command

    if [[ "$command" == "quit" ]]; then
        break
    fi

    echo "You entered: $command"
done
```

---

## 10. Read a file line by line

Suppose `users.txt` contains:

```text
ali
omar
asim
```

Script:

```bash
while IFS= read -r username
do
    echo "Username: $username"
done < users.txt
```

| Part | Purpose |
|---|---|
| `IFS=` | Preserves leading and trailing spaces |
| `read -r` | Prevents backslashes from being interpreted |
| `username` | Stores the current line |
| `< users.txt` | Sends the file into the loop |

To process a final line that has no newline:

```bash
while IFS= read -r line || [[ -n "$line" ]]
do
    echo "$line"
done < users.txt
```

---

## 11. The `until` loop

An `until` loop repeats while its condition is false. It stops when the condition becomes true.

### Syntax

```bash
until condition
do
    commands
done
```

### Counter example

```bash
counter=1

until [[ "$counter" -gt 5 ]]
do
    echo "Counter: $counter"
    counter=$((counter + 1))
done
```

These conditions can produce the same result:

```text
while [[ "$counter" -le 5 ]]
```

```text
until [[ "$counter" -gt 5 ]]
```

### Wait for a file

```bash
until [[ -f "ready.txt" ]]
do
    echo "Waiting for ready.txt..."
    sleep 2
done

echo "The file is available."
```

### Wait with a maximum-attempt limit

```bash
attempt=1
maximum_attempts=5

until [[ -f "ready.txt" ]]
do
    if [[ "$attempt" -ge "$maximum_attempts" ]]; then
        echo "Error: ready.txt was not found" >&2
        exit 1
    fi

    echo "Attempt $attempt: waiting..."
    sleep 2
    attempt=$((attempt + 1))
done

echo "The file is available."
```

---

## 12. `break`

`break` exits the loop immediately.

```bash
for fruit in apple banana cherry
do
    if [[ "$fruit" == "banana" ]]; then
        echo "Banana found"
        break
    fi

    echo "Checking: $fruit"
done
```

Output:

```text
Checking: apple
Banana found
```

`cherry` is never processed.

---

## 13. `continue`

`continue` skips the remaining commands in the current round and begins the next round.

```bash
for fruit in apple banana cherry
do
    if [[ "$fruit" == "banana" ]]; then
        continue
    fi

    echo "$fruit"
done
```

Output:

```text
apple
cherry
```

---

## 14. Nested loops

A loop inside another loop is called a nested loop.

```bash
for student in Ali Omar
do
    for subject in Linux Bash
    do
        echo "$student is studying $subject"
    done
done
```

Output:

```text
Ali is studying Linux
Ali is studying Bash
Omar is studying Linux
Omar is studying Bash
```

### Exit multiple loop levels

```bash
for server in server1 server2
do
    for port in 22 80 443
    do
        echo "Checking $server on port $port"

        if [[ "$server" == "server2" && "$port" -eq 80 ]]; then
            break 2
        fi
    done
done
```

`break 2` exits two loop levels. Similarly, `continue 2` continues with the next round of the outer loop.

---

## 15. Menu using `while` and `case`

```bash
while true
do
    echo
    echo "1. Show date"
    echo "2. Show current directory"
    echo "3. Show current user"
    echo "4. Exit"

    read -r -p "Choose an option: " choice

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
            echo "Goodbye"
            break
            ;;
        *)
            echo "Invalid selection"
            ;;
    esac
done
```

This combines `while`, `read`, `case`, and `break`.

---

## 16. The `select` loop

`select` creates a simple numbered terminal menu.

```bash
PS3="Choose a fruit: "

select fruit in apple banana cherry quit
do
    case "$fruit" in
        apple|banana|cherry)
            echo "You selected: $fruit"
            ;;
        quit)
            echo "Goodbye"
            break
            ;;
        *)
            echo "Invalid selection"
            ;;
    esac
done
```

Bash displays:

```text
1) apple
2) banana
3) cherry
4) quit
Choose a fruit:
```

`select` is useful for basic menus. A `while` loop with `read` and `case` provides more formatting control.

---

## 17. Loop through an array

```bash
servers=("web01" "web02" "database01")

for server in "${servers[@]}"
do
    echo "Checking server: $server"
done
```

Use:

```bash
"${servers[@]}"
```

This preserves each array element as a separate item, including values containing spaces.

---

## 18. DevOps example: check services

```bash
services=("ssh" "cron")

for service in "${services[@]}"
do
    if systemctl is-active --quiet "$service"; then
        echo "$service is running"
    else
        echo "$service is not running"
    fi
done
```

Service names vary between distributions. For example, SSH may be named `ssh` on Ubuntu and `sshd` on RHEL.

---

## 19. DevOps example: limited retry

```bash
maximum_attempts=3

for (( attempt=1; attempt<=maximum_attempts; attempt++ ))
do
    echo "Attempt $attempt of $maximum_attempts"

    if curl -fsS https://example.com > /dev/null; then
        echo "Connection successful"
        break
    fi

    if [[ "$attempt" -eq "$maximum_attempts" ]]; then
        echo "Connection failed after $maximum_attempts attempts" >&2
        exit 1
    fi

    sleep 2
done
```

Production retries should normally have:

- A maximum attempt count
- A delay between attempts
- A meaningful error message
- A nonzero exit status when all attempts fail

---

## 20. Advanced: pipeline subshell problem

Consider:

```bash
count=0

echo -e "apple\nbanana\ncherry" |
while read -r fruit
do
    count=$((count + 1))
done

echo "$count"
```

The result may be:

```text
0
```

The loop on the right side of the pipeline commonly runs in a subshell. Changes to `count` are lost when that subshell finishes.

### Solution: process substitution

```bash
count=0

while read -r fruit
do
    count=$((count + 1))
done < <(echo -e "apple\nbanana\ncherry")

echo "$count"
```

Output:

```text
3
```

`< <(...)` is process substitution. It supplies command output to the loop without placing the loop in a pipeline subshell.

---

## 21. Common mistakes

### Mistake 1: forgetting to update the counter

Incorrect:

```bash
counter=1

while [[ "$counter" -le 5 ]]
do
    echo "$counter"
done
```

The condition never changes, so the loop continues forever.

Correct:

```bash
counter=1

while [[ "$counter" -le 5 ]]
do
    echo "$counter"
    counter=$((counter + 1))
done
```

### Mistake 2: not quoting arguments

Risky:

```bash
for argument in $@
do
    echo "$argument"
done
```

Correct:

```bash
for argument in "$@"
do
    echo "$argument"
done
```

### Mistake 3: parsing `ls`

Avoid:

```bash
for file in $(ls *.txt)
do
    echo "$file"
done
```

It can break filenames containing spaces or special characters.

Use the glob directly:

```bash
for file in *.txt
do
    [[ -e "$file" ]] || continue
    echo "$file"
done
```

### Mistake 4: using `for` to read file lines

Avoid:

```bash
for line in $(cat users.txt)
do
    echo "$line"
done
```

This processes words rather than reliable complete lines.

Use:

```bash
while IFS= read -r line
do
    echo "$line"
done < users.txt
```

### Mistake 5: unlimited production retry

Avoid:

```bash
until curl -fsS https://example.com
do
    sleep 2
done
```

The script may never finish. Add a maximum-attempt counter.

---

## 22. Choosing the right loop

| Requirement | Recommended approach |
|---|---|
| Process `apple banana cherry` | Basic `for` |
| Process script arguments | `for argument in "$@"` |
| Count from 1 to 10 | C-style `for` |
| Repeat while something is true | `while` |
| Wait until something becomes true | `until` |
| Read a file safely | `while IFS= read -r` |
| Create a numbered menu | `select` |
| Repeat a custom menu | `while` with `case` |
| Stop the loop early | `break` |
| Skip the current round | `continue` |

---

## 23. Recommended learning path

```text
Basic for loop
    ↓
Numeric for loop
    ↓
while loop
    ↓
until loop
    ↓
break and continue
    ↓
Arguments and arrays
    ↓
Safe file-reading loops
    ↓
Menus
    ↓
Process substitution
    ↓
Limited retries and DevOps automation
```

---

## 24. Quick practice

### Task 1

Use a `for` loop to display:

```text
apple
banana
cherry
```

### Task 2

Use a C-style `for` loop to display numbers from 1 through 5.

### Task 3

Ask the user to enter `yes`. Keep asking until the answer is correct.

### Task 4

Loop through every argument supplied to a script.

### Task 5

Read a file named `students.txt` one line at a time.

### Task 6

Create a menu with these options:

1. Show the date
2. Show the current user
3. Exit

---

## 25. Revision checklist

- [ ] I understand what a loop does.
- [ ] I can write a basic `for` loop.
- [ ] I can use brace expansion.
- [ ] I can write a C-style counter loop.
- [ ] I can loop through `"$@"`.
- [ ] I can loop through `"${array[@]}"`.
- [ ] I can write a `while` loop.
- [ ] I can explain the difference between `while` and `until`.
- [ ] I can use `break` and `continue`.
- [ ] I can safely read a file with `while IFS= read -r`.
- [ ] I know why parsing `ls` is unsafe.
- [ ] I know how an accidental infinite loop happens.
- [ ] I understand the pipeline subshell problem.
- [ ] I can create a limited retry loop.
- [ ] I check my script with `bash -n`.

---

## Final summary

- Use `for` for a known list.
- Use C-style `for` for numeric counting.
- Use `while` while a condition is true.
- Use `until` until a condition becomes true.
- Use `break` to exit and `continue` to skip one round.
- Use `"$@"` for script arguments.
- Use `"${array[@]}"` for arrays.
- Use `while IFS= read -r` for file lines.
- Quote variable expansions.
- Limit retries and test loop exit conditions.
