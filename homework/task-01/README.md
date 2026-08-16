# Bash Scripting Challenge Tasks 1

A practical Bash scripting challenge covering loops, user input, command-line arguments, package checks, root validation, and basic error handling.

The exercises are designed for students who have learned Bash fundamentals and now want to practise writing complete, testable scripts.

## Learning Resources

| Resource | Purpose |
|---|---|
| [Student Challenge Sheet](Bash-Scripting-Challenge-Tasks-1.md) | Tasks, requirements, testing guidance, and bonus challenges |
| [Complete Solutions](Bash-Scripting-Challenge-Tasks-1-Solutions.md) | Reference scripts, explanations, and verification commands |

> Try each challenge independently before opening the solution guide.

## Challenge Summary

| Task | Script | Main Concepts |
|---:|---|---|
| 1 | `for_loop.sh` | Looping through a list of fruits |
| 1 | `count.sh` | Number sequence with a `for` loop |
| 2 | `countdown.sh` | User input, validation, and a `while` loop |
| 3 | `greet.sh` | Positional parameter `$1` and usage messages |
| 3 | `args_demo.sh` | `$0`, `$#`, and `"$@"` |
| 4 | `install_packages.sh` | Package detection, loops, root checks, and installation |
| 5 | `safe_script.sh` | `set -e`, `||`, directory navigation, and failure handling |

## Learning Objectives

After completing these challenges, students should be able to:

- Write and run Bash scripts.
- Use `for` and `while` loops.
- Read input safely with `read -r`.
- Access command-line arguments.
- Validate missing or invalid input.
- Check whether a command succeeds or fails.
- Use exit statuses and meaningful error messages.
- Check whether a script is running as `root`.
- Detect packages on Debian/Ubuntu and RHEL-family systems.
- Apply basic error-handling practices.

## Required Scripts

Create the following seven files:

```text
Bash-Scripting-Challenge-Tasks-1/
├── for_loop.sh
├── count.sh
├── countdown.sh
├── greet.sh
├── args_demo.sh
├── install_packages.sh
└── safe_script.sh
```

## Requirements

- A Linux environment
- Bash
- A text editor such as Vim, Nano, or VS Code
- `sudo` access for the package-installation task
- A Debian/Ubuntu or RHEL-family system for `install_packages.sh`

Check your Bash version:

```bash
bash --version
```

## Getting Started

Create a practice directory:

```bash
mkdir -p Bash-Scripting-Challenge-Tasks-1
cd Bash-Scripting-Challenge-Tasks-1
```

Create the required files:

```bash
touch for_loop.sh count.sh countdown.sh greet.sh args_demo.sh
touch install_packages.sh safe_script.sh
```

Add this shebang to the beginning of every script:

```bash
#!/bin/bash
```

Make the scripts executable:

```bash
chmod +x ./*.sh
```

## Recommended Learning Workflow

1. Read one task in the student challenge sheet.
2. Write the script without looking at the solution.
3. Check its syntax with `bash -n`.
4. Test successful, invalid, and missing-input cases.
5. Inspect the exit status with `echo $?`.
6. Compare your work with the solution guide.
7. Improve your script and add comments.

## Syntax Checking

Check one script:

```bash
bash -n countdown.sh
```

Check every challenge script:

```bash
for script in ./*.sh
do
    bash -n "$script" || exit 1
done

echo "All scripts passed syntax checking."
```

`bash -n` checks syntax without executing the script.

## Example Test Commands

### Loops

```bash
./for_loop.sh
./count.sh
```

### Countdown

```bash
./countdown.sh
```

Test it with:

- A positive whole number
- `0`
- Empty input
- Text such as `abc`

### Command-Line Arguments

```bash
./greet.sh Ali
./greet.sh

./args_demo.sh apple banana "red cherry"
```

The quoted value `"red cherry"` should remain one argument.

### Error Handling

```bash
./safe_script.sh
echo $?
```

Run it more than once to observe how it handles an existing directory.

## Exit Status Reminder

Every command returns an exit status:

| Status | Meaning |
|---:|---|
| `0` | Success |
| Non-zero | Failure or another special result |

Display the most recent status:

```bash
echo $?
```

Scripts should normally use:

```bash
exit 0
```

for success, and:

```bash
exit 1
```

for a general failure.

## Safety Notice

`install_packages.sh` can modify system software. Read and understand the script before running it.

Use it only on a suitable practice system:

```bash
sudo ./install_packages.sh
```

The script should verify root access before attempting an installation:

```bash
if [[ "$EUID" -ne 0 ]]; then
    echo "Error: run this script as root." >&2
    exit 1
fi
```

Do not test package installation on an important production system.

## Submission Checklist

- [ ] All seven scripts are present.
- [ ] Every script starts with `#!/bin/bash`.
- [ ] All scripts pass `bash -n`.
- [ ] Variables are quoted where appropriate.
- [ ] Invalid or missing input is handled.
- [ ] Error messages are sent to `stderr` where appropriate.
- [ ] Failure paths return a non-zero exit status.
- [ ] `install_packages.sh` checks for root privileges.
- [ ] Scripts contain useful comments.
- [ ] Successful and failure cases have been tested.

## Topics Covered

- Bash script structure
- Variables and quoting
- `for` loops
- `while` loops
- Interactive input
- Positional parameters
- Argument counting
- Package management
- Root-user validation
- Exit statuses
- `set -e`
- The `||` operator
- Standard error
- Defensive scripting

## Author

Created for Bash scripting practice by **Muhammad Khalid Khan**.

