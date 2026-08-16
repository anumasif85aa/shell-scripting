# Linux Bash Alias — Complete Study Notes

## Topic

Alias in Linux / Bash

---

## 1. What is Alias?

An **alias** is a shortcut name for a command in Linux or Bash.

Simple definition:

```text
Alias = a shortcut name for a command
```

An alias is especially useful for a long or frequently used command.

Example:

```bash
alias ll='ls -la'
```

Now instead of typing:

```bash
ls -la
```

You can simply type:

```bash
ll
```

Bash will run:

```bash
ls -la
```

---

## 2. Why Do We Need Alias?

We use aliases to make command-line work easier and faster.

Aliases help us:

- Save time
- Avoid typing long commands again and again
- Reduce typing mistakes
- Make daily Linux work easier
- Create shortcuts for frequently used commands
- Improve productivity in terminal

Example:

```bash
alias c='clear'
```

Now instead of typing:

```bash
clear
```

You can type:

```bash
c
```

---

## 3. Basic Alias Syntax

The basic syntax is:

```bash
alias shortcut='actual command'
```

Example:

```bash
alias ll='ls -la'
```

Meaning:

```text
ll is the shortcut
ls -la is the actual command
```

Important rules:

- No spaces around `=`
- Put the command inside quotes
- Use a meaningful shortcut name

Correct:

```bash
alias ll='ls -la'
```

Wrong:

```bash
alias ll = 'ls -la'
```

---

## 4. Temporary Alias

A temporary alias works only in the current terminal session.

Example:

```bash
alias ll='ls -la'
alias gs='git status'
alias c='clear'
```

Now you can run:

```bash
ll
gs
c
```

But after closing the terminal, these aliases will be removed.

### Why?

Because temporary aliases are stored only in the current shell memory.

---

## 5. Permanent Alias

A permanent alias stays available even after closing and reopening the terminal.

To make an alias permanent, add it to the `~/.bashrc` file.

### Step 1: Open `.bashrc`

```bash
vim ~/.bashrc
```

### Step 2: Add aliases at the end

```bash
alias ll='ls -la'
alias gs='git status'
alias c='clear'
alias update='sudo apt update'
```

### Step 3: Save the file

In Vim, press `Esc`, type `:wq`, and press `Enter`:

```text
Esc
:wq
Enter
```

> `Ctrl + O`, `Enter`, and `Ctrl + X` are Nano commands, not Vim commands.

### Step 4: Reload `.bashrc`

```bash
source ~/.bashrc
```

The aliases will now be loaded in the current shell and in future interactive Bash sessions.

---

## 6. How to Check Aliases

To see all aliases:

```bash
alias
```

To check a specific alias:

```bash
alias ll
```

Example output:

```bash
alias ll='ls -la'
```

---

## 7. How to Remove Alias

To remove one alias temporarily:

```bash
unalias ll
```

To remove all aliases temporarily:

```bash
unalias -a
```

Important:

If the alias is saved inside `~/.bashrc`, it will come back when you open a new terminal.

To remove it permanently:

1. Open `.bashrc`

```bash
vim ~/.bashrc
```

2. Delete the alias line

```bash
alias ll='ls -la'
```

3. Reload `.bashrc`

```bash
source ~/.bashrc
```

### Why can a deleted alias remain active?

Deleting an alias line from `~/.bashrc` does not automatically remove the alias already stored in the current shell's memory. Running `source ~/.bashrc` reads the remaining lines, but it does not remove definitions that are no longer present.

Remove the active alias explicitly:

```bash
unalias ll
```

Then reload the file if necessary:

```bash
source ~/.bashrc
```

Opening a new terminal also starts a fresh shell that will no longer load the deleted alias.

---

## 8. Common Alias Examples

| Alias | Actual Command | Purpose |
|---|---|---|
| `ll` | `ls -la` | Detailed file list |
| `la` | `ls -A` | Show hidden files except `.` and `..` |
| `c` | `clear` | Clear terminal |
| `gs` | `git status` | Git status shortcut |
| `ga` | `git add .` | Add all changes in Git |
| `gc` | `git commit` | Git commit shortcut |
| `gp` | `git pull` | Git pull shortcut |
| `update` | `sudo apt update` | Update package list |
| `ports` | `ss -tulnp` | Show listening ports |
| `myip` | `hostname -I` | Show system IP address |

---

## 9. Alias Examples for Linux Practice

### Example 1: Date Alias

```bash
alias today='date'
```

Run:

```bash
today
```

This runs:

```bash
date
```

---

### Example 2: Clear Screen Alias

```bash
alias c='clear'
```

Run:

```bash
c
```

This clears the terminal screen.

---

### Example 3: Long Listing Alias

```bash
alias ll='ls -la'
```

Run:

```bash
ll
```

This shows detailed files, including hidden files.

---

### Example 4: Git Status Alias

```bash
alias gs='git status'
```

Run:

```bash
gs
```

This runs:

```bash
git status
```

---

### Example 5: Update Alias

```bash
alias update='sudo apt update'
```

Run:

```bash
update
```

This runs:

```bash
sudo apt update
```

---

## 10. Alias in Simple Words

An alias is a short name or nickname for a command.

If a command is long or used repeatedly, we can create a convenient shortcut for it.

Example:

```bash
alias ll='ls -la'
```

When we enter:

```bash
ll
```

Bash runs the original command:

```bash
ls -la
```

In simple words:

```text
An alias is a command's nickname.
We assign a short name to a longer command.
Bash then expands that short name and runs the corresponding command.
```

---

