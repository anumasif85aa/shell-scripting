# Study Notes: The `set -e` Option in Shell Scripting

## Overview
In Bash and Shell scripting, **`set -e`** (also known as `errexit`) is an option that instructs the script to **exit immediately if any command exits with a non-zero status (fails)**.

By default, Bash continues executing subsequent commands even if a previous command returns an error. `set -e` changes this behavior to enforce strict execution.

---

## 1. Default Behavior (Without `set -e`)

Without `set -e`, Bash ignores command failures and continues executing line by line.

```bash
#!/bin/bash

cd /folder_that_does_not_exist  # Error: Directory not found!
rm -rf *                        # DANGEROUS: Deletes files in the current directory!
echo "Task completed"
```
> **Risk:** Since `cd` fails, the script stays in the working directory and proceeds to execute `rm -rf *`, causing unintended file deletion.

---

## 2. Behavior With `set -e`

When `set -e` is placed at the top of the script, execution stops immediately upon the first failure.

```bash
#!/bin/bash
set -e

cd /folder_that_does_not_exist  # Error! Script terminates here instantly.
rm -rf *                        # This line NEVER runs.
echo "Task completed"
```
> **Outcome:** The failed `cd` command triggers an immediate exit, preventing any destructive commands from executing.

---

## 3. Exceptions (When `set -e` Does NOT Trigger an Exit)

`set -e` will **not** terminate the script under the following conditions:

### 1. Commands inside `if` or `while` statements
```bash
if grep "pattern" file.txt; then
    echo "Pattern found"
fi
# If grep fails (no match), the script continues because it is part of a conditional check.
```

### 2. Commands joined with `||` (OR operator)
```bash
command_that_might_fail || echo "Failed, but script continues running"
```

### 3. Commands negated with `!` (NOT operator)
```bash
! false # Script continues execution
```

### 4. Pipelines (`|`)
By default, `set -e` only checks the exit status of the **last command** in a pipeline.
```bash
first_failing_command | second_successful_command
# Script will NOT exit because second_successful_command succeeded.
```

---

## 4. Best Practice: Bash Strict Mode

In production scripts, `set -e` is often combined with other flags to form **Bash Strict Mode**:

```bash
set -euo pipefail
```

### Breakdown of Flags:
* **`-e` (`errexit`):** Exit immediately if a command fails.
* **`-u` (`nounset`):** Treat unset/undefined variables as an error and exit immediately.
* **`-o pipefail`:** Forces a pipeline to return a failure status if **any** command in the pipeline fails (not just the last one).
