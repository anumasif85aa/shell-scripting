# Bash Conditionals — From Scratch to Advanced

Conditionals allow a Bash script to test a situation, make a decision, and run the correct commands.

```text
Input → Test a condition → Make a decision → Run commands
```

These notes begin with simple `if` statements and gradually introduce strings, numbers, files, command results, logical operators, patterns, regular expressions, and a practical DevOps preflight script.

## Learning objectives

After completing these notes, you should be able to:

- Explain how Bash decides whether a condition is true or false
- Write `if`, `if/else`, and `if/elif/else` statements
- Use `[ ]`, `[[ ]]`, and `(( ))` correctly
- Compare strings and numbers
- Test files, directories, permissions, and file content
- Combine conditions with `&&`, `||`, and `!`
- Use a command directly as an `if` condition
- Validate arguments and user input
- Use Bash patterns and regular expressions
- Return meaningful success and failure exit statuses
- Build a practical DevOps preflight script

---

## 1. How Bash understands true and false

Bash conditions are based on **exit status**:

| Exit status | Meaning in a conditional |
|---:|---|
| `0` | True or successful |
| Non-zero | False, failed, or another defined condition |

Example:

```bash
ls /etc/passwd
echo "$?"
```

The file exists, so `ls` normally returns `0`.

```bash
ls /missing-file
echo "$?"
```

The command fails and returns a non-zero status.

This is the central idea behind Bash conditionals:

```text
Success status 0 → condition is true
Non-zero status → condition is false
```

---

## 2. Basic `if` statement

Use `if` when commands should run only when a condition is true.

```bash
if [[ condition ]]; then
    commands
fi
```

Example:

**script name:** `basic_weather_if.sh`

```bash
#!/bin/bash

weather="yes"

if [[ "$weather" = "yes" ]]; then
    echo "Take an umbrella"
fi
```

### Important keywords

| Keyword | Purpose |
|---|---|
| `if` | Starts the first test |
| `then` | Starts the commands for a true condition |
| `fi` | Ends the conditional |

`fi` is `if` written backward.

### Put `then` on the next line

This is also correct:

```bash
if [[ "$weather" = "yes" ]]
then
    echo "Take an umbrella"
fi
```

If `then` is written on the same line as the condition, use a semicolon:

```bash
if [[ "$weather" = "yes" ]]; then
```

---

## 3. `if` and `else`

Use `else` when you need a fallback decision.

```bash
if [[ condition ]]; then
    commands_if_true
else
    commands_if_false
fi
```

### Weather example

**script name:** `weather_decision.sh`

```bash
#!/bin/bash

read -r -p "Is it raining? Enter yes or no: " weather

if [[ "$weather" = "yes" ]]; then
    echo "Take an umbrella"
else
    echo "You do not need an umbrella"
fi
```

If the user enters `yes`, the `if` branch runs. Every other value goes to `else`.

---

## 4. `if`, `elif`, and `else`

Use `elif` when more than two decisions are possible.

```bash
if [[ condition1 ]]; then
    command1
elif [[ condition2 ]]; then
    command2
elif [[ condition3 ]]; then
    command3
else
    fallback_command
fi
```

### Traffic-light example

**script name:** `traffic_light.sh`

```bash
#!/bin/bash

read -r -p "Enter traffic-light color (red/yellow/green): " light

if [[ "$light" = "red" ]]; then
    echo "Stop"
elif [[ "$light" = "yellow" ]]; then
    echo "Get ready"
elif [[ "$light" = "green" ]]; then
    echo "Go"
else
    echo "Invalid color: enter red, yellow, or green" >&2
    exit 1
fi

exit 0
```

Bash checks conditions from top to bottom. After finding the first true condition, it runs that branch and skips the remaining branches.

---

## 5. Make input case-insensitive

The previous script does not treat `RED` and `red` as equal.

Bash can convert text to lowercase:

**script name:** `case_insensitive_traffic_light.sh`

```bash
read -r -p "Enter traffic-light color: " light

light="${light,,}"

if [[ "$light" = "red" ]]; then
    echo "Stop"
elif [[ "$light" = "yellow" ]]; then
    echo "Get ready"
elif [[ "$light" = "green" ]]; then
    echo "Go"
else
    echo "Invalid color" >&2
    exit 1
fi
```

`${light,,}` converts the value stored in `light` to lowercase.

---

## 6. Understanding `[[ condition ]]`

The double-bracket syntax is Bash's modern conditional syntax:

```bash
[[ condition ]]
```

It is itself a command-like construct that returns an exit status.

```bash
name="Ali"

[[ "$name" = "Ali" ]]
echo "$?"
```

Expected status:

```text
0
```

False example:

```bash
name="Omar"

[[ "$name" = "Ali" ]]
echo "$?"
```

Expected status:

```text
1
```

### Spaces are required

Correct:

```bash
[[ "$name" = "Ali" ]]
```

Incorrect:

```bash
[["$name"="Ali"]]
```

Bash needs spaces so that it can recognize the brackets, values, and operator as separate parts.

---

## 7. `[ ]` versus `[[ ]]`

Both forms can test conditions:

```bash
[ "$name" = "Ali" ]
```

```bash
[[ "$name" = "Ali" ]]
```

| Feature | `[ ]` | `[[ ]]` |
|---|---|---|
| POSIX-compatible | Yes | No, Bash-specific |
| Basic string and file tests | Yes | Yes |
| Safer Bash string handling | Limited | Better |
| Pattern matching | Limited | Supported |
| Regular-expression matching | No | Supported |
| Recommended in `#!/bin/bash` scripts | Acceptable | Yes |

For Bash scripts, prefer:

```bash
[[ condition ]]
```

For portable `/bin/sh` scripts, use:

```bash
[ condition ]
```

---

## 8. String operators

| Operator | Meaning |
|---|---|
| `=` or `==` | Strings are equal |
| `!=` | Strings are different |
| `-z` | String is empty |
| `-n` | String is not empty |
| `<` | String comes before another string alphabetically |
| `>` | String comes after another string alphabetically |

### Equal strings

```bash
if [[ "$username" = "ali" ]]; then
    echo "Username matched"
fi
```

### Different strings

```bash
if [[ "$environment" != "production" ]]; then
    echo "This is not production"
fi
```

### Empty input

**script name:** `validate_name_input.sh`

```bash
read -r -p "Enter your name: " name

if [[ -z "$name" ]]; then
    echo "Error: name cannot be empty" >&2
    exit 1
else
    echo "Hello, $name"
fi
```

### Non-empty input

```bash
if [[ -n "$name" ]]; then
    echo "Name received: $name"
fi
```

### Why variables should be quoted

Recommended:

```bash
[[ "$name" = "Ali" ]]
```

Quoting is a safe habit because it keeps the expanded value together and prevents unwanted interpretation.

---

## 9. Numeric comparison operators

With `[ ]` or `[[ ]]`, use numeric operators:

| Operator | Meaning |
|---|---|
| `-eq` | Equal |
| `-ne` | Not equal |
| `-gt` | Greater than |
| `-ge` | Greater than or equal |
| `-lt` | Less than |
| `-le` | Less than or equal |

### Age example

**script name:** `age_classifier.sh`

```bash
#!/bin/bash

read -r -p "Enter your age: " age

if [[ "$age" -ge 18 ]]; then
    echo "You are an adult"
else
    echo "You are under 18"
fi
```

### Grade example

**script name:** `grade_classifier.sh`

```bash
#!/bin/bash

read -r -p "Enter your marks: " marks

if [[ "$marks" -ge 90 ]]; then
    echo "Grade A"
elif [[ "$marks" -ge 80 ]]; then
    echo "Grade B"
elif [[ "$marks" -ge 70 ]]; then
    echo "Grade C"
elif [[ "$marks" -ge 60 ]]; then
    echo "Grade D"
else
    echo "Needs improvement"
fi
```

Test the highest value first. For example, a score of `95` also satisfies `-ge 80`, but the first matching branch should be Grade A.

---

## 10. Validate numeric input

Entering text such as `abc` when a number is expected can produce errors or incorrect decisions.

**script name:** `validate_age.sh`

```bash
read -r -p "Enter your age: " age

if [[ ! "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: enter a positive whole number" >&2
    exit 1
fi

if [[ "$age" -ge 18 ]]; then
    echo "Adult"
else
    echo "Minor"
fi
```

The regular expression means:

| Part | Meaning |
|---|---|
| `^` | Start of the value |
| `[0-9]` | Any digit |
| `+` | One or more digits |
| `$` | End of the value |

Do not quote the regular expression on the right side of `=~`.

---

## 11. Arithmetic conditionals with `(( ))`

For numeric calculations, Bash provides arithmetic evaluation:

```bash
(( expression ))
```

Example:

**script name:** `arithmetic_age_check.sh`

```bash
age=20

if (( age >= 18 )); then
    echo "Adult"
else
    echo "Minor"
fi
```

Inside `(( ))`:

- Use `==`, `!=`, `>`, `>=`, `<`, and `<=`
- Variable names normally do not need `$`
- Logical `&&` and `||` are supported

**script name:** `grade_b_range_check.sh`

```bash
marks=85

if (( marks >= 80 && marks <= 89 )); then
    echo "Grade B"
fi
```

Both of these are valid:

```bash
[[ "$age" -ge 18 ]]
```

```bash
(( age >= 18 ))
```

`(( ))` is usually clearer for arithmetic.

---

## 12. File and directory tests

| Test | Meaning |
|---|---|
| `-e` | Path exists |
| `-f` | Regular file exists |
| `-d` | Directory exists |
| `-s` | File exists and is not empty |
| `-r` | Path is readable |
| `-w` | Path is writable |
| `-x` | Path is executable |
| `-L` | Path is a symbolic link |

### Regular-file check

**script name:** `regular_file_checker.sh`

```bash
file="/etc/passwd"

if [[ -f "$file" ]]; then
    echo "Regular file found: $file"
else
    echo "File not found: $file" >&2
fi
```

### Directory check

**script name:** `directory_checker.sh`

```bash
directory="/var/log"

if [[ -d "$directory" ]]; then
    echo "Directory exists: $directory"
else
    echo "Directory does not exist: $directory" >&2
fi
```

### Missing, empty, and valid file

**script name:** `file_content_checker.sh`

```bash
file="homework.txt"

if [[ ! -e "$file" ]]; then
    echo "File does not exist" >&2
elif [[ ! -s "$file" ]]; then
    echo "File exists but is empty" >&2
else
    echo "File exists and contains data"
fi
```

---

## 13. Combine conditions with `&&`

`&&` means **AND**. Both conditions must be true.

**script name:** `age_country_eligibility.sh`

```bash
age=25
country="USA"

if [[ "$age" -ge 18 && "$country" = "USA" ]]; then
    echo "Both conditions are true"
fi
```

Real file example:

**script name:** `readable_file_checker.sh`

```bash
file="application.log"

if [[ -f "$file" && -r "$file" ]]; then
    echo "The file exists and is readable"
else
    echo "The file is missing or unreadable" >&2
fi
```

---

## 14. Combine conditions with `||`

`||` means **OR**. At least one condition must be true.

**script name:** `role_access_checker.sh`

```bash
role="admin"

if [[ "$role" = "admin" || "$role" = "devops" ]]; then
    echo "Access allowed"
else
    echo "Access denied"
fi
```

---

## 15. Reverse a condition with `!`

`!` means **NOT**.

**script name:** `missing_config_checker.sh`

```bash
file="config.txt"

if [[ ! -f "$file" ]]; then
    echo "File does not exist" >&2
fi
```

This reads as:

```text
If config.txt is not a regular file
```

---

## 16. Group complex conditions

Use parentheses inside `[[ ]]` to make complex logic clear:

**script name:** `environment_role_access.sh`

```bash
if [[ "$environment" = "dev" && ( "$role" = "admin" || "$role" = "devops" ) ]]; then
    echo "Access allowed"
else
    echo "Access denied"
fi
```

Meaning:

```text
The environment must be dev
AND
The role must be admin OR devops
```

---

## 17. Use a command directly as the condition

Every Linux command returns an exit status. A command can therefore be placed directly after `if`.

**script name:** `student_search.sh`

```bash
if grep -q "Ali" students.txt; then
    echo "Ali was found"
else
    echo "Ali was not found"
fi
```

`grep -q` stays quiet and communicates the result through its exit status.

Another example:

**script name:** `prepare_reports_directory.sh`

```bash
if mkdir -p reports; then
    echo "Reports directory is ready"
else
    echo "Could not prepare reports directory" >&2
fi
```

Less clear:

```bash
mkdir -p reports

if [[ "$?" -eq 0 ]]; then
    echo "Success"
fi
```

Better:

```bash
if mkdir -p reports; then
    echo "Success"
fi
```

Testing the command directly avoids accidentally replacing `$?` with the status of another command.

---

## 18. Conditional based on script arguments

**script name:** `check-file.sh`

```bash
#!/bin/bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 FILE" >&2
    exit 1
fi

file="$1"

if [[ -f "$file" ]]; then
    echo "File found: $file"
    exit 0
else
    echo "File not found: $file" >&2
    exit 1
fi
```

