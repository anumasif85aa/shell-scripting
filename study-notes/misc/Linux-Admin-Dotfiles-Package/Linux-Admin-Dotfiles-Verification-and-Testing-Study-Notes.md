# Linux Admin Dotfiles – Verification and Testing Study Notes

## Objective

These notes explain how to verify that the **Linux Admin Dotfiles Package** is installed correctly and that its main features are working.

---

# 1. Check the Bash Prompt (`PS1`)

Run:

```bash
echo "$PS1"
```

## Expected Result

- A custom prompt definition should be displayed.
- Your terminal prompt should appear customized.
- The prompt may show your username, hostname, current directory, colors, or Git branch.

Example:

```text
khalid@Khalid-laptop:~/Linux-Admin-Dotfiles-Package
$
```

---

# 2. Check Aliases

List all aliases:

```bash
alias
```

Check specific aliases:

```bash
alias ll
alias la
alias gs
alias gp
alias c
```

Test the `ll` alias:

```bash
ll
```

## Expected Result

You should see output similar to:

```text
alias ll='ls -alF'
alias gs='git status'
alias gp='git push'
```

If `ll` runs successfully, the alias file is loaded.

---

# 3. Check Bash Functions

List all available Bash functions:

```bash
declare -F
```

Check the `mkcd` function:

```bash
type mkcd
```

Check the `extract` function:

```bash
type extract
```

## Test `mkcd`

```bash
mkcd test-folder
pwd
```

## Expected Result

- `mkcd is a function`
- The `test-folder` directory is created.
- You automatically enter the new directory.

Remove the test directory after leaving it:

```bash
cd ..
rmdir test-folder
```

---

# 4. Check Environment Variables

Run:

```bash
echo "EDITOR=$EDITOR"
echo "VISUAL=$VISUAL"
echo "PAGER=$PAGER"
echo "PATH=$PATH"
```

## Expected Result

Typical values may be:

```text
EDITOR=vim
VISUAL=vim
PAGER=less
```

The exact `PATH` value may differ between systems.

---

# 5. Check Vim Configuration

Confirm that `.vimrc` exists:

```bash
ls -l ~/.vimrc
```

Open Vim:

```bash
vim
```

Inside Vim, run:

```vim
:set number?
:set relativenumber?
:set autoindent?
:set smartindent?
```

## Expected Result

You may see:

```text
number
relativenumber
autoindent
smartindent
```

Exit Vim:

```vim
:q
```

---

# 6. Check the Git Branch in the Prompt

Create a temporary Git repository:

```bash
mkdir -p ~/git-prompt-test
cd ~/git-prompt-test
git init
```

## Expected Result

Your Bash prompt should display the current branch, such as:

```text
(main)
```

or:

```text
(master)
```

Clean up afterward:

```bash
cd ~
rm -rf ~/git-prompt-test
```

---

# 7. Check Bash History Settings

Run:

```bash
echo "HISTSIZE=$HISTSIZE"
echo "HISTFILESIZE=$HISTFILESIZE"
echo "HISTTIMEFORMAT=$HISTTIMEFORMAT"
```

## Expected Result

Example:

```text
HISTSIZE=10000
HISTFILESIZE=20000
```

Your actual configured values may differ.

Check whether history append mode is enabled:

```bash
shopt histappend
```

Expected:

```text
histappend on
```

---

# 8. Check Shell Options

Run:

```bash
shopt checkwinsize
shopt cdspell
shopt histappend
shopt globstar
```

## Expected Result

Example:

```text
checkwinsize on
cdspell on
histappend on
globstar on
```

Some options may be off if they were not included in your configuration.

---

# 9. Check Terminal Colors

Test colored `ls` output:

```bash
ls --color=auto
```

Test colored `grep` output:

```bash
grep --color=auto root /etc/passwd
```

Check the `GREP_COLORS` variable:

```bash
echo "$GREP_COLORS"
```

## Expected Result

- File names should appear in different colors.
- The word `root` should be highlighted.
- `GREP_COLORS` may show a color configuration value.

---

# 10. Check the Backup Directory

Run:

```bash
ls -ld ~/.dotfiles-backup-*
```

## Expected Result

Example:

```text
/home/khalid/.dotfiles-backup-20260730-171435
```

