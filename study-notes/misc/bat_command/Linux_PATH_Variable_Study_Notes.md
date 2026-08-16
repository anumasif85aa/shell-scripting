# Linux `$PATH` Environment Variable — Complete Study Notes



## Learning objectives

After studying these notes, you should be able to:

- Explain what the `$PATH` environment variable does.
- Understand how Bash finds a command.
- Distinguish aliases, functions, built-ins, and external commands.
- Display and inspect PATH directories clearly.
- Temporarily or permanently add a directory to `$PATH`.
- Understand why an existing command may still produce `command not found`.
- Troubleshoot the Ubuntu `bat` and `batcat` naming issue.
- Use `command -v`, `type`, and `hash` during troubleshooting.
- Avoid insecure or destructive PATH configurations.
- Recover safely from a broken PATH.

---

## Quick navigation

- [Jump to Section 17: `bat` command case study](#bat-command-case-study)

---

## 1. What is `$PATH`?

`PATH` is an environment variable containing an ordered list of directories. The shell searches those directories when you enter the name of an **external command** without its complete path.

Example:

```bash
ls
```

Instead of searching the complete filesystem, Bash checks the directories listed in `$PATH` until it finds an executable file named `ls`.

In simple words:

> `$PATH` tells the shell where to look for external commands.

---

## 2. `PATH` versus `$PATH`

| Form | Meaning |
|---|---|
| `PATH` | The variable's name |
| `$PATH` | Expands to the variable's current value |

Example:

```bash
echo "$PATH"
```

The dollar sign `$` asks the shell to expand the variable and return its value.

---

## 3. Example PATH value

```text
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

The directories are separated by colons (`:`).

Think of the colon as a separator:

```text
directory1:directory2:directory3
```

---

## 4. How Bash finds a command

Bash does more than search `$PATH`. A simplified command-resolution order is:

1. Reserved words and shell syntax.
2. Aliases.
3. Shell functions.
4. Shell built-ins.
5. Cached command locations.
6. External executables found through `$PATH`.

For example:

```bash
cd /tmp
```

`cd` is a Bash built-in. It is not an external executable found through `$PATH`.

Check it:

```bash
type cd
```

Expected result:

```text
cd is a shell builtin
```

External command example:

```bash
type ls
```

Typical result:

```text
ls is /usr/bin/ls
```

Important correction:

> `$PATH` is mainly used to locate external executable commands—not aliases, functions, or shell built-ins such as `cd`.

---

## 5. Search order is left to right

Suppose `$PATH` contains:

```text
/usr/local/bin:/usr/bin:/bin
```

When you enter:

```bash
mycommand
```

Bash checks:

1. `/usr/local/bin/mycommand`
2. `/usr/bin/mycommand`
3. `/bin/mycommand`

It normally executes the first suitable match.

This means PATH order matters. A directory placed at the beginning has higher priority than directories placed later.

---

## 6. Display the current PATH

Use `printf` for predictable output:

```bash
printf '%s\n' "$PATH"
```

You can also use:

```bash
echo "$PATH"
```

Quoting `"$PATH"` is a good shell habit because it prevents unwanted word splitting and expansion behavior.

---

## 7. Display one PATH directory per line

```bash
echo "$PATH" |
tr ':' '\n'
```

Example output:

```text
/usr/local/sbin
/usr/local/bin
/usr/sbin
/usr/bin
/sbin
/bin
```

Number the entries:

```bash
echo "$PATH" |
tr ':' '\n' |
nl
```

Show only nonempty unique entries:

```bash
echo "$PATH" |
tr ':' '\n' |
awk 'NF' |
sort -u
```

---

## 8. Check whether a directory is already in PATH

Simple readable method:

```bash
echo "$PATH" |
tr ':' '\n' |
grep -Fx "$HOME/.local/bin"
```

If the directory is present, the command prints it. If it is absent, there is no output and `grep` returns a nonzero status.

Bash pattern method:

```bash
case ":$PATH:" in
    *":$HOME/.local/bin:"*)
        echo "Present in PATH"
        ;;
    *)
        echo "Not present in PATH"
        ;;
