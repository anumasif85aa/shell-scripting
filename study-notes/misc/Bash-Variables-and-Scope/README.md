# Bash Variables and Scope

A beginner-to-advanced learning package for understanding Bash variables, variable scope, function arguments, environment variables, subshells, and safe scripting practices.

## Live MCQ Quiz

Test your knowledge with the interactive 25-question quiz:

### [Start the Bash Variables and Scope Quiz](https://khalidkhan.me/mcqs/bash-scripting/Bash-Variables-and-Scope-25-MCQ-Quiz.html)

The quiz includes:

- 25 multiple-choice questions
- 25-minute countdown timer
- Automatic answer checking and scoring
- 80% passing score
- Short explanation for every answer
- Topic-by-topic performance breakdown
- Missed-question review
- Shuffled questions and answers on every reattempt
- Mobile-friendly dark interface

## Package Contents

| Resource | Description |
|---|---|
| [English Study Notes](Bash-Variables-and-Scope.md) | Complete beginner-to-advanced notes in English |
| [Roman Urdu Study Notes](Bash-Variables-and-Scope-Roman-Urdu.md) | The same concepts explained in beginner-friendly Roman Urdu |
| [Printable Poster](Bash-Variables-and-Scope-Poster.png) | Visual summary of global, local, environment, and subshell scope |
| [Interactive MCQ Quiz](Bash-Variables-and-Scope-25-MCQ-Quiz.html) | Offline copy of the 25-question assessment |

## Topics Covered

- Creating and expanding Bash variables
- Variable naming rules and quotation
- Global variables
- Variables created inside functions
- Local variables and the `local` keyword
- Global versus local scope
- Protecting global values
- Script and function arguments
- Positional parameters such as `$1`, `$#`, and `"$@"`
- Environment variables and `export`
- Parent and child shell behavior
- Subshell scope
- Command substitution
- Readonly variables
- Removing variables with `unset`
- Variable-safety best practices

## Quick Example

```bash
#!/bin/bash

name="Ali"

change_name()
{
    local name="Omar"
    echo "Inside: $name"
}

change_name
echo "Outside: $name"
```

Output:

```text
Inside: Omar
Outside: Ali
```

The function's `name` is local, so changing it does not overwrite the global `name`.

## Recommended Learning Flow

1. Read the English or Roman Urdu study notes.
2. Type and run the examples yourself.
3. Compare global and local variable behavior.
4. Review the printable poster.
5. Attempt the quiz without using the notes.
6. Study the explanations for incorrect answers.
7. Reattempt the shuffled quiz and aim for at least 80%.

## Run the Examples Safely

Check the syntax without executing the script:

```bash
bash -n script.sh
```

Run the script with an execution trace:

```bash
bash -x script.sh
```

## Learning Objectives

After completing this package, learners should be able to:

- Create and use Bash variables correctly.
- Explain where global and local variables are available.
- Prevent functions from accidentally changing global variables.
- Pass arguments safely to scripts and functions.
- Export values for child processes.
- Predict how variables behave in subshells.
- Apply safer variable-handling practices in Bash scripts.

## Author

Created by **Muhammad Khalid Khan** for practical Bash scripting study and classroom revision.

