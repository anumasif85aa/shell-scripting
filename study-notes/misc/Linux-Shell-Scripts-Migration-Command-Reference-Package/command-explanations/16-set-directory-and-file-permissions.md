# 16. Set Directory and File Permissions

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Commands

```bash
sudo find /home/khan/shell-scripts -type d -exec chmod 750 {} +
```

```bash
sudo find /home/khan/shell-scripts -type f -name '*.sh' -exec chmod 750 {} +
```

```bash
sudo find /home/khan/shell-scripts -type f ! -name '*.sh' -exec chmod 640 {} +
```

## Purpose

Apply different permissions to directories, executable scripts, and non-script files.

## Command Breakdown

| Part | Explanation |
|---|---|
| `-type d` | Select directories. |
| `chmod 750` | Owner rwx, group r-x, others none. |
| `-type f -name '*.sh'` | Select shell-script files. |
| `! -name '*.sh'` | Select files that are not shell scripts. |
| `chmod 640` | Owner read/write, group read, others none. |

## Expected Result

Directories are traversable, scripts are executable, and ordinary data files are not executable.

## Verification

- `find /home/khan/shell-scripts -printf '%M %u:%g %p
'`

## Safety Note

> Do not use chmod 777 as a shortcut. Apply the minimum permissions required.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
