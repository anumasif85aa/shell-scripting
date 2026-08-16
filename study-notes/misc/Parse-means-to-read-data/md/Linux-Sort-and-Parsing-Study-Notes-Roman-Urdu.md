# Linux `sort` Command aur Parsing — Roman Urdu Study Notes

## Learning objectives

In notes ko parhne ke baad aap:

- `sort` command ka purpose samjha sakenge.
- Text ko alphabetically, numerically aur reverse order mein sort kar sakenge.
- Ek ya multiple field keys ke zariye records sort kar sakenge.
- Custom delimiters aur specialized comparison modes use kar sakenge.
- Duplicate records remove ya count kar sakenge.
- Headings, locale, stable sorting aur output files ko safely handle kar sakenge.
- Linux Administrator pipelines mein `sort` use kar sakenge.

---

## 1. `sort` kya hai?

`sort` ek Linux text-processing command hai jo lines ko required order mein arrange karti hai.

Yeh data ko sort kar sakti hai:

- Alphabetically
- Numerically
- Reverse order mein
- Specific field ke mutabiq
- Month name ke mutabiq
- Human-readable size ke mutabiq
- Version number ke mutabiq
- Duplicate records remove karte hue

Asaan alfaaz mein:

> `sort` records ko parhta hai, un ka comparison karta hai aur unhein requested order mein display karta hai.

`sort` kisi phrase ka short form nahi hai. Isay `sort` is liye kehte hain kyun ke yeh data arrange karta hai.

---

## 2. Kya `sort` parsing command hai?

`sort` mainly ordering command hai, lekin parsing aur text-processing pipelines mein commonly use hoti hai. Yeh:

- Fields ko pehchan sakti hai.
- Delimiter use kar sakti hai.
- Field ko sorting key bana sakti hai.
- Numeric ya textual values compare kar sakti hai.
- Duplicate records remove kar sakti hai.
- Reporting ke liye data prepare kar sakti hai.

Yeh aam tor par fields extract ya modify nahi karti.

```text
grep = lines search ya filter karna
cut  = simple fields extract karna
awk  = parse, calculate aur format karna
sed  = text edit aur transform karna
sort = records ko order mein arrange karna
```

---

## 3. Basic syntax aur behavior

```bash
sort [OPTIONS] [FILE]
```

Agar file na di jaye to `sort` standard input parhti hai:

```bash
printf '%s\n' banana apple mango | sort
```

Output:

```text
apple
banana
mango
```

Processing model:

```text
Input records → comparison → ordered output
```

Default tor par original file modify nahi hoti.

---

## 4. Practice file banana

```bash
cat > servers.txt <<'EOF'
web01 running 25
web02 stopped 80
db01 running 65
app01 running 10
EOF
```

> Redirection operator `>` here-document ka content `servers.txt` mein save karta hai. Aakhri `EOF` apni line par akela hona chahiye.

---

## 5. Default aur reverse sorting

### Default sorting

```bash
sort servers.txt
```

Output:

```text
app01 running 10
db01 running 65
web01 running 25
web02 stopped 80
```

Poori lines ko un ke shuru se compare kiya jata hai.

### `-r` se reverse sorting

```bash
sort -r servers.txt
```

Output:

```text
web02 stopped 80
web01 running 25
db01 running 65
app01 running 10
```

---

## 6. `-n` se numeric sorting

Maan lein `numbers.txt` mein yeh data hai:

```text
5
100
25
8
```

Normal text sorting:

```bash
sort numbers.txt
```

Possible output:

```text
100
25
5
8
```

Yahan values ko text ke tor par compare kiya ja raha hai. Numeric sorting use karein:

```bash
sort -n numbers.txt
```

Output:

```text
5
8
25
100
```

### Reverse numeric sorting

```bash
sort -nr numbers.txt
```

Output:

```text
100
25
8
5
```

Options combine kiye ja sakte hain:

```text
-n  = numeric
-r  = reverse
-nr = reverse numeric
```

---

## 7. `-k` se field ke mutabiq sorting

`servers.txt` mein fields:

| Field | Information |
|---:|---|
| 1 | Server name |
| 2 | Status |
| 3 | Usage value |

### Field 2 ke mutabiq sort karna

```bash
sort -k2,2 servers.txt
```

`-k2,2` ka matlab:

- Key field 2 se shuru karo.
- Key field 2 par khatam karo.
- Sirf field 2 compare karo.

`-k2` akela field 2 se record ke aakhir tak key banata hai. Sirf ek exact field ke liye `-k2,2` prefer karein.

### Field 3 ko numerically sort karna

```bash
sort -k3,3n servers.txt
```

Output:

```text
app01 running 10
web01 running 25
db01 running 65
web02 stopped 80
```

Yeh bhi likh sakte hain:

```bash
sort -n -k3,3 servers.txt
```

### Field 3 ko reverse numeric sort karna

```bash
sort -k3,3nr servers.txt
```

Output:

```text
web02 stopped 80
db01 running 65
web01 running 25
app01 running 10
```

---

## 8. Multiple sorting keys

Pehle status aur phir usage ke mutabiq numeric sort karein:

```bash
sort -k2,2 -k3,3n servers.txt
```

Pehli key primary key hoti hai. Doosri key un records ka order decide karti hai jin ki primary keys equal hon.

Example result:

```text
app01 running 10
web01 running 25
db01 running 65
db02 stopped 30
web02 stopped 80
```

---

## 9. `-t` se delimiter use karna

Maan lein `servers-colon.txt` mein:

```text
web01:running:25
web02:stopped:80
db01:running:65
app01:running:10
```

Field 3 ke mutabiq numeric sort:

```bash
sort -t: -k3,3n servers-colon.txt
```

Output:

```text
app01:running:10
web01:running:25
db01:running:65
web02:stopped:80
```

Breakdown:

| Hissa | Matlab |
|---|---|
| `-t:` | `:` ko field separator banao |
| `-k3,3` | Sirf field 3 key hai |
| `n` | Key ko numerically compare karo |

Yeh bhi likh sakte hain:

```bash
sort -t ':' -k3,3n servers-colon.txt
```

`-t` ko diya gaya separator aam tor par ek character hota hai.

---

## 10. `/etc/passwd` ko parse karna

`/etc/passwd` colon delimiter use karta hai:

```text
ali:x:1001:1001:Ali Khan:/home/ali:/bin/bash
```

| Field | Information |
|---:|---|
| 1 | Username |
| 3 | UID |
| 4 | GID |
| 6 | Home directory |
| 7 | Login shell |

### Username ke mutabiq sort karna

```bash
sort -t: -k1,1 /etc/passwd
```

### UID ke mutabiq numeric sort karna

```bash
sort -t: -k3,3n /etc/passwd
```

### Sorting ke baad usernames aur UIDs display karna

```bash
sort -t: -k3,3n /etc/passwd |
awk -F: '{print $1, $3}'
```

Processing flow:

```text
/etc/passwd → numeric UID ke mutabiq sort → awk username aur UID display karta hai
```

---

## 11. `-u` se duplicate records remove karna

Maan lein `colors.txt` mein:

```text
red
blue
red
green
blue
```

```bash
sort -u colors.txt
```

Output:

```text
blue
green
red
```

`sort -u` data sort karta hai aur equal comparison keys ke liye ek record output karta hai.

Yeh pipeline bhi kaam karti hai:

```bash
sort colors.txt | uniq
```

### `sort -u` aur `uniq` ka farq

`uniq` sirf paas paas maujood duplicate records remove karta hai. Unsorted duplicates reh sakte hain.

Use karein:

```bash
sort colors.txt | uniq
```

ya:

```bash
sort -u colors.txt
```

### Repeated values count karna

```bash
sort colors.txt | uniq -c
```

Sab se zyada count ko pehle dikhana:

```bash
sort colors.txt |
uniq -c |
sort -nr
```

---

## 12. Case, blanks aur specialized comparisons

### `-f` se letter case ignore karna

```bash
sort -f names.txt
```

`-f` comparison ke waqt lowercase letters ko uppercase equivalents ke saath treat karta hai.

### `-b` se leading blanks ignore karna

