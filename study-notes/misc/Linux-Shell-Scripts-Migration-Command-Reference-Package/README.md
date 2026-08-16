# Linux Shell Scripts Migration — Command Reference Package

A complete learning package for migrating Bash scripts from `/root` to a regular sudo-enabled user's home directory. Every Bash command in the main guide has a direct link to a separate explanation file.

## Start Here

1. [Main Migration Study Guide](Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)
2. [Command Explanation Index](COMMAND-INDEX.md)
3. [Reusable Automation Guide](automation/README.md)
4. [Reusable Migration Script](automation/migrate-user-files.sh)

## Package Contents

```text
Linux-Shell-Scripts-Migration-Command-Reference-Package/
├── README.md
├── COMMAND-INDEX.md
├── Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md
├── automation/
│   ├── README.md
│   └── migrate-user-files.sh
└── command-explanations/
    ├── 01-create-user-and-password.md
    ├── ...
    └── 19-inspect-path-permissions-with-namei.md
```

## Topics Covered

- Creating and verifying a regular Linux user
- Password-required and passwordless sudo
- Ubuntu `sudo` and RHEL `wheel` groups
- Sudoers ownership, permissions, and validation
- Previewing migration targets with `find`
- Staged and direct file-migration methods
- Ownership and permission correction
- Target-user access verification
- Bash syntax checks and exit statuses
- Path-permission troubleshooting with `namei`
- Reusable migration for any existing Linux user
- Multiple file patterns such as `*.sh`, `*.py`, `*.conf`, and `*.md`
- Safe dry runs, copy or move actions, recursion, and collision protection

## Learning Design

Each command explanation includes:

- Exact command syntax
- Purpose
- Command breakdown
- Expected result
- Verification commands
- Safety note
- Key lesson

## Recommended Workflow

Read the main guide from top to bottom. Whenever a command appears, select the detailed explanation link directly underneath it. Return to the main guide after completing that command's verification step.

For repeated migrations, read the automation guide and run the reusable script without `--apply` first. Review the plan, matches, destination, and collisions before applying any change.

## Safety

Use a controlled lab. Preview file targets before moving them, validate sudoers files with `visudo`, avoid unrestricted `NOPASSWD:ALL` in production, and verify ownership and permissions after every migration.

## Author

Created for Linux and Bash scripting practice by **Muhammad Khalid Khan**.
