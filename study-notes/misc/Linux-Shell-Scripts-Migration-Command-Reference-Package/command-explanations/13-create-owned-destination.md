# 13. Create the Owned Destination Directory

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Command

```bash
sudo install -d -o khan -g khan -m 750 /home/khan/shell-scripts
```

## Purpose

Create the destination with the intended owner, group, and permissions in one operation.

## Command Breakdown

| Part | Explanation |
|---|---|
| `install -d` | Create a directory instead of copying a file. |
| `-o khan` | Set the owner to khan. |
| `-g khan` | Set the group to khan. |
| `-m 750` | Set owner rwx, group r-x, and no access for others. |

## Expected Result

/home/khan/shell-scripts exists with khan:khan ownership and mode 750.

## Verification

- `ls -ld /home/khan/shell-scripts`

## Safety Note

> Confirm that group khan exists; many distributions create a same-name primary group automatically.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