```bash
sort -b fruits.txt
```

Yeh comparison ke waqt leading spaces aur tabs ignore karta hai.

### `-h` se human-readable sizes sort karna

Data:

```text
900K
2G
50M
1G
```

Command:

```bash
sort -h sizes.txt
```

Output:

```text
900K
50M
1G
2G
```

Sab se bara pehle:

```bash
sort -hr sizes.txt
```

Example:

```bash
du -h /var/log/* 2>/dev/null | sort -hr
```

### `-M` se month names sort karna

```bash
sort -M months.txt
```

`Mar`, `Jan`, `Dec`, `Feb` ka result:

```text
Jan
Feb
Mar
Dec
```

### `-V` se version numbers sort karna

```bash
sort -V versions.txt
```

Data:

```text
app-1.2
app-1.10
app-1.3
app-2.0
```

Result:

```text
app-1.2
app-1.3
app-1.10
app-2.0
```

### `-g` se general numeric comparison

```bash
printf '%s\n' 1e3 25 4.5 2e2 | sort -g
```

Output:

```text
4.5
25
2e2
1e3
```

Normal integers aur decimals ke liye `-n` aam tor par kafi hai.

---

## 13. Check karna ke input sorted hai ya nahi

`-c` use karein:

```bash
sort -c names.txt
```

Agar file correctly sorted ho to command aam tor par koi output nahi deta aur exit status `0` return karta hai.

Status check karein:

```bash
sort -c names.txt
echo $?
```

Quiet check ke liye `-C`:

```bash
sort -C names.txt
```

---

## 14. Sorted output safely save karna

### Doosri file mein redirect karna

```bash
sort names.txt > sorted-names.txt
```

### `-o` use karna

```bash
sort names.txt -o sorted-names.txt
```

### Input file ko safely replace karna

Yeh use na karein:

```bash
sort names.txt > names.txt
```

Shell, `sort` ke file parhne se pehle `names.txt` ko empty kar sakta hai.

Use karein:

```bash
sort names.txt -o names.txt
```

Important file ka pehle backup banayein:

```bash
cp names.txt names.txt.bak
sort names.txt -o names.txt
```

---

## 15. `-s` se stable sorting

Jab selected keys equal hon to `sort` baqi line ko final comparison ke liye use kar sakta hai.

```bash
sort -s -k2,2 records.txt
```

`-s` is last-resort comparison ko band karta hai aur equal keys wale records ka original order preserve karta hai.

---

## 16. Heading preserve karke data sort karna

Maan lein `employees.txt` mein:

```text
Name Department Salary
Khalid IT 75000
Ali DevOps 90000
Sara Cloud 85000
```

Heading ko rakhein aur sirf data sort karein:

```bash
{
    head -n 1 employees.txt
    tail -n +2 employees.txt | sort -k3,3n
}
```

Output:

```text
Name Department Salary
Khalid IT 75000
Sara Cloud 85000
Ali DevOps 90000
```

---

## 17. Locale aur sorting order

Sorting behavior current locale par depend kar sakta hai. Uppercase, lowercase, punctuation aur language-specific characters ka order mukhtalif ho sakta hai.

Locale check karein:

```bash
locale
```

Predictable byte-based order ke liye:

```bash
LC_ALL=C sort names.txt
```

Yeh scripts, tests, comparisons aur reproducible reports mein useful hai.

---

## 18. Key syntax samajhna

General form:

```text
-k START_FIELD,END_FIELD
```

Examples:

```bash
# Sirf field 2
sort -k2,2 file

# Field 2 se field 3 tak
sort -k2,3 file

# Sirf field 3, numeric comparison
sort -k3,3n file

# Field 2 primary; field 3 reverse numeric secondary
sort -k2,2 -k3,3nr file
```

Ek exact field ke liye start aur end field numbers dono dein.

---

## 19. Linux Administrator examples

### Sab se bari directories pehle

```bash
du -h /var/* 2>/dev/null |
sort -hr |
head
```

### Sab se zyada CPU use karne wale processes pehle

```bash
ps -eo user,pid,comm,%cpu --no-headers |
sort -k4,4nr |
head
```