This confirms that the installer created a backup before modifying your configuration.

To see the contents of a backup directory:

```bash
ls -la ~/.dotfiles-backup-20260730-171435
```

Replace the directory name with your actual backup name.

---

# 11. Complete Dotfiles Verification Script

Instead of running every command manually, create a Bash script named:

```text
verify_dotfiles.sh
```

## Script

```bash
#!/bin/bash
#
# Script Name : verify_dotfiles.sh
# Author      : Muhammad Khalid Khan
# Purpose     : Verify Linux Admin Dotfiles installation
# Usage       : ./verify_dotfiles.sh
#

echo "========================================"
echo " Linux Admin Dotfiles Verification"
echo "========================================"

echo
echo "===== Prompt ====="
echo "$PS1"

echo
echo "===== Aliases ====="

for alias_name in ll la gs gp c; do
    if alias "$alias_name" &>/dev/null; then
        alias "$alias_name"
    else
        echo "$alias_name : Not Found"
    fi
done

echo
echo "===== Functions ====="

for func in mkcd extract; do
    if type "$func" &>/dev/null; then
        type "$func"
    else
        echo "$func : Not Found"
    fi
done

echo
echo "===== Environment Variables ====="
echo "EDITOR       = ${EDITOR:-Not Set}"
echo "VISUAL       = ${VISUAL:-Not Set}"
echo "PAGER        = ${PAGER:-Not Set}"
echo "PATH         = $PATH"

echo
echo "===== Bash History ====="
echo "HISTSIZE       = ${HISTSIZE:-Not Set}"
echo "HISTFILESIZE   = ${HISTFILESIZE:-Not Set}"
echo "HISTTIMEFORMAT = ${HISTTIMEFORMAT:-Not Set}"

echo
echo "===== Shell Options ====="

for option in checkwinsize cdspell histappend globstar; do
    shopt "$option"
done

echo
echo "===== Backup Directory ====="

if compgen -G "$HOME/.dotfiles-backup-*" > /dev/null; then
    ls -ld "$HOME"/.dotfiles-backup-*
else
    echo "No backup directory found."
fi

echo
echo "===== Vim Configuration ====="

if [[ -f "$HOME/.vimrc" ]]; then
    echo ".vimrc : Found"
else
    echo ".vimrc : Not Found"
fi

echo
echo "===== Git ====="

if git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Repository : Yes"

    branch_name=$(git branch --show-current)

    if [[ -n "$branch_name" ]]; then
        echo "Branch     : $branch_name"
    else
        echo "Branch     : No branch name found"
    fi
else
    echo "Not inside a Git repository."
fi

echo
echo "========================================"
echo " Verification Complete"
echo "========================================"
```

---

# 12. How to Create the Script

Create the file:

```bash
vim verify_dotfiles.sh
```

Press `i` to enter insert mode, paste the script, and then save it:

```vim
Esc
:wq
```

Alternatively, use Nano:

```bash
nano verify_dotfiles.sh
```

---

# 13. Make the Script Executable

```bash
chmod +x verify_dotfiles.sh
```

Check its permissions:

```bash
ls -l verify_dotfiles.sh
```

Expected:

```text
-rwxr-xr-x 1 khalid khalid ... verify_dotfiles.sh
```

The `x` permissions show that the script is executable.

---

# 14. Run the Verification Script

```bash
./verify_dotfiles.sh
```

## Important Bash Note

Aliases are normally available only in an **interactive Bash shell**. When a script runs as a separate non-interactive process, aliases from your current shell may not automatically be available.

Therefore, for the most accurate alias and function verification, run the script by sourcing it:

```bash
source ./verify_dotfiles.sh
```

or:

```bash
. ./verify_dotfiles.sh
```

Another option is:

```bash
bash -i ./verify_dotfiles.sh
```

The `-i` option starts Bash in interactive mode so that interactive shell configuration can be loaded.

---

# 15. Recommended Way to Run the Script

Use:

```bash
source ~/.bashrc
source ./verify_dotfiles.sh
```

This ensures that:

1. Your `.bashrc` is loaded.
2. Your aliases and functions are available.
3. The verification script checks the current shell environment.

---

# 16. Example Output

