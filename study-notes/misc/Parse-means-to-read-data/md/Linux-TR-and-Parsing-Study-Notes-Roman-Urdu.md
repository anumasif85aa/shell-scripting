# Linux `tr` Command aur Parsing — Roman Urdu Study Notes

## Learning objectives

In notes ko parhne ke baad aap:

- Samjha sakenge ke `tr` character-processing command hai.
- Ek character set ko doosre character set mein translate kar sakenge.
- Selected characters ko delete aur repeated characters ko squeeze kar sakenge.
- POSIX character classes istemal kar sakenge.
- Delimiters, whitespace, line endings aur mixed text ko clean kar sakenge.
- Input redirection aur pipelines ko sahi tarah use kar sakenge.
- Linux Administrator ke workflows mein `tr` ko safely use kar sakenge.

---

## 1. `tr` kya hai?

`tr` ka matlab hai:

```text
Translate
```

Is command ko in kaamon ke liye use kiya jata hai:

- Characters ke ek group ko doosre group mein translate karna.
- Selected characters delete karna.
- Repeated characters ko squeeze karna.
- Uppercase aur lowercase letters convert karna.
- Delimiters change karna.
- Text ko clean aur normalize karna.

Asaan alfaaz mein:

> `tr` text ko character by character parhta hai aur selected characters ko translate, delete ya squeeze karta hai.

---

## 2. Kya `tr` parsing command hai?

`tr` parsing aur data-cleaning pipelines ka hissa ban sakta hai, lekin yeh AWK ki tarah field parser nahi hai. Yeh individual characters process karta hai.

```text
Input → character set → tr operation → transformed output
```

```text
grep = lines search karta hai
cut  = fields extract karta hai
awk  = fields parse aur calculations karta hai
sed  = patterns ki madad se text edit karta hai
sort = records ko arrange karta hai
uniq = paas paas maujood duplicate lines process karta hai
tr   = characters translate, delete ya squeeze karta hai
```

---

## 3. Input ka important behavior

`tr` aam tor par standard input se data parhta hai. Yeh input filename ko regular argument ke tor par accept nahi karta.

Sahi:

```bash
tr 'a-z' 'A-Z' < file.txt
```

Yeh bhi sahi hai:

```bash
cat file.txt | tr 'a-z' 'A-Z'
```

Ghalat:

```bash
tr 'a-z' 'A-Z' file.txt
```

Preferred form:

```bash
tr 'a-z' 'A-Z' < file.txt
```

Is form mein extra `cat` process ki zaroorat nahi hoti.

---

## 4. Basic syntax aur mapping

```bash
tr [OPTIONS] SET1 [SET2]
```

| Hissa | Matlab |
|---|---|
| `tr` | Command run karta hai |
| `SET1` | Woh characters jinhein find karna hai |
| `SET2` | Replacement characters |
| `OPTIONS` | Delete, squeeze ya complement controls |

Example:

```bash
echo "abc" | tr 'abc' '123'
```

Output:

```text
123
```

Mapping:

| SET1 | SET2 |
|---|---|
| `a` | `1` |
| `b` | `2` |
| `c` | `3` |

Yani `a` ki jagah `1`, `b` ki jagah `2`, aur `c` ki jagah `3` aayega.

---

## 5. Letter case convert karna

### Lowercase se uppercase

```bash
echo "linux administrator" |
tr 'a-z' 'A-Z'
```

Character-class wala preferred form:

```bash
echo "linux administrator" |
tr '[:lower:]' '[:upper:]'
```

### Uppercase se lowercase

```bash
echo "LINUX ADMINISTRATOR" |
tr '[:upper:]' '[:lower:]'
```

Output:

```text
linux administrator
```

---

## 6. Common POSIX character classes