### Sab se zyada memory use karne wale processes pehle

```bash
ps -eo user,pid,comm,%mem --no-headers |
sort -k4,4nr |
head
```

### Common login shells count karna

```bash
getent passwd |
cut -d: -f7 |
sort |
uniq -c |
sort -nr
```

### Log ki pehli client field count karna

Agar pehli whitespace-separated field client address ho:

```bash
awk '{print $1}' access.log |
sort |
uniq -c |
sort -nr |
head
```

Field 1 ko IP samajhne se pehle log format verify karein.

### Sab se bari log files pehle

```bash
find /var/log -type f -printf '%s %p\n' 2>/dev/null |
sort -k1,1nr |
head
```

---

## 20. Parsing pipelines

### Running servers ko usage ke mutabiq order karna

```bash
awk '$2 == "running" {print}' servers.txt |
sort -k3,3n
```

### Sorting ke baad sirf server names display karna

```bash
sort -k3,3n servers.txt |
awk '{print $1}'
```

### Whitespace transform karke colon-delimited field sort karna

```bash
sed -E 's/[[:space:]]+/:/g' servers.txt |
sort -t: -k3,3n
```

Processing flow:

```text
Input → sed delimiters transform karta hai → sort numeric field 3 arrange karta hai → output
```

---

## 21. Important options

| Option | Purpose |
|---|---|
| `-r` | Result reverse karta hai |
| `-n` | Numeric comparison |
| `-h` | Human-readable number comparison |
| `-g` | General numeric comparison |
| `-M` | Month comparison |
| `-V` | Version comparison |
| `-f` | Comparison mein letter case ignore karta hai |
| `-b` | Leading blanks ignore karta hai |
| `-u` | Har equal key ke liye ek record output karta hai |
| `-t` | Field separator set karta hai |
| `-k` | Sorting keys define karta hai |
| `-c` | Order check karke disorder report karta hai |
| `-C` | Quietly order check karta hai |
| `-o` | Result file mein likhta hai |
| `-s` | Stable sorting use karta hai |

---

## 22. Common mistakes

### Mistake 1: Numbers ko text ke tor par sort karna

```bash
sort numbers.txt
```

Correct:

```bash
sort -n numbers.txt
```

### Mistake 2: Incomplete key use karna

Yeh field 3 se record ke aakhir tak key banata hai:

```bash
sort -k3 file.txt
```

Sirf field 3 ke liye:

```bash
sort -k3,3 file.txt
```

### Mistake 3: Numeric comparison bhoolna

```bash
sort -k3,3 servers.txt
```

Correct:

```bash
sort -k3,3n servers.txt
```

### Mistake 4: Redirection se input overwrite karna

Risky:

```bash
sort file.txt > file.txt
```

Correct:

```bash
sort file.txt -o file.txt
```

### Mistake 5: Input file ke change hone ki umeed

```bash
sort names.txt
```

Yeh sirf ordered output display karta hai. Doosri file mein redirect karein ya `-o` use karein.

### Mistake 6: Locale differences ignore karna

Predictable order ke liye:

```bash
LC_ALL=C sort file.txt
```

---

## 23. `sort` use karne se pehle thinking process

Yeh sawalat poochhein:

1. Ek record kaisa hai?
2. Poori line sort karni hai ya specific field?
3. Delimiter kya hai?
4. Key textual, numeric, human-readable, month ya version hai?
5. Order ascending hona chahiye ya descending?
6. Duplicates allowed hain?
7. Input mein heading hai?
8. Kya locale-independent behavior chahiye?
9. Result sirf display karna hai ya save bhi karna hai?

Basic flow:

```text
Input → delimiter → sorting key → comparison type → order → output
```

Example:

```bash
sort -t: -k3,3nr servers-colon.txt
```

Breakdown:

- Input: `servers-colon.txt`
- Delimiter: `:`
- Key: Sirf field 3
- Comparison: Numeric
- Order: Reverse, yani highest pehle

---

## 24. Practice lab

File banayein:

