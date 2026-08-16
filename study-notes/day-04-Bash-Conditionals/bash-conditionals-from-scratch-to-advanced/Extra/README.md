# Bash Conditionals — Complete Learning Package

This package teaches Bash decision-making from a first `if` statement to
practical DevOps-style validation and deployment gates.

## Package Contents

| Folder | Content |
|---|---|
| `01-study-notes/` | Conditionals from scratch to advanced |
| `02-student-labs/` | Three progressive labs with six tasks each |
| `03-lab-solutions/` | Separate solution scripts |
| `04-poster/` | Printable Bash Conditionals classroom poster |
| `05-mcqs/` | Interactive 25-question HTML quiz |

## Recommended Learning Order

1. Read the study notes.
2. Complete Lab 01 using everyday decisions.
3. Complete Lab 02 using numbers, strings, files, and logical operators.
4. Complete Lab 03 with the supplied DevOps practice artifacts.
5. Compare your work with the separate solutions.
6. Review the poster.
7. Attempt the interactive quiz.

## Learning Outcomes

Students will be able to:

- Understand command success and failure.
- Write `if`, `if/else`, and `if/elif/else`.
- Compare strings and numbers.
- Test files and directories.
- Combine conditions using `&&`, `||`, and `!`.
- Use `[[ ]]`, `(( ))`, and `case`.
- Validate user input and script arguments.
- Make decisions from command and function statuses.
- Build safe configuration checks and deployment gates.

## Safe Practice

The labs do not require `sudo` and do not change real services.

```bash
bash -n script_name.sh
chmod u+x script_name.sh
./script_name.sh
```