## 11. Temporary vs Permanent Alias

| Type | Where It Works | Removed When? |
|---|---|---|
| Temporary alias | Current terminal only | When terminal closes |
| Permanent alias | Every new terminal | Until removed from `.bashrc` |

---

## 12. Important Notes

### Alias does not change the original command

Example:

```bash
alias ll='ls -la'
```

This does not delete or change the `ls` command.

It only creates a shortcut.

---

### Alias works in the current shell

If you create an alias in one terminal, it may not appear in another terminal unless it is saved in `.bashrc`.

---

### Alias is best for simple shortcuts

For complex tasks, use Bash functions or scripts instead of aliases.

Good alias:

```bash
alias ll='ls -la'
```

Better as a function or script:

```bash
backup_project() {
    tar -czf backup.tar.gz project/
}
```

### Aliases normally expand in interactive shells

Aliases are mainly intended for interactive terminal use. Bash does not expand aliases in a non-interactive script by default. Use a function or script when automation must work reliably.

### Use `type` to inspect a command name

The `type` command shows whether a name is an alias, function, builtin, or external command:

```bash
type ll
type cd
type ls
```

Example:

```text
ll is aliased to `ls -la'
```

### Bypass an alias temporarily

If `ls` has been aliased but you want to run the original command for one invocation, use either form:

```bash
command ls
\ls
```

### Use a function when arguments need flexible placement

Aliases perform text substitution and cannot reliably place arguments in the middle of a command. Use a function instead:

```bash
mkcd() {
    mkdir -p -- "$1" && cd -- "$1"
}
```

---

## 13. Common Mistakes

### Mistake 1: Spaces around `=`

Wrong:

```bash
alias ll = 'ls -la'
```

Correct:

```bash
alias ll='ls -la'
```

---

### Mistake 2: Forgetting quotes

Better:

```bash
alias ll='ls -la'
```

Avoid:

```bash
alias ll=ls -la
```

---

### Mistake 3: Forgetting to source `.bashrc`

After adding alias to `.bashrc`, run:

```bash
source ~/.bashrc
```

Otherwise, the alias may not work in the current terminal.

---

### Mistake 4: Saving a dangerous alias

Avoid dangerous aliases like:

```bash
alias delete='rm -rf /'
```

Always be careful with aliases that delete files.

### Mistake 5: Expecting aliases to work in scripts

Do not depend on an interactive alias inside a Bash script. Put the complete command in the script, or use a function.

### Mistake 6: Reusing an important command name carelessly

An alias can replace how a familiar command behaves in your interactive shell. Check it first:

```bash
type rm
alias rm
```

---

## 14. Safe Alias Examples

Some people create safer aliases:

```bash
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
```

Meaning:

| Alias | Meaning |
|---|---|
| `rm -i` | Ask before deleting |
| `cp -i` | Ask before overwriting while copying |
| `mv -i` | Ask before overwriting while moving |

These can help beginners avoid mistakes.

> Interactive safety aliases are helpful, but scripts should use explicit options and proper error handling instead of depending on a user's aliases.

---

## 15. Teaching Flow

When teaching alias, explain in this order:

```text
1. What is alias?
2. Why do we need alias?
3. Basic syntax
4. Temporary alias
5. Permanent alias
6. Check alias
7. Remove alias
8. Common examples
9. Practice task
```

---

## 16. Class Demo

### Step 1: Create temporary alias

```bash
alias today='date'
```

### Step 2: Run alias

```bash
today
```

### Step 3: Check alias

```bash
alias today
```

### Step 4: Remove alias

```bash
unalias today
```

### Step 5: Test again

```bash
today
```

Expected result:

```text
Command not found
```

---

## 17. Lab Task

Create these temporary aliases:

```bash
alias ll='ls -la'
alias c='clear'
alias h='history'
alias d='date'
alias p='pwd'
```

Then run:

```bash
ll
c
h
d
p
```

After that, check all aliases:

```bash
alias
```

Remove one alias:

```bash
unalias d
```

Check again:

```bash
alias d
```

---

## 18. Homework

Add these aliases permanently in `~/.bashrc`:

```bash
alias ll='ls -la'
alias gs='git status'
alias c='clear'
alias today='date'
alias ports='ss -tulnp'
```

Then reload `.bashrc`:

```bash
source ~/.bashrc
```

Test all aliases.

---

## 19. Practice Questions

1. What is an alias?
2. Why do we use aliases?
3. What is the syntax of alias?
4. What is the difference between temporary and permanent alias?
5. Which file is used to save permanent aliases?
6. How do you check all aliases?
7. How do you check one specific alias?
8. How do you remove an alias?
9. What does `source ~/.bashrc` do?
10. Why should we avoid dangerous aliases?
11. Why might an alias remain active after deleting it from `.bashrc`?
12. What does the `type` command show?
13. How can you bypass an alias for one command?
14. Why is a function better when arguments require flexible placement?
15. Why should scripts not depend on interactive aliases?

---

## Final Summary

Alias is a shortcut name for a command.

It helps us run long or frequently used commands quickly.

Example:

```bash
alias ll='ls -la'
```

Now:

```bash
ll
```

runs:

```bash
ls -la
```

Temporary aliases work only in the current terminal session.

Permanent aliases should be saved in:

```bash
~/.bashrc
```

Then reload the file:

```bash
source ~/.bashrc
```

Best one-line definition:

```text
Alias is a shortcut name for a command in Linux/Bash.
```

Remember:

```text
Use an alias for a simple interactive shortcut.
Use a function or script for logic, arguments, validation, and automation.
```
