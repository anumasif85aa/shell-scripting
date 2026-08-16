# Bash Conditionals: From Scratch to Advanced

A complete classroom, GitHub, Linux administration, DevOps, and interview-preparation package for learning Bash decision-making.

The package starts with simple real-life examples and progresses to safe local release validation.

## Quick links

- [Complete study notes](01-study-notes/Bash-Conditionals-From-Scratch-to-Advanced-Study-Notes.md)
- [Level 01 lab](02-labs/Level-01-Conditionals-Fundamentals-Lab.md)
- [Level 02 lab](02-labs/Level-02-Practical-Conditionals-Lab.md)
- [Level 03 lab](02-labs/Level-03-DevOps-Conditionals-Lab.md)
- [Level 01 solutions](03-solutions/Level-01-Conditionals-Fundamentals-Solutions.md)
- [Level 02 solutions](03-solutions/Level-02-Practical-Conditionals-Solutions.md)
- [Level 03 solutions](03-solutions/Level-03-DevOps-Conditionals-Solutions.md)
- [Interactive 25-question quiz](06-mcqs/Bash-Conditionals-From-Scratch-to-Advanced-25-MCQ-Quiz.html)
- [Roman Urdu summary](08-bonus-resources/Bash-Conditionals-Roman-Urdu-Summary.md)
- [Cheat sheet](08-bonus-resources/Bash-Conditionals-Cheat-Sheet.md)
- [Assignment](08-bonus-resources/Bash-Conditionals-Assignment.md)
- [Mini project](08-bonus-resources/Bash-Conditionals-Mini-Project.md)
- [Interview questions](08-bonus-resources/Bash-Conditionals-Interview-Questions.md)
- [LinkedIn post](08-bonus-resources/Bash-Conditionals-LinkedIn-Post.md)

## Package structure

```text
bash-conditionals-from-scratch-to-advanced/
├── README.md
├── 01-study-notes/
│   └── Bash-Conditionals-From-Scratch-to-Advanced-Study-Notes.md
├── 02-labs/
│   ├── Level-01-Conditionals-Fundamentals-Lab.md
│   ├── Level-02-Practical-Conditionals-Lab.md
│   └── Level-03-DevOps-Conditionals-Lab.md
├── 03-solutions/
│   ├── Level-01-Conditionals-Fundamentals-Solutions.md
│   ├── Level-02-Practical-Conditionals-Solutions.md
│   └── Level-03-DevOps-Conditionals-Solutions.md
├── 04-lab-data/
│   ├── approval.txt
│   ├── artifacts/
│   ├── deployment-audit.log
│   ├── release.env
│   ├── sample-app.log
│   ├── server-status.env
│   ├── source/
│   └── test-data/
├── 05-posters/
│   ├── Bash-Conditionals-Core-Syntax-Poster.png
│   └── Bash-Conditionals-DevOps-Decision-Flow-Poster.png
├── 06-mcqs/
│   └── Bash-Conditionals-From-Scratch-to-Advanced-25-MCQ-Quiz.html
├── 07-solution-scripts/
│   ├── level-01/
│   ├── level-02/
│   └── level-03/
└── 08-bonus-resources/
    ├── Bash-Conditionals-Assignment.md
    ├── Bash-Conditionals-Cheat-Sheet.md
    ├── Bash-Conditionals-Interview-Questions.md
    ├── Bash-Conditionals-LinkedIn-Post.md
    ├── Bash-Conditionals-Mini-Project.md
    └── Bash-Conditionals-Roman-Urdu-Summary.md
```

## Learning path

### Level 01: Baby steps

- Basic `if` and `else`
- `if`, `elif`, and `else`
- Empty and numeric input validation
- Simple string decisions
- File checks
- Argument-count checks

Examples use weather, traffic lights, age, and fruit choices.

### Level 02: Practical decisions

- Numeric ranges
- Regular-expression validation
- File and directory inspection
- Pattern matching
- Command exit statuses
- Logical AND, OR, and NOT

### Level 03: DevOps release flow

- Change-request validation
- Artifact validation
- Environment and port checks
- Approval decisions
- Simulated server readiness
- Final decision and audit recording

All actions are local simulations. Nothing is deployed.

## Lab boundaries

The lab scripts intentionally avoid:

- Functions
- Loops
- Arrays
- `case`
- `getopts`
- `sudo`
- Remote servers
- Production resources

This keeps the learning focus on conditional logic.

## Running the scripts

Move into the package:

```bash
cd bash-conditionals-from-scratch-to-advanced
```

Check syntax:

```bash
bash -n 07-solution-scripts/level-01/01_weather.sh
```

Run:

```bash
bash 07-solution-scripts/level-01/01_weather.sh
```

Or use execute permission:

```bash
./07-solution-scripts/level-01/01_weather.sh
```

## Running the Level 03 controller

```bash
./07-solution-scripts/level-03/06_release_controller.sh CHG-20260725-001
echo "$?"
```

The script records a local decision but performs no deployment.

## Opening the quiz

Open this file in a browser:

```text
06-mcqs/Bash-Conditionals-From-Scratch-to-Advanced-25-MCQ-Quiz.html
```

Quiz features:

- 25 questions
- 25-minute timer
- 80% passing score
- Unanswered-question warning
- Automatic answer checking
- Short explanation for every question
- Performance by topic
- Best-score tracking
- Shuffled questions and choices on every reattempt

## Recommended order

1. Read the study notes through basic `if/elif/else`.
2. Complete Level 01 without looking at solutions.
3. Compare and correct your scripts.
4. Complete Level 02.
5. Complete Level 03 with supplied local data.
6. Review the posters and cheat sheet.
7. Complete the assignment and mini project.
8. Practise the interview questions.
9. Reattempt the quiz until you score at least 80%.

## Completion checklist

- [ ] Study notes reviewed
- [ ] Level 01: six tasks completed
- [ ] Level 02: six tasks completed
- [ ] Level 03: six tasks completed
- [ ] All scripts pass `bash -n`
- [ ] Valid and invalid inputs tested
- [ ] Expected failure statuses verified
- [ ] Posters reviewed
- [ ] Assignment completed
- [ ] Mini project completed
- [ ] Interview questions reviewed
- [ ] MCQ score is 80% or higher

## Validation status

The package was checked for:

- 18 executable solution scripts
- Bash syntax
- 29 successful and expected-failure execution paths
- Release artifact integrity
- 25 unique quiz questions
- 100 valid quiz choices
- Correct-answer mapping
- Quiz rendering, timer, scoring, and explanations
- Topic reporting and shuffled reattempts

---

Prepared for the Bash Scripting Learning Series by Muhammad Khalid Khan.
