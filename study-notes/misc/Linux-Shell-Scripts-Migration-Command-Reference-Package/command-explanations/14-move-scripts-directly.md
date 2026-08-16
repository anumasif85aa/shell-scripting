# 14. Move Scripts Directly to the User's Home

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Command

```bash
sudo find /root -maxdepth 1 -type f -name '*.sh' -exec mv -t /home/khan/shell-scripts -- {} +
```

## Purpose

Move the selected scripts directly to the prepared destination without using /tmp.

## Command Breakdown

| Part | Explanation |
|---|---|
| `find criteria` | Select only top-level regular .sh files. |
| `-exec mv` | Run mv on the selected paths. |
| `-t /home/khan/shell-scripts` | Set the destination directory. |
| `{} +` | Append many matched files efficiently. |

## Expected Result

The selected scripts move into /home/khan/shell-scripts.

## Verification

- `find /home/khan/shell-scripts -maxdepth 1 -type f -name '*.sh' -print`

## Safety Note

> Moving changes the source location. Take a backup or use cp first when recovery requirements demand it.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
