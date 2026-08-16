# Reusable File Migration Automation

## Script

```text
migrate-user-files.sh
```

This script automates the migration of selected files from one directory into an existing Linux user’s home directory.

It is not limited to:

- The user `khan`
- The `/root` source directory
- Shell scripts ending in `.sh`
- One file type
- One migration method

## Design Principles

The script follows these programming and administration practices:

- **Reusable:** User, source, destination, and patterns are arguments.
- **Dry-run first:** No changes occur unless `--apply` is supplied.
- **Copy by default:** The safer non-destructive action is the default.
- **Explicit move:** Source files are removed only when `--move --apply` is used.
- **Collision protection:** Existing destination files are skipped by default.
- **Multiple patterns:** Repeat `--pattern` to migrate several file types.
- **Optional recursion:** Subdirectories are searched only with `--recursive`.
- **Structure preservation:** Recursive migrations keep paths relative to the source.
- **User validation:** The target must exist in the configured identity database.
- **Permission control:** Directories, ordinary files, and executable files can use different modes.
- **Safe filenames:** Null-delimited `find` output protects spaces and special characters.
- **No `eval`:** Arguments remain data and are not reinterpreted as shell code.
- **Single responsibility:** The script migrates files; it does not create users or change sudo policy.

## Requirements

- Linux
- Bash
- Root or sudo access
- Existing target user and home directory
- GNU-compatible `find`, `sort`, `install`, `cp`, and `mv`

Make the script executable:

```bash
chmod +x automation/migrate-user-files.sh
```

Display help:

```bash
./automation/migrate-user-files.sh --help
```

## Required Options

| Option | Purpose |
|---|---|
| `--source DIR` | Directory containing the source files |
| `--user USER` | Existing target user |
| `--destination PATH` | Relative destination beneath the target home |
| `--pattern GLOB` | Filename pattern; repeat it for multiple types |

## Optional Controls

| Option | Default | Purpose |
|---|---|---|
| `--copy` | Enabled | Copy files and keep the sources |
| `--move` | Disabled | Move files and remove the sources |
| `--recursive` | Disabled | Search inside source subdirectories |
| `--overwrite` | Disabled | Replace existing target files |
| `--apply` | Disabled | Perform changes instead of a dry run |
| `--dir-mode MODE` | `750` | Permission mode for destination directories |
| `--file-mode MODE` | `640` | Mode for non-executable files |
| `--exec-mode MODE` | `750` | Mode for executable files |
| `--target-home DIR` | Account home | Override the home returned by `getent` |

## Example 1: Preview Shell Scripts for `khan`

```bash
sudo ./automation/migrate-user-files.sh \
    --source /root \
    --user khan \
    --destination shell-scripts \
    --pattern '*.sh'
```

Because `--apply` is absent, the script only displays the plan.

## Example 2: Copy Shell Scripts After Reviewing the Plan

```bash
sudo ./automation/migrate-user-files.sh \
    --source /root \
    --user khan \
    --destination shell-scripts \
    --pattern '*.sh' \
    --apply
```

Copy is the default, so the original files remain in `/root`.

## Example 3: Use Another User and Multiple File Types

```bash
sudo ./automation/migrate-user-files.sh \
    --source /opt/training-files \
    --user ali \
    --destination imported-project \
    --pattern '*.sh' \
    --pattern '*.py' \
    --pattern '*.conf'
```

Review the dry-run output, then repeat with `--apply`.

## Example 4: Recursive Copy

```bash
sudo ./automation/migrate-user-files.sh \
    --source /opt/project \
    --user ali \
    --destination project-backup \
    --pattern '*.sh' \
    --pattern '*.md' \
    --recursive \
    --apply
```

When recursion is enabled, relative subdirectory paths are preserved.

## Example 5: Move Files

First preview:

```bash
sudo ./automation/migrate-user-files.sh \
    --source /root \
    --user khan \
    --destination migrated-files \
    --pattern '*.sh' \
    --pattern '*.txt' \
    --move
```

After verifying every source and destination, apply it:

```bash
sudo ./automation/migrate-user-files.sh \
    --source /root \
    --user khan \
    --destination migrated-files \
    --pattern '*.sh' \
    --pattern '*.txt' \
    --move \
    --apply
```

> `--move --apply` removes successfully migrated files from the source. Use it only after a dry run and backup review.

## Example 6: Preserve Executable and Non-Executable Modes

```bash
sudo ./automation/migrate-user-files.sh \
    --source /srv/project \
    --user developer \
    --destination project \
    --pattern '*' \
    --recursive \
    --dir-mode 750 \
    --file-mode 640 \
    --exec-mode 750 \
    --apply
```

Files executable at the source receive `--exec-mode`. Other files receive `--file-mode`.

## What the Script Validates

Before processing files, it checks:

- The script is running as root.
- Required options are present.
- The target user exists.
- The user’s primary group exists.
- The source directory exists.
- The target home exists.
- The destination is a safe relative path.
- At least one pattern was provided.
- Permission modes contain valid octal digits.
- A recursive destination is not inside the source.
- At least one file matches.

## Collision Behavior

If a target file already exists, the default behavior is:

```text
SKIP: target already exists
```

To replace existing files deliberately:

```bash
--overwrite
```

Always preview an overwrite operation before adding `--apply`.

## Exit Statuses

| Status | Meaning |
|---:|---|
| `0` | Successful dry run or completed migration |
| `1` | Validation or command failure |
| `3` | No files matched the supplied patterns |

## Why Sudo Configuration Is Separate

Creating users, configuring sudo, and migrating files are different administrative responsibilities.

Keeping them separate makes the migration script:

- Easier to test
- Safer to reuse
- Easier to review
- Less privileged
- Less likely to make an unrelated security change

Configure and validate the target user before running the migration script.

## Recommended Workflow

```text
Verify the target user
          ↓
Run the migration dry run
          ↓
Review matches and collisions
          ↓
Confirm destination and permissions
          ↓
Run again with --apply
          ↓
Verify ownership, permissions, and content
```

## Post-Migration Verification

```bash
sudo -iu khan
cd ~/shell-scripts
pwd
find . -maxdepth 2 -ls
```

For Bash scripts:

```bash
find . -type f -name '*.sh' -print0 |
while IFS= read -r -d '' script
do
    bash -n "$script" || exit 1
done
```

## Key Lesson

> Automation should make the safe action easy, the risky action explicit, and every result verifiable.

