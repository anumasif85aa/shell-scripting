# 01. Create a Regular User and Set a Password

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Commands

```bash
sudo useradd -m -s /bin/bash khan
```

```bash
sudo passwd khan
```

## Purpose

Create the regular user khan, create the home directory, select Bash as the login shell, and assign an account password.

## Command Breakdown

| Part | Explanation |
|---|---|
| `sudo` | Run the administrative command with elevated privileges. |
| `useradd` | Create a local user account. |
| `-m` | Create /home/khan if it does not exist. |
| `-s /bin/bash` | Set Bash as the login shell. |
| `passwd khan` | Set or replace khan's password securely. |

## Expected Result

The account exists with a home directory and can authenticate with the password entered interactively.

## Verification

- `id khan`
- `getent passwd khan`
- `ls -ld /home/khan`

## Safety Note

> Do not place a plaintext password inside a command or script. The passwd command prompts securely.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
