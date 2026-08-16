# Bash Conditionals Day 4 — 25 MCQ Quiz

An interactive beginner-friendly assessment based on Day 4 of the Bash scripting course. It reinforces conditional decision-making through simple weather and traffic-light examples.

> **25 questions · 25-minute timer · 80% passing score**

## Take the live quiz

[Start the Bash Conditionals Day 4 Quiz](https://khalidkhan.me/mcqs/bash-scripting/Bash-Conditionals-Day-4-25-MCQ-Quiz.html)

## Topics covered

- Purpose of conditional statements
- `if`, `then`, `elif`, `else`, and `fi`
- Bash tests with `[[ condition ]]`
- Correct spacing and semicolon placement
- String comparison with `=`
- Safe variable quoting
- User input with `read -r -p`
- Weather decision using `if` and `else`
- Traffic-light decisions using `if`, `elif`, and `else`
- Top-to-bottom condition evaluation
- Safe fallback handling for invalid input
- Syntax checking with `bash -n`
- Execute permission with `chmod u+x`
- Terminal-session recording with `script abc.txt`

## Quiz features

- 25 multiple-choice questions
- 25-minute countdown timer
- Automatic submission when time expires
- 80% passing requirement
- Progress indicator
- Unanswered-question warning
- Correct and incorrect answer highlighting
- Short explanation for every answer
- Attempt counter and time-used report
- Best score saved in the browser
- Questions and answer choices shuffled on every reattempt
- Mobile-friendly and print-friendly design

## How to use

1. Open the live quiz.
2. Answer all 25 questions.
3. Select **Submit Quiz** before the timer expires.
4. Review the highlighted answers and short explanations.
5. Practise missed concepts with the weather and traffic-light scripts.
6. Select **Reattempt and Shuffle** to try a new question order.

## Conditional learning flow

```text
Input → Condition → Decision → Output
```

```text
if    = first test
elif  = another test
else  = fallback
fi    = end of the conditional
```

## Basic syntax

```bash
if [[ condition ]]; then
    command
elif [[ another_condition ]]; then
    another_command
else
    fallback_command
fi
```

## Run locally

Download the following file and open it in any modern web browser:

```text
Bash-Conditionals-Day-4-25-MCQ-Quiz.html
```

On Linux:

```bash
xdg-open Bash-Conditionals-Day-4-25-MCQ-Quiz.html
```

The quiz is self-contained and does not require a web server, database, or installation.

## Recommended practice

Before attempting the quiz:

```bash
bash -n 01_weather.sh
bash -n 02_traffic_light.sh

chmod u+x 01_weather.sh 02_traffic_light.sh

./01_weather.sh
./02_traffic_light.sh
```

Test valid, invalid, and empty input. Remember that Bash checks conditions from top to bottom and runs the first matching branch.

## Target audience

- Bash scripting beginners
- Linux learners
- DevOps students
- Learners practising decision-making in scripts

---

Created for the Bash Scripting learning series by **Muhammad Khalid Khan**.
