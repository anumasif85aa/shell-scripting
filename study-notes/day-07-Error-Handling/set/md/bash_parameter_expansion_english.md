# Bash Parameter Expansion: `source_file="${1:-}"` Study Notes

## Command
```bash
source_file="${1:-}"
```

---

## Term-by-Term Breakdown

### 1. `source_file=`
- **Description:** Target variable name.
- **Function:** Receives and stores the resulting value evaluated from the parameter expansion on the right side.

---

### 2. `"${...}"` (Double Quotes and Curly Braces)
- **Curly Braces `{ }`:** Enclose the parameter expansion construct to clearly define variable boundaries and prevent syntax ambiguity.
- **Double Quotes `" "`:** Prevent word splitting and file globbing if the argument contains spaces or special characters (e.g., `"My Documents/file.txt"`).

---

### 3. `$1` (First Positional Argument)
- **Description:** Represents the first positional command-line argument passed to the script during execution.
- **Example:** Running `./script.sh input.txt` sets `$1` to `input.txt`.

---

### 4. `:-` (Default / Fallback Operator)
- **Description:** The standard Bash parameter expansion fallback operator.
- **Logic:** Evaluates to: *"If `$1` is unset or empty, substitute the fallback value provided after `:-`."*

---

### 5. `}` (Empty Fallback Value)
- **Description:** Represents the absence of a explicit default value following `:-`.
- **Result:** If no argument is passed to `$1`, the expansion safely resolves to an empty string (`""`), preventing errors under strict shell modes like `set -u` (nounset).

---

## Plain English Summary

> **"Check the first positional argument (`$1`). If provided, assign its value to `source_file`. If no argument was provided, safely assign an empty string (`""`) to `source_file`."**

---

## Execution Behavior Matrix

| Script Execution | Argument (`$1`) | `source_file` Value |
| :--- | :--- | :--- |
| `./script.sh config.txt` | `config.txt` | `"config.txt"` |
| `./script.sh` | *(Unset / None)* | `""` *(Empty String)* |

---

## Useful Related Variations

### 1. Hardcoded Default Value
Fallback to a default filename if no argument is supplied:
```bash
source_file="${1:-default_config.txt}"
```

### 2. Mandatory Argument Check
Exit with an error message if `$1` is missing:
```bash
source_file="${1:?Error: No source file argument provided!}"
```
