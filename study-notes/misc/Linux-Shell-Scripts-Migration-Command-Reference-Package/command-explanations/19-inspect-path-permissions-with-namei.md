# 19. Inspect Every Path Component with namei

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Command

```bash
namei -l /home/khan/shell-scripts
```

## Purpose

Display ownership and permissions for each directory component in the path.

## Command Breakdown

| Part | Explanation |
|---|---|
| `namei` | Follow a pathname component by component. |
| `-l` | Use a long listing with modes, owners, and groups. |
| `/home/khan/shell-scripts` | The path being diagnosed. |

## Expected Result

The output shows /, /home, /home/khan, and the project directory separately.

## Verification

- `namei -l /home/khan/shell-scripts`
- `ls -ld /home /home/khan /home/khan/shell-scripts`

## Safety Note

> A user needs execute permission on every parent directory to traverse the complete path.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
