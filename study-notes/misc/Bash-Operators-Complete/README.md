# Bash Operators — Complete Learning Package

A beginner-friendly Bash learning package covering the operators used for comparisons, validation, file testing, arithmetic, command control, pattern matching, and output redirection.

## Live MCQ Quiz

Test your knowledge with the interactive 25-question assessment:

### [Start the Bash Operators Quiz](https://khalidkhan.me/mcqs/bash-scripting/Bash-Operators-Complete-25-MCQ-Quiz.html)

The quiz includes:

- 25 progressively challenging questions
- 25-minute countdown timer
- Automatic answer checking and scoring
- 80% passing score
- Short explanation for every answer
- Five-topic performance breakdown
- Unanswered-question warning
- Missed-question review mode
- Shuffled questions and answers on every reattempt
- Responsive dark interface for desktop and mobile

## Package Contents

| Resource | Description |
|---|---|
| [Complete Study Notes](Bash-Operators-Complete-Study-Notes.md) | Bash operators from basic comparisons to practical scripting |
| [Quick-Reference Poster](Bash-Operators-Complete-Quick-Reference.png) | Printable visual summary of the main operator categories |
| [Interactive 25-MCQ Quiz](Bash-Operators-Complete-25-MCQ-Quiz.html) | Offline copy of the complete assessment |

## Topics Covered

- Choosing between `[[ ... ]]`, `(( ... ))`, and `$(( ... ))`
- Numeric comparison operators
- String comparison operators
- Regular-expression matching with `=~`
- Logical operators: `&&`, `||`, and `!`
- File and directory test operators
- Arithmetic and arithmetic-comparison operators
- Assignment operators
- Glob pattern-matching operators
- Command-control operators
- Standard streams and redirection operators
- Common operator mistakes
- Practical validation and error-handling examples

## Quick Operator Guide

| Task | Recommended form | Example |
|---|---|---|
| Compare whole numbers | `[[ ... ]]` | `[[ "$age" -ge 18 ]]` |
| Compare strings | `[[ ... ]]` | `[[ "$name" == "Ali" ]]` |
| Validate with regex | `[[ ... ]]` | `[[ "$value" =~ ^[0-9]+$ ]]` |
| Check a regular file | `[[ ... ]]` | `[[ -f "$file" ]]` |
| Perform arithmetic | `(( ... ))` | `(( count++ ))` |
| Capture a calculation | `$(( ... ))` | `result=$((5 + 3))` |
| Run after success | `&&` | `mkdir backup && echo "Created"` |
| Run after failure | `||` | `cp file backup/ || echo "Failed" >&2` |
| Redirect stdout | `>` | `command > output.txt` |
| Redirect stderr | `2>` | `command 2> error.txt` |

## Important Examples

### Validate and compare a whole number

```bash
#!/bin/bash

read -r -p "Enter your age: " age

if [[ ! "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: enter digits only." >&2
    exit 1
fi

if [[ "$age" -ge 18 ]]; then
    echo "Adult"
else
    echo "Minor"
fi
```

### Check whether a number is even

```bash
if (( number % 2 == 0 )); then
    echo "$number is even"
else
    echo "$number is odd"
fi
```

### Check a file safely

```bash
if [[ -f "$file" && -r "$file" ]]; then
    echo "The file exists and is readable"
else
    echo "Error: file is unavailable" >&2
    exit 1
fi
```

## Recommended Learning Flow

1. Read the complete study notes.
2. Type and run each example yourself.
3. Compare similar operators, such as `-eq` versus `==`.
4. Review the quick-reference poster.
5. Complete the practice tasks without looking at the solutions.
6. Attempt the interactive quiz.
7. Review every explanation, especially missed questions.
8. Reattempt the shuffled quiz and aim for at least 80%.

## Learning Objectives

After completing this package, learners should be able to:

- Select the correct Bash structure for a given task.
- Compare numeric and string values correctly.
- Validate input using regular expressions.
- Combine conditions with logical operators.
- Test files, directories, permissions, and modification times.
- Perform and store arithmetic calculations.
- Control command execution using exit status.
- Redirect stdout and stderr safely.
- Recognize and correct common operator mistakes.

## Syntax Checking and Debugging

Check syntax without executing the script:

```bash
bash -n script.sh
```

Run the script with an execution trace:

```bash
bash -x script.sh
```

## Author

Created by **Muhammad Khalid Khan** for practical Bash scripting study, teaching, and revision.

