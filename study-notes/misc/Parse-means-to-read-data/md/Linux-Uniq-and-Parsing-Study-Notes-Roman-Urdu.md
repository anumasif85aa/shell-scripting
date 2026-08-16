# Linux `uniq` Command aur Parsing — Roman Urdu Study Notes

## Learning objectives

In notes ko parhne ke baad aap:

- Samjha sakenge ke `uniq` kya karta hai aur input order kyun important hai.
- Adjacent duplicate records remove, count aur report kar sakenge.
- `uniq -u`, `uniq -d`, `uniq -D` aur `sort -u` ka farq samajh sakenge.
- Case, fields ya characters ignore karke records compare kar sakenge.
- Zaroorat par first-occurrence order preserve kar sakenge.
- Linux Administrator aur log-analysis pipelines mein `uniq` use kar sakenge.

---

## 1. `uniq` kya hai?

`uniq` ek Linux text-processing command hai jo **paas paas maujood duplicate lines** ko detect, remove ya count karti hai.

Asaan alfaaz mein:

> `uniq` neighboring records ko compare karke repeated groups process karta hai.

Command ka naam `uniq` hai kyun ke yeh unique aur duplicate records ke saath kaam karti hai. Yeh acronym nahi hai.

---

## 2. Sab se important rule

`uniq` duplicate records ko sirf us waqt pehchanta hai jab woh ek doosre ke paas hon.

Maan lein `colors.txt` mein:

```text
red
blue
red
green
blue
```

Yeh duplicates chhor sakta hai:

```bash
uniq colors.txt
```

Correct approach:

```bash
sort colors.txt | uniq
```

Output:

```text
blue
green
red
```

Processing:

1. `sort` equal records ko ek saath rakhta hai.
2. `uniq` adjacent duplicate groups process karta hai.

---

## 3. Basic syntax

```bash
uniq [OPTIONS] [INPUT_FILE] [OUTPUT_FILE]
```

Example:

```bash
uniq colors.txt
```

Zyada common pipeline:

```bash
sort colors.txt | uniq
```

---

## 4. Practice file banana

```bash
cat > colors.txt <<'EOF'
red
blue
red
green
blue
red
yellow
EOF
```

---

## 5. Duplicate records remove karna

```bash
sort colors.txt | uniq
```

Output:

```text
blue
green
red
yellow
```

Is ka shorter equivalent:

```bash
sort -u colors.txt
```

---

## 6. `-c` se records count karna

```bash
sort colors.txt | uniq -c
```

Output:

```text
      2 blue
      1 green
      3 red
      1 yellow
```

Line ke shuru ka number occurrence count hota hai.

### Highest counts pehle

```bash
sort colors.txt |
uniq -c |
sort -nr
```

Possible output:

```text
      3 red
      2 blue
      1 yellow
      1 green
```

Processing flow:

```text
Input → sort records group karta hai → uniq -c groups count karta hai → sort -nr ranking karta hai
```

---

## 7. `-d` se duplicate records display karna

```bash
sort colors.txt | uniq -d
```

Output:

```text
blue
red
```

`-d` har us duplicate group ki ek copy display karta hai jo ek se zyada baar aya ho.

---

## 8. `-u` se sirf ek baar aane wale records

```bash
sort colors.txt | uniq -u
```

Output:

```text
green
yellow
```

Important difference:

```text
sort -u = har distinct comparison key ki ek copy
uniq -u = sirf woh records jo exactly ek baar aye
```

---

## 9. `-D` se tamam repeated records display karna

```bash
sort colors.txt | uniq -D
```

Possible output:

```text
blue
blue
red
red
red
```

| Option | Result |
|---|---|
| `-d` | Har duplicate group ki ek copy |
| `-D` | Duplicate groups ke tamam records |

`-D` GNU `uniq` mein commonly available hai jo Linux par use hota hai.

---

## 10. `-i` se letter case ignore karna

Maan lein `names.txt` mein:

```text
Ali
ali
Khalid
khalid
Sara
```

Compatible case-insensitive sorting aur comparison use karein:

```bash
sort -f names.txt | uniq -i
```

`-i`, uppercase aur lowercase equivalents ko equal samajhta hai.

Agar sirf `uniq -i` use ho to equivalent values adjacent nahi bhi ho sakti. Is liye pehle `sort -f` useful hai.

---

## 11. `-f` se fields skip karna

Maan lein `logs.txt` mein:

```text
10:00 INFO Server started
10:01 INFO Server started
10:02 ERROR Backup failed
10:03 ERROR Backup failed
```

Comparison mein pehli whitespace-separated field skip karein:

```bash
uniq -f 1 logs.txt
```

Possible output:

```text
10:00 INFO Server started
10:02 ERROR Backup failed
```

Complete selected line display hoti hai; pehli field sirf comparison mein ignore hoti hai.

Equivalent records ka adjacent hona phir bhi zaroori hai.

---

## 12. Characters skip ya limit karna

### `-s` se characters skip karna

Data:

```text
001-error
002-error
003-warning
```

Pehle chaar characters ignore karein:

```bash
uniq -s 4 file.txt
```

### `-w` se limited width compare karna

```bash
uniq -w 3 file.txt
```

Data:

```text
web01
web02
db01
```

Possible output:

```text
web01
db01
```

`web01` aur `web02` equal samjhe jate hain kyun ke un ke pehle teen compared characters `web` hain.

---

## 13. Common options

| Option | Purpose |
|---|---|
| `-c` | Records ke saath occurrence count lagata hai |
| `-d` | Har duplicate group ki ek copy display karta hai |
| `-D` | Duplicate groups ke tamam records display karta hai |
| `-u` | Exactly ek baar aane wale records display karta hai |
| `-i` | Letter case ignore karta hai |
| `-f N` | Pehli `N` fields skip karta hai |
| `-s N` | Pehle `N` characters skip karta hai |
| `-w N` | Sirf `N` characters compare karta hai |

---

## 14. `uniq` aur `sort -u` ka muqabla

### `sort -u`

```bash
sort -u colors.txt
```

Yeh data sort karke har distinct comparison key ka ek record display karta hai.

### `sort | uniq`

```bash
sort colors.txt | uniq
```

Yeh input sort karta aur phir adjacent duplicates remove karta hai.

Dono aam tor par similar distinct-record output dete hain. `uniq` specialized analysis options bhi deta hai:

```bash
uniq -c
uniq -d
uniq -D
uniq -u
```

---

## 15. Original order preserve karna

Sorting record order change kar deti hai. Pehla occurrence preserve karte hue duplicates remove karne ke liye AWK useful hai:

```bash
awk '!seen[$0]++' colors.txt
```

Data:

```text
red
blue
red
green
blue
```

Output:

```text
red
blue
green
```

Yeh har complete line ka pehla occurrence rakhta hai.

---

## 16. Kya `uniq` parsing command hai?

`uniq` parsing aur analysis pipelines ka hissa banta hai. Is ke main kaam:

- Adjacent records compare karna.
- Repeated groups detect karna.
- Duplicates remove karna.
- Occurrences count karna.
- Duplicate-only ya single-occurrence records display karna.

```text
Input → equal records ko group karo → uniq operation → result
```

---

## 17. Linux Administrator examples

### Login shells count karna

```bash
getent passwd |
cut -d: -f7 |
sort |
uniq -c |
sort -nr
```

### Logged-in usernames count karna

```bash
who |
awk '{print $1}' |
sort |
uniq -c |
sort -nr
```

### Web log mein client-address fields count karna

Agar field 1 mein client address ho:

```bash
awk '{print $1}' access.log |
sort |
uniq -c |
sort -nr |
head
```

Field ka meaning assume karne se pehle log format verify karein.

### HTTP status-code fields count karna

Agar log format mein field 9 status code ho:

```bash
awk '{print $9}' access.log |
sort |
uniq -c |
sort -nr
```

### Duplicate records dhoondhna

```bash
sort users.txt | uniq -d
```

### Exactly ek baar aane wale records

```bash
sort users.txt | uniq -u
```

---

## 18. Colon-separated data ke saath kaam

Maan lein `servers.txt` mein:

```text
web01:running:25
web02:stopped:80
db01:running:65
app01:running:10
```

Statuses extract aur count karein:

```bash
cut -d: -f2 servers.txt |
sort |
uniq -c |
sort -nr
```

Output:

```text
      3 running
      1 stopped
```

Processing:

```text
cut status extract karta hai → sort statuses group karta hai → uniq -c count karta hai → sort -nr rank karta hai
```

---

## 19. Output save karna

Redirection ke saath:

```bash
sort colors.txt |
uniq > unique-colors.txt
```

`uniq` output filename bhi accept kar sakta hai:

```bash
uniq sorted-colors.txt unique-colors.txt
```

Direct form useful hone ke liye input mein duplicate groups adjacent hone chahiye.

---

## 20. Common mistakes

### Unsorted data par `uniq` use karna

```bash
uniq colors.txt
```

Nonadjacent duplicates reh sakte hain. Correct:

```bash
sort colors.txt | uniq
```

