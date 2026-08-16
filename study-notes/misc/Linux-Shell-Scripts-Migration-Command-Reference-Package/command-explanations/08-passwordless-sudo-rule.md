# 08. Create a Passwordless Sudo Rule

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Command

```bash
echo "khan ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/khan
```

## Purpose

Allow khan to execute all sudo commands without entering a password.

## Command Breakdown

| Part | Explanation |
|---|---|
| `NOPASSWD:` | Disable the password prompt for matching commands. |
| `Final ALL` | Permit every command. |
| `sudo tee` | Write the protected sudoers drop-in file. |

## Expected Result

The previous contents of /etc/sudoers.d/khan are replaced with the passwordless rule.

## Verification

- `sudo visudo -cf /etc/sudoers.d/khan`
- `sudo -l -U khan`
- `sudo -iu khan`

## Safety Note

> NOPASSWD:ALL is equivalent to very powerful passwordless root access. Restrict commands in production.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