| Character class | Matlab |
|---|---|
| `[:lower:]` | Lowercase letters |
| `[:upper:]` | Uppercase letters |
| `[:alpha:]` | Alphabetic characters |
| `[:digit:]` | Digits yani numbers |
| `[:alnum:]` | Letters aur digits |
| `[:space:]` | Tamam whitespace, newlines bhi |
| `[:blank:]` | Spaces aur tabs |
| `[:punct:]` | Punctuation marks |
| `[:print:]` | Printable characters |
| `[:cntrl:]` | Control characters |

Character classes ko quotes mein likhein:

```bash
tr '[:lower:]' '[:upper:]'
```

---

## 7. Characters aur delimiters replace karna

### Spaces ko underscores mein badalna

```bash
echo "linux system administrator" |
tr ' ' '_'
```

Output:

```text
linux_system_administrator
```

### Colons ko commas mein badalna

```bash
echo "web01:running:25" |
tr ':' ','
```

Output:

```text
web01,running,25
```

### Multiple input delimiters ko ek output delimiter mein badalna

```bash
echo "web01:running,25" |
tr ':,' '||'
```

Output:

```text
web01|running|25
```

Equal-length sets use karne se mapping saaf samajh aati hai.

---

## 8. `-d` se characters delete karna

### Digits remove karna

```bash
echo "server123" |
tr -d '[:digit:]'
```

Output:

```text
server
```

### Spaces remove karna

```bash
echo "linux administrator" |
tr -d ' '
```

### Punctuation remove karna

```bash
echo "Error: server-down!" |
tr -d '[:punct:]'
```

### Colons remove karna

```bash
echo "web01:running:25" |
tr -d ':'
```

---

## 9. Windows carriage returns remove karna

Windows line endings aam tor par `\r\n` use karti hain, jabke Linux `\n` use karta hai.

```bash
tr -d '\r' < windows-file.txt > linux-file.txt
```

Yeh us waqt useful hai jab script yeh error de:

```text
/bin/bash^M: bad interpreter
```

Is kaam ke liye ek purpose-built tool bhi hai:

```bash
dos2unix script.sh
```

---

## 10. `-s` se repetitions squeeze karna

Squeeze ka matlab hai ek hi character ki lagataar repetitions ko sirf ek character mein badal dena.

### Repeated spaces squeeze karna

```bash
echo "web01     running     25" |
tr -s ' '
```

Output:

```text
web01 running 25
```

### Spaces aur tabs normalize karna

```bash
printf 'web01\t\t   running    25\n' |
tr -s '[:blank:]' ' '
```

Output:

```text
web01 running 25
```

### Repeated newlines squeeze karna

```bash
tr -s '\n' < file.txt
```

Is se lagataar multiple newline characters ek newline ban jate hain.

### `[:space:]` aur `[:blank:]` ka farq

Yeh newlines ko bhi translate kar sakta hai:

```bash
tr -s '[:space:]' ' '
```

Sirf spaces aur tabs ko target karne aur line boundaries ko bachane ke liye:

```bash
tr -s '[:blank:]' ' '
```

---

## 11. `-c` se set ko complement karna

`-c` supplied set mein na hone wale tamam characters select karta hai. Isay aksar `-d` ke saath use kiya jata hai.

### Sirf digits rakhna

```bash
echo "Phone: 123-456-7890" |
tr -cd '[:digit:]'
```

Output:

```text
1234567890
```

Yahan:

- `-c` = digits ke ilawa tamam characters select karo
- `-d` = selected characters delete kar do
- Result = sirf digits bachti hain

### Sirf letters aur newlines rakhna

```bash
tr -cd '[:alpha:]\n' < file.txt
```

### Printable text aur newlines rakhna

```bash
tr -cd '[:print:]\n' < file.txt
```

Character whitelisting meaningful data bhi remove kar sakti hai, is liye result ko dhyan se inspect karein.

---

## 12. Records aur delimiters convert karna

### Newlines ko commas mein badalna

Agar file mein yeh data ho:

```text
web01
web02
db01
```

