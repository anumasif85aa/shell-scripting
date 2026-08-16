# Level 02 Lab: Practical Conditionals

## Objective

Combine validation, numeric ranges, patterns, file tests, command results, and logical operators in practical scripts.

Continue using simple scripts without functions, loops, arrays, `case`, `sudo`, or remote systems.

## Task 1: Grade classifier

Create `01_grade.sh`.

1. Receive a score from `$1`.
2. Reject missing or non-numeric input.
3. Reject scores below `0` or above `100`.
4. Classify:
   - 90–100: `A`
   - 80–89: `B`
   - 70–79: `C`
   - 60–69: `D`
   - Below 60: `F`

## Task 2: Username validator

Create `02_username_validator.sh`.

A valid practice username:

- Starts with a lowercase letter.
- Then contains lowercase letters, digits, `_`, or `-`.
- Contains at least three characters.

Use a regular expression with `=~`.

Test:

```bash
bash 02_username_validator.sh ali
bash 02_username_validator.sh user_01
bash 02_username_validator.sh 2ali
```

## Task 3: Path inspector

Create `03_path_inspector.sh`.

Receive a path as `$1` and report:

- Missing path
- Directory
- Empty regular file
- Non-empty regular file
- Readable or not readable

Use `-e`, `-d`, `-f`, `-s`, and `-r`.

## Task 4: Log filename validator

Create `04_log_filename.sh`.

1. Receive a filename as `$1`.
2. Accept names ending in `.log`.
3. Reject all other names.
4. Use Bash pattern matching:

```bash
[[ "$filename" == *.log ]]
```

## Task 5: Search command decision

Create `05_error_search.sh`.

1. Receive a log file path as `$1`.
2. Validate that it is a readable, non-empty regular file.
3. Run `grep -q "ERROR" "$log_file"` directly as an `if` condition.
4. Print whether errors were found.
5. Use the supplied `sample-app.log`.

## Task 6: Access evaluator

Create `06_access_check.sh`.

Receive:

```text
$1 = role
$2 = active status
$3 = maintenance status
```

Allow access only when:

- Role is `admin` or `operator`.
- Active status is `yes`.
- Maintenance status is not `yes`.

Use `&&`, `||`, and `!`.

## Deliverables

- Six scripts
- Tests for boundary scores
- Tests for valid and invalid usernames
- Tests for file, directory, empty file, and missing path
- Tests for allowed and denied access
