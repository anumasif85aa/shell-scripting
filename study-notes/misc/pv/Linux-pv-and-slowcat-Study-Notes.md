# Linux `pv` and `slowcat` — Complete Study Notes

## Table of Contents

1. [Learning Objectives](#1-learning-objectives)
2. [What Is `pv`?](#2-what-is-pv)
3. [What Is `slowcat`?](#3-what-is-slowcat)
4. [Install on RHEL-Based Systems](#4-install-on-rhel-based-systems)
5. [Install on Ubuntu or Debian](#5-install-on-ubuntu-or-debian)
6. [Create a Temporary Alias](#6-create-a-temporary-alias)
7. [Create a Global Alias](#7-create-a-global-alias)
8. [Recommended Global Executable](#8-recommended-global-executable)
9. [Test `slowcat`](#9-test-slowcat)
10. [Reproduce the Progress-Bar Example](#10-reproduce-the-progress-bar-example)
11. [Understanding the Options](#11-understanding-the-options)
12. [Alias Versus Function Versus Executable](#12-alias-versus-function-versus-executable)
13. [Useful Practical Examples](#13-useful-practical-examples)
14. [Troubleshooting](#14-troubleshooting)
15. [Remove the Global Configuration](#15-remove-the-global-configuration)
16. [Quick Reference](#16-quick-reference)
17. [Final Summary](#17-final-summary)

---

## 1. Learning Objectives

After completing these notes, you should be able to:

- Explain what `pv` does in a Linux pipeline.
- Install `pv` and an English word list on different Linux distributions.
- Create a temporary `slowcat` alias.
- Create a system-wide alias for multiple users.
- Understand the limitations of Bash aliases.
- Create a more reliable global `slowcat` executable.
- Limit output to a selected number of lines per second.
- Display transfer progress, speed, percentage, and estimated completion time.

---

## 2. What Is `pv`?

`pv` stands for **Pipe Viewer**.

It monitors data flowing through a Linux pipeline. Depending on the options used, it can display:

- Data processed
- Elapsed time
- Current transfer speed
- Progress percentage
- Estimated remaining time

Basic flow:

```text
Input command or file
        ↓
       pv
        ↓
Output command or file
```

Basic example:

```bash
pv large_file.iso > copied_file.iso
```

In this example, `pv` copies the data while displaying its progress.

Official package references:

- [Fedora `pv` package](https://packages.fedoraproject.org/pkgs/pv/pv/)
- [Debian `pv` package](https://packages.debian.org/sid/pv)

---

## 3. What Is `slowcat`?

In this exercise, `slowcat` is not a separate standard Linux program. It is a custom alias or command built with `pv`:

```bash
alias slowcat='pv -l -L 5 -q'
```

It behaves like a slow version of `cat` by displaying approximately five lines per second.

```text
Normal cat             slowcat
---------              -------
Prints immediately     Prints at a controlled speed
No rate limit          Five lines per second
```

Example:

```bash
slowcat /usr/share/dict/words
```

---

## 4. Install on RHEL-Based Systems

These commands apply to distributions that use DNF, including Fedora, RHEL, Rocky Linux, and AlmaLinux, when the packages are available in the enabled repositories.

Install `pv` and the English dictionary:

```bash
sudo dnf install -y pv words
```

The `words` package supplies an English dictionary under `/usr/share/dict`. See the [Fedora `words` package information](https://packages.fedoraproject.org/pkgs/words/words/fedora-38.html).

Verify `pv`:

```bash
command -v pv
pv --version
```

Verify the dictionary:

```bash
ls -l /usr/share/dict/words
```

Preview its first ten lines:

```bash
head /usr/share/dict/words
```

### Expected package-installation flow

```text
Run dnf install
       ↓
Install pv
       ↓
Install words
       ↓
Verify /usr/bin/pv
       ↓
Verify /usr/share/dict/words
```

---

## 5. Install on Ubuntu or Debian

Update the package index:

```bash
sudo apt update
```

Install `pv` and an American English word list:

```bash
sudo apt install -y pv wamerican
```

The Ubuntu `wamerican` package provides `/usr/share/dict/american-english` and `/usr/share/dict/words`. See the [Ubuntu `wamerican` file list](https://packages.ubuntu.com/stonking/all/wamerican/filelist).

Verify `pv`:

```bash
command -v pv
pv --version
```

Verify the dictionary:

```bash
ls -l /usr/share/dict/words
```

Preview it:

```bash
head /usr/share/dict/words
```

### Distribution comparison

| Distribution family | Install command | Dictionary package |
|---|---|---|
| RHEL, Fedora, Rocky, AlmaLinux | `sudo dnf install -y pv words` | `words` |
| Ubuntu or Debian | `sudo apt install -y pv wamerican` | `wamerican` |

---

## 6. Create a Temporary Alias

Create the alias in the current Bash session:

```bash
alias slowcat='pv -l -L 5 -q'
```

Verify it:

```bash
type slowcat
```

Expected output:

```text
slowcat is aliased to `pv -l -L 5 -q'
```

Test it:

```bash
slowcat /usr/share/dict/words
```

Press `Ctrl+C` to stop it.

### Important limitation

This alias exists only in the current shell. When the terminal is closed, the temporary alias disappears.

---

## 7. Create a Global Alias

A global alias can be defined in `/etc/profile.d/` so that users whose Bash environment loads the system profile can receive it.

### Create the global configuration

```bash
sudo tee /etc/profile.d/slowcat.sh >/dev/null <<'EOF'
# Global slowcat alias
alias slowcat='pv -l -L 5 -q'
EOF
```

### Set appropriate permissions

```bash
sudo chmod 644 /etc/profile.d/slowcat.sh
```

Permission meaning:

| Permission | Meaning |
|---|---|
| Owner: `rw-` | Root can read and modify the file |
| Group: `r--` | Group members can read it |
| Others: `r--` | All other users can read it |

The file is sourced as shell configuration, so it does not need an executable permission.

### Load it in the current shell

```bash
source /etc/profile.d/slowcat.sh
```

Other users can log out and log back in, start a login shell, or source the file:

```bash
source /etc/profile.d/slowcat.sh
```

### Verify the global alias

```bash
type slowcat
```

Expected output:

```text
slowcat is aliased to `pv -l -L 5 -q'
```

### Important alias limitation

Bash aliases are primarily intended for interactive shells. They are not normally expanded inside non-interactive Bash scripts unless alias expansion is explicitly enabled.

Therefore, a global executable is more reliable when `slowcat` must work:

- For all users
- In scripts
- In non-login shells
- From automation tools

---

## 8. Recommended Global Executable

Instead of relying only on an alias, create a real command under `/usr/local/bin`.

Suggested script name and path:

```text
/usr/local/bin/slowcat
```

Create it:

```bash
sudo tee /usr/local/bin/slowcat >/dev/null <<'EOF'
#!/bin/bash

# Display text at approximately five lines per second.
exec pv -l -L 5 -q -- "$@"
EOF
```

Make it executable:

```bash
sudo chmod 755 /usr/local/bin/slowcat
```

Verify it:

```bash
type -a slowcat
```

If no alias has been defined, the output should identify the executable:

```text
slowcat is /usr/local/bin/slowcat
```

Test it:

```bash
slowcat /usr/share/dict/words
```

### Line-by-line explanation

```bash
#!/bin/bash
```

This selects Bash as the interpreter.

```bash
exec pv -l -L 5 -q -- "$@"
```

| Part | Meaning |
|---|---|
| `exec` | Replaces the wrapper shell process with `pv` |
| `pv` | Runs Pipe Viewer |
| `-l` | Uses line-based counting |
| `-L 5` | Limits output to approximately five lines per second |
| `-q` | Hides `pv`'s own progress display |
| `--` | Marks the end of command options |
| `"$@"` | Forwards all supplied filenames and arguments safely |

### Why `/usr/local/bin`?

`/usr/local/bin` is commonly used for administrator-created commands that are not managed by the operating system's package manager. It is normally included in users' `PATH`.

---

## 9. Test `slowcat`

Display the system dictionary slowly:

```bash
slowcat /usr/share/dict/words
```

Possible output:

```text
A
a
aa
aal
aalii
aam
Aani
aardvark
aardwolf
Aaron
```

Approximately five lines are displayed per second.

Stop it with:

```text
Ctrl+C
```

`Ctrl+C` sends signal number `2`, known as `SIGINT`, to interrupt the running process.

You may see a message similar to:

```text
pv: interrupted by a signal: Interrupt: 2
```

---

## 10. Reproduce the Progress-Bar Example

Store the dictionary path in a variable:

```bash
dictionary="/usr/share/dict/words"
```

Run the complete pipeline:

```bash
slowcat "$dictionary" |
pv --size "$(stat -c %s "$dictionary")" > /dev/null
```

It can also be written on one line:

```bash
slowcat "$dictionary" | pv --size "$(stat -c %s "$dictionary")" > /dev/null
```

### Pipeline flow

```text
/usr/share/dict/words
          ↓
slowcat sends five lines per second
          ↓
pv measures bytes, speed, progress and ETA
          ↓
/dev/null discards the final normal output
```

### Command breakdown

| Part | Purpose |
|---|---|
| `slowcat "$dictionary"` | Reads the dictionary at a controlled rate |
| `|` | Connects `slowcat` stdout to the next `pv` stdin |
| `stat -c %s "$dictionary"` | Returns the dictionary's size in bytes |
| `pv --size SIZE` | Uses the expected size to calculate percentage and ETA |
| `> /dev/null` | Discards the final normal output |

### Example progress display

```text
1.64KiB 0:00:37 [56.5 B/s] [>                 ] 0% ETA 14:58:57
```

| Display | Meaning |
|---|---|
| `1.64KiB` | Amount of data processed |
| `0:00:37` | Elapsed time |
| `56.5 B/s` | Current data-transfer rate |
| `0%` | Percentage completed |
| `ETA 14:58:57` | Estimated remaining time |

---

## 11. Understanding the Options

| Short option | Long option | Meaning |
|---|---|---|
| `-l` | `--line-mode` | Count lines instead of bytes for rate-related behavior |
| `-L RATE` | `--rate-limit RATE` | Limit the transfer rate |
| `-q` | `--quiet` | Hide normal `pv` progress information |
| `-s SIZE` | `--size SIZE` | Supply the expected total data size |

The custom command uses:

```bash
pv -l -L 5 -q
```

Meaning:

```text
Use line mode
      +
Limit the flow to five lines per second
      +
Do not show an internal progress display
```

The second `pv` in the demonstration is responsible for displaying the progress bar.

---

## 12. Alias Versus Function Versus Executable

| Method | Example location | Interactive shell | Bash scripts | Available to all users |
|---|---|---:|---:|---:|
| Temporary alias | Current terminal | Yes | Normally no | No |
| User alias | `~/.bashrc` | Yes | Normally no | No |
| Global alias | `/etc/profile.d/slowcat.sh` | Yes, when profile is loaded | Normally no | Yes, when profile is loaded |
| User function | `~/.bashrc` | Yes | Only when loaded or defined | No |
| Global executable | `/usr/local/bin/slowcat` | Yes | Yes | Yes |

### Recommendation

Use the global executable when reliability matters. Use an alias when the command is only a personal interactive shortcut.

Do not create both with the same name unless you understand command-resolution order. An alias can hide an executable with the same name.

Check every matching definition with:

```bash
type -a slowcat
```

---

## 13. Useful Practical Examples

### Display a log slowly

```bash
slowcat application.log
```

### Display command output slowly

```bash
find /etc -type f 2>/dev/null | pv -l -L 5 -q
```

### Monitor a file copy

```bash
pv source.iso > destination.iso
```

### Monitor a compressed archive

```bash
tar -czf - project/ | pv > project.tar.gz
```

### Extract with progress when the size is known

```bash
pv archive.tar.gz | tar -xzf -
```

### Use a different line speed directly

Two lines per second:

```bash
pv -l -L 2 -q /usr/share/dict/words
```

Ten lines per second:

```bash
pv -l -L 10 -q /usr/share/dict/words
```

---

## 14. Troubleshooting

### Problem: `pv: command not found`

Check whether `pv` is installed:

```bash
command -v pv
```

Install it with the appropriate package manager:

```bash
sudo dnf install -y pv
```

or:

```bash
sudo apt update
sudo apt install -y pv
```

### Problem: `/usr/share/dict/words` does not exist

On a DNF-based system:

```bash
sudo dnf install -y words
```

On Ubuntu or Debian:

```bash
sudo apt update
sudo apt install -y wamerican
```

Verify again:

```bash
ls -l /usr/share/dict/words
```

### Problem: `slowcat: command not found`

For the alias, load the configuration:

```bash
source /etc/profile.d/slowcat.sh
```

For the executable, check its path and permissions:

```bash
ls -l /usr/local/bin/slowcat
```

Expected executable permissions:

```text
-rwxr-xr-x
```

Verify that `/usr/local/bin` is in `PATH`:

```bash
echo "$PATH"
```

### Problem: an alias hides the executable

Inspect all definitions:

```bash
type -a slowcat
```

Temporarily remove the alias from the current shell:

```bash
unalias slowcat
```

Clear Bash's remembered command locations if necessary:

```bash
hash -r
```

### Problem: permission denied while creating global files

Files under `/etc/profile.d` and `/usr/local/bin` normally require administrative privileges. Use `sudo` with the provided `tee` and `chmod` commands.

---

## 15. Remove the Global Configuration

### Remove the global alias

Confirm the exact file first:

```bash
ls -l /etc/profile.d/slowcat.sh
```

Remove it:

```bash
sudo rm -- /etc/profile.d/slowcat.sh
```

Remove the currently loaded alias:

```bash
unalias slowcat
```

### Remove the global executable

Confirm it first:

```bash
ls -l /usr/local/bin/slowcat
```

Remove it:

```bash
sudo rm -- /usr/local/bin/slowcat
```

---

## 16. Quick Reference

| Task | Command |
|---|---|
| Install on RHEL family | `sudo dnf install -y pv words` |
| Install on Ubuntu/Debian | `sudo apt install -y pv wamerican` |
| Verify `pv` | `command -v pv` |
| Check version | `pv --version` |
| Verify word list | `ls -l /usr/share/dict/words` |
| Create temporary alias | `alias slowcat='pv -l -L 5 -q'` |
| Identify `slowcat` | `type -a slowcat` |
| Display dictionary slowly | `slowcat /usr/share/dict/words` |
| Reload global alias | `source /etc/profile.d/slowcat.sh` |
| Stop the running command | `Ctrl+C` |
| Get file size | `stat -c %s FILE` |
| Discard stdout | `> /dev/null` |

---

## 17. Final Summary

`pv` is the actual installed program. `slowcat` is a custom name that uses `pv` to limit text output to approximately five lines per second.

Complete installation commands:

```bash
# RHEL, Fedora, Rocky Linux or AlmaLinux
sudo dnf install -y pv words

# Ubuntu or Debian
sudo apt update
sudo apt install -y pv wamerican
```

Global alias:

```bash
alias slowcat='pv -l -L 5 -q'
```

Recommended global executable logic:

```bash
#!/bin/bash
exec pv -l -L 5 -q -- "$@"
```

Progress demonstration:

```bash
dictionary="/usr/share/dict/words"
slowcat "$dictionary" | pv --size "$(stat -c %s "$dictionary")" > /dev/null
```

The key learning flow is:

```text
Install pv and dictionary
          ↓
Create slowcat alias or executable
          ↓
Verify with type and command -v
          ↓
Read dictionary at a controlled rate
          ↓
Add another pv to display progress
```