Command:

```bash
tr '\n' ',' < servers.txt
```

Output:

```text
web01,web02,db01,
```

Final newline bhi comma ban jati hai, is liye trailing comma aata hai. Isay remove karne ke liye:

```bash
tr '\n' ',' < servers.txt |
sed 's/,$/\n/'
```

Ya direct line-joining command use karein:

```bash
paste -sd, servers.txt
```

### Commas ko newlines mein badalna

```bash
echo "web01,web02,db01" |
tr ',' '\n'
```

---

## 13. Names aur shell variables normalize karna

### Simple URL-style name

```bash
echo "Linux System Administrator" |
tr '[:upper:]' '[:lower:]' |
tr ' ' '-'
```

Output:

```text
linux-system-administrator
```

Repeated blanks bhi normalize karna:

```bash
echo "Linux    System   Administrator" |
tr '[:upper:]' '[:lower:]' |
tr -s '[:blank:]' '-'
```

### Shell variable ke saath use karna

```bash
name="Linux Administrator"

normalized_name=$(printf '%s\n' "$name" |
    tr '[:upper:]' '[:lower:]' |
    tr ' ' '_')

echo "$normalized_name"
```

Jab exact input handling zaroori ho to `echo` ke bajaye `printf` use karein.

---

## 14. Data-cleaning pipeline

Input:

```text
web01       running       25
web02    stopped      80
db01        running       65
```

Blanks normalize karein:

```bash
tr -s '[:blank:]' ' ' < servers.txt
```

Blanks ko colons mein convert karein:

```bash
tr -s '[:blank:]' ':' < servers.txt
```

Phir AWK se filter karein:

```bash
tr -s '[:blank:]' ':' < servers.txt |
awk -F: '$2 == "running" {print $1}'
```

Output:

```text
web01
db01
```

Yahan `tr` ne messy spaces clean karke colon-delimited data banaya aur AWK ne doosra field check kiya.

---

## 15. Linux Administrator examples

### Command output mein blanks normalize karna

```bash
command |
tr -s '[:blank:]' ' '
```

### Service names uppercase karna

```bash
systemctl list-units --type=service --no-legend |
awk '{print $1}' |
tr '[:lower:]' '[:upper:]'
```

### PATH directories ko alag alag lines par dikhana

```bash
printf '%s\n' "$PATH" |
tr ':' '\n'
```

### Empty aur duplicate PATH entries remove karke number karna

```bash
printf '%s\n' "$PATH" |
tr ':' '\n' |
awk 'NF' |
sort -u |
nl
```

### Nonempty PATH entries count karna

```bash
printf '%s\n' "$PATH" |
tr ':' '\n' |
awk 'NF' |
wc -l
```

### Mixed text se digits extract karna

```bash
printf '%s\n' 'PID=12345' |
tr -cd '[:digit:]\n'
```

---

## 16. `tr` aur doosre tools ka comparison

| Command | Main purpose |
|---|---|
| `grep` | Matching lines search karna |
| `cut` | Simple fields extract karna |
| `awk` | Fields, conditions aur calculations process karna |
| `sed` | Patterns ke zariye text edit karna |
| `sort` | Records arrange karna |
| `uniq` | Adjacent duplicate lines process karna |
| `tr` | Characters translate, delete ya squeeze karna |
| `jq` | JSON parse aur transform karna |

### Character replacement ke liye `tr`

```bash
tr ':' ','
```

### Word ya pattern replacement ke liye `sed`

```bash
sed 's/running/active/g'
```

### Field conditions ke liye AWK

```bash
awk -F: '$2 == "running" {print $1}'
```

---

## 17. `tr` complete words replace nahi karta

Yeh command word `cat` ko word `dog` se replace nahi karti; yeh character mapping banati hai:

```bash
echo "cat" | tr 'cat' 'dog'
```

Mapping:

```text
c → d
a → o
t → g
```

