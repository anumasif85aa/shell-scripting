# Bash `read` Command Breakdown Study Notes

## Command
```bash
read -r fruit1 fruit2 fruit3 <<< "$text"
```

---

## Term-by-Term Explanation

### 1. `read`
- **Definition:** A built-in Bash command used to accept input and store it into one or more variables.
- **Role in Command:** Reads the incoming stream from standard input and parses words based on field separators (`IFS`).

---

### 2. `-r` (Raw Input Flag)
- **Definition:** Disables backslash (`\`) escape processing.
- **Why It Matters:**
  - *Without `-r`:* Bash treats `\` as an escape character and strips it (e.g., `\n` becomes `n`).
  - *With `-r`:* Preserves literal characters exactly as provided in the input.

---

### 3. `fruit1 fruit2 fruit3` (Target Variables)
- **Definition:** The positional variable names that will store the split output.
- **Word Allocation Rules:**
  - `fruit1` receives the **1st word**.
  - `fruit2` receives the **2nd word**.
  - `fruit3` receives the **3rd word AND all remaining text** on that line.

---

### 4. `<<<` (Here-String Operator)
- **Definition:** A Bash redirection operator that feeds a single string directly into a command's standard input (`stdin`).
- **Advantage:** Avoids creating subshells (which happens when using pipes like `echo "$text" | read ...`).

---

### 5. `"$text"` (Input Source Variable)
- **Definition:** The string variable containing the data to be parsed.
- **Best Practice:** Wrapped in double quotes `"$text"` to prevent premature word splitting or wildcard expansion before `read` processes it.

---

## Practical Code Example

```bash
#!/bin/bash

# Define input string
text="apple banana mango cherry"

# Execute read command
read -r fruit1 fruit2 fruit3 <<< "$text"

# Output results
echo "fruit1: $fruit1"  # Output: apple
echo "fruit2: $fruit2"  # Output: banana
echo "fruit3: $fruit3"  # Output: mango cherry (receives all remaining words)
```

---

## Summary Table

| Term | Component | Function |
| :--- | :--- | :--- |
| `read` | Built-in Command | Reads data from standard input into variables |
| `-r` | Command Option | Disables backslash escaping (raw mode) |
| `fruit1...` | Variable Names | Destination variables for split words |
| `<<<` | Here-String | Redirects string into command's `stdin` |
| `"$text"` | String Source | The source variable containing input text |
