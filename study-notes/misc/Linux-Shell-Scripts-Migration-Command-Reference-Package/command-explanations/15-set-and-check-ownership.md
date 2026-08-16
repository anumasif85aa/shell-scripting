# 15. Set and Check Project Ownership

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Commands

```bash
sudo chown -R khan:khan /home/khan/shell-scripts
```

```bash
ls -ld /home/khan/shell-scripts
```

```bash
ls -l /home/khan/shell-scripts
```

## Purpose

Transfer ownership from root to khan and confirm directory and file metadata.

## Command Breakdown

| Part | Explanation |
|---|---|
| `chown` | Change owner and group. |
| `-R` | Apply recursively to all descendants. |
| `khan:khan` | Use khan as both owner and group. |
| `ls -ld` | Inspect the directory itself. |
| `ls -l` | Inspect its contents. |

## Expected Result

The project directory and its files belong to khan:khan.

## Verification

- `find /home/khan/shell-scripts -maxdepth 1 -ls`

## Safety Note

> Confirm the path before using recursive chown; a wrong target can change ownership across unrelated files.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
