# Bash Conditionals: From Scratch to Advanced

This interactive quiz helps beginners practise Bash conditional statements from basic decision-making to practical DevOps validation.

## Start the Quiz

[Open the Bash Conditionals 25-MCQ Quiz](https://khalidkhan.me/mcqs/bash-scripting/Bash-Conditionals-From-Scratch-to-Advanced-25-MCQ-Quiz.html)

## Quiz Information

| Item | Details |
|---|---|
| Total questions | 25 |
| Time limit | 25 minutes |
| Passing score | 80% |
| Question type | Multiple choice |
| Answer checking | Available after submission |
| Explanations | Short explanation for every question |
| Reattempt | Questions and answer choices are shuffled |

## Topics Covered

- Bash exit status and true/false results
- Basic `if` statements
- `if`, `elif`, and `else` decision flow
- Closing a conditional with `fi`
- String comparisons
- Empty and non-empty string tests
- Numeric comparison operators
- Arithmetic conditions with `(( ))`
- Input validation with regular expressions
- File and directory tests
- Logical AND, OR, and NOT operators
- Wildcard pattern matching
- Testing commands such as `grep`
- Choosing between `if` and `case`
- Validating positional arguments
- Writing errors to standard error
- Safe DevOps preflight checks
- Syntax checking with `bash -n`
- Returning meaningful exit statuses

## Important Operators

### Numeric comparison operators

| Operator | Meaning |
|---|---|
| `-eq` | Equal |
| `-ne` | Not equal |
| `-gt` | Greater than |
| `-ge` | Greater than or equal |
| `-lt` | Less than |
| `-le` | Less than or equal |

### Common file tests

| Test | Meaning |
|---|---|
| `-f` | Path is a regular file |
| `-d` | Path is a directory |
| `-e` | Path exists |
| `-s` | File exists and is not empty |
| `-r` | Path is readable |
| `-w` | Path is writable |
| `-x` | Path is executable |

### Logical operators

| Operator | Meaning |
|---|---|
| `&&` | Both conditions must be true |
| `||` | At least one condition must be true |
| `!` | Reverse the result of a condition |

## Basic Conditional Structure

```bash
#!/bin/bash

read -r -p "Enter your age: " age

if [[ "$age" =~ ^[0-9]+$ ]]; then
    if (( age >= 18 )); then
        echo "You are eligible."
    else
        echo "You are not eligible."
    fi
else
    echo "Error: Please enter numbers only." >&2
    exit 1
fi
```

## How to Use the Quiz

1. Open the quiz using the link above.
2. Read each question carefully.
3. Select one answer for every question.
4. Watch the timer and progress bar.
5. Select **Submit Quiz** when finished.
6. Review your score, highlighted answers, and explanations.
7. Check the performance report to identify weak topics.
8. Select **Reattempt & Shuffle** to try a new question and answer order.

## Score Guide

| Score | Result | Suggested action |
|---|---|---|
| 90–100% | Excellent | Move to conditional scripting labs |
| 80–89% | Passed | Review missed answers and continue |
| 60–79% | Developing | Practise weak topics and reattempt |
| Below 60% | More practice needed | Review the basics before reattempting |

## Learning Outcomes

After completing this quiz, learners should be able to:

- Explain how Bash interprets success and failure.
- Write correct `if`, `elif`, and `else` blocks.
- Compare strings and numbers safely.
- Test files, directories, and user input.
- Combine multiple conditions.
- Use commands directly as conditions.
- Validate arguments before performing an action.
- Stop unsafe automation with a clear error and non-zero exit status.

## Recommended Practice

Do not only memorize the answers. Write small scripts for weather decisions, traffic lights, age checks, file validation, argument checking, and deployment preflight checks.

Validate script syntax before running it:

```bash
bash -n script.sh
```

Then run the script with different valid and invalid inputs and inspect its exit status:

```bash
echo $?
```

---

Prepared for the Bash Scripting Learning Series by Muhammad Khalid Khan.
