# Bash `case` Statement — Complete Study Notes

## Table of Contents

1. [What Is a `case` Statement?](#1-what-is-a-case-statement)
2. [Basic Syntax](#2-basic-syntax)
3. [Meaning of Each Part](#3-meaning-of-each-part)
4. [Simple Yes-or-No Example](#4-simple-yes-or-no-example)
5. [Multiple Patterns with `|`](#5-multiple-patterns-with-)
6. [The Default `*` Pattern](#6-the-default--pattern)
7. [Service-Checker Example](#7-service-checker-example)
8. [Menu Example](#8-menu-example)
9. [Useful Pattern Symbols](#9-useful-pattern-symbols)
10. [`case` vs `if`](#10-case-vs-if)
11. [`case` Is Not a Loop](#11-case-is-not-a-loop)
12. [Exit Status Behavior](#12-exit-status-behavior)
13. [Common Mistakes](#13-common-mistakes)
14. [Practice Tasks](#14-practice-tasks)
15. [Final Summary](#15-final-summary)

---

## 1. What Is a `case` Statement?

A Bash `case` statement is a conditional or decision-making structure.

It compares one value against several patterns and runs the commands belonging to the first matching pattern.

It is especially useful for:

- Yes-or-No input
- Menu selections
- Command actions such as `start`, `stop`, and `restart`
- Operating-system names
- File extensions
- Command-line options

> A `case` statement is not a loop. It selects a command block; it does not repeat that block automatically.

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

1. Bash reads the value after `case`.
2. Bash checks the patterns from top to bottom.
3. The first matching block runs.
4. `;;` ends that branch.
5. Bash continues after `esac`.

---

## 3. Meaning of Each Part

| Part | Meaning |
|---|---|
| `case` | Starts the decision statement. |
| `"$variable"` | Value that Bash will examine. |
| `in` | Begins the list of patterns. |
| `pattern)` | A possible value or wildcard pattern. |
| `commands` | Commands executed when that pattern matches. |
| `;;` | Ends the current pattern branch. |
| `*` | Default pattern; matches anything not matched earlier. |
| `esac` | Ends the statement; it is `case` written backward. |

Similar closing keywords include:

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

### Input: `y`

```text
You selected Yes.
```

### Input: `n`

```text
You selected No.
```

### Any Other Input

```text
Invalid answer.
```

The value is normally quoted:

```text
case "$answer" in
```

Quoting safely preserves empty input, spaces, and wildcard characters as part of the value being examined.

---

## 5. Multiple Patterns with `|`

Inside a `case` branch, the pipe symbol means **or**:

```text
y|Y)
```

This pattern matches either lowercase `y` or uppercase `Y`.

You may accept complete words too:

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

The pipe used in a `case` pattern is not a command pipeline. Here it separates alternative patterns.

---

## 6. The Default `*` Pattern

```text
*)
    echo "Invalid response." >&2
    ;;
```

The asterisk is a wildcard that matches anything not handled by an earlier branch.

For example, if only `y` and `n` are defined, the default branch catches:

```text
yes
no
maybe
apple
an empty answer
```

Place `*` last. If it appears first, it matches every value before Bash can reach the more specific patterns.

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

### Branch Behavior

| Input | Branch | Result |
|---|---|---|
| `y`, `Y`, or an accepted Yes word | First branch | Checks the service. |
| `n`, `N`, or an accepted No word | Second branch | Prints `Skipped.` |
| Anything else | Default branch | Prints an error. |

### Nested `if`

A `case` branch may contain another conditional:

```text
if systemctl is-active --quiet "$service_name"; then
```

The `case` decides whether the user requested a check. The nested `if` decides whether the service is active.

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

This menu runs once. To display it repeatedly, place the `case` statement inside a loop.

---

## 9. Useful Pattern Symbols

Bash `case` uses shell patterns, not regular expressions.

| Pattern | Meaning | Example Match |
|---|---|---|
| `*` | Zero or more characters | Anything |
| `?` | Exactly one character | `a`, `7`, `-` |
| `[abc]` | One listed character | `a`, `b`, or `c` |
| `[0-9]` | One digit | `0` through `9` |
| `a*` | Starts with `a` | `apple`, `admin` |
| `*.txt` | Ends with `.txt` | `notes.txt` |
| `y|Y` | Either pattern | `y` or `Y` |

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

### Important: Glob vs Regex

This `case` pattern:

```text
*.txt
```

is a shell glob pattern. A `case` branch does not use the `=~` regex operator.

---

## 10. `case` vs `if`

Both structures make decisions, but they are best suited to different tasks.

| Requirement | Recommended Structure |
|---|---|
| Match one value against several choices | `case` |
| Handle menu options | `case` |
| Handle `start`, `stop`, `restart`, or `status` | `case` |
| Match file extensions or wildcard patterns | `case` |
| Compare numbers | `if` with `(( ... ))` |
| Test files with `-f`, `-d`, or `-e` | `if` with `[[ ... ]]` |
| Combine several logical conditions | `if` |
| Check a command's exit status | `if command; then` |

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

For several exact choices, `case` is often easier to read.

---

## 11. `case` Is Not a Loop

A `case` statement checks its value once:

```text
Read one value
    ↓
Find the first matching pattern
    ↓
Run that branch
    ↓
Continue after esac
```

A loop repeats:

**script name:** `infinite_loop_demo.sh`

```bash
while true
do
    echo "Running..."
    sleep 2
done
```

To create a repeated menu, combine both structures:

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

Here:

- `while` performs the repetition.
- `case` selects an action.
- `break` ends the loop when the user enters `quit`.

---

## 12. Exit Status Behavior

A `case` statement normally produces the status of the last command executed in the selected branch. If no pattern matches and no default branch exists, the status is `0`.

For clear script behavior, explicitly use appropriate statuses when finishing inside a branch:

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

In this example, an intentional No is not an error, so it returns `0`. Invalid input returns `1`.

---

## 13. Common Mistakes

### Mistake 1: Missing `esac`

Incorrect:

```text
case "$answer" in
    y)
        echo "Yes"
        ;;
```

Bash reaches the end of the file while still waiting for `esac`.

### Mistake 2: Missing `;;`

Each ordinary branch should end with:

```text
;;
```

### Mistake 3: Forgetting `)` After a Pattern

Correct:

```text
y|Y)
```

### Mistake 4: Placing `*` First

The default wildcard would match everything, making later patterns unreachable.

### Mistake 5: Treating `|` as a Pipeline

In this pattern:

```text
y|Y)
```

the pipe separates alternatives; it does not connect command output to another command.

### Mistake 6: Calling `case` a Loop

`case` chooses a branch once. Use `for`, `while`, or `until` for repetition.

### Mistake 7: Expecting Regex Syntax

`case` uses shell patterns. For Bash regex matching, use:

```bash
[[ "$value" =~ REGEX ]]
```

---

## 14. Practice Tasks

### Task 1 — Yes or No

Ask the user whether they want to continue. Accept lowercase and uppercase `y` and `n`, and reject other responses.

### Task 2 — Service Action

Ask for one of these actions:

```text
start
stop
restart
status
```

Print which action was selected. Do not run real service-management commands yet.

### Task 3 — File Type

Ask for a filename and classify `.txt`, `.sh`, and `.md` extensions with `case` patterns.

### Task 4 — Repeating Menu

Create a `while` loop containing a `case` menu. Add a `quit` option that uses `break`.

### Task 5 — Exit Status

Return `0` for accepted choices and `1` for invalid input. Check the result immediately with:

```bash
echo "$?"
```

---

## 15. Final Summary

```text
case       → Starts the decision statement
"$value"   → Value being examined
in         → Starts the pattern list
y|Y)       → Matches y or Y
*)         → Default pattern
;;         → Ends one branch
esac       → Ends the case statement
```

Remember:

> `case` selects one matching branch. It does not repeat commands unless it is placed inside a loop.
