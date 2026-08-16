# Command Explanation Index

Use this index to open a detailed explanation for every command used in the migration project.

[← Package README](README.md) · [Open Main Study Guide](Linux-Shell-Scripts-Root-to-Sudo-User-Migration-Study-Notes.md)

## Reusable Automation

- [Open the Automation Guide](automation/README.md)
- [Open the Reusable Migration Script](automation/migrate-user-files.sh)

The automation is not hard-coded to `khan`, `/root`, or `*.sh`. It accepts the user, source, destination, and one or more filename patterns as command-line options. It performs a dry run unless `--apply` is supplied.

## Individual Command Explanations

| No. | Explanation | Main Command(s) |
|---:|---|---|
| 01 | [Create a Regular User and Set a Password](command-explanations/01-create-user-and-password.md) | `sudo useradd -m -s /bin/bash khan`<br>`sudo passwd khan` |
| 02 | [Verify the User Account](command-explanations/02-verify-user-account.md) | `id khan`<br>`getent passwd khan`<br>`ls -ld /home/khan` |
| 03 | [Create a Password-Required Sudo Rule](command-explanations/03-password-required-sudo-rule.md) | `echo "khan ALL=(ALL) PASSWD:ALL" | sudo tee /etc/sudoers.d/khan` |
| 04 | [Secure and Validate a Sudoers File](command-explanations/04-secure-and-validate-sudoers-file.md) | `sudo chown root:root /etc/sudoers.d/khan`<br>`sudo chmod 440 /etc/sudoers.d/khan`<br>`sudo visudo -cf /etc/sudoers.d/khan` |
| 05 | [Test Password-Required Sudo](command-explanations/05-test-password-required-sudo.md) | `sudo -iu khan`<br>`sudo -k`<br>`sudo whoami` |
| 06 | [Grant Sudo Through an Administrative Group](command-explanations/06-group-based-sudo-access.md) | `sudo usermod -aG sudo khan`<br>`sudo usermod -aG wheel khan` |
| 07 | [Inspect Effective Sudo Access](command-explanations/07-inspect-effective-sudo-access.md) | `sudo -l -U khan`<br>`sudo cat /etc/sudoers.d/khan` |
| 08 | [Create a Passwordless Sudo Rule](command-explanations/08-passwordless-sudo-rule.md) | `echo "khan ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/khan` |
| 09 | [Test Passwordless Sudo](command-explanations/09-test-passwordless-sudo.md) | `sudo -iu khan`<br>`sudo -k`<br>`sudo -n whoami` |
| 10 | [Preview and Count Shell Scripts in /root](command-explanations/10-preview-and-count-root-scripts.md) | `sudo find /root -maxdepth 1 -type f -name '*.sh' -print`<br>`sudo find /root -maxdepth 1 -type f -name '*.sh' | wc -l` |
| 11 | [Create and Fill the Staging Directory](command-explanations/11-create-and-fill-staging-directory.md) | `sudo mkdir -p /root/shell-scripts`<br>`sudo find /root -maxdepth 1 -type f -name '*.sh' -exec mv -t /root/shell-scripts -- {} +` |
| 12 | [Stage and Move the Directory Through /tmp](command-explanations/12-stage-and-move-through-tmp.md) | `sudo mv -- /root/shell-scripts /tmp/`<br>`sudo test ! -e /home/khan/shell-scripts`<br>`sudo mv -- /tmp/shell-scripts /home/khan/` |
| 13 | [Create the Owned Destination Directory](command-explanations/13-create-owned-destination.md) | `sudo install -d -o khan -g khan -m 750 /home/khan/shell-scripts` |
| 14 | [Move Scripts Directly to the User's Home](command-explanations/14-move-scripts-directly.md) | `sudo find /root -maxdepth 1 -type f -name '*.sh' -exec mv -t /home/khan/shell-scripts -- {} +` |
| 15 | [Set and Check Project Ownership](command-explanations/15-set-and-check-ownership.md) | `sudo chown -R khan:khan /home/khan/shell-scripts`<br>`ls -ld /home/khan/shell-scripts`<br>`ls -l /home/khan/shell-scripts` |
| 16 | [Set Directory and File Permissions](command-explanations/16-set-directory-and-file-permissions.md) | `sudo find /home/khan/shell-scripts -type d -exec chmod 750 {} +`<br>`sudo find /home/khan/shell-scripts -type f -name '*.sh' -exec chmod 750 {} +`<br>`sudo find /home/khan/shell-scripts -type f ! -name '*.sh' -exec chmod 640 {} +` |
| 17 | [Verify Files and Access as the Target User](command-explanations/17-verify-files-and-user-access.md) | `find /home/khan/shell-scripts -maxdepth 1 -type f -ls`<br>`sudo -iu khan`<br>`cd ~/shell-scripts`<br>`pwd`<br>`ls -la` |
| 18 | [Check Syntax, Run Scripts, and Read Exit Status](command-explanations/18-check-and-run-bash-scripts.md) | `for script in ./*.sh; do bash -n "$script" || exit 1; done`<br>`bash ./script-name.sh`<br>`echo $?` |
| 19 | [Inspect Every Path Component with namei](command-explanations/19-inspect-path-permissions-with-namei.md) | `namei -l /home/khan/shell-scripts` |

## Study Method

1. Read the command in the main project guide.
2. Open the detailed explanation immediately below it.
3. Study the command breakdown and safety note.
4. Run the verification command.
5. Return to the main workflow.
