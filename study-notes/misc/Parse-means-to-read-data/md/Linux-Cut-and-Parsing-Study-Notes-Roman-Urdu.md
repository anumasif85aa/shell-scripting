# Linux `cut` Command aur Parsing — Roman Urdu Study Notes

## Learning objectives

In notes ko parhne ke baad aap:

- Parsing ko asaan alfaaz mein samjha sakenge.
- Structured text mein delimiters aur fields ko pehchan sakenge.
- `cut` se fields, characters aur bytes nikal sakenge.
- Files aur piped command output ko parse kar sakenge.
- Yeh faisla kar sakenge ke `cut` kab aur `awk` kab use karna hai.

---

## 1. Parsing kya hai?

**Parsing** ka matlab structured data ko parhna aur usay useful hisson mein alag karna hai.

Is record ko dekhein:

```text
khalid:LinuxAdmin:Chicago
```

Colon (`:`) is record ko teen fields mein divide kar raha hai:

| Field number | Value |
|---:|---|
| 1 | `khalid` |
| 2 | `LinuxAdmin` |
| 3 | `Chicago` |

Yahan `:` ko **delimiter** kehte hain.

### Zaroori terms

- **Input:** Asal text ya data jis par kaam kiya ja raha ho.
- **Delimiter:** Woh character jo fields ko ek doosre se alag karta hai.
- **Field:** Structured record ka ek hissa.
- **Parsing:** Input ko alag ya analyze karke useful information hasil karna.

---

## 2. `cut` command kya hai?

Linux ki `cut` command input ki har line se selected fields, characters ya bytes nikalti hai.

### Basic syntax

```bash
cut OPTION FILE
```

Yeh pipe ke through milne wale output ko bhi process kar sakti hai:

```bash
command | cut OPTION
```

### Common options

| Option | Kaam |
|---|---|
| `-d` | Field delimiter define karta hai |
| `-f` | Ek ya zyada fields select karta hai |
| `-c` | Position ke mutabiq characters select karta hai |
| `-b` | Position ke mutabiq bytes select karta hai |
| `--complement` | Di hui fields ya positions ke ilawa baqi sab select karta hai |
| `-s` | Un lines ko display nahi karta jin mein delimiter maujood na ho |
| `--output-delimiter` | Output mein nazar aane wala delimiter badalta hai |

> Aam tor par `-d` aur `-f` ko saath use kiya jata hai.

---

## 3. `/etc/passwd` ko samajhna

`/etc/passwd` file basic user-account information rakhti hai. Is ke fields colon se separate hote hain.

Example record:

```text
ali:x:1001:1001:Ali Khan:/home/ali:/bin/bash
```

| Field | Matlab | Example |
|---:|---|---|
| 1 | Username | `ali` |
| 2 | Password placeholder | `x` |
| 3 | User ID (UID) | `1001` |
| 4 | Primary group ID (GID) | `1001` |
| 5 | User information/comment | `Ali Khan` |
| 6 | Home directory | `/home/ali` |
| 7 | Login shell | `/bin/bash` |

### Usernames display karna

```bash
cut -d: -f1 /etc/passwd
```

Isi command ko zyada clear tarike se yun bhi likh sakte hain:

```bash
cut -d ':' -f 1 /etc/passwd
```

### Command breakdown

| Hissa | Matlab |
|---|---|
| `cut` | Command run karta hai |
| `-d ':'` | Colon ko delimiter banata hai |
| `-f 1` | Pehli field select karta hai |
| `/etc/passwd` | Input file hai |

Asaan alfaaz mein:

> `/etc/passwd` ki har line ko parho, har colon par line ko divide karo aur pehli field display karo.

Example output:

```text
root
daemon
ali
```

---

## 4. Fields select karna

### Sirf ek field select karna

Login shells display karein:

```bash
cut -d: -f7 /etc/passwd
```

### Multiple fields select karna

Usernames aur login shells display karein:

```bash
cut -d: -f1,7 /etc/passwd
```

Example output:

```text
root:/bin/bash
daemon:/usr/sbin/nologin
ali:/bin/bash
```

### Fields ki range select karna

Field 1 se field 3 tak display karein:

```bash
cut -d: -f1-3 /etc/passwd
```

### Ek field se aakhir tak select karna

Field 3 aur us ke baad tamam fields display karein:

```bash
cut -d: -f3- /etc/passwd
```

### Shuru se ek field tak select karna

Field 1 se field 4 tak display karein:

```bash
cut -d: -f-4 /etc/passwd
```

### Ek field ke ilawa sab select karna

Field 2 ke ilawa tamam fields display karein:

```bash
cut -d: -f2 --complement /etc/passwd
```

---

## 5. Pipe se milne wale text ko parse karna

Pipe operator (`|`) ek command ka output doosri command ko input ke tor par deta hai.

### Example 1: Job title nikalna

```bash
echo "khalid:LinuxAdmin:Chicago" | cut -d: -f2
```

Output:

```text
LinuxAdmin
```

### Example 2: Server name aur status nikalna

```bash
echo "server01,running,75" | cut -d, -f1,2
```

Output:

```text
server01,running
```

### Example 3: `@` se pehle login name nikalna

```bash
echo "khalid@server01" | cut -d@ -f1
```

Output:

```text
khalid
```

---

## 6. `-c` se characters nikalna

Jab fields ke bajaye character positions ke mutabiq text chahiye ho to `-c` use karein.

### Pehla character select karna

```bash
echo "LinuxAdmin" | cut -c1
```

Output:

```text
L
```

### Character 1 se 5 tak select karna

```bash
echo "LinuxAdmin" | cut -c1-5
```

Output:

```text
Linux
```

### Character 6 se aakhir tak select karna

```bash
echo "LinuxAdmin" | cut -c6-
```

Output:

```text
Admin
```

### Alag alag character positions select karna

```bash
echo "LinuxAdmin" | cut -c1,6
```

Output:

```text
LA
```

---

## 7. `-b` se bytes nikalna

Position ke mutabiq bytes select karne ke liye `-b` use karein:

```bash
echo "Linux" | cut -b1-3
```

Output:

```text
Lin
```

Normal English text mein character aur byte positions aksar ek jaisi lagti hain. Unicode ke multibyte characters mein dono mukhtalif ho sakti hain.

---

## 8. Output delimiter badalna

Selected fields aam tor par asal delimiter ke saath display hoti hain:

```bash
cut -d: -f1,7 /etc/passwd
```

Output separator badalne ke liye `--output-delimiter` use karein:

```bash
cut -d: -f1,7 --output-delimiter=' -> ' /etc/passwd
```

Example output:

```text
root -> /bin/bash
ali -> /bin/bash
```

---

## 9. Practical server-data example

Here-document se practice file sahi tarike se banayein:

```bash
cat > servers.txt <<'EOF'
web01:running:25
web02:stopped:80
db01:running:65
EOF
```

> `>` here-document ke content ko `servers.txt` mein redirect karta hai. Aakhri `EOF` apni line par akela hona chahiye.

Server names display karein:

```bash
cut -d: -f1 servers.txt
```

Server status display karein:

```bash
cut -d: -f2 servers.txt
```

Server names aur usage values display karein:

```bash
cut -d: -f1,3 servers.txt
```

Output separator badlein:

```bash
cut -d: -f1,2 --output-delimiter=' | ' servers.txt
```

---

## 10. `cut` ki important limitations

### Limitation 1: Sirf ek delimiter character

`-d` ke saath diya gaya field delimiter sirf ek character hona chahiye.

Valid:

```bash
cut -d: -f1 file.txt
```

`::` jaisa multi-character delimiter seedha `cut -d` ke liye suitable nahi hai.

### Limitation 2: Repeated spaces empty fields banati hain

Is data ko dekhein:

```text
web01 running 25
web02    stopped 80
```

Yeh command inconsistent result de sakti hai:

```bash
cut -d' ' -f2 servers.txt
```

Har space ko alag delimiter samjha jata hai. Is liye repeated spaces empty fields bana deti hain.

Whitespace-separated data ke liye `awk` zyada behtar hai:

```bash
awk '{print $2}' servers.txt
```

`awk` default tor par lagatar spaces ko ek separator samajhta hai.

