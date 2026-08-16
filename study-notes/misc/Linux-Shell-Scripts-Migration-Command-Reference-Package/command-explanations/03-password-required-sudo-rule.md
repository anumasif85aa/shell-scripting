# 03. Create a Password-Required Sudo Rule

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Command

```bash
echo "khan ALL=(ALL) PASSWD:ALL" | sudo tee /etc/sudoers.d/khan
```

## Purpose

Allow khan to run sudo commands while requiring authentication.

## Command Breakdown

| Part | Explanation |
|---|---|
| `echo` | Produce the sudoers rule as standard output. |
| `|` | Send the rule to tee through a pipeline. |
| `sudo tee` | Write the protected file with root privileges. |
| `PASSWD:` | Require sudo authentication for matching commands. |
| `ALL` | Permit every command; broad access that should be restricted when possible. |

## Expected Result

The sudoers drop-in file contains a password-required rule for khan.

## Verification

- `sudo cat /etc/sudoers.d/khan`
- `sudo visudo -cf /etc/sudoers.d/khan`
- `sudo -l -U khan`

## Safety Note

> tee replaces the file unless -a is used. Validate the rule before depending on it.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