esac
```

The surrounding colons prevent partial directory-name matches.

---

## 9. Find how a command will be resolved

### `command -v`

```bash
command -v ls
command -v bat
command -v batcat
```

This is the preferred script-friendly check.

### `type`

```bash
type ls
type cd
type bat
```

Display every available resolution:

```bash
type -a python
```

`type` can identify aliases, functions, built-ins, and external commands.

### Why not rely only on `which`?

`which` mainly searches PATH for external executables and may not correctly explain aliases, functions, or built-ins. Prefer:

```bash
command -v COMMAND
type -a COMMAND
```

---

## 10. Run a command by its complete path

If a command is not in `$PATH`, you can still run it using its complete path:

```bash
/usr/bin/batcat --version
```

For a command in your user directory:

```bash
$HOME/.local/bin/bat --version
```

This works because the shell does not need to search PATH when the command contains a slash `/`.

---

## 11. Why `./script.sh` is required

The current directory `.` is normally not included in PATH for security reasons.

If a script is in the current directory:

```bash
ls -l script.sh
```

Run it explicitly:

```bash
./script.sh
```

The `./` tells Bash to use the file from the current directory.

The script also needs execute permission:

```bash
chmod +x script.sh
```

Alternatively, run it through Bash without execute permission:

```bash
bash script.sh
```

---

## 12. Temporary PATH change

Add `~/.local/bin` for the current shell session:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Verify:

```bash
echo "$PATH" |
tr ':' '\n'
```

This change normally disappears when the shell closes.

---

## 13. Prepend versus append

### Prepend: higher priority

```bash
export PATH="$HOME/.local/bin:$PATH"
```

The user directory is searched before existing directories.

### Append: lower priority

```bash
export PATH="$PATH:$HOME/.local/bin"
```

The user directory is searched after existing directories.

Use prepend when you intentionally want your user-installed command to take priority. Use append when system commands should retain priority.

---

## 14. Permanent PATH configuration for Bash

For interactive Bash shells, add the export statement to `~/.bashrc`:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

Reload the file:

```bash
source ~/.bashrc
```

Verify:

```bash
command -v bat
```

Before appending, inspect the file to avoid duplicate entries:

```bash
grep -n 'local/bin' ~/.bashrc
```

If the line is already present, do not add it again.

---

## 15. Ubuntu's `~/.profile` behavior

Ubuntu's default `~/.profile` commonly contains logic that adds these directories when they exist:

```text
$HOME/bin
$HOME/.local/bin
```

Inspect it:

```bash
grep -n 'local/bin\|HOME/bin' ~/.profile
```

If `~/.local/bin` was created after login, the current session may not have received the updated PATH yet.

Reload the profile:

```bash
source ~/.profile
```

Or sign out and start a new login session.

Important:

> On Ubuntu, manually editing `~/.bashrc` may be unnecessary if the default `~/.profile` already adds `~/.local/bin`.

---

## 16. Which startup file should be used?

| File | Common purpose |
|---|---|
| `~/.bashrc` | Interactive non-login Bash shells |
| `~/.profile` | Login environment; shell-independent settings on many systems |
| `~/.bash_profile` | Bash login-shell configuration when present |
| `/etc/profile` | System-wide login-shell settings |
| `/etc/environment` | System-wide environment assignments on many Linux systems; not a shell script |

For a personal command directory on Ubuntu, the default `~/.profile` handling is often appropriate. For interactive Bash-only customization, `~/.bashrc` is commonly used.

Do not add shell commands such as `export`, command substitutions, or Bash syntax to `/etc/environment`.

---

<a id="bat-command-case-study"></a>

## 17. Case study: `bat` command not found on Ubuntu

### Scenario

The package is installed:

```bash
sudo apt install bat -y
```

But this fails:

```bash
bat bakar-key.pem
```

Ubuntu reports:

```text
Command 'bat' not found
```

### Cause 1: Ubuntu uses the name `batcat`

On Ubuntu/Debian, the executable supplied by the `bat` package is commonly named:

```text
batcat
```

Check:

```bash
command -v batcat
batcat --version
```

Use it directly:

```bash
batcat FILE
```

### Cause 2: A user symlink exists but is not searchable

Suppose this exists:

```text
~/.local/bin/bat
```

Check it:

```bash
ls -l ~/.local/bin/bat
readlink -f ~/.local/bin/bat
```

Run it using the complete path:

```bash
~/.local/bin/bat --version
```

If the full path works but `bat` does not, `~/.local/bin` is probably missing from the current PATH.

Reload Ubuntu's profile:

```bash
source ~/.profile
hash -r
```

Then test:

```bash
command -v bat
bat --version
```

### Create or repair the user-level symlink

```bash
mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat
```

Reload and verify:

```bash
source ~/.profile
hash -r
command -v bat
```

Expected result:

```text
/home/USERNAME/.local/bin/bat
```

### Recommended priority

1. Use `batcat` immediately.
2. Use a user-level symlink in `~/.local/bin` if you want the shorter `bat` name.
3. Ensure `~/.local/bin` is in PATH.
4. Avoid a system-wide symlink unless there is a real multi-user requirement.

---

## 18. Bash command hashing

Bash may remember a previously resolved executable location.

Display cached commands:

```bash
hash
```

Clear the cache after changing PATH or symlinks:

```bash
hash -r
```

Then check again:

```bash
command -v bat
```

---

## 19. Permissions and executability

A directory being in PATH is not enough. The target must also be usable.

Check the command:

```bash
ls -l ~/.local/bin/mycommand
```

For a regular script, add execute permission:

```bash
chmod +x ~/.local/bin/mycommand
```

Check the parent directories too:

```bash
namei -l ~/.local/bin/mycommand
```

Users need directory traversal permission to reach the executable.

---

## 20. Broken symbolic links

A filename may exist in `~/.local/bin`, but its symlink target may be missing.

Check:

```bash
ls -l ~/.local/bin/bat
readlink -f ~/.local/bin/bat
```

If `readlink -f` produces no valid target, recreate the link:

```bash
ln -sf /usr/bin/batcat ~/.local/bin/bat
```

---

## 21. Avoid duplicate PATH entries

Repeatedly appending the same export line can create duplicate PATH entries.

Inspect:

```bash
echo "$PATH" |
tr ':' '\n' |
nl
```

Search startup files:

```bash
grep -n 'PATH=' ~/.profile ~/.bashrc ~/.bash_profile 2>/dev/null
```

Edit the responsible file and keep only the intended configuration.

Do not solve duplicates by blindly rebuilding PATH with unreviewed text processing; preserve required system directories.

---

## 22. Security: do not add `.` to PATH

Avoid configurations such as:

```bash
export PATH=".:$PATH"
```

If the current directory contains a malicious executable named like a trusted command, the shell could run it first.

Use an explicit relative path instead:

```bash
./script.sh
```

Also watch for empty PATH entries:

```text
/usr/bin::/bin
```

An empty entry may represent the current directory in some contexts and creates a security risk.

Detect empty entries:

```bash
echo "$PATH" |
tr ':' '\n' |
nl -ba
```

Blank numbered lines indicate empty entries.

---

## 23. Security: directory ownership matters

Do not place privileged or important PATH entries in directories writable by untrusted users.

Check a directory:

```bash
ls -ld ~/.local/bin /usr/local/bin /usr/bin
```

For your personal directory:

```bash
chmod 700 ~/.local/bin
```

Only do this when the directory is intended for your user alone.

System directories should be owned and managed appropriately by `root`.

---

## 24. Why `sudo` may use a different PATH

This command shows your user PATH:

```bash
echo "$PATH"
```

But `sudo` may use a restricted `secure_path` defined in sudoers.

Compare carefully:

```bash
command -v mycommand
sudo sh -c 'command -v mycommand'
```

A command in `~/.local/bin` may work for your user but not through `sudo`.

Do not copy personal scripts into privileged directories just to bypass this behavior. Decide whether the command should be user-specific or system-wide.

---

## 25. Recover from a broken PATH

If an incorrect assignment removes standard directories, even common commands may stop working.

Temporary recovery for a typical Ubuntu system:

```bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
```

Then inspect your startup files:

```bash
grep -n 'PATH=' ~/.profile ~/.bashrc ~/.bash_profile 2>/dev/null
```

Correct the bad line and reload the appropriate file.

If a command still cannot be found, use its complete path:

```bash
/usr/bin/nano ~/.bashrc
/usr/bin/vim ~/.bashrc
```

Important:

> Never replace PATH with only your custom directory.

Incorrect:

```bash
export PATH="$HOME/.local/bin"
```

Correct:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

---

## 26. Safe troubleshooting workflow

When a command returns `command not found`, use this order:

### Step 1: Check whether the package executable exists

```bash
command -v batcat
```

### Step 2: Check the expected custom path

```bash
ls -l ~/.local/bin/bat
```

### Step 3: Test the complete path

```bash
~/.local/bin/bat --version
```

### Step 4: Inspect PATH

```bash
echo "$PATH" |
tr ':' '\n' |
nl
```

### Step 5: Reload the correct startup file

```bash
source ~/.profile
```

Or, when the setting is in `~/.bashrc`:

```bash
source ~/.bashrc
```

### Step 6: Clear Bash's cache

```bash
hash -r
```

### Step 7: Verify resolution

```bash
command -v bat
type -a bat
bat --version
```

---

## 27. Practice lab

### Task 1: Create a personal command directory

```bash
mkdir -p ~/.local/bin
```

### Task 2: Create a small command

```bash
cat > ~/.local/bin/hello-path <<'EOF'
#!/bin/bash
echo "Hello from ~/.local/bin"
EOF
```

### Task 3: Make it executable

```bash
chmod +x ~/.local/bin/hello-path
```

### Task 4: Run it using the complete path

```bash
~/.local/bin/hello-path
```

### Task 5: Check whether the directory is in PATH

```bash
echo "$PATH" |
tr ':' '\n' |
grep -Fx "$HOME/.local/bin"
```

### Task 6: Add it temporarily if required

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Task 7: Run it by command name

```bash
hello-path
```

### Task 8: Inspect command resolution

```bash
command -v hello-path
type -a hello-path
```

### Task 9: Start a new shell and test persistence

```bash
bash
command -v hello-path
exit
```

If it is missing in the new shell, review `~/.profile` and `~/.bashrc` using the earlier guidance.

---

## 28. Knowledge check

1. What does `$PATH` contain?
2. What character separates PATH directories?
3. Does Bash search PATH from left to right or right to left?
4. Why is `cd` not found through PATH?
5. What is the difference between `PATH` and `$PATH`?
6. Why does `./script.sh` work when `script.sh` may not?
7. What does `command -v` show?
8. What is the difference between prepending and appending a directory?
9. Why might `~/.local/bin/bat` exist while `bat` returns `command not found`?
10. Why is Ubuntu's executable commonly named `batcat`?
11. What does `hash -r` do?
12. Why should `.` not be added to the beginning of PATH?
13. Why might a command work normally but fail with `sudo`?
14. How can a broken PATH be temporarily restored?

---

## 29. Quick reference

```bash
# Display PATH
echo "$PATH"

