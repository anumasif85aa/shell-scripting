# 11. Create and Fill the Staging Directory

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Commands

```bash
sudo mkdir -p /root/shell-scripts
```

```bash
sudo find /root -maxdepth 1 -type f -name '*.sh' -exec mv -t /root/shell-scripts -- {} +
```

## Purpose

Create one directory and move the selected top-level scripts into it.

## Command Breakdown

| Part | Explanation |
|---|---|
| `mkdir -p` | Create the directory and do not fail if it already exists. |
| `-exec ... {} +` | Pass matched files to mv in efficient batches. |
| `mv -t DEST` | Declare the target directory before the source paths. |
| `--` | End option processing so filenames beginning with - are handled safely. |

## Expected Result

The matching /root/*.sh files are moved into /root/shell-scripts.

## Verification

- `sudo find /root/shell-scripts -maxdepth 1 -type f -name '*.sh' -print`

## Safety Note

> Run the preview command first and confirm that the destination does not contain conflicting filenames.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
