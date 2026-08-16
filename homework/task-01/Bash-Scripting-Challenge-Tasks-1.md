# Bash Scripting Challenge Tasks

## Summary

This challenge set provides practical exercises on:

- `for` loops
- `while` loops
- Command-line arguments
- Package installation
- Root-user validation
- Exit statuses
- Error handling with `set -e` and `||`

Students must create, test, and syntax-check each script.

---

## Table of Contents

1. [Learning Objectives](#learning-objectives)
2. [General Instructions](#general-instructions)
3. [Required Files](#required-files)
4. [Task 1 — For Loops](#task-1--for-loops)
5. [Task 2 — While Loop](#task-2--while-loop)
6. [Task 3 — Command-Line Arguments](#task-3--command-line-arguments)
7. [Task 4 — Install Packages with a Script](#task-4--install-packages-with-a-script)
8. [Task 5 — Error Handling](#task-5--error-handling)
9. [Testing Requirements](#testing-requirements)
10. [Submission Checklist](#submission-checklist)
11. [Optional Bonus Challenges](#optional-bonus-challenges)

---

## Learning Objectives

After completing these tasks, students should be able to:

- Process lists and number ranges with `for` loops.
- Repeat commands with a condition-controlled `while` loop.
- Read script arguments using `$0`, `$1`, `$#`, and `"$@"`.
- Detect the available Linux package-management system.
- Check whether a package is already installed.
- Install only missing packages.
- Verify whether a script is running with root privileges.
- Detect failures and return meaningful exit statuses.
- Send error messages to standard error.

---

## General Instructions

1. Add the Bash shebang to every script:

   ```bash
   #!/bin/bash
   ```

2. Use meaningful variable names.
3. Quote variable expansions:

   ```bash
   echo "$variable"
   ```

4. Send error messages to `stderr`:

   ```bash
   echo "Error: something went wrong." >&2
   ```

5. Use `exit 0` for success and a nonzero status such as `exit 1` for failure.
6. Check syntax before running a script:

   ```bash
   bash -n script_name.sh
   ```

7. Use execution tracing when troubleshooting:

   ```bash
   bash -x script_name.sh
   ```

8. Make each script executable:

   ```bash
   chmod +x script_name.sh
   ```

> **Safety note:** Do not remain logged in as `root` for ordinary practice. Run only the package-installation script with `sudo` when required.

---

## Required Files

Create the following seven scripts:

```text
bash-challenges/
├── for_loop.sh
├── count.sh
├── countdown.sh
├── greet.sh
├── args_demo.sh
├── install_packages.sh
└── safe_script.sh
```

Create the working directory:

```bash
mkdir -p bash-challenges
cd bash-challenges
```

---

# Task 1 — For Loops

## Challenge 1A: Fruit List

Create:

```text
for_loop.sh
```

### Requirements

The script must:

- Define a list containing five fruits.
- Use a `for` loop to process the list.
- Print each fruit on a separate line.
- Add an item number to each fruit as an improvement.

### Example output

```text
Item 1: apple
Item 2: banana
Item 3: mango
Item 4: orange
Item 5: red cherry
```

### Acceptance criteria

- [ ] Exactly five fruits are processed.
- [ ] A `for` loop is used.
- [ ] A fruit containing a space, such as `red cherry`, remains one item.
- [ ] Each item appears on a separate line.

---

## Challenge 1B: Count from 1 to 10

Create:

```text
count.sh
```

### Requirements

The script must:

- Use a `for` loop.
- Print the numbers `1` through `10`.
- Print one number per line.

### Example output

```text
1
2
3
4
5
6
7
8
9
10
```

### Acceptance criteria

- [ ] The first number is `1`.
- [ ] The final number is `10`.
- [ ] No number is skipped.
- [ ] A `for` loop is used.

[Back to Table of Contents](#table-of-contents)

---

# Task 2 — While Loop

Create:

```text
countdown.sh
```

## Requirements

The script must:

1. Ask the user to enter a starting number.
2. Reject empty input.
3. Reject letters, decimals, and special characters.
4. Accept a non-negative whole number.
5. Use a `while` loop to count down to `0`.
6. Print `Done!` after the loop finishes.

### Example run

```text
Enter a starting number: 5
5
4
3
2
1
0
Done!
```

### Invalid-input example

```text
Enter a starting number: apple
Error: enter a non-negative whole number.
```

### Acceptance criteria

- [ ] User input is collected with `read -r`.
- [ ] Input is validated before arithmetic is performed.
- [ ] A `while` loop is used.
- [ ] The countdown includes `0`.
- [ ] Invalid input produces an error on `stderr`.
- [ ] Invalid input returns a nonzero exit status.

[Back to Table of Contents](#table-of-contents)

---

# Task 3 — Command-Line Arguments

## Challenge 3A: Greeting Script

Create:

```text
greet.sh
```

### Requirements

The script must:

- Accept a name as `$1`.
- Print:

  ```text
  Hello, <name>!
  ```

- Display a usage message if no name is supplied:

  ```text
  Usage: ./greet.sh NAME
  ```

- Send the usage message to `stderr`.
- Exit with status `1` when the argument is missing.

### Example runs

```bash
./greet.sh Ali
```

```text
Hello, Ali!
```

Without an argument:

```bash
./greet.sh
```

```text
Usage: ./greet.sh NAME
```

### Acceptance criteria

- [ ] `$1` is used.
- [ ] Missing input is detected.
- [ ] The usage message includes the script name.
- [ ] Successful and unsuccessful runs return suitable exit statuses.

---

## Challenge 3B: Argument Information

Create:

```text
args_demo.sh
```

### Requirements

The script must print:

- The script name using `$0`.
- The total number of arguments using `$#`.
- All supplied arguments using `"$@"`.
- Each argument on a separate numbered line.

### Example run

```bash
./args_demo.sh apple banana "red cherry"
```

### Example output

```text
Script name: ./args_demo.sh
Arguments count: 3
All arguments: apple banana red cherry
Item 1: apple
Item 2: banana
Item 3: red cherry
```

### Acceptance criteria

- [ ] `$0` is displayed.
- [ ] `$#` is displayed.
- [ ] `"$@"` is used safely.
- [ ] An argument containing spaces remains one argument.

[Back to Table of Contents](#table-of-contents)

---

# Task 4 — Install Packages with a Script

Create:

```text
install_packages.sh
```

## Required package list

The script must manage:

```text
nginx
curl
wget
```

## Requirements

The script must:

1. Define a list containing `nginx`, `curl`, and `wget`.
2. Check whether the operating system uses:

   - `dpkg` with `apt`/`apt-get`, or
   - `rpm` with `dnf`/`yum`.

3. Loop through the package list.
4. Check whether each package is installed:

   ```bash
   dpkg -s PACKAGE
   ```

   or:

   ```bash
   rpm -q PACKAGE
   ```

5. Skip packages that are already installed.
6. Install packages that are missing.
7. Print a clear status for every package:

   ```text
   [INSTALLED] curl is already installed.
   [MISSING] Installing nginx...
   [SUCCESS] nginx was installed.
   [ERROR] wget installation failed.
   ```

8. Return a nonzero exit status if an installation fails.

## Root-user check

Before installing anything, verify that the effective user ID is `0`.

If the script is not running as root, it must print:

```text
Error: run this script with sudo.
Usage: sudo ./install_packages.sh
```

Then it must exit with status `1`.

## Recommended execution

```bash
sudo ./install_packages.sh
```

This is safer than opening and keeping an interactive root shell with:

```bash
sudo -i
```

or:

```bash
sudo su
```

## Safety requirements

- Do not remove packages.
- Do not change repository files.
- Do not disable security controls.
- Do not run the script repeatedly until its logic has been reviewed.
- Test the root check before testing installation.

### Acceptance criteria

- [ ] The script refuses to install packages when not run as root.
- [ ] All three packages are processed in a loop.
- [ ] Installed packages are skipped.
- [ ] Missing packages are installed.
- [ ] Debian/Ubuntu and RHEL-family checks are handled clearly.
- [ ] Every package receives a status message.
- [ ] Installation failures return a nonzero status.

[Back to Table of Contents](#table-of-contents)

---

# Task 5 — Error Handling

## Challenge 5A: Safe File-Creation Workflow

Create:

```text
safe_script.sh
```

## Requirements

The script must:

1. Enable exit-on-error near the top:

   ```bash
   set -e
   ```

2. Define the target directory:

   ```text
   /tmp/devops-test
   ```

3. Attempt to create the directory.
4. Navigate into the directory.
5. Create a file inside it.
6. Use `||` to provide a meaningful error message when an important command fails.
7. Send error messages to `stderr`.
8. Exit with a nonzero status after an unrecoverable failure.
9. Print a success message only after every required step succeeds.

### Basic error-handling pattern

Use this general pattern where appropriate:

```bash
command || {
    echo "Error: command failed." >&2
    exit 1
}
```

Do not copy the word `command` literally into your finished script. Replace it with the command being checked.

### Important `set -e` note

A command used directly with `||` is treated as a handled condition. Therefore, this:

```bash
mkdir /tmp/devops-test || echo "Directory already exists"
```

prints a message but allows the script to continue.

If failure must stop the script, the `||` block must explicitly use:

```bash
exit 1
```

Also remember that `mkdir` can fail for reasons other than an existing directory, including:

- Permission denied
- Invalid path
- Read-only filesystem
- No available disk space

### Expected successful result

```text
Directory created or verified: /tmp/devops-test
Entered directory: /tmp/devops-test
File created successfully
Workflow completed
```

### Acceptance criteria

- [ ] `set -e` is enabled.
- [ ] `/tmp/devops-test` is used.
- [ ] Directory creation is handled safely.
- [ ] Directory navigation is checked.
- [ ] File creation is checked.
- [ ] Error messages are written to `stderr`.
- [ ] A success message is not printed after a failed step.

---

## Challenge 5B: Improve the Package Installer

Modify:

```text
install_packages.sh
```

Add the following error-handling features:

- Root-user validation
- Package-manager detection
- Failure handling for package installation
- An error message on `stderr`
- A nonzero exit status when installation fails
- A final success message only when all packages are installed or already present

[Back to Table of Contents](#table-of-contents)

---

# Testing Requirements

## 1. Check every script's syntax

```bash
bash -n for_loop.sh
bash -n count.sh
bash -n countdown.sh
bash -n greet.sh
bash -n args_demo.sh
bash -n install_packages.sh
bash -n safe_script.sh
```

No output normally means that Bash found no syntax errors.

## 2. Test successful cases

Examples:

```bash
./for_loop.sh
./count.sh
./countdown.sh
./greet.sh Ali
./args_demo.sh apple banana "red cherry"
./safe_script.sh
```

## 3. Test failure cases

Examples:

```bash
./countdown.sh
./greet.sh
./install_packages.sh
```

The package script must refuse to continue without root privileges.

## 4. Check exit statuses

Run this immediately after each test:

```bash
echo $?
```

Expected convention:

| Status | Meaning |
|---:|---|
| `0` | Success |
| Nonzero | Failure |

## 5. Use tracing when needed

```bash
bash -x script_name.sh
```

> Do not use `bash -x` with commands that contain passwords or other secrets because tracing can expose expanded values.

[Back to Table of Contents](#table-of-contents)

---

# Submission Checklist

Before submitting, confirm:

- [ ] All seven required scripts exist.
- [ ] Every script starts with `#!/bin/bash`.
- [ ] All scripts pass `bash -n`.
- [ ] Variables are quoted where appropriate.
- [ ] Error messages use `>&2`.
- [ ] Failure paths return a nonzero status.
- [ ] Success messages appear only after successful operations.
- [ ] `"$@"` is used when preserving separate arguments.
- [ ] The package installer checks for root privileges.
- [ ] The package installer skips packages that are already installed.
- [ ] No unnecessary files or captured passwords are included.

---

# Optional Bonus Challenges

## Bonus 1: Custom countdown argument

Allow `countdown.sh` to accept the starting number as `$1`, while still prompting the user when no argument is supplied.

## Bonus 2: Custom package list

Allow package names to be passed to `install_packages.sh`:

```bash
sudo ./install_packages.sh nginx curl wget
```

Use the default list when no arguments are provided.

## Bonus 3: Log package results

Write normal status messages to:

```text
install.log
```

Write error messages to:

```text
install-error.log
```

## Bonus 4: Summary report

At the end of `install_packages.sh`, print:

- Packages already installed
- Packages installed successfully
- Packages that failed

## Bonus 5: Cleanup option

Add an optional argument to `safe_script.sh` that removes only the file and directory created by that script.

Do not delete broad or unresolved paths.

[Back to Table of Contents](#table-of-contents)
