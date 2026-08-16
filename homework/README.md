# Bash Scripting Homework

A collection of practical Bash scripting assignments designed to develop problem-solving, automation, validation, and error-handling skills.

Each homework task provides:

- A student challenge sheet
- Clearly defined script requirements
- Testing instructions
- A separate solution guide
- A downloadable task package

## Homework Index

| Homework | Topics | Resources |
|---|---|---|
| Task 1 | `for` loops, `while` loops, command-line arguments, package checks, root validation, and error handling | [Overview](task-1/README.md) · [Challenge](task-1/Bash-Scripting-Challenge-Tasks-1.md) · [Solutions](task-1/Bash-Scripting-Challenge-Tasks-1-Solutions.md) · [Download ZIP](task-1.zip) |

## Repository Structure

```text
homework/
├── README.md
├── task-1/
│   ├── README.md
│   ├── Bash-Scripting-Challenge-Tasks-1.md
│   └── Bash-Scripting-Challenge-Tasks-1-Solutions.md
└── task-1.zip
```

## Task 1 Overview

Task 1 contains five challenges requiring seven Bash scripts:

| Task | Script | Main Skill |
|---:|---|---|
| 1 | `for_loop.sh` | Loop through a list of fruits |
| 1 | `count.sh` | Print numbers with a `for` loop |
| 2 | `countdown.sh` | Validate input and use a `while` loop |
| 3 | `greet.sh` | Read the first positional argument |
| 3 | `args_demo.sh` | Work with `$0`, `$#`, and `"$@"` |
| 4 | `install_packages.sh` | Check and install Linux packages safely |
| 5 | `safe_script.sh` | Apply exit statuses and error handling |

## Learning Objectives

After completing the homework, students should be able to:

- Create and execute Bash scripts.
- Use `for` and `while` loops.
- Read and validate user input.
- Process command-line arguments.
- Quote variables and arguments safely.
- Check command success and failure.
- Send error messages to standard error.
- Return meaningful exit statuses.
- Verify root privileges before administrative operations.
- Apply basic defensive scripting practices.

## Recommended Workflow

1. Open the challenge sheet.
2. Read one task carefully.
3. Write the required script independently.
4. Check its syntax with `bash -n`.
5. Test both successful and failure cases.
6. Check the exit status with `echo $?`.
7. Review the solution only after completing your attempt.
8. Improve your script based on what you learned.

## Getting Started

Open the homework directory:

```bash
cd homework
```

Open Task 1:

```bash
cd task-1
```

Read the assignment:

```bash
less Bash-Scripting-Challenge-Tasks-1.md
```

Use a Markdown preview in GitHub or your code editor for the best reading experience.

## Running a Script

Make a script executable:

```bash
chmod +x script.sh
```

Run it:

```bash
./script.sh
```

You can also run it directly with Bash:

```bash
bash script.sh
```

## Syntax Checking

Check a script without executing it:

```bash
bash -n script.sh
```

Check all Bash scripts in the current directory:

```bash
for script in ./*.sh
do
    bash -n "$script" || exit 1
done

echo "All scripts passed syntax checking."
```

## Debugging

Run a script in trace mode:

```bash
bash -x script.sh
```

- `bash -n` checks syntax.
- `bash -x` displays commands as Bash executes them.

## Exit Status

Check the status returned by the most recent command:

```bash
echo $?
```

| Status | Meaning |
|---:|---|
| `0` | Success |
| Non-zero | Failure or another special result |

## Student Guidelines

- Attempt every task before reading its solution.
- Use meaningful variable names.
- Quote variable expansions when appropriate.
- Add comments that explain the purpose of important code.
- Test valid, invalid, empty, and missing input.
- Send error messages to `stderr` using `>&2`.
- Never assume that a command succeeded.
- Do not run administrative scripts without reviewing them.

## Safety Notice

The package-installation exercise can modify system software. Run it only on a suitable Linux practice environment after reviewing the script:

```bash
sudo ./install_packages.sh
```

Do not test package installation on an important production system.

## Submission Checklist

- [ ] All required scripts have been created.
- [ ] Every script begins with a Bash shebang.
- [ ] Scripts pass `bash -n`.
- [ ] Successful and failure cases have been tested.
- [ ] Variables and arguments are quoted correctly.
- [ ] Invalid input produces a clear error.
- [ ] Failure paths return non-zero exit statuses.
- [ ] Administrative scripts verify root access.
- [ ] Scripts include useful comments.
- [ ] Solutions were reviewed only after attempting the challenges.

## Author

Created for Bash scripting practice by **Muhammad Khalid Khan**.

