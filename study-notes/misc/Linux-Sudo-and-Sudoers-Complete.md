# Linux Sudo & Sudoers – Complete Study Notes

## Contents
- What is sudo?
- What is a sudoer?
- Ubuntu vs RHEL
- 9 Methods to Grant sudo Access
- Best Practices
- Interview Questions
- Roman Urdu Summary

## What is sudo?
`sudo` (SuperUser DO) allows an authorized user to run commands with elevated privileges.

## What is a sudoer?
A sudoer is a user who has permission to execute commands using `sudo`.

## Ubuntu vs RHEL

| Distribution | Admin Group |
|---|---|
| Ubuntu/Debian | sudo |
| RHEL/Rocky/AlmaLinux/CentOS | wheel |

## Method 1 - Ubuntu
```bash
sudo usermod -aG sudo khalid
```

## Method 2 - RHEL
```bash
sudo usermod -aG wheel khalid
```

## Method 3 - /etc/sudoers.d (Recommended)
Password required:
```text
khalid ALL=(ALL) ALL
```

Passwordless:
```text
khalid ALL=(ALL) NOPASSWD:ALL
```

Create:
```bash
echo "khalid ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/khalid
```

## Method 4 - Edit sudoers
```bash
sudo visudo
```

## Method 5 - Group Rule
```text
%admins ALL=(ALL) ALL
```

## Method 6 - Specific Commands
```text
khalid ALL=(ALL) /usr/bin/systemctl
```

## Method 7 - Passwordless sudo
```text
khalid ALL=(ALL) NOPASSWD:ALL
```

## Method 8 - Password Required
```text
khalid ALL=(ALL) ALL
```

## Method 9 - Run as Another User
```text
khalid ALL=(apache) ALL
```

```bash
sudo -u apache whoami
```

## Verify Configuration
```bash
sudo visudo -c
sudo whoami
```

Expected output:
```text
root
```

## Best Practices
- Use `visudo` to edit sudo rules.
- Prefer `/etc/sudoers.d/` for custom entries.
- Grant the minimum permissions required.
- Verify with `visudo -c`.

## Interview Questions
1. What is sudo?
2. What is a sudoer?
3. What is the wheel group?
4. Why use `visudo`?
5. What is `NOPASSWD`?
6. Why use `/etc/sudoers.d/`?
7. How do you verify sudo syntax?
8. How do you grant one specific command?

## Roman Urdu Summary
- Ubuntu mein `sudo` group use hota hai.
- RHEL family mein `wheel` group use hota hai.
- `visudo` se sudoers safely edit hoti hai.
- `/etc/sudoers.d/` custom rules ke liye best hai.
- `NOPASSWD:ALL` password ke baghair sudo ki ijazat deta hai.

## One-Line Summary
Use `visudo` and `/etc/sudoers.d/` to safely manage sudo permissions.
