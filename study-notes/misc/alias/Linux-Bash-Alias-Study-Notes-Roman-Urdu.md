# Linux Bash Alias — Mukammal Study Notes (Roman Urdu)

## Mauzu

Linux aur Bash mein Alias

---

## 1. Alias Kya Hai?

**Alias** kisi command ka chhota naam, shortcut, ya nickname hota hai.

Seedhi definition:

```text
Alias = command ka shortcut naam
```

Agar koi command lambi ho ya hum use baar baar chalate hon, to us command ka chhota naam bana sakte hain.

Misal:

```bash
alias ll='ls -la'
```

Ab is command ke bajaye:

```bash
ls -la
```

Sirf yeh likhen:

```bash
ll
```

Bash asal command chalayega:

```bash
ls -la
```

---

## 2. Alias Ki Zaroorat Kyun Hoti Hai?

Alias command-line par kaam ko asaan aur tez banata hai.

Alias ke faide:

- Waqt bachata hai.
- Lambi commands baar baar type nahi karni parteen.
- Typing mistakes kam hoti hain.
- Rozana Linux ka kaam asaan hota hai.
- Aksar istemal hone wali commands ke shortcuts ban jate hain.
- Terminal mein productivity behtar hoti hai.

Misal:

```bash
alias c='clear'
```

Ab `clear` ke bajaye sirf yeh likhen:

```bash
c
```

---

## 3. Alias Ka Basic Syntax

Basic syntax:

```bash
alias shortcut='asal command'
```

Misal:

```bash
alias ll='ls -la'
```

Is mein:

```text
ll     = shortcut naam
ls -la = asal command
```

Zaroori rules:

- `=` ke aagay ya peechay space na dein.
- Command ko quotes ke andar likhen.
- Shortcut ka naam meaningful rakhen.

Sahi:

```bash
alias ll='ls -la'
```

Ghalat:

```bash
alias ll = 'ls -la'
```

---

## 4. Temporary Alias

Temporary alias sirf current terminal session mein kaam karta hai.

Misal:

```bash
alias ll='ls -la'
alias gs='git status'
alias c='clear'
```

Ab yeh shortcuts chala sakte hain:

```bash
ll
gs
c
```

Terminal band karne ke baad yeh aliases khatam ho jayenge.

### Kyun?

Kyun ke temporary aliases sirf current shell ki memory mein store hote hain.

---

## 5. Permanent Alias

Permanent alias terminal band karke dobara kholne ke baad bhi available hota hai.

Alias ko permanent banane ke liye use `~/.bashrc` file mein add karte hain.

### Step 1: `.bashrc` Kholen

```bash
vim ~/.bashrc
```

### Step 2: File Ke Aakhir Mein Aliases Add Karen

```bash
alias ll='ls -la'
alias gs='git status'
alias c='clear'
alias update='sudo apt update'
```

### Step 3: Vim Mein File Save Karen

Pehle `Esc` dabayen, phir `:wq` type karke `Enter` dabayen:

```text
Esc
:wq
Enter
```

> `Ctrl+O`, `Enter`, aur `Ctrl+X` Nano editor ke commands hain, Vim ke nahi.

### Step 4: `.bashrc` Reload Karen

```bash
source ~/.bashrc
```

Ab aliases current shell aur naye interactive Bash sessions mein available honge.

---

## 6. Aliases Kaise Check Karen?

Tamam aliases dekhne ke liye:

```bash
alias
```

Kisi ek alias ko check karne ke liye:

```bash
alias ll
```

Misali output:

```bash
alias ll='ls -la'
```

`type` command se bhi check kar sakte hain:

```bash
type ll
```

Misali output:

