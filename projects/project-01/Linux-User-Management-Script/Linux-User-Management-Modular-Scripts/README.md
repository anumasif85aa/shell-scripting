# Modular Linux User Management Scripts

This beginner-friendly package separates Linux user management into three focused tasks and calls them from one main script.

## Files

| File | Purpose |
|---|---|
| `00-manage_users.sh` | Defines the usernames and calls the other scripts in order. |
| `01-create_users.sh` | Creates users with Bash shells and home directories. |
| `02-assign_passwords.sh` | Asks whether to set or reset each user's password. |
| `03-grant_admin_privileges.sh` | Asks whether to add each user to `sudo` or `wheel`. |

## Learning Flow

```text
Main controller
      |
      +--> Create accounts
      |
      +--> Set passwords interactively
      |
      +--> Ask about administrative privileges
```

## Usernames

Edit this array in `00-manage_users.sh`:

```bash
usernames=("apple" "banana" "mango" "orange" "red_cherry")
```

Use valid Linux usernames. The creation script accepts lowercase letters, digits, underscores, and hyphens, and requires the first character to be a lowercase letter or underscore.

## Run the Complete Workflow

Make the scripts executable:

```bash
chmod +x ./*.sh
```

Run the main script:

```bash
sudo ./00-manage_users.sh
```

You may also use:

```bash
sudo bash 00-manage_users.sh
```

## Run One Task Separately

Create users:

```bash
sudo bash 01-create_users.sh ali sara
```

Assign passwords:

```bash
sudo bash 02-assign_passwords.sh ali sara
```

Ask about administrative privileges:

```bash
sudo bash 03-grant_admin_privileges.sh ali sara
```

## Password Security

The package uses:

```bash
passwd "$username"
```

`passwd` securely prompts for the password without storing plaintext passwords inside the scripts or exposing them in command history.

The password script asks before setting or resetting each password. Answer `y` to continue or press Enter to skip.

## Administrative Privileges

The privilege script detects:

- `sudo` on Ubuntu and Debian-family systems.
- `wheel` on RHEL, AlmaLinux, Rocky Linux, and similar systems.

It uses:

```bash
usermod -aG "$admin_group" "$username"
```

This grants normal group-based administrative access. It does **not** create a `NOPASSWD:ALL` sudoers rule.

After being added to an administrative group, the user should sign out and sign in again.

## Security Notes

- Run these scripts only in a controlled learning lab or on a system you administer.
- Review the username list before execution.
- Grant administrative privileges only when they are genuinely required.
- Do not store plaintext passwords in scripts.
- Do not use fruit names as production usernames; use meaningful account names that follow your organization's policy.
- Test in a disposable virtual machine or cloud lab before using the scripts on an important system.

## Verify the Results

Check a user:

```bash
id apple
```

Check the account entry:

```bash
getent passwd apple
```

Check the home directory:

```bash
ls -ld /home/apple
```

Check administrative group membership:

```bash
id -nG apple
```

## Important Behavior

- Existing users are skipped during account creation.
- Password assignment is optional for every user.
- Administrative access is optional for every user.
- A failure in a critical operation stops the workflow with status `1`.
- The scripts do not delete users or overwrite sudoers files.

