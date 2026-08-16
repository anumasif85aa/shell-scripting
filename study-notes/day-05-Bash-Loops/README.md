# Bash Loops — Complete Learning Package

A complete beginner-to-advanced Bash loops teaching package.

## Package contents

```text
Bash-Loops-Complete-Learning-Package/
├── 01-study-notes/
│   └── Bash-Loops-From-Scratch-to-Advanced.md
├── 02-labs/
│   ├── Level-1-Beginner-Lab.md
│   ├── Level-2-Intermediate-Lab.md
│   └── Level-3-DevOps-Lab.md
├── 03-lab-data/
│   ├── fruits.txt
│   ├── students.txt
│   ├── disk-usage.txt
│   ├── logs/
│   │   ├── application.log
│   │   └── authentication.log
│   └── servers/
│       └── server-status.csv
├── 04-solutions/
│   ├── Level-1-Solutions.md
│   ├── Level-2-Solutions.md
│   └── Level-3-Solutions.md
├── 05-mcqs/
│   └── Bash-Loops-25-MCQ-Quiz.html
└── 06-poster/
    └── Bash-Loops-From-Scratch-to-Advanced-Poster.png
```

## Recommended learning order

1. Read the study notes.
2. Complete Level 1 without looking at the solutions.
3. Check scripts with `bash -n`.
4. Test normal and unusual inputs.
5. Compare your work with the Level 1 solutions.
6. Repeat the process for Levels 2 and 3.
7. Take the 25-question quiz.
8. Reattempt the quiz to receive shuffled questions and answer choices.

## Levels

| Level | Focus |
|---|---|
| Level 1 | Fruits, numbers, arguments, `break`, and `continue` |
| Level 2 | Files, input validation, arrays, menus, and nested loops |
| Level 3 | Logs, server data, disk data, retries, and reporting |

## Safe working directory

```bash
mkdir -p ~/bash-loops-practice
cd ~/bash-loops-practice
```

Copy the package into that directory, then:

```bash
cd Bash-Loops-Complete-Learning-Package
```

## Script workflow

For every script:

```bash
vim script.sh
bash -n script.sh
chmod u+x script.sh
./script.sh
echo "$?"
```

## Important safety rules

- Do not practice as the root user.
- Quote variable expansions: `"$variable"`.
- Use `"$@"` for script arguments.
- Use `"${array[@]}"` for array elements.
- Use `while IFS= read -r` for complete file lines.
- Preview file changes before running `mv`, `rm`, or similar commands.
- Give retry loops a maximum attempt count.
- A successful `bash -n` check confirms syntax only, not logic.

## Quiz features

- 25 questions
- 20-minute timer
- One-question-at-a-time navigation
- Progress bar
- Answer checking
- Score and percentage
- Short explanations
- Review of correct and incorrect answers
- Shuffled questions and answer choices on reattempt

## Teaching suggestion

Use one level per class:

- Class 1: Level 1 and poster
- Class 2: Level 2 and troubleshooting
- Class 3: Level 3 and DevOps discussion
- Class 4: MCQ assessment and student script review

