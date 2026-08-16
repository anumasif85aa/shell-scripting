# 17. Verify Files and Access as the Target User

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Commands

```bash
find /home/khan/shell-scripts -maxdepth 1 -type f -ls
```

```bash
sudo -iu khan
```

```bash
cd ~/shell-scripts
```

```bash
pwd
```

```bash
ls -la
```

## Purpose

Inspect migrated files and confirm that khan can enter and read the project directory.

## Command Breakdown

| Part | Explanation |
|---|---|
| `find ... -ls` | Show detailed metadata for matching files. |
| `sudo -iu khan` | Open khan's login environment. |
| `cd ~/shell-scripts` | Enter the project using khan's home expansion. |
| `pwd` | Confirm the current directory. |
| `ls -la` | Display all files and their metadata. |

## Expected Result

The shell should be in /home/khan/shell-scripts and the files should be visible without permission errors.

## Verification

- `pwd`
- `ls -la`

## Safety Note

> Successful listing does not prove every script behaves correctly; syntax-check and test them next.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
