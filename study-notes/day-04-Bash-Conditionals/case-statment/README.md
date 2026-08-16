# Bash `case` Statement — Complete Learning Package

A beginner-friendly Bash learning package for understanding and practising the `case` conditional statement.

The package includes English and Roman Urdu study notes, a printable classroom poster, and an interactive 25-question MCQ quiz.

## Live Quiz

[Start the Bash `case` Statement 25-MCQ Quiz](https://khalidkhan.me/mcqs/bash-scripting/Bash-Case-Statement-25-MCQ-Quiz.html)

## Package Contents

| File | Purpose |
|---|---|
| `Bash-Case-Statement-Study-Notes.md` | Complete English study notes from beginner to advanced level. |
| `Bash-Case-Statement-Roman-Urdu-Study-Notes.md` | The same concepts explained in beginner-friendly Roman Urdu. |
| `Bash-case-statement.png` | Printable classroom quick-reference poster. |
| `Bash-Case-Statement-25-MCQ-Quiz.html` | Interactive 25-question assessment with automatic checking. |

## Topics Covered

- Purpose of the Bash `case` statement
- Basic `case ... in ... esac` syntax
- Patterns and command branches
- Branch terminator `;;`
- Multiple alternatives with `|`
- Default matching with `*`
- Wildcards such as `*`, `?`, and `[a-z]`
- Yes-or-No input handling
- Menus and command-line actions
- Service-management examples
- Exit statuses and error messages
- `case` compared with `if` and `elif`
- Common syntax mistakes and troubleshooting
- Advanced Bash terminators `;&` and `;;&`

## Learning Objectives

After completing this package, learners should be able to:

1. Explain why and when a `case` statement is useful.
2. Write a correctly structured `case` statement.
3. Match one value against several patterns.
4. Accept alternative inputs such as `y`, `Y`, `yes`, and `YES`.
5. Add a safe default branch for unexpected input.
6. Use `case` with command-line arguments and interactive menus.
7. Choose appropriately between `case` and `if`.
8. Identify and correct common `case` syntax errors.

## Quiz Features

- 25 progressively challenging questions
- 25-minute countdown timer
- Automatic answer checking and scoring
- 80% passing score
- Correct and incorrect answer highlighting
- Short explanation for every answer
- Warning before submitting unanswered questions
- Topic-by-topic score breakdown
- Review Missed Questions mode
- Questions reshuffled on every reattempt
- Answer choices reshuffled independently
- Responsive dark design for desktop and mobile devices

## Quiz Score Guide

| Score | Performance |
|---:|---|
| 90–100% | Excellent — strong understanding of Bash `case` statements. |
| 80–89% | Passed — review missed explanations and practise the examples. |
| 70–79% | Developing — revisit patterns, syntax, and practical menu scripts. |
| Below 70% | Review required — study the notes before reattempting the quiz. |

## Recommended Study Flow

1. Read `Bash-Case-Statement-Study-Notes.md`.
2. Use the Roman Urdu notes if additional explanation is helpful.
3. Review the poster to memorise the main syntax and symbols.
4. Type and run the examples in a Bash terminal.
5. Complete the live 25-question quiz.
6. Review incorrect answers and their explanations.
7. Reattempt the quiz; questions and choices will appear in a new order.

## Basic Syntax

```bash
case "$value" in
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

## Quick Example

```bash
#!/bin/bash

read -r -p "Enter y or n: " answer

case "$answer" in
    y|Y|yes|Yes|YES)
        echo "You selected Yes."
        ;;
    n|N|no|No|NO)
        echo "You selected No."
        ;;
    *)
        echo "Error: invalid response." >&2
        exit 1
        ;;
esac

exit 0
```

## Run the Quiz Locally

Download or extract the package, and then open:

```text
Bash-Case-Statement-25-MCQ-Quiz.html
```

The quiz runs entirely in a modern web browser. No web server, installation, account, or internet connection is required after downloading it.

## Important Reminder

The `case` statement is a conditional structure, not a loop. It selects a matching command branch but does not repeat it automatically.

## Author

Prepared for the Bash Scripting Study Series by Muhammad Khalid Khan.
