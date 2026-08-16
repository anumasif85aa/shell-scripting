# Modular Linux User Management — Script Explanations

This package explains each script from the modular Linux user-management project in a separate Markdown file.

## Study Order

| Order | Explanation | What You Will Learn |
|---:|---|---|
| 1 | [Package Overview](00-Package-Overview-and-Execution-Flow.md) | How the four scripts communicate and pass statuses. |
| 2 | [Main Controller](01-Main-Controller-Script-Explanation.md) | Arrays, script paths, child-script calls, and workflow control. |
| 3 | [Create Users](02-Create-Users-Script-Explanation.md) | Argument validation, username regex, `id`, and `useradd`. |
| 4 | [Assign Passwords](03-Assign-Passwords-Script-Explanation.md) | Interactive confirmation, `case`, and secure `passwd` use. |
| 5 | [Grant Privileges](04-Grant-Admin-Privileges-Script-Explanation.md) | `sudo`/`wheel` detection, group checks, and `usermod -aG`. |

## Original Package

The explanations refer to these scripts:

```text
00-manage_users.sh
01-create_users.sh
02-assign_passwords.sh
03-grant_admin_privileges.sh
```

Run the workflow only on a controlled Linux system that you administer:

```bash
sudo bash 00-manage_users.sh
```

## Security Reminder

- Passwords are entered securely through `passwd`; they are not stored in the scripts.
- Administrative privileges are optional and granted through `sudo` or `wheel` group membership.
- The scripts do not create `NOPASSWD:ALL` rules.
- Test user-management automation in a disposable virtual machine or lab first.

