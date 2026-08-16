# 07. Inspect Effective Sudo Access

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Commands

```bash
sudo -l -U khan
```

```bash
sudo cat /etc/sudoers.d/khan
```

## Purpose

Compare the configured rule with the effective permissions sudo calculates for khan.

## Command Breakdown

| Part | Explanation |
|---|---|
| `sudo -l` | List allowed and forbidden sudo commands. |
| `-U khan` | Evaluate permissions for khan. |
| `sudo cat` | Read the protected drop-in file. |

## Expected Result

The rule text and sudo's effective permission listing can be reviewed together.

## Verification

- `sudo visudo -cf /etc/sudoers.d/khan`
- `sudo -l -U khan`

## Safety Note

> A valid file can still grant broader access than intended. Review effective permissions, not syntax alone.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