Run it:

```bash
chmod u+x check-file.sh

./check-file.sh /etc/passwd
echo "$?"

./check-file.sh /missing-file
echo "$?"
```

---

## 19. Pattern matching

Inside `[[ ]]`, Bash supports wildcard patterns.

**script name:** `log_file_detector.sh`

```bash
filename="application.log"

if [[ "$filename" == *.log ]]; then
    echo "This is a log file"
fi
```

Quote the variable, but do not quote the pattern:

```bash
[[ "$filename" == *.log ]]
```

Another example:

**script name:** `production_environment_detector.sh`

```bash
environment="production-east"

if [[ "$environment" == production-* ]]; then
    echo "Production environment detected"
fi
```

---

## 20. Regular-expression matching

Bash uses `=~` for regular expressions.

**script name:** `username_validator.sh`

```bash
username="ali123"

if [[ "$username" =~ ^[a-z][a-z0-9_-]*$ ]]; then
    echo "Valid username format"
else
    echo "Invalid username format" >&2
fi
```

This rule requires the username to:

- Start with a lowercase letter
- Contain only lowercase letters, numbers, underscores, or hyphens
- Contain no spaces

Do not quote the regular expression:

```bash
[[ "$username" =~ ^[a-z][a-z0-9_-]*$ ]]
```

---

## 21. Nested conditionals

A conditional can be placed inside another conditional.

**script name:** `nested_file_checker.sh`

```bash
if [[ -f "$file" ]]; then
    if [[ -s "$file" ]]; then
        echo "File exists and contains data"
    else
        echo "File exists but is empty"
    fi
else
    echo "File does not exist"
fi
```

Nested conditions can be useful, but too many levels make scripts difficult to read. Use `elif`, combined conditions, or early `exit` statements when they make the flow clearer.

---

## 22. `case` as an alternative

When one value is compared against many fixed choices, `case` may be clearer than many `elif` blocks.

**script name:** `traffic_light_case.sh`

```bash
#!/bin/bash

read -r -p "Enter traffic-light color: " light

case "${light,,}" in
    red)
        echo "Stop"
        ;;
    yellow)
        echo "Get ready"
        ;;
    green)
        echo "Go"
        ;;
    *)
        echo "Invalid color" >&2
        exit 1
        ;;
esac

exit 0
```

Use `if/elif/else` for different or complex conditions. Use `case` when matching one value against several fixed values or patterns.

---

## 23. Real DevOps example: deployment preflight

This script validates its arguments, environment name, configuration file, file content, and read permission before approving a deployment.

**script name:** `deployment-preflight.sh`

```bash
#!/bin/bash

if [[ "$#" -ne 2 ]]; then
    echo "Usage: $0 ENVIRONMENT CONFIG_FILE" >&2
    exit 1
fi

environment="$1"
config_file="$2"

if [[ "$environment" != "dev" && "$environment" != "test" && "$environment" != "prod" ]]; then
    echo "Error: environment must be dev, test, or prod" >&2
    exit 1
fi

if [[ ! -f "$config_file" ]]; then
    echo "Error: configuration file not found: $config_file" >&2
    exit 1
fi

if [[ ! -s "$config_file" ]]; then
    echo "Error: configuration file is empty: $config_file" >&2
    exit 1
fi

if [[ ! -r "$config_file" ]]; then
    echo "Error: configuration file is not readable: $config_file" >&2
    exit 1
fi

echo "Preflight passed"
echo "Environment: $environment"
echo "Configuration: $config_file"
exit 0
```

Create practice files:

```bash
echo "PORT=8080" > application.conf
touch empty.conf
```

Test the script:

```bash
bash -n deployment-preflight.sh
chmod u+x deployment-preflight.sh

./deployment-preflight.sh dev application.conf
echo "$?"

./deployment-preflight.sh production application.conf
echo "$?"

./deployment-preflight.sh test empty.conf
echo "$?"

./deployment-preflight.sh prod missing.conf
echo "$?"
```

Expected behavior:

| Test | Expected result |
|---|---|
| `dev application.conf` | Pass |
| `production application.conf` | Fail because the accepted value is `prod` |
| `test empty.conf` | Fail because the file is empty |
| `prod missing.conf` | Fail because the file is missing |

---

## 24. Common mistakes

### Missing spaces

Incorrect:

```bash
if [["$name" = "Ali"]]; then
```

Correct:

```bash
if [[ "$name" = "Ali" ]]; then
```

### Missing `then`

Incorrect:

```bash
if [[ "$name" = "Ali" ]]
    echo "Matched"
fi
```

Correct:

```bash
if [[ "$name" = "Ali" ]]; then
    echo "Matched"
fi
```

### Missing `fi`

Every `if` structure must end with:

```bash
fi
```

### Spaces around a variable assignment

Incorrect:

```bash
name = "Ali"
```

Correct:

```bash
name="Ali"
```

### Using `$` on the left side of an assignment

Incorrect:

```bash
$name="Ali"
```

Correct:

```bash
name="Ali"
```

Use `$name` when reading the value, not when assigning it.

### Using string comparison for numbers

Not recommended:

```bash
[[ "$age" > "18" ]]
```

This compares strings alphabetically.

Use:

```bash
[[ "$age" -gt 18 ]]
```

Or:

```bash
(( age > 18 ))
```

### Testing `$?` too late

Incorrect:

```bash
mkdir reports
echo "Command completed"
echo "$?"
```

The displayed status belongs to `echo`, not `mkdir`.

Prefer:

```bash
if mkdir reports; then
    echo "Directory created"
else
    echo "Directory creation failed" >&2
fi
```

### Giving unsafe fallback instructions

Avoid:

```bash
else
    echo "Move at your own risk"
fi
```

Prefer:

```bash
else
    echo "Invalid color: enter red, yellow, or green" >&2
    exit 1
fi
```

---

## 25. Test conditionals properly

A conditional script should be tested with:

- A value that makes the `if` condition true
- A value that makes every `elif` condition true
- A value that reaches `else`
- Empty input
- Incorrect input
- Correct and incorrect argument counts
- Existing and missing files
- Non-empty and empty files
- Readable and unreadable paths when appropriate

### Check syntax

```bash
bash -n script.sh
```

No output means Bash detected no syntax error. It does not prove that the script's logic is correct.

### Add execute permission

```bash
chmod u+x script.sh
```

### Run the script

```bash
./script.sh
```

### Check the exit status immediately

```bash
echo "$?"
```

---

## 26. Quick-reference sheet

### String tests

```bash
[[ "$a" = "$b" ]]
[[ "$a" != "$b" ]]
[[ -z "$a" ]]
[[ -n "$a" ]]
```

### Numeric tests

```bash
[[ "$a" -eq "$b" ]]
[[ "$a" -ne "$b" ]]
[[ "$a" -gt "$b" ]]
[[ "$a" -ge "$b" ]]
[[ "$a" -lt "$b" ]]
[[ "$a" -le "$b" ]]
```

### File tests

```bash
[[ -e "$path" ]]
[[ -f "$file" ]]
[[ -d "$directory" ]]
[[ -s "$file" ]]
[[ -r "$file" ]]
[[ -w "$file" ]]
[[ -x "$file" ]]
[[ -L "$path" ]]
```

### Logical operators

```bash
[[ condition1 && condition2 ]]
[[ condition1 || condition2 ]]
[[ ! condition ]]
```

### Arithmetic

```bash
(( number >= 10 ))
```

### Pattern

```bash
[[ "$filename" == *.log ]]
```

### Regular expression

```bash
[[ "$username" =~ ^[a-z][a-z0-9_-]*$ ]]
```

---

## 27. Six practice tasks

### Task 1 — Weather decision

Ask whether it is raining and display the correct umbrella message.

### Task 2 — Traffic light

Accept `red`, `yellow`, or `green`. Reject empty or unknown input.

### Task 3 — Age validator

Validate that the input contains only digits, then report whether the user is an adult.

### Task 4 — File inspector

Accept one filename and report whether it is missing, empty, or contains data.

### Task 5 — Role and environment

Allow access only when:

- The environment is `dev`
- The role is `admin` or `devops`

### Task 6 — Deployment preflight

Build and test the complete deployment-preflight script from these notes.

For every task:

```bash
bash -n script.sh
chmod u+x script.sh
./script.sh
echo "$?"
```

---

## Final rule

```text
A Bash conditional does not decide whether something “looks correct.”
It checks whether a command or test returns success.

Exit status 0     = true or successful
Non-zero status  = false, failed, or another defined condition
```

Start with simple `if/else` decisions. Add validation, file tests, logical operators, patterns, and command conditions only after the basic flow is clear.