```bash
cat > employees.txt <<'EOF'
104:Ahmed:Support:Chicago:65000
102:Ali:DevOps:Dallas:90000
101:Khalid:Linux:Chicago:75000
103:Sara:Cloud:Houston:85000
105:Zain:Support:Chicago:65000
EOF
```

Yeh tasks complete karein:

1. Complete records alphabetically sort karein.
2. Employees ko name ke mutabiq sort karein.
3. Salaries lowest se highest sort karein.
4. Salaries highest se lowest sort karein.
5. City aur phir name ke mutabiq sort karein.
6. Department aur phir salary descending order mein sort karein.
7. Unique department names display karein.
8. Har city ke employees count karein.
9. Salary-sorted output doosri file mein save karein.
10. Check karein ke original file employee ID ke mutabiq sorted hai ya nahi.
11. Teen highest-paid employees display karein.
12. Equal salaries ka original order preserve karte hue salary sort karein.

### Solutions

```bash
# 1. Complete records sort karna
sort employees.txt

# 2. Name ke mutabiq sort
sort -t: -k2,2 employees.txt

# 3. Salary: lowest se highest
sort -t: -k5,5n employees.txt

# 4. Salary: highest se lowest
sort -t: -k5,5nr employees.txt

# 5. City, phir name
sort -t: -k4,4 -k2,2 employees.txt

# 6. Department, phir salary descending
sort -t: -k3,3 -k5,5nr employees.txt

# 7. Unique departments
cut -d: -f3 employees.txt | sort -u

# 8. Har city ka employee count
cut -d: -f4 employees.txt |
sort |
uniq -c |
sort -nr

# 9. Salary-sorted output save karna
sort -t: -k5,5n employees.txt > employees-by-salary.txt

# 10. Numeric ID order check karna
sort -t: -k1,1n -c employees.txt

# 11. Teen highest-paid employees
sort -t: -k5,5nr employees.txt | head -n 3

# 12. Stable salary sort
sort -s -t: -k5,5n employees.txt
```

---

## 25. Quick knowledge check

1. Kya `sort` kisi cheez ka short form hai?
2. `sort` default tor par kya karta hai?
3. Normal sorting numbers ke liye unexpected result kyun de sakti hai?
4. `-n` aur `-r` ka kya matlab hai?
5. `-k3` aur `-k3,3` mein kya farq hai?
6. `-t:` kya karta hai?
7. `sort -u` kya karta hai?
8. `uniq` ko aksar sorted input kyun chahiye hota hai?
9. `-h`, `-M` aur `-V` kab use karne chahiye?
10. `sort -c` kya check karta hai?
11. `sort file > file` kyun use nahi karna chahiye?
12. Stable sorting kya hai?
13. `LC_ALL=C` kyun useful ho sakta hai?
14. `sort`, `grep`, `cut`, `awk` aur `sed` se kaise mukhtalif hai?

---

## 26. Quick reference

```bash
# Alphabetical sorting
sort file

# Reverse sorting
sort -r file

# Numeric sorting
sort -n file

# Reverse numeric sorting
sort -nr file

# Exact field 2 ke mutabiq sort
sort -k2,2 file

# Field 3 ko numerically sort
sort -k3,3n file

# Colon-separated numeric field sort
sort -t: -k3,3n file

# Multiple keys
sort -k2,2 -k3,3n file

# Duplicate records remove karna
sort -u file

# Letter case ignore karna
sort -f file

# Human-readable sizes
sort -h file

# Month names
sort -M file

# Version numbers
sort -V file

# Check karna ke input sorted hai
sort -c file

# Output safely save karna
sort file -o sorted-file

# Stable sorting
sort -s -k2,2 file

# Predictable byte-based order
LC_ALL=C sort file
```

## Final summary

`sort` text records ko requested order mein arrange karta hai. Yeh complete records ya selected fields ko alphabetical, numeric, reverse, human-readable, month ya version comparison se sort kar sakta hai.

Yaad rakhein:

```text
grep = lines search ya filter karna
cut  = simple fields extract karna
awk  = parse, calculate aur format karna
sed  = text edit aur transform karna
sort = records ko order mein arrange karna
```
