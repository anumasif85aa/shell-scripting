# `bat` Command — Complete Study Notes & Cheat Sheet

`bat` is a modern clone of the traditional Unix `cat` command with enhanced features including syntax highlighting, Git integration, automatic paging, and line numbering.

---

## 1. Overview & Key Features

* **Syntax Highlighting:** Automatically detects file types and applies color schemes for standard programming, markup, and config files.
* **Git Integration:** Displays Git modifications (added, modified, removed lines) in the gutter/margin.
* **Show Non-Printable Characters:** Renders tabs, spaces, and line endings visibly when requested.
* **Automatic Paging:** Pipe output into `less` automatically if content exceeds terminal height.
* **Drop-in `cat` Replacement:** Works seamlessly with standard pipes (`|`) and redirects (`>`), automatically disabling formatting/colors when piped.

---

## 2. Installation Guide

### Debian / Ubuntu
```bash
sudo apt update
sudo apt install bat -y

# On Ubuntu/Debian, the binary is renamed to 'batcat' to avoid package conflicts.
# Create a symlink to use 'bat':
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat
```

### RHEL / CentOS / Rocky Linux / AlmaLinux / Fedora
```bash
# Enable EPEL repository (for RHEL/CentOS)
sudo dnf install epel-release -y

# Install bat
sudo dnf install bat -y
```

### Arch Linux / Manjaro
```bash
sudo pacman -S bat
```

### macOS (Homebrew)
```bash
brew install bat
```

### Rust / Cargo (Universal)
```bash
cargo install --locked bat
```

---

## 3. Core Usage & Command Syntax

### Basic Viewing
```bash
# View a single file with line numbers and syntax highlighting
bat filename.sh

# View multiple files sequentially
bat file1.py file2.py

# Read from standard input (stdin)
echo '{"key": "value"}' | bat -l json
```

### Key Flags & Options

| Flag / Option | Description | Example |
| :--- | :--- | :--- |
| `-n`, `--line-numbers` | Display line numbers only (minimal decorations) | `bat -n script.sh` |
| `-A`, `--show-all` | Show non-printable characters (tabs, spaces, `
`) | `bat -A config.txt` |
| `-p`, `--plain` | Plain mode — disable headers, line numbers, and grid | `bat -p file.txt` |
| `-l`, `--language` | Explicitly set language for syntax highlighting | `bat -l python snippet` |
| `-r`, `--line-range` | Display specific line numbers or ranges | `bat -r 10:25 file.py` |
| `--list-languages` | List all supported language syntaxes | `bat --list-languages` |
| `--list-themes` | List all available color themes | `bat --list-themes` |
| `--theme=<theme>` | Set color theme temporarily | `bat --theme="TwoDark" file.js` |
| `--paging=<never\|always\|auto>` | Control when automatic paging is used | `bat --paging=never log.txt` |

---

## 4. Line Range Examples

```bash
# Print lines 15 through 40
bat -r 15:40 app.py

# Print from line 50 to the end of the file
bat -r 50: app.py

# Print the first 20 lines
bat -r :20 app.py

# Print specific single lines and ranges together
bat -r 5:10 -r 30:35 app.py
```

---

## 5. Shell Integration & Aliases

### Replacing `cat` safely
Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# Alias cat to bat (plain mode or full mode)
alias cat='bat --style=plain'
alias batcat='bat'
```

### Enhancing `git diff` with `bat`
Integrate `bat` as a dynamic pager for Git diffs:

```bash
# View side-by-side git diffs with syntax highlighting
git diff | bat --language=diff
```

### Integration with `fzf` (Fuzzy Finder)
Use `bat` as an interactive preview panel in `fzf`:

```bash
fzf --preview 'bat --style=numbers --color=always --line-range :50 {}'
```

---

## 6. Configuration Customization

`bat` looks for a configuration file at `~/.config/bat/config`.

### Sample `~/.config/bat/config`:
```ini
# Set theme
--theme="TwoDark"

# Enable line numbers and Git status, but hide top/bottom header borders
--style="numbers,changes"

# Always use grid lines
# --style="full"

# Set default tabs width to 4 spaces
--tabs=4

# Map custom file extensions to syntaxes
--map-syntax "*.inc:C++"
```

To create the configuration directory and file:
```bash
mkdir -p ~/.config/bat
nano ~/.config/bat/config
```

---

## 7. Quick Comparison: `cat` vs `bat`

| Feature | `cat` | `bat` |
| :--- | :--- | :--- |
| **Syntax Highlighting** | ❌ No | ✅ Automatic / Configurable |
| **Line Numbers** | ⚠️ `-n` (basic text) | ✅ Styled margin with grid |
| **Git Integration** | ❌ No | ✅ Displays added/modified indicators |
| **Paging** | ❌ No (requires `cat file \| less`) | ✅ Auto-pages long files |
| **Non-Printable Characters** | ⚠️ `-A` (raw caret notation) | ✅ Highlighting & clear visual markers |
| **Scripting / Piping Safe** | ✅ Always raw text | ✅ Auto-detects pipe & turns off styles |

---

## 8. Summary & Reference Cheat Sheet

```bash
bat file.txt                 # Highlighting + line numbers + auto-paging
bat -p file.txt              # Pure plain text (like cat)
bat -A file.txt              # Reveal hidden/whitespace chars
bat -r 10:20 file.txt        # Lines 10 to 20
bat -l json config.txt       # Force JSON syntax
bat --list-themes            # Preview available themes
```
