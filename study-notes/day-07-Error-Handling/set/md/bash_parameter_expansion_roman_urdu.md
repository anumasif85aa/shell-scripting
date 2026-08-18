# Bash Parameter Expansion: `source_file="${1:-}"` Study Notes (Roman Urdu)

## Command
```bash
source_file="${1:-}"
```

---

## Term-by-Term Breakdown (Roman Urdu)

### 1. `source_file=`
- **Description:** Ye aapke destination variable ka naam hai.
- **Function:** Command run hone ke baad jo bhi result aayega, woh is `source_file` variable ke andar save (store) ho jayega.

---

### 2. `"${...}"` (Double Quotes aur Curly Braces)
- **Curly Braces `{ }`:** Bash ko batate hain ke Parameter Expansion process ho raha hai. Is se variable syntax clear aur safe ho jata hai.
- **Double Quotes `" "`:** Spaces wale paths/filenames ko protect karte hain (maslan `"My Files/data.txt"`). Ye space ki wajah se word-splitting hone se bachate hain.

---

### 3. `$1` (First Positional Argument)
- **Description:** Script ko terminal se pass kiya gaya pehla argument.
- **Example:** Agar aap command likhte hain `./script.sh input.txt`, toh `$1` ki value `input.txt` hogi.

---

### 4. `:-` (Default / Fallback Operator)
- **Description:** Ye Bash ka default value expansion operator hai.
- **Logic:** *"Agar `$1` unset hai ya khali (empty) hai, toh `:-` ke baad di gayi fallback value use karo."*

---

### 5. `}` (Empty Fallback Value)
- **Description:** `:-` ke right side par yahan kuch nahi likha gaya.
- **Result:** Agar user ne terminal se koi argument nahi diya, toh error aane ke bajaye `source_file` ko safe tareeqay se empty string (`""`) set kar diya jayega.

---

## Summary Statement (Aasan Khulasa)

> **"Pehla argument (`$1`) check karo. Agar user ne argument diya hai toh `source_file` mein woh value store kar do. Agar user ne argument NAHI diya, toh error dene ke bajaye `source_file` ko khali (empty string) chhor do."**

---

## Practical Comparison Table

| Command Run Mode | Input Argument (`$1`) | `source_file` Ki Value |
| :--- | :--- | :--- |
| `./script.sh config.txt` | `config.txt` | `config.txt` |
| `./script.sh` | *(Kucch nahi)* | `""` *(Empty String)* |

---

## Related Variations (Pro-Tip)

### 1. Hardcoded Default Value Set Karna
Agar aap chahte hain ke argument na dene par default file automatically select ho jaye:
```bash
source_file="${1:-default_config.txt}"
```

### 2. Mandatory Argument Check (Error Throw Karna)
Agar aap chahte hain ke argument na milne par script error de kar band ho jaye:
```bash
source_file="${1:?Error: Koyi source file argument nahi diya gaya!}"
```
