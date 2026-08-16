# Bash `read` Command Breakdown Study Notes (Roman Urdu)

## Command
```bash
read -r fruit1 fruit2 fruit3 <<< "$text"
```

---

## Term-by-Term Explanation (Roman Urdu)

### 1. `read`
- **Definition:** Ye Bash ka ek built-in command hai jo input se data ko read karke variables ke andar save karta hai.
- **Role:** Incoming stream ko process karke `IFS` (Internal Field Separator) ke mutabiq words ko alag karta hai.

---

### 2. `-r` (Raw Input Flag)
- **Definition:** Ye option Bash ko batata hai ke backslash (`\`) ko kisi special character ke tor par samjhane ke bajaye raw text samjhe.
- **Kyun Zaroori Hai:**
  - *Bina `-r` ke:* Agar text mein backslash ho, toh Bash use hata (strip) deta hai.
  - *`-r` ke sath:* Text bilkul waisa hi read hota hai jaisa original format mein hota hai.

---

### 3. `fruit1 fruit2 fruit3` (Target Variables)
- **Definition:** Ye aapke teeno variables hain jahan split hone ke baad text store hoga.
- **Rules:**
  - `fruit1`: Pehla word receive karega.
  - `fruit2`: Doosra word receive karega.
  - `fruit3`: Teesra word aur uske baad bacha hua **saara text** receive karega.

---

### 4. `<<<` (Here-String Operator)
- **Definition:** Ye Bash ka **Here-String operator** hai. Ye right side wali string ko left side wali command (`read`) ke standard input (`stdin`) mein direct bhej deta hai.
- **Faida:** Pipe (`|`) ki tarah subshell create nahi karta, jis se variables current shell mein hi save rehte hain.

---

### 5. `"$text"` (Input Source Variable)
- **Definition:** Ye woh variable hai jismein aapka asal string data para hota hai.
- **Best Practice:** Double quotes `"$text"` lagana zaroori hai taake spaces aur special characters mahfooz rahein.

---

## Code Example

```bash
#!/bin/bash

# Input string
text="apple banana mango cherry"

# Read command run karte hain
read -r fruit1 fruit2 fruit3 <<< "$text"

# Output display karte hain
echo "fruit1: $fruit1"  # Output: apple
echo "fruit2: $fruit2"  # Output: banana
echo "fruit3: $fruit3"  # Output: mango cherry (baaki bacha saara text yahan aa gaya)
```

---

## Summary Table

| Term | Component | Function (Roman Urdu) |
| :--- | :--- | :--- |
| `read` | Built-in Command | Standard input se data read karke variables mein save karta hai |
| `-r` | Command Option | Backslash escaping ko disable karta hai (raw mode) |
| `fruit1...` | Variable Names | Split hue words ko save karne wale variables |
| `<<<` | Here-String | String ko command ke `stdin` mein redirect karta hai |
| `"$text"` | String Source | Asal input text wala variable |