Word replacement ke liye `sed` use karein:

```bash
echo "cat" |
sed 's/cat/dog/g'
```

---

## 18. Unequal sets aur locale

Unequal set lengths ko different implementations mukhtalif tarah interpret kar sakti hain. Clear command ke liye mapping explicit rakhein:

```bash
echo "abc" | tr 'abc' '122'
```

`a-z` jaisi ranges locale par depend kar sakti hain. Character classes aksar zyada clear hoti hain:

```bash
tr '[:lower:]' '[:upper:]'
```

Predictable byte-oriented processing ke liye:

```bash
LC_ALL=C tr 'a-z' 'A-Z'
```

Unicode aur multibyte transformations ke liye Unicode-aware tools ki zaroorat ho sakti hai.

---

## 19. Transformed output safely save karna

Output doosri file mein save karein:

```bash
tr '[:lower:]' '[:upper:]' \
    < names.txt \
    > names-uppercase.txt
```

Input aur redirected output ke liye same file use na karein:

```bash
tr '[:lower:]' '[:upper:]' \
    < names.txt \
    > names.txt
```

Shell, `tr` ke file parhne se pehle hi file ko empty kar sakta hai.

Safe replacement:

```bash
tr '[:lower:]' '[:upper:]' \
    < names.txt \
    > names.tmp &&
mv names.tmp names.txt
```

Backup ke saath zyada safe workflow:

```bash
cp names.txt names.txt.bak

tr '[:lower:]' '[:upper:]' \
    < names.txt \
    > names.tmp &&
mv names.tmp names.txt
```

---

## 20. Common options

| Option | Kaam |
|---|---|
| `-d` | SET1 ke characters delete karta hai |
| `-s` | Repeated characters squeeze karta hai |
| `-c` ya `-C` | SET1 ko complement karta hai |
| `--help` | Help display karta hai |
| `--version` | Version information display karta hai |

---

## 21. Common mistakes

### Filename directly pass karna

```bash
# Ghalat
tr 'a-z' 'A-Z' file.txt

# Sahi
tr 'a-z' 'A-Z' < file.txt
```

### Word replacement ki umeed rakhna

Words aur patterns ke liye `tr` ke bajaye `sed` use karein.

### Quotes bhool jana

```bash
# Risky
tr [:lower:] [:upper:]

# Sahi
tr '[:lower:]' '[:upper:]'
```

### Jab newlines unchanged chahiye hon tab `[:space:]` use karna

Sirf spaces aur tabs ke liye `[:blank:]` use karein:

```bash
tr -s '[:blank:]' ' '
```

### Input file overwrite karna

`tr ... < file > file` ke bajaye temporary file use karein.

### Trailing delimiter bhool jana

`tr '\n' ','` final newline ko bhi comma bana deta hai. `paste -sd,` use karein ya final delimiter baad mein remove karein.

---

## 22. `tr` use karne se pehle thinking process

Khud se yeh sawal poochein:

1. Kya main individual characters process kar raha hoon ya complete words?
2. Kin characters ko translate karna hai?
3. Kaun se replacement characters chahiye?
4. Kya characters delete karne hain?
5. Kya repetitions squeeze karni hain?
6. Kya set ko complement karna hai?
7. Kya spaces, tabs aur newlines ko alag tarah treat karna hai?
8. Kya locale ya Unicode result par asar daal sakta hai?
9. Output screen par dikhana hai ya file mein save karna hai?
10. Kya original file protected hai?

Basic flow:

```text
Input stream → SET1 → translate/delete/squeeze → output
```

Example:

```bash
tr -s '[:blank:]' ':' < servers.txt
```

---

## 23. Practice lab

File banayein:

```bash
cat > employee-data.txt <<'EOF'
KHALID     LINUX_ADMIN     75000
ALI        DEVOPS_ENGINEER 90000
SARA       CLOUD_ENGINEER  85000
EOF
```

Yeh tasks complete karein:

1. Tamam letters lowercase mein convert karein.
2. Spaces ko colons mein convert karein.
3. Repeated spaces ko ek space mein normalize karein.
4. Repeated spaces normalize karke colons mein convert karein.
5. Tamam digits remove karein.
6. Sirf digits aur newlines rakhein.
7. Underscores ko hyphens mein convert karein.
8. Har record ko ek comma-separated line mein convert karein.
9. Colon-separated PATH ko alag lines mein convert karein.
10. Lowercase version doosri file mein save karein.

### Solutions

```bash
# 1. Lowercase mein convert karein
tr '[:upper:]' '[:lower:]' < employee-data.txt

# 2. Har space ko colon mein convert karein
tr ' ' ':' < employee-data.txt

# 3. Repeated blanks normalize karein
tr -s '[:blank:]' ' ' < employee-data.txt

# 4. Blanks normalize karke colons mein convert karein
tr -s '[:blank:]' ':' < employee-data.txt

# 5. Digits remove karein
tr -d '[:digit:]' < employee-data.txt

# 6. Sirf digits aur newlines rakhein
tr -cd '[:digit:]\n' < employee-data.txt

# 7. Underscores ko hyphens mein convert karein
tr '_' '-' < employee-data.txt

# 8. Records ko commas ke saath join karein
tr '\n' ',' < employee-data.txt |
sed 's/,$/\n/'

# 9. PATH entries alag lines par dikhayein
printf '%s\n' "$PATH" | tr ':' '\n'

# 10. Lowercase output save karein
tr '[:upper:]' '[:lower:]' \
    < employee-data.txt \
    > employee-data-lowercase.txt
```

---

## 24. Quick knowledge check

1. `tr` ka kya matlab hai?
2. `tr` characters, words ya fields mein se kya process karta hai?
3. `tr` ko aam tor par pipe ya input redirection ki zaroorat kyun hoti hai?
4. Lowercase letters ko uppercase mein kaise convert karenge?
5. `-d` kya karta hai?
6. `-s` kya karta hai?
7. `-c` kya karta hai?
8. `[:space:]` aur `[:blank:]` mein kya farq hai?
9. Windows-formatted file se carriage returns kaise remove karenge?
10. Input aur redirected output same file kyun nahi hone chahiye?
11. `tr` word replacement ke liye suitable kyun nahi hai?
12. `sed` ya AWK kab zyada munasib hain?

---

## 25. Quick reference

```bash
# Lowercase se uppercase
tr '[:lower:]' '[:upper:]'

# Uppercase se lowercase
tr '[:upper:]' '[:lower:]'

# Spaces ko underscores mein replace karein
tr ' ' '_'

# Colons ko commas mein replace karein
tr ':' ','

# Digits delete karein
tr -d '[:digit:]'

# Carriage returns delete karein
tr -d '\r'

# Spaces squeeze karein
tr -s ' '

# Spaces aur tabs normalize karein
tr -s '[:blank:]' ' '

# Blanks normalize karke colons use karein
tr -s '[:blank:]' ':'

# Sirf digits rakhein
tr -cd '[:digit:]'

# Digits aur newlines rakhein
tr -cd '[:digit:]\n'

# Commas ko newlines mein convert karein
tr ',' '\n'

# File se input parhein
tr '[:lower:]' '[:upper:]' < file.txt

# Doosri file mein output save karein
tr ':' ',' < input.txt > output.txt
```

## Final summary

`tr` ek character-processing command hai jo characters ko translate, delete ya squeeze karta hai.

Yaad rakhein:

```text
tr SET1 SET2 = characters translate karo
tr -d SET1   = characters delete karo
tr -s SET1   = repetitions squeeze karo
tr -cd SET1  = sirf selected characters rakho
```

Sab se important farq:

> `tr` individual characters ke saath kaam karta hai—complete words, fields ya JSON structures ke saath nahi.