```text
========================================
 Linux Admin Dotfiles Verification
========================================

===== Prompt =====
<custom PS1 value>

===== Aliases =====
alias ll='ls -alF'
alias la='ls -A'
alias gs='git status'
alias gp='git push'
alias c='clear'

===== Functions =====
mkcd is a function
extract is a function

===== Environment Variables =====
EDITOR       = vim
VISUAL       = vim
PAGER        = less

===== Bash History =====
HISTSIZE       = 10000
HISTFILESIZE   = 20000

===== Shell Options =====
checkwinsize on
cdspell on
histappend on
globstar on

===== Backup Directory =====
/home/khalid/.dotfiles-backup-20260730-171435

===== Vim Configuration =====
.vimrc : Found

===== Git =====
Not inside a Git repository.

========================================
 Verification Complete
========================================
```

---

# 17. Understanding the Script

## Shebang

```bash
#!/bin/bash
```

This tells Linux to run the script using Bash.

## `${VARIABLE:-Not Set}`

Example:

```bash
${EDITOR:-Not Set}
```

Meaning:

- Display the value of `EDITOR` if it is set.
- Display `Not Set` if the variable is empty or unset.

## Redirecting Output

```bash
&>/dev/null
```

This sends both standard output and standard error to `/dev/null`.

It prevents unnecessary command output from appearing during a test.

## `compgen -G`

```bash
compgen -G "$HOME/.dotfiles-backup-*"
```

This safely checks whether any matching backup directory exists.

## Git Repository Check

```bash
git rev-parse --is-inside-work-tree
```

This checks whether the current directory is inside a Git working tree.

## Git Branch Check

```bash
git branch --show-current
```

This displays the current Git branch name.

---

# 18. Compare Installed Configuration Files

Before using `diff`, remember that the package installer may **source** custom files from `.bashrc` instead of replacing `.bashrc` completely. Therefore, different output does not always mean the installation failed.

Check whether the custom Bash configuration is referenced:

```bash
grep -n "bashrc-admin.sh" ~/.bashrc
grep -n "aliases.sh" ~/.bashrc
```

Compare Vim configuration:

```bash
diff ~/.vimrc ~/Linux-Admin-Dotfiles-Package/vim/vimrc
```

Inspect the installed Bash configuration files:

```bash
ls -l ~/.config/linux-admin-dotfiles/
```

The exact installation directory depends on how your installer was written.

---

# 19. Troubleshooting

## Alias Shows `Not Found`

Reload `.bashrc`:

```bash
source ~/.bashrc
```

Then check:

```bash
alias ll
```

## Function Shows `Not Found`

Check whether the function file is loaded:

```bash
type mkcd
```

Inspect `.bashrc` for a `source` line:

```bash
grep -n "source" ~/.bashrc
```

## Environment Variable Shows `Not Set`

Check the configuration file:

```bash
grep -n "EDITOR\|VISUAL\|PAGER" ~/.bashrc
```

Reload:

```bash
source ~/.bashrc
```

## `.vimrc` Not Found

Check:

```bash
ls -la ~ | grep vimrc
```

Re-run the installer if necessary:

```bash
cd ~/Linux-Admin-Dotfiles-Package
./install.sh
```

## No Backup Directory Found

Check all hidden files and directories:

```bash
ls -ld ~/.dotfiles-backup-*
```

If no directory appears, inspect the installer:

```bash
grep -n "backup" ~/Linux-Admin-Dotfiles-Package/install.sh
```

---

# 20. Quick Verification Checklist

- [ ] Custom Bash prompt appears.
- [ ] `ll` alias works.
- [ ] `gs` alias works.
- [ ] `mkcd` function works.
- [ ] `EDITOR` is configured.
- [ ] `VISUAL` is configured.
- [ ] `PAGER` is configured.
- [ ] Bash history values are set.
- [ ] Required shell options are enabled.
- [ ] Terminal colors are working.
- [ ] `.vimrc` exists.
- [ ] Vim options are active.
- [ ] Git branch appears in a Git repository.
- [ ] Backup directory exists.
- [ ] Verification script completes without unexpected errors.

---

# One-Line Summary

The `verify_dotfiles.sh` script checks your prompt, aliases, functions, environment variables, Bash history, shell options, backup directory, Vim configuration, and Git status to confirm that your Linux Admin Dotfiles Package is working correctly.
