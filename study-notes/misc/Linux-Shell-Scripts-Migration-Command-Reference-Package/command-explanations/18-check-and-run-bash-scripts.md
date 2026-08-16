# 18. Check Syntax, Run Scripts, and Read Exit Status

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Commands

```bash
for script in ./*.sh; do bash -n "$script" || exit 1; done
```

```bash
bash ./script-name.sh
```

```bash
echo $?
```

## Purpose

Validate every script's Bash syntax, run a chosen script, and inspect its result status.

## Command Breakdown

| Part | Explanation |
|---|---|
| `for script in ./*.sh` | Iterate through shell scripts in the current directory. |
| `bash -n` | Parse syntax without executing commands. |
| `|| exit 1` | Stop at the first syntax failure. |
| `bash ./script-name.sh` | Execute the selected script with Bash. |
| `echo $?` | Display the most recent command's exit status. |

## Expected Result

No output from bash -n normally means valid syntax; status 0 normally means successful execution.

## Verification

- `bash -n ./script-name.sh`
- `bash ./script-name.sh`
- `echo $?`

## Safety Note

> Syntax validation does not prove correct behavior. Test valid, invalid, and failure paths safely.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
