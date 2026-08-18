# Bash Input Redirection & `stdin` Study Notes

## 1. Understanding Standard Input (`stdin`) & `cat`

By default, when `cat` is executed without any file arguments, it reads directly from **`stdin`** (Standard Input, File Descriptor `0`).

---

## 2. Ways to Feed `stdin` into `cat`

### A. Interactive Terminal Input
Running `cat` alone waits for user input from the keyboard:
```bash
cat
```
1. Type your lines of text.
2. Press `Enter` (it echoes back what you typed).
3. Press `Ctrl + D` to send the **EOF** (End-of-File) signal and terminate `cat`.

---

### B. Pipe (`|`)
Pipes the `stdout` (Standard Output) of a preceding command into the `stdin` of `cat`:
```bash
echo "Hello from stdout" | cat
```

---

### C. Here-Doc (`<<`)
Feeds multi-line text directly into `cat` via `stdin` without creating external files:
```bash
cat << EOF
Line 1: Server Configuration
Line 2: Debug Mode Enabled
EOF
```

---

### D. Here-String (`<<<`)
Redirects a single string or variable into `cat` via `stdin`:
```bash
text="Sample log message"
cat <<< "$text"
```

---

### E. File Redirection Operator (`<`)
Redirects the contents of an **existing** file into `cat`'s `stdin`:
```bash
cat < application.log
```

---

## 3. Difference: `cat file.txt` vs `cat < file.txt`

| Feature | `cat file.txt` | `cat < file.txt` |
| :--- | :--- | :--- |
| **Who opens the file?** | The `cat` command directly opens `file.txt`. | **Bash** opens `file.txt` and attaches it to `cat`'s `stdin`. |
| **Awareness of Filename** | `cat` knows the filename (used in error messages). | `cat` does **not** know the filename; it only reads `stdin`. |
| **If file is missing?** | `cat: file.txt: No such file or directory` | `-bash: file.txt: No such file or directory` |

---

## 4. Troubleshooting Common Errors

### Error: `No such file or directory`
```text
-bash: qaz.txt: No such file or directory
```
- **Cause:** Bash tried to open `qaz.txt` to pass it into `stdin` before running the command, but the file did not exist in the current directory (`$PWD`).
- **Fix / Verification:**
  ```bash
  # Check current directory files
  ls -la

  # Search for file across system
  find ~ -name "qaz.txt" 2>/dev/null
  ```
