# 04. Secure and Validate a Sudoers File

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Commands

```bash
sudo chown root:root /etc/sudoers.d/khan
```

```bash
sudo chmod 440 /etc/sudoers.d/khan
```

```bash
sudo visudo -cf /etc/sudoers.d/khan
```

## Purpose

Set the correct owner and mode, then check sudoers syntax safely.

## Command Breakdown

| Part | Explanation |
|---|---|
| `chown root:root` | Set both owner and group to root. |
| `chmod 440` | Allow read access for owner and group, with no access for others. |
| `visudo` | Use the sudo-aware validation utility. |
| `-c` | Check syntax without editing. |
| `-f` | Validate the named file. |

## Expected Result

Successful validation prints /etc/sudoers.d/khan: parsed OK and returns status 0.

## Verification

- `sudo ls -l /etc/sudoers.d/khan`
- `sudo visudo -cf /etc/sudoers.d/khan`
- `echo $?`

## Safety Note

> Do not ignore a validation error. Correct the file before starting another administrative session.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
