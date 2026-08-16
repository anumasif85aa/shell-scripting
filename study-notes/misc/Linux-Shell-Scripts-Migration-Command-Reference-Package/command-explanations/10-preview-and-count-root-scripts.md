# 10. Preview and Count Shell Scripts in /root

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Commands

```bash
sudo find /root -maxdepth 1 -type f -name '*.sh' -print
```

```bash
sudo find /root -maxdepth 1 -type f -name '*.sh' | wc -l
```

## Purpose

Identify the exact migration targets and count them before moving anything.

## Command Breakdown

| Part | Explanation |
|---|---|
| `find /root` | Search from the root user's home directory. |
| `-maxdepth 1` | Do not descend into subdirectories. |
| `-type f` | Match regular files only. |
| `-name '*.sh'` | Match names ending in .sh; quotes prevent early shell expansion. |
| `wc -l` | Count the matching output lines. |

## Expected Result

The first command lists each target; the second prints the number of targets.

## Verification

- `sudo find /root -maxdepth 1 -type f -name '*.sh' -print`

## Safety Note

> This is the required dry run. Confirm the list before executing a move.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