# One directory per line
echo "$PATH" | tr ':' '\n'

# Number PATH directories
echo "$PATH" | tr ':' '\n' | nl

# Check command resolution
command -v COMMAND
type -a COMMAND

# Add a directory temporarily at high priority
export PATH="$HOME/.local/bin:$PATH"

# Add a directory temporarily at low priority
export PATH="$PATH:$HOME/.local/bin"

# Reload Ubuntu login environment
source ~/.profile

# Reload interactive Bash configuration
source ~/.bashrc

# Clear Bash command cache
hash -r

# Install bat on Ubuntu
sudo apt install bat -y

# Use Ubuntu's executable directly
batcat FILE

# Create the shorter user-level command name
mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat
source ~/.profile
hash -r

# Recover a typical Ubuntu PATH temporarily
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
```

---

## Final summary

`$PATH` is an ordered, colon-separated list of directories used by the shell to find external executable commands.

Remember:

```text
PATH                      = variable name
$PATH                     = variable value
Directories               = separated by colons
Search direction          = left to right
User command directory    = ~/.local/bin
Temporary change          = export PATH="...:$PATH"
Reload Ubuntu profile     = source ~/.profile
Clear Bash command cache  = hash -r
Ubuntu bat executable     = batcat
```

The key troubleshooting distinction is:

> A file can exist and be executable, but entering its command name will fail if its directory is not searchable through the current PATH.
