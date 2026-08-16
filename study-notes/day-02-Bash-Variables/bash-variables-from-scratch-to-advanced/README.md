# Bash Variables: From Scratch to Advanced

A complete learning package for understanding and practising Bash variables from first assignment to practical DevOps validation.

The package uses small steps, simple language, `echo`-based examples, progressive labs, tested solutions, printable posters, and an interactive quiz.

## Quick links

- [Complete study notes](01-study-notes/Bash-Variables-From-Scratch-to-Advanced-Study-Notes.md)
- [Level 01 lab](02-labs/Level-01-Variables-Fundamentals-Lab.md)
- [Level 02 lab](02-labs/Level-02-Practical-Variables-Lab.md)
- [Level 03 lab](02-labs/Level-03-DevOps-Variables-Lab.md)
- [Level 01 solutions](03-solutions/Level-01-Variables-Fundamentals-Solutions.md)
- [Level 02 solutions](03-solutions/Level-02-Practical-Variables-Solutions.md)
- [Level 03 solutions](03-solutions/Level-03-DevOps-Variables-Solutions.md)
- [Open the interactive MCQ quiz](06-mcqs/Bash-Variables-From-Scratch-to-Advanced-25-MCQ-Quiz.html)

## Package contents

```text
bash-variables-from-scratch-to-advanced/
├── README.md
├── 01-study-notes/
│   └── Bash-Variables-From-Scratch-to-Advanced-Study-Notes.md
├── 02-labs/
│   ├── Level-01-Variables-Fundamentals-Lab.md
│   ├── Level-02-Practical-Variables-Lab.md
│   └── Level-03-DevOps-Variables-Lab.md
├── 03-solutions/
│   ├── Level-01-Variables-Fundamentals-Solutions.md
│   ├── Level-02-Practical-Variables-Solutions.md
│   └── Level-03-DevOps-Variables-Solutions.md
├── 04-lab-data/
│   ├── app.env
│   ├── deploy-request.txt
│   ├── sample-app.log
│   └── servers.txt
├── 05-posters/
│   ├── Bash-Variables-Fundamentals-Poster.png
│   └── Bash-Variables-Practical-Advanced-Poster.png
├── 06-mcqs/
│   └── Bash-Variables-From-Scratch-to-Advanced-25-MCQ-Quiz.html
└── 07-solution-scripts/
    ├── level-01/
    ├── level-02/
    └── level-03/
```

## Learning path

### Level 01: Variables fundamentals

Start here if you are new to Bash.

- Variable assignment
- Reading values with `$`
- Braces
- Double and single quotes
- User input
- Positional arguments
- Command substitution
- Basic arithmetic

The lab uses simple fruit examples such as `apple`, `banana`, and `cherry`.

### Level 02: Practical variables

Move here after completing Level 01.

- Default values
- Input validation
- Environment variables
- Temporary command environments
- Filename expansion
- String length
- Timestamped names
- Backup dry-run planning

### Level 03: DevOps variables

Use variables in safe automation patterns.

- Reading approved configuration keys
- Required deployment variables
- Build metadata
- Environment-based deployment planning
- Secret input practice
- Preflight validation
- Meaningful exit statuses

All deployment work is simulation only.

## Recommended order

1. Read the study notes through the fundamentals section.
2. Complete Level 01 without looking at the solutions.
3. Compare your work with the Level 01 solutions.
4. Repeat the same process for Levels 02 and 03.
5. Review both posters.
6. Open the interactive MCQ quiz.
7. Reattempt the quiz until you score at least 80%.
8. Rewrite weak scripts without copying.

## Running a solution script

Move into the package:

```bash
cd bash-variables-from-scratch-to-advanced
```

Check syntax:

```bash
bash -n 07-solution-scripts/level-01/01_fruits.sh
```

Run with Bash:

```bash
bash 07-solution-scripts/level-01/01_fruits.sh
```

The solution scripts are also executable:

```bash
./07-solution-scripts/level-01/01_fruits.sh
```

## Opening the quiz

Open this file in a web browser:

```text
06-mcqs/Bash-Variables-From-Scratch-to-Advanced-25-MCQ-Quiz.html
```

Quiz features:

- 25 questions
- 25-minute timer
- 80% passing score
- Unanswered-question warning
- Automatic answer checking
- Correct, incorrect, and unanswered totals
- Short explanation for every answer
- Performance by topic
- Best-score tracking
- Shuffled questions and answers on every reattempt

## Lab rules

- Use `#!/bin/bash`.
- Use `echo`, not `printf`.
- Do not use functions in the beginner labs.
- Do not work as the root user.
- Quote variable expansions.
- Use fake tokens only.
- Validate before performing an action.
- Run `bash -n` before execution.
- Test valid, invalid, missing, and empty input.

## Important reminder

Correct assignment:

```bash
name="Ali"
```

Incorrect assignment:

```bash
name = "Ali"
```

There must be no spaces around `=`.

## Completion checklist

- [ ] Study notes reviewed
- [ ] Level 01: six tasks completed
- [ ] Level 02: six tasks completed
- [ ] Level 03: six tasks completed
- [ ] All scripts pass `bash -n`
- [ ] Valid and invalid cases tested
- [ ] Fundamentals poster reviewed
- [ ] Advanced poster reviewed
- [ ] MCQ score is 80% or higher
- [ ] Weak scripts rewritten without copying

## Validation status

The package was checked for:

- 18 executable solution scripts
- Bash syntax across solution code
- Successful and expected-failure script paths
- 25 unique quiz questions
- Four choices per quiz question
- Correct-answer mapping
- Quiz rendering and scoring
- Timer reset
- Explanations and category report
- Question and answer shuffling

---

Prepared for the Bash Scripting Learning Series by Muhammad Khalid Khan.