### Limitation 3: `cut` complex conditions nahi samajhta

`cut` simple extraction ke liye bohat achha hai, lekin yeh advanced filtering, calculations ya field-based conditions ke liye nahi bana.

---

## 11. `cut` aur `awk` ka muqabla

| Requirement | Behtar tool |
|---|---|
| Consistent single-character delimiter se fields nikalna | `cut` |
| Fixed character positions nikalna | `cut` |
| Inconsistent ya repeated whitespace process karna | `awk` |
| Fields par conditions lagana | `awk` |
| Calculations karna | `awk` |
| Complex records ko reformat karna | `awk` |

Examples:

```bash
# Colon delimiter consistent hai, is liye cut simple aur suitable hai
cut -d: -f1 /etc/passwd

# Spaces ki tadaad mukhtalif ho sakti hai, is liye awk reliable hai
awk '{print $2}' servers.txt
```

---

## 12. `cut` use karne se pehle thinking process

Yeh sequence follow karein:

1. Input data ko dhyan se dekhein.
2. Delimiter identify karein.
3. Fields ko left se right count karein.
4. Faisla karein ke kaunsi field ya fields chahiye.
5. `cut` command banayein aur test karein.

Formula:

```text
Input → delimiter → field number → extracted result
```

Example:

```bash
cut -d: -f1 /etc/passwd
```

- Input: `/etc/passwd`
- Delimiter: `:`
- Required field: `1`
- Result: usernames

---

## 13. Practice lab

Lab file banayein:

```bash
cat > employees.csv <<'EOF'
101,Khalid,Linux Administrator,Chicago
102,Ali,DevOps Engineer,Dallas
103,Sara,Cloud Engineer,Houston
EOF
```

Yeh tasks complete karein:

1. Sirf employee IDs display karein.
2. Sirf employee names display karein.
3. Names aur job titles display karein.
4. Field 2 se field 4 tak display karein.
5. Employee ID ke ilawa tamam fields display karein.
6. Names aur cities ko ` -> ` se separate karke display karein.

### Solutions

```bash
# 1. Employee IDs
cut -d, -f1 employees.csv

# 2. Employee names
cut -d, -f2 employees.csv

# 3. Names aur job titles
cut -d, -f2,3 employees.csv

# 4. Field 2 se field 4 tak
cut -d, -f2-4 employees.csv

# 5. Employee ID ke ilawa sab kuch
cut -d, -f1 --complement employees.csv

# 6. Names aur cities naye output separator ke saath
cut -d, -f2,4 --output-delimiter=' -> ' employees.csv
```

---

## 14. Quick knowledge check

1. Parsing kya hoti hai?
2. Delimiter kya hota hai?
3. `cut` mein fields select karne ke liye kaunsa option use hota hai?
4. Delimiter define karne ke liye kaunsa option use hota hai?
5. `-f1,7` kya select karta hai?
6. `-f3-` kya select karta hai?
7. `-c1-5` kya select karta hai?
8. Repeated spaces ke saath `cut -d' '` unreliable kyun ho sakta hai?
9. `awk`, `cut` se kab zyada suitable hota hai?
10. `cut -d: -f1 /etc/passwd` ko asaan alfaaz mein explain karein.

---

## 15. Quick reference

```bash
# Ek field
cut -d: -f1 file

# Multiple fields
cut -d: -f1,3 file

# Field range
cut -d: -f1-3 file

# Ek field se aakhir tak
cut -d: -f3- file

# Shuru se ek field tak
cut -d: -f-3 file

# Ek field ko exclude karna
cut -d: -f2 --complement file

# Characters select karna
cut -c1-5 file

# Piped output parse karna
echo "one:two:three" | cut -d: -f2

# Output delimiter badalna
cut -d: -f1,3 --output-delimiter=' | ' file
```

## Final summary

`cut` ek simple Linux text-processing command hai jo input ki har line se fields, characters ya bytes nikalti hai. Yeh us waqt behtareen kaam karti hai jab input ki structure consistent ho aur ek clear single-character delimiter maujood ho. Agar data mein inconsistent spaces hon ya conditions aur calculations ki zaroorat ho, to aam tor par `awk` zyada behtar tool hai.
