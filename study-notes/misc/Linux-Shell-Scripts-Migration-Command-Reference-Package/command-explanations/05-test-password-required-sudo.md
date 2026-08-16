# 05. Test Password-Required Sudo

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Commands

```bash
sudo -iu khan
```

```bash
sudo -k
```

```bash
sudo whoami
```

## Purpose

Open khan's login environment, clear cached sudo authentication, and verify that sudo requests khan's password.

## Command Breakdown

| Part | Explanation |
|---|---|
| `sudo -iu khan` | Start a login-style interactive shell as khan. |
| `sudo -k` | Invalidate cached sudo credentials. |
| `sudo whoami` | Request elevation and display the effective user. |

## Expected Result

sudo should request khan's password and then print root after successful authentication.

## Verification

- `sudo -k`
- `sudo whoami`
- `sudo -l`

## Safety Note

> Enter the khan account password, not the root password, unless the system is configured differently.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
