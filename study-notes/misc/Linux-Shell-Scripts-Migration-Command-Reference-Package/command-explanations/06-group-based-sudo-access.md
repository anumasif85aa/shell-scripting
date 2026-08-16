# 06. Grant Sudo Through an Administrative Group

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Commands

```bash
sudo usermod -aG sudo khan
```

```bash
sudo usermod -aG wheel khan
```

## Purpose

Add khan to the distribution's standard administrative group.

## Command Breakdown

| Part | Explanation |
|---|---|
| `usermod` | Modify an existing user account. |
| `-a` | Append the new group without removing existing supplementary groups. |
| `-G` | Specify supplementary groups. |
| `sudo` | Common administrative group on Ubuntu and Debian. |
| `wheel` | Common administrative group on RHEL-family systems. |

## Expected Result

After a new login session, khan receives the sudo permissions assigned to the selected group.

## Verification

- `id khan`
- `sudo -l -U khan`

## Safety Note

> Never use -G without -a when you intend to preserve the user's existing supplementary groups.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