```text
ll is aliased to `ls -la'
```

---

## 7. Alias Kaise Remove Karen?

Ek alias ko current shell se temporary remove karne ke liye:

```bash
unalias ll
```

Tamam active aliases ko temporary remove karne ke liye:

```bash
unalias -a
```

Agar alias `~/.bashrc` mein save hai, to naya terminal kholne par dobara load ho jayega.

Permanent removal ke steps:

1. `.bashrc` kholen:

```bash
vim ~/.bashrc
```

2. Alias wali line delete karen:

```bash
alias ll='ls -la'
```

3. Current shell se active alias bhi remove karen:

```bash
unalias ll
```

4. `.bashrc` reload karen:

```bash
source ~/.bashrc
```

### Alias Line Delete Karne Ke Baad Bhi Alias Active Kyun Rehta Hai?

Jab alias current shell ki memory mein load ho jata hai, to sirf uski line `.bashrc` se delete karne par woh memory se remove nahi hota.

```bash
source ~/.bashrc
```

File ki mojood definitions dobara load karta hai, lekin jo definition file se delete ho chuki ho use current memory se automatically remove nahi karta.

Is liye yeh command chalani hoti hai:

```bash
unalias ll
```

Ya terminal band karke naya terminal khol len.

---

## 8. Common Alias Examples

| Alias | Asal Command | Maqsad |
|---|---|---|
| `ll` | `ls -la` | Files ki detailed list |
| `la` | `ls -A` | `.` aur `..` ke ilawa hidden files dikhana |
| `c` | `clear` | Terminal saaf karna |
| `gs` | `git status` | Git status check karna |
| `ga` | `git add .` | Git mein tamam changes stage karna |
| `gc` | `git commit` | Git commit command ka shortcut |
| `gp` | `git pull` | Remote changes pull karna |
| `update` | `sudo apt update` | Package list update karna |
| `ports` | `ss -tulnp` | Listening ports dikhana |
| `myip` | `hostname -I` | System ka IP address dikhana |

---

## 9. Linux Practice Ke Alias Examples

### Misal 1: Date Alias

```bash
alias today='date'
```

Chalayen:

```bash
today
```

Yeh asal mein chalata hai:

```bash
date
```

### Misal 2: Clear Screen Alias

```bash
alias c='clear'
```

Chalayen:

```bash
c
```

Yeh terminal screen ko clear karega.

### Misal 3: Long Listing Alias

```bash
alias ll='ls -la'
```

Chalayen:

```bash
ll
```

Yeh hidden files samait detailed file list dikhayega.

### Misal 4: Git Status Alias

```bash
alias gs='git status'
```

Chalayen:

```bash
gs
```

Yeh chalata hai:

```bash
git status
```

### Misal 5: Update Alias

```bash
alias update='sudo apt update'
```

Chalayen:

```bash
update
```

Yeh chalata hai:

```bash
sudo apt update
```

---

## 10. Temporary Aur Permanent Alias Ka Farq

| Type | Kahan Kaam Karta Hai? | Kab Remove Hota Hai? |
|---|---|---|
| Temporary alias | Sirf current terminal mein | Terminal band hone par |
| Permanent alias | Har naye Bash terminal mein | `.bashrc` se remove karne tak |

---

## 11. Alias Kaise Kaam Karta Hai?

Bash command run karne se pehle alias naam ko uske text se replace karta hai.

Misal:

```bash
alias ll='ls -la'
```

Jab aap likhte hain:

```bash
ll /etc
```

Bash isay is tarah samajhta hai:

```bash
ls -la /etc
```

Alias asal `ls` command ko delete ya modify nahi karta; sirf shortcut banata hai.

---

## 12. Zaroori Notes

### Alias Current Shell Mein Kaam Karta Hai

Agar ek terminal mein temporary alias banaya hai, to woh doosre terminal mein nazar nahi ayega jab tak `~/.bashrc` mein save na ho.

### Alias Interactive Shell Ke Liye Behtar Hai

Aliases zyada tar interactive terminal use ke liye hote hain. Bash non-interactive scripts mein aliases ko default taur par expand nahi karta.

Automation ke liye function ya script use karen.

### Simple Kaam Ke Liye Alias

Achha alias:

```bash
alias ll='ls -la'
```

Complex kaam ke liye function ya script:

```bash
backup_project() {
    tar -czf backup.tar.gz project/
}
```

### `type` Se Naam Ki Asal Type Check Karen

`type` batata hai ke koi naam alias, function, shell builtin, ya external command hai:

```bash
type ll
type cd
type ls
```

### Ek Dafa Alias Ko Bypass Karna

Agar `ls` ka alias bana hua hai lekin ek dafa asal command chalani ho:

```bash
command ls
\ls
```

### Arguments Ki Flexible Position Ke Liye Function

Alias sirf text substitution karta hai. Agar argument ko command ke darmiyan ya mukhtalif jagah par use karna ho, to function behtar hai:

```bash
mkcd() {
    mkdir -p -- "$1" && cd -- "$1"
}
```

Chalayen:

```bash
mkcd practice
```

Yeh `practice` directory banayega aur us mein chala jayega.

---

## 13. Common Mistakes

### Ghalti 1: `=` Ke Aagay Peechay Spaces

Ghalat:

```bash
alias ll = 'ls -la'
```

Sahi:

```bash
alias ll='ls -la'
```

### Ghalti 2: Quotes Bhool Jana

Behtar:

```bash
alias ll='ls -la'
```

Is se parhez karen:

```bash
alias ll=ls -la
```

### Ghalti 3: `.bashrc` Ko Source Na Karna

Alias add karne ke baad:

```bash
source ~/.bashrc
```

Warna naya alias current terminal mein foran kaam nahi karega.

### Ghalti 4: Dangerous Alias Save Karna

Is tarah ke dangerous aliases se parhez karen:

```bash
alias delete='rm -rf /'
```

File delete karne wale aliases ke sath hamesha ehtiyat karen.

### Ghalti 5: Script Mein Alias Ki Umeed Karna

Bash script ke andar interactive alias par depend na karen. Script mein poori command ya function likhen.

### Ghalti 6: Important Command Ka Naam Be-Ehtiyati Se Reuse Karna

Alias kisi familiar command ke interactive behavior ko badal sakta hai. Pehle check karen:

```bash
type rm
alias rm
```

---

## 14. Safe Alias Examples

Kuch log beginners ke liye interactive safety aliases banate hain:

```bash
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
```

| Alias | Matlab |
|---|---|
| `rm -i` | Delete karne se pehle confirmation mangta hai |
| `cp -i` | Copy ke waqt overwrite se pehle poochta hai |
| `mv -i` | Move ke waqt overwrite se pehle poochta hai |

Yeh beginners ko ghalti se bachne mein madad de sakte hain.

> Scripts ko user's aliases par depend nahi karna chahiye. Script ke andar explicit options, validation, aur error handling use karen.

---

## 15. Teaching Flow

Alias ko is order mein parhayen:

```text
1. Alias kya hai?
2. Alias kyun chahiye?
3. Basic syntax
4. Temporary alias
5. Permanent alias
6. Alias check karna
7. Alias remove karna
8. Common examples
9. Practice task
10. Alias aur function ka farq
```

---

## 16. Class Demo

### Step 1: Temporary Alias Banayen

```bash
alias today='date'
```

### Step 2: Alias Chalayen

```bash
today
```

### Step 3: Alias Check Karen

```bash
alias today
type today
```

### Step 4: Alias Remove Karen

```bash
unalias today
```

### Step 5: Dobara Test Karen

```bash
today
```

Expected result:

```text
Command not found
```

---

## 17. Lab Task

Yeh temporary aliases banayen:

```bash
alias ll='ls -la'
alias c='clear'
alias h='history'
alias d='date'
alias p='pwd'
```

Phir chalayen:

```bash
ll
c
h
d
p
```

Tamam aliases check karen:

```bash
alias
```

Ek alias remove karen:

```bash
unalias d
```

Dobara check karen:

```bash
alias d
```

---

## 18. Homework

Yeh aliases `~/.bashrc` mein permanently add karen:

```bash
alias ll='ls -la'
alias gs='git status'
alias c='clear'
alias today='date'
alias ports='ss -tulnp'
```

`.bashrc` reload karen:

```bash
source ~/.bashrc
```

Har alias ko test karen.

Extra test:

1. `ll` ki line `.bashrc` se delete karen.
2. `source ~/.bashrc` chalayen.
3. Dekhen kya `ll` abhi bhi current shell mein active hai.
4. `unalias ll` chala kar dobara test karen.
5. Apne alfaaz mein result ki wajah likhen.

---

## 19. Practice Questions

1. Alias kya hota hai?
2. Hum aliases kyun use karte hain?
3. Alias ka basic syntax kya hai?
4. Temporary aur permanent alias mein kya farq hai?
5. Permanent aliases kis file mein save hote hain?
6. Tamam aliases kaise check karte hain?
7. Kisi ek alias ko kaise check karte hain?
8. Alias ko current shell se kaise remove karte hain?
9. `source ~/.bashrc` kya karta hai?
10. Dangerous aliases se kyun bachna chahiye?
11. Alias line delete karne ke baad alias active kyun reh sakta hai?
12. `type` command kya batati hai?
13. Ek command ke liye alias ko temporarily bypass kaise karte hain?
14. Arguments ki flexible placement ke liye function kyun behtar hai?
15. Bash script ko interactive aliases par depend kyun nahi karna chahiye?

---

## Final Summary

Alias kisi Linux ya Bash command ka shortcut naam hota hai.

Misal:

```bash
alias ll='ls -la'
```

Ab:

```bash
ll
```

Yeh command chalayega:

```bash
ls -la
```

Temporary alias sirf current terminal session mein kaam karta hai.

Permanent alias ko is file mein save karen:

```bash
~/.bashrc
```

Phir file reload karen:

```bash
source ~/.bashrc
```

Alias remove karne ke liye:

```bash
unalias alias_name
```

Sab se behtar one-line definition:

```text
Alias Linux/Bash command ka shortcut naam hota hai.
```

Yaad rakhen:

```text
Simple interactive shortcut ke liye alias use karen.
Logic, arguments, validation, aur automation ke liye function ya script use karen.
```

