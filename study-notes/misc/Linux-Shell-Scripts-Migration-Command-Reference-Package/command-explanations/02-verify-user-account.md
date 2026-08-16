# 02. Verify the User Account

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Commands

```bash
id khan
```

```bash
getent passwd khan
```

```bash
ls -ld /home/khan
```

## Purpose

Confirm the user's identity, account record, groups, login shell, home-directory path, ownership, and permissions.

## Command Breakdown

| Part | Explanation |
|---|---|
| `id khan` | Display khan's UID, primary GID, and supplementary groups. |
| `getent passwd khan` | Read the user record through the system's configured identity sources. |
| `ls -ld` | Display information about the directory itself instead of listing its contents. |

## Expected Result

The output should identify khan and show /home/khan as an accessible home directory.

## Verification

- `getent passwd khan`
- `namei -l /home/khan`

## Safety Note

> An existing account record does not by itself prove that login and sudo access work; test those separately.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
