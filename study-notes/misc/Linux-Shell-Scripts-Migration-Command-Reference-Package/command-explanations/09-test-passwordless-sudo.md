# 09. Test Passwordless Sudo

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Commands

```bash
sudo -iu khan
```

```bash
sudo -k
```

```bash
sudo -n whoami
```

## Purpose

Verify that khan can elevate without using cached credentials or receiving a password prompt.

## Command Breakdown

| Part | Explanation |
|---|---|
| `sudo -k` | Clear cached authentication. |
| `sudo -n` | Use non-interactive mode; fail instead of prompting. |
| `whoami` | Display the effective user after elevation. |

## Expected Result

A working passwordless rule prints root. A password-required rule causes sudo -n to fail.

## Verification

- `sudo -n whoami`
- `echo $?`

## Safety Note

> A successful result confirms passwordless elevation, which is also a reminder of the rule's security impact.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
