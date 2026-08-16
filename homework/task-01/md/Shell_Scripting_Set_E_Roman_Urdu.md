# Study Notes: Shell Scripting Mein `set -e` Option

## Overview
Bash aur Shell scripting mein **`set -e`** (jisay `errexit` bhi kaha jata hai) ek aisa option hai jo script ko hidayat deta hai ke **agar koi bhi command fail ho jaye (non-zero status return kare), toh script ko foran exit/band kar do.**

By default, Bash pehli command fail hone ke bawajood agli tamam commands ko run karta rehta hai. `set -e` is behavior ko badal kar strict execution apply karta hai.

---

## 1. Default Behavior (`set -e` ke baghair)

`set -e` ke baghair, Bash errors ko ignore karta hai aur line by line agay barhta rehta hai.

```bash
#!/bin/bash

cd /folder_jo_exist_nahi_karta  # Error: Directory nahi mili!
rm -rf *                         # KHATARNAK: Current folder ki tamam files delete ho jayengi!
echo "Task completed"
```
> **Khatra:** Chunke `cd` fail ho gaya, script current working directory mein hi rahegi aur `rm -rf *` chala degi, jis se ghalti se zaroori files delete ho sakti hain.

---

## 2. Behavior `set -e` Ke Sath

Jab aap script ke shuru mein `set -e` laga dete hain, toh pehle error par hi script stop ho jati hai.

```bash
#!/bin/bash
set -e

cd /folder_jo_exist_nahi_karta  # Error! Script yahan hi foran band ho jayegi.
rm -rf *                         # Yeh line KABHI RUN NAHI hogi.
echo "Task completed"
```
> **Nateeja:** Fail hone wali `cd` command script ko foran stop kar deti hai, jis se aage ki koi bhi nuksandeh command run nahi hoti.

---

## 3. Exceptions (Jab `set -e` Script Ko Stop Nahi Karta)

Kuch specific conditions mein `set -e` error aane par bhi script ko stop nahi karta:

### 1. `if` ya `while` statements ke andar:
```bash
if grep "pattern" file.txt; then
    echo "Pattern mil gaya"
fi
# Agar grep fail ho jaye (match na mile), toh bhi script chalti rahegi kyun ke yeh conditional check ka hissa hai.
```

### 2. `||` (OR operator) ke sath jori gayi commands:
```bash
command_jo_fail_ho_sakti_hai || echo "Fail hui, lekin script chalti rahegi"
```

### 3. `!` (NOT operator) ke sath negation:
```bash
! false # Script exit nahi hogi
```

### 4. Pipelines (`|` commands):
By default, `set -e` sirf pipeline ki **aakhri command** ka exit status check karta hai.
```bash
pehli_failing_command | doosri_successful_command
# Script exit NAHI hogi kyun ke doosri command kamyab ho gayi.
```

---

## 4. Best Practice: Bash Strict Mode

Production level scripts mein, `set -e` ko doosre flags ke sath mila kar **Bash Strict Mode** banaya jata hai:

```bash
set -euo pipefail
```

### Flags Ki Tafseel:
* **`-e` (`errexit`):** Koi bhi command fail ho toh foran exit karein.
* **`-u` (`nounset`):** Kisi aise variable ko use karne par error de kar exit karein jo define na hua ho (unset variable).
* **`-o pipefail`:** Agar pipeline (`|`) ki **koi bhi** command fail ho, toh poori pipeline ko fail samjhein (sirf aakhri command ko nahi).
