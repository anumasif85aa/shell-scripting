# Linux Project Study Notes — Migrating Shell Scripts from Root to a Sudo User

## Project Title

**Move Shell Scripts from `/root` to a Regular User’s Home Directory**

## Project Scenario

I initially worked inside the root user’s home directory:

```text
/root
```

I created and stored my shell scripts there. Later, I learned that using the `root` account for normal daily work is not a security best practice.

I created a regular user named `khan`, granted the required sudo access, moved the scripts to the new user’s home directory, and corrected their ownership and permissions.

---

## 1. Why Is Working as Root Risky?

The `root` user has unrestricted control over the Linux system.

A command run as `root` can:

- Delete important system files.
- Change critical configurations.
- Modify every user’s data.
- Install or remove system software.
- Make the system unbootable.
- Bypass ordinary file permissions.

Best practice:

```text
Use a regular user for daily work.
Use sudo only when administrative access is required.
```

---

## 2. Important Linux Directories

| Path | Purpose |
|---|---|
| `/root` | Home directory of the `root` user |
| `/home/khan` | Home directory of the regular user `khan` |
| `/tmp` | Temporary shared storage, usually cleared periodically |
| `/etc/sudoers.d` | Directory containing additional sudo rules |

> The correct temporary directory is `/tmp`, not `/temp`.

---

## 3. Create the Regular User

If the user does not already exist:

```bash
sudo useradd -m -s /bin/bash khan
sudo passwd khan
```

> [📘 Detailed command explanation](command-explanations/01-create-user-and-password.md)

Explanation:

| Part | Meaning |
|---|---|
| `useradd` | Create a user account |
| `-m` | Create the user’s home directory |
| `-s /bin/bash` | Set Bash as the login shell |
| `passwd khan` | Set the user’s password |

Verify the account:

```bash
id khan
getent passwd khan
ls -ld /home/khan
```

> [📘 Detailed command explanation](command-explanations/02-verify-user-account.md)

---

## 4. Grant Sudo Access: Password Required or Passwordless

There are two different approaches:

| Method | Rule tag | Password requested? | Recommendation |
|---|---|---|---|
| Password-required sudo | `PASSWD:` | Yes | Safer default |
| Passwordless sudo | `NOPASSWD:` | No | Controlled labs or specific automation only |

Choose one method according to the requirement. Do not add both rules for the same user and commands without understanding sudoers rule precedence.

### Method 1: Password-Required Sudo Access

First make sure that the user has a password:

```bash
sudo passwd khan
```

> [📘 Detailed command explanation](command-explanations/01-create-user-and-password.md)

Create an explicit password-required sudo rule:

```bash
echo "khan ALL=(ALL) PASSWD:ALL" | sudo tee /etc/sudoers.d/khan
```

> [📘 Detailed command explanation](command-explanations/03-password-required-sudo-rule.md)

The `PASSWD:` tag is the normal secure choice. The shorter rule below also requires a password by default:

```text
khan ALL=(ALL) ALL
```

Set the required owner and permissions:

```bash
sudo chown root:root /etc/sudoers.d/khan
sudo chmod 440 /etc/sudoers.d/khan
```

> [📘 Detailed command explanation](command-explanations/04-secure-and-validate-sudoers-file.md)

Validate the syntax:

```bash
sudo visudo -cf /etc/sudoers.d/khan
```

> [📘 Detailed command explanation](command-explanations/04-secure-and-validate-sudoers-file.md)

Expected result:

```text
/etc/sudoers.d/khan: parsed OK
```

Test the rule as `khan`:

```bash
sudo -iu khan
sudo -k
sudo whoami
```

> [📘 Detailed command explanation](command-explanations/05-test-password-required-sudo.md)

Explanation:

- `sudo -iu khan` opens the target user’s login environment.
- `sudo -k` clears the cached sudo authentication.
- `sudo whoami` should request `khan`’s password.
- After successful authentication, the expected output is `root`.