### `uniq -u` aur `sort -u` confuse karna

```text
uniq -u = exactly ek baar aane wale records
sort -u = har distinct key ki ek copy
```

### Sirf `uniq -i` use karna

Reliable case-insensitive grouping:

```bash
sort -f names.txt | uniq -i
```

### Input modify hone ki umeed

```bash
uniq colors.txt
```

Yeh sirf output display karta hai. Save karne ke liye redirection use karein.

### Bhoolna ke sorting order change karti hai

First-occurrence order preserve karne ke liye:

```bash
awk '!seen[$0]++' file.txt
```

---

## 21. `uniq` use karne se pehle thinking process

Yeh sawalat poochhein:

1. Ek record kya hai?
2. Kya duplicate records adjacent hain?
3. Kya pehle sort karna chahiye?
4. Har value ki ek copy chahiye?
5. Sirf duplicated values chahiye?
6. Sirf ek baar aane wali values chahiye?
7. Occurrence counts chahiye?
8. Letter case ignore karna hai?
9. Original order preserve karna hai?
10. Result display karna hai ya save?

Basic flow:

```text
Input → required value extract → sort/group → uniq operation → result
```

Example:

```bash
cut -d: -f2 servers.txt |
sort |
uniq -c |
sort -nr
```

---

## 22. Practice lab

File banayein:

```bash
cat > access-sample.txt <<'EOF'
10.0.0.1
10.0.0.2
10.0.0.1
10.0.0.3
10.0.0.1
10.0.0.2
10.0.0.4
EOF
```

Yeh tasks complete karein:

1. Har address ki ek copy display karein.
2. Har address count karein.
3. Sirf repeated addresses display karein.
4. Sirf exactly ek baar aane wale addresses display karein.
5. Duplicate groups ki tamam lines display karein.
6. Sab se frequent address pehle display karein.
7. Distinct addresses doosri file mein save karein.
8. First-occurrence order preserve karte hue duplicates remove karein.

### Solutions

```bash
# 1. Har address ki ek copy
sort access-sample.txt | uniq

# Shorter alternative
sort -u access-sample.txt

# 2. Har address count karna
sort access-sample.txt | uniq -c

# 3. Sirf repeated addresses
sort access-sample.txt | uniq -d

# 4. Exactly ek baar aane wale addresses
sort access-sample.txt | uniq -u

# 5. Duplicate groups ke tamam records
sort access-sample.txt | uniq -D

# 6. Most frequent pehle
sort access-sample.txt |
uniq -c |
sort -nr

# 7. Distinct addresses save karna
sort -u access-sample.txt > unique-addresses.txt

# 8. First-occurrence order preserve karna
awk '!seen[$0]++' access-sample.txt
```

---

## 23. Quick knowledge check

1. `uniq` kya karta hai?
2. Kya `uniq` kisi cheez ka short form hai?
3. `uniq` ko aam tor par sorted input kyun chahiye?
4. `uniq -c` kya display karta hai?
5. `-d` aur `-D` mein kya farq hai?
6. `uniq -u` kya display karta hai?
7. `uniq -u` aur `sort -u` mein kya farq hai?
8. `-i` comparison ko kaise affect karta hai?
9. `-f`, `-s` aur `-w` kya karte hain?
10. Order preserve karte hue duplicates kaise remove karte hain?
11. Kya `uniq` original file modify karta hai?
12. Log analysis mein `uniq` kaise use hota hai?

---

## 24. Quick reference

```bash
# Adjacent duplicates remove karna
uniq file

# Sort karke duplicates remove karna
sort file | uniq

# Shorter distinct-record command
sort -u file

# Occurrences count karna
sort file | uniq -c

# Duplicate values display karna
sort file | uniq -d

# Duplicate groups ke tamam records
sort file | uniq -D

# Exactly ek baar aane wali values
sort file | uniq -u

# Letter case ignore karna
sort -f file | uniq -i

# Pehli do fields skip karna
uniq -f 2 file

# Pehle chaar characters skip karna
uniq -s 4 file

# Sirf pehle paanch characters compare karna
uniq -w 5 file

# Highest occurrence count pehle
sort file | uniq -c | sort -nr

# First-occurrence order preserve karna
awk '!seen[$0]++' file
```

## Final summary

`uniq` adjacent duplicate records ko detect, remove ya count karta hai.

Sab se important rule:

> `uniq` duplicates ko sirf tab pehchanta hai jab equal records ek doosre ke paas hon.

Yaad rakhein:

```text
uniq -c = occurrences count karna
uniq -d = duplicate values
uniq -u = exactly ek baar aane wali values
```
