# Modular Linux User Management — Roman Urdu Script Explanations

Yeh package modular Linux user-management project ki har script ko Roman Urdu mein alag samjhata hai.

## Study Order

| Order | File | Aap Kya Seekhen Gay |
|---:|---|---|
| 1 | [Package Overview](00-Package-Overview-and-Execution-Flow-Roman-Urdu.md) | Charon scripts ka connection, arguments aur exit statuses. |
| 2 | [Main Controller](01-Main-Controller-Script-Explanation-Roman-Urdu.md) | Array, script path, child-script calls aur workflow control. |
| 3 | [Create Users](02-Create-Users-Script-Explanation-Roman-Urdu.md) | Username validation, `id` aur `useradd`. |
| 4 | [Assign Passwords](03-Assign-Passwords-Script-Explanation-Roman-Urdu.md) | Confirmation, `case` aur secure `passwd` command. |
| 5 | [Grant Privileges](04-Grant-Admin-Privileges-Script-Explanation-Roman-Urdu.md) | `sudo`/`wheel` group, membership check aur `usermod -aG`. |

## Original Scripts

```text
00-manage_users.sh
01-create_users.sh
02-assign_passwords.sh
03-grant_admin_privileges.sh
```

Controlled Linux lab mein complete workflow is tarah run karein:

```bash
sudo bash 00-manage_users.sh
```

## Security Reminder

- Password script ke andar save nahin hota; `passwd` usay securely leta hai.
- Admin privileges optional hain aur sirf confirmation ke baad di jati hain.
- Package `NOPASSWD:ALL` sudo rule create nahin karta.
- Pehle disposable VM ya controlled lab mein test karein.