#### Meaning of the Password-Required Rule

```text
khan ALL=(ALL) PASSWD:ALL
```

| Part | Meaning |
|---|---|
| `khan` | User receiving sudo permission |
| First `ALL` | Rule applies on all hosts |
| `(ALL)` | Commands may run as any user |
| `PASSWD:` | Sudo requires authentication |
| Final `ALL` | Every command is permitted |

### Group-Based Password-Required Sudo

Linux distributions normally provide an administrative group whose members can use sudo with their own passwords.

On Ubuntu or Debian:

```bash
sudo usermod -aG sudo khan
```

> [📘 Detailed command explanation](command-explanations/06-group-based-sudo-access.md)

On RHEL, AlmaLinux, Rocky Linux, or CentOS:

```bash
sudo usermod -aG wheel khan
```

> [📘 Detailed command explanation](command-explanations/06-group-based-sudo-access.md)

The user should log out and log back in so the new group membership is applied.

Verify membership:

```bash
id khan
```

> [📘 Detailed command explanation](command-explanations/02-verify-user-account.md)

Verify effective sudo permissions:

```bash
sudo -l -U khan
```

> [📘 Detailed command explanation](command-explanations/07-inspect-effective-sudo-access.md)

> Group-based sudo is usually preferable to creating a broad individual `ALL` rule when the distribution’s standard administrative group already meets the requirement.

### Method 2: Passwordless Sudo Access

The original project used:

```bash
echo "khan ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/khan
```

> [📘 Detailed command explanation](command-explanations/03-password-required-sudo-rule.md)

Set the required owner and permissions:

```bash
sudo chown root:root /etc/sudoers.d/khan
sudo chmod 440 /etc/sudoers.d/khan
```

> [📘 Detailed command explanation](command-explanations/04-secure-and-validate-sudoers-file.md)

Validate the syntax safely:

```bash
sudo visudo -cf /etc/sudoers.d/khan
```

> [📘 Detailed command explanation](command-explanations/04-secure-and-validate-sudoers-file.md)

Expected result:

```text
/etc/sudoers.d/khan: parsed OK
```

Test without allowing a password prompt:

```bash
sudo -iu khan
sudo -k
sudo -n whoami
```

> [📘 Detailed command explanation](command-explanations/09-test-passwordless-sudo.md)

Expected output:

```text
root
```

The `-n` option makes `sudo` fail instead of asking for a password. Successful output confirms that the command is permitted without authentication.

#### Meaning of the Passwordless Rule

```text
khan ALL=(ALL) NOPASSWD:ALL
```

| Part | Meaning |
|---|---|
| `khan` | User receiving sudo permission |
| First `ALL` | Rule applies on all hosts |
| `(ALL)` | Commands may run as any user |
| `NOPASSWD:` | Sudo does not request a password |
| Final `ALL` | Every command is permitted |

### Replace One Method with the Other

Because both examples use the same file, running either `tee` command replaces its previous contents.

Change passwordless sudo to password-required sudo:

```bash
echo "khan ALL=(ALL) PASSWD:ALL" | sudo tee /etc/sudoers.d/khan
sudo chmod 440 /etc/sudoers.d/khan
sudo visudo -cf /etc/sudoers.d/khan
```

> [📘 Detailed command explanation](command-explanations/03-password-required-sudo-rule.md)

Check the final rule:

```bash
sudo cat /etc/sudoers.d/khan
sudo -l -U khan
```

> [📘 Detailed command explanation](command-explanations/07-inspect-effective-sudo-access.md)

### Security Warning

`NOPASSWD:ALL` gives extremely powerful passwordless administrative access.

It may be acceptable in a controlled learning lab, but production systems should follow the principle of least privilege and allow only the specific commands required. Password-required sudo is generally safer than unrestricted passwordless sudo.

---

## 5. Original Migration Approach

The original learning workflow was:

```text
Find scripts in /root
        ↓
Create one scripts directory
        ↓
Move all *.sh files into it
        ↓
Move the directory to /tmp
        ↓
Move it to /home/khan
        ↓
Change ownership and permissions
        ↓
Verify access as khan
```

This works as a staged migration, but `/tmp` is not required when the source and destination are on the same system.

---

## 6. Preview the Files Before Moving Them

Always inspect the files before changing anything:

```bash
sudo find /root -maxdepth 1 -type f -name '*.sh' -print
```

> [📘 Detailed command explanation](command-explanations/10-preview-and-count-root-scripts.md)

This is a **dry run** because it displays the matching scripts without moving them.

Count the scripts:

```bash
sudo find /root -maxdepth 1 -type f -name '*.sh' | wc -l
```

> [📘 Detailed command explanation](command-explanations/10-preview-and-count-root-scripts.md)

> When a regular user runs `sudo mv /root/*.sh ...`, the shell may try to expand `*.sh` before `sudo` runs. Because the regular user normally cannot read `/root`, the glob may fail. Using `sudo find` avoids this problem.

---

## 7. Staged Method Using `/tmp`

### Step 1: Create a Directory in `/root`

```bash
sudo mkdir -p /root/shell-scripts
```

> [📘 Detailed command explanation](command-explanations/11-create-and-fill-staging-directory.md)

### Step 2: Move the Scripts into It

```bash
sudo find /root -maxdepth 1 -type f -name '*.sh' \
    -exec mv -t /root/shell-scripts -- {} +
```

> [📘 Detailed command explanation](command-explanations/11-create-and-fill-staging-directory.md)

### Step 3: Verify the Directory

```bash
sudo find /root/shell-scripts -maxdepth 1 -type f -name '*.sh' -print
```

> [📘 Detailed command explanation](command-explanations/11-create-and-fill-staging-directory.md)

### Step 4: Move the Directory to `/tmp`

```bash
sudo mv -- /root/shell-scripts /tmp/
```

> [📘 Detailed command explanation](command-explanations/12-stage-and-move-through-tmp.md)

### Step 5: Move It to the User’s Home Directory

First confirm that the final destination does not already exist:

```bash
sudo test ! -e /home/khan/shell-scripts
```

> [📘 Detailed command explanation](command-explanations/12-stage-and-move-through-tmp.md)

Then move it:

```bash
sudo mv -- /tmp/shell-scripts /home/khan/
```

> [📘 Detailed command explanation](command-explanations/12-stage-and-move-through-tmp.md)

---

## 8. Better Direct Method

The `/tmp` staging step is unnecessary for a normal migration on the same system.

### Step 1: Create the Destination

```bash
sudo install -d -o khan -g khan -m 750 /home/khan/shell-scripts
```

> [📘 Detailed command explanation](command-explanations/13-create-owned-destination.md)

### Step 2: Preview the Source Files

```bash
sudo find /root -maxdepth 1 -type f -name '*.sh' -print
```

> [📘 Detailed command explanation](command-explanations/10-preview-and-count-root-scripts.md)

### Step 3: Move the Scripts Directly

```bash
sudo find /root -maxdepth 1 -type f -name '*.sh' \
    -exec mv -t /home/khan/shell-scripts -- {} +
```

> [📘 Detailed command explanation](command-explanations/14-move-scripts-directly.md)

### Step 4: Set the Correct Ownership

```bash
sudo chown -R khan:khan /home/khan/shell-scripts
```

> [📘 Detailed command explanation](command-explanations/15-set-and-check-ownership.md)

This method is shorter and avoids placing project files in a shared temporary directory.

---

## 9. Understanding Ownership

Check ownership:

```bash
ls -ld /home/khan/shell-scripts
ls -l /home/khan/shell-scripts
```

> [📘 Detailed command explanation](command-explanations/15-set-and-check-ownership.md)

Change ownership recursively:

```bash
sudo chown -R khan:khan /home/khan/shell-scripts
```

> [📘 Detailed command explanation](command-explanations/15-set-and-check-ownership.md)

Explanation:

| Part | Meaning |
|---|---|
| `chown` | Change ownership |
| `-R` | Apply recursively to directory contents |
| `khan:khan` | Set owner and group to `khan` |

Without `chown`, files moved from `/root` may still belong to `root`.

---

## 10. Setting Safe Permissions

Set directory permissions:

```bash
sudo find /home/khan/shell-scripts -type d -exec chmod 750 {} +
```

> [📘 Detailed command explanation](command-explanations/16-set-directory-and-file-permissions.md)

Set executable script permissions:

```bash
sudo find /home/khan/shell-scripts -type f -name '*.sh' -exec chmod 750 {} +
```

> [📘 Detailed command explanation](command-explanations/16-set-directory-and-file-permissions.md)

Set non-script files to read/write for the owner and read-only for the group:

```bash
sudo find /home/khan/shell-scripts -type f ! -name '*.sh' -exec chmod 640 {} +
```

> [📘 Detailed command explanation](command-explanations/16-set-directory-and-file-permissions.md)

### Meaning of `750`

| User class | Permission | Meaning |
|---|---:|---|
| Owner | `7` | Read, write, and execute |
| Group | `5` | Read and execute |
| Others | `0` | No access |

For a private project, `700` may also be appropriate.

---

## 11. Verify the Migration

### Check the Directory

```bash
ls -ld /home/khan/shell-scripts
```

> [📘 Detailed command explanation](command-explanations/15-set-and-check-ownership.md)

### Check the Files

```bash
find /home/khan/shell-scripts -maxdepth 1 -type f -ls
```

> [📘 Detailed command explanation](command-explanations/17-verify-files-and-user-access.md)

### Check Access as `khan`

```bash
sudo -iu khan
cd ~/shell-scripts
pwd
ls -la
```

> [📘 Detailed command explanation](command-explanations/17-verify-files-and-user-access.md)

### Check Script Syntax

```bash
for script in ./*.sh
do
    bash -n "$script" || exit 1
done

echo "All scripts passed syntax checking."
```

> [📘 Detailed command explanation](command-explanations/18-check-and-run-bash-scripts.md)

### Test One Script

```bash
bash ./script-name.sh
echo $?
```

> [📘 Detailed command explanation](command-explanations/18-check-and-run-bash-scripts.md)

An exit status of `0` normally indicates success.

---

## 12. Useful Verification Commands

| Command | Purpose |
|---|---|
| `id khan` | Verify the user and groups |
| `sudo -l -U khan` | Display the user’s sudo permissions |
| `ls -ld PATH` | Check directory ownership and permissions |
| `ls -l PATH` | Check file ownership and permissions |
| `namei -l PATH` | Inspect permissions for every path component |
| `find PATH -type f -ls` | Display detailed file information |
| `bash -n script.sh` | Check Bash syntax without execution |

Example:

```bash
namei -l /home/khan/shell-scripts
```

> [📘 Detailed command explanation](command-explanations/19-inspect-path-permissions-with-namei.md)

---

## 13. Common Mistakes

### Mistake 1: Continuing Daily Work as Root

Use the regular user and run only necessary administrative commands with `sudo`.

### Mistake 2: Using `/temp`

The standard Linux temporary directory is:

```text
/tmp
```

### Mistake 3: Forgetting Ownership

Moved files may still belong to `root`. Correct them with:

```bash
sudo chown -R khan:khan /home/khan/shell-scripts
```

> [📘 Detailed command explanation](command-explanations/15-set-and-check-ownership.md)

### Mistake 4: Using `chmod 777`

`777` gives every user permission to modify the files. Use the minimum permissions required.

### Mistake 5: Editing `/etc/sudoers` Without Validation

Use a file inside `/etc/sudoers.d` and validate it with:

```bash
sudo visudo -cf /etc/sudoers.d/khan
```

> [📘 Detailed command explanation](command-explanations/04-secure-and-validate-sudoers-file.md)

### Mistake 6: Using `/tmp` as Permanent Storage

Files in `/tmp` may be deleted automatically and the directory is shared by multiple users.

### Mistake 7: Moving Files Without a Preview

Always run a `find ... -print` dry run before running the move command.

---

## 14. Key Linux Concepts Used

- Root and regular users
- Home directories
- Sudo and sudoers rules
- Least privilege
- File globbing
- `find` and `mv`
- Temporary directories
- File ownership
- File and directory permissions
- Recursive operations
- Bash syntax checking
- Exit statuses
- Verification and troubleshooting

---

## 15. Project Summary

```text
Problem:
Shell scripts were stored under /root.

Decision:
Use a regular account for daily work.

Action:
Create or verify user khan.
Configure the required sudo access.
Preview and move the scripts.
Correct ownership and permissions.
Test access and script syntax.

Result:
The scripts are now managed safely from /home/khan/shell-scripts.
```

---

## 16. Interview Explanation

> I initially created my Bash scripts in the root user’s home directory. After recognizing the security risk of using root for daily work, I migrated the scripts to a regular sudo-enabled account. I previewed the source files, moved them to the new user’s home directory, corrected ownership and permissions, validated the sudoers configuration, and tested access and Bash syntax as the target user. This project strengthened my understanding of least privilege, Linux ownership, permissions, sudo configuration, and safe file migration.

---

## 17. Reusable Automation for Any User and File Type

The manual commands in this guide are valuable for learning. For repeated work, the package also includes a reusable migration tool:

- [Open the Automation Guide](automation/README.md)
- [Open the Reusable Migration Script](automation/migrate-user-files.sh)

It is not restricted to the user `khan` or files ending in `.sh`. You supply:

- The existing target user
- The source directory
- A destination relative to the user's home
- One or more patterns such as `*.sh`, `*.py`, `*.conf`, `*.md`, or `*`
- Copy or move behavior
- Optional recursive searching

Preview a migration for several file types:

```bash
sudo ./automation/migrate-user-files.sh \
    --source /root \
    --user khan \
    --destination migrated-project \
    --pattern '*.sh' \
    --pattern '*.py' \
    --pattern '*.md' \
    --recursive
```

No changes occur because `--apply` is absent. After reviewing the complete plan, repeat the command with:

```bash
--apply
```

Copy is the default. Moving source files requires the explicit combination `--move --apply`.

User creation and sudo configuration remain separate because they are security-sensitive administrative tasks. This keeps the migration tool focused, reusable, and easier to test.

---

## 18. Practice Questions

1. Why should daily work not be performed as `root`?
2. What is the difference between `/root` and `/home/khan`?
3. What is the difference between `PASSWD:ALL` and `NOPASSWD:ALL`?
4. How can you add `khan` to the standard sudo group on Ubuntu?
5. How can you add `khan` to the standard administrative group on RHEL?
6. Why must a sudoers file normally have permission `440`?
7. What does `visudo -cf` check?
8. Why can `sudo mv /root/*.sh ...` fail for a regular user?
9. Why is `find` useful for this migration?
10. What does `chown -R khan:khan` do?
11. What does permission `750` mean?
12. Why is moving through `/tmp` usually unnecessary?
13. How can you test password-required sudo as `khan`?
14. How can you test passwordless sudo without allowing a prompt?
15. How does `bash -n` help after migration?
16. Why does the automation script use a dry run by default?
17. How can multiple `--pattern` options migrate more than one file type?
18. Why are user creation and sudo configuration separate from file migration?

---

## Final Lesson

```text
Work as a regular user.
Use sudo only when required.
Preview before moving files.
Apply correct ownership and minimum permissions.
Verify every administrative change.
```
