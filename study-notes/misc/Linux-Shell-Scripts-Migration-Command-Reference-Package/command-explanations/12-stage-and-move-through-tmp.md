# 12. Stage and Move the Directory Through /tmp

[← Back to Command Index](../COMMAND-INDEX.md) · [← Main Study Guide](../Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Commands

```bash
sudo mv -- /root/shell-scripts /tmp/
```

```bash
sudo test ! -e /home/khan/shell-scripts
```

```bash
sudo mv -- /tmp/shell-scripts /home/khan/
```

## Purpose

Demonstrate a staged move while checking that the final target does not already exist.

## Command Breakdown

| Part | Explanation |
|---|---|
| `mv --` | Move the named directory and end option parsing. |
| `test ! -e PATH` | Succeed only when the destination path does not exist. |
| `/tmp` | Shared temporary storage; not intended for permanent project files. |

## Expected Result

The directory moves from /root to /tmp and then to /home/khan.

## Verification

- `sudo test -d /home/khan/shell-scripts`
- `sudo test ! -e /tmp/shell-scripts`

## Safety Note

> The test command and move must be joined carefully in automation to avoid a race. A direct move is normally simpler.

## Key Lesson

Understand the command, preview its targets where possible, run it with the minimum required privilege, and verify the result.
