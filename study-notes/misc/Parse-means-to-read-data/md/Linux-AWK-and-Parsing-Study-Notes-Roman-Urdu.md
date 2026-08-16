# Linux `awk` Command aur Parsing — Roman Urdu Study Notes

## Learning objectives

In notes ko parhne ke baad aap:

- Samjha sakenge ke AWK kya hai aur us ka naam kahan se aya.
- Records, fields, patterns aur actions ko samajh sakenge.
- Structured text se fields extract aur filter kar sakenge.
- AWK variables, conditions, regex, calculations aur formatting use kar sakenge.
- `/etc/passwd`, logs, whitespace data aur simple CSV files parse kar sakenge.
- Faisla kar sakenge ke `grep`, `cut` ya `awk` mein se kaunsa tool use karna hai.

---

## 1. `awk` kya hai?

`awk` ek powerful Linux text-processing tool aur programming language hai. Yeh:

- Text ko line by line parhta hai.
- Har line ko fields mein divide karta hai.
- Records ko search aur filter karta hai.
- Selected columns extract karta hai.
- Conditions apply karta hai.
- Calculations karta hai.
- Data ko reformat karke reports banata hai.

Asaan alfaaz mein:

> `awk` structured text ko parhta hai, usay fields mein divide karta hai, un fields ko process karta hai aur required result display karta hai.

---

## 2. `awk` ka naam kahan se aya?

`awk` ka naam us ke teen original developers ke surnames se bana hai:

- **A**lfred Aho
- Peter **W**einberger
- Brian **K**ernighan

```text
Aho + Weinberger + Kernighan = AWK
```

AWK sirf search command nahi hai. Yeh text processing ke liye banayi gayi ek chhoti programming language hai.

---

## 3. Records aur fields

Maan lein `servers.txt` mein yeh data hai:

```text
web01 running 25
web02 stopped 80
db01 running 65
```

Default tor par AWK har line ko ek **record** samajhta hai aur whitespace ke zariye fields alag karta hai.

Is record ko dekhein:

```text
web01 running 25
```

| AWK reference | Value |
|---|---|
| `$0` | Poori line: `web01 running 25` |
| `$1` | Pehli field: `web01` |
| `$2` | Doosri field: `running` |
| `$3` | Teesri field: `25` |

Important:

- `$0` ka matlab poora record ya line hai.
- `$1`, `$2` aur aage ke numbers individual field values ko represent karte hain.

---

## 4. Basic syntax

```bash
awk 'PATTERN { ACTION }' FILE
```

| Hissa | Purpose |
|---|---|
| `PATTERN` | Faisla karta hai ke kaun se records process honge |
| `{ ACTION }` | Faisla karta hai ke matching records ke saath kya karna hai |

Example:

```bash
awk '{print $1}' servers.txt
```

Output:

```text
web01
web02
db01
```

### Command breakdown

| Hissa | Matlab |
|---|---|
| `awk` | AWK run karta hai |
| `'...'` | AWK program ko contain karta hai |
| `{print $1}` | Field 1 display karta hai |
| `servers.txt` | Input file hai |

---

## 5. Practice file banana

```bash
cat > servers.txt <<'EOF'
web01 running 25
web02 stopped 80
db01 running 65
EOF
```

> Redirection operator `>` here-document ka content `servers.txt` mein save karta hai. Aakhri `EOF` apni line par akela hona chahiye.

---

## 6. Fields print karna

### Poori line display karna

```bash
awk '{print $0}' servers.txt
```

Is ka short form bhi wohi result deta hai:

```bash
awk '{print}' servers.txt
```

### Pehli field display karna

```bash
awk '{print $1}' servers.txt
```

### Doosri field display karna

```bash
awk '{print $2}' servers.txt
```

### Multiple fields display karna

```bash
awk '{print $1, $3}' servers.txt
```

Output:

```text
web01 25
web02 80
db01 65
```

`print` mein comma output field separator add karta hai, jo default tor par ek space hota hai.

### Output mein labels add karna

```bash
awk '{print "Server:", $1, "Status:", $2}' servers.txt
```

Output:

```text
Server: web01 Status: running
Server: web02 Status: stopped
Server: db01 Status: running
```

---

## 7. Field separators

### Default whitespace separator

Default tor par AWK lagatar spaces aur tabs ko ek separator samajhta hai. Is liye yeh dono records sahi parse honge:

```text
web01 running 25
web02       stopped       80
```

```bash
awk '{print $2}' servers.txt
```

Yeh `cut` par AWK ka ek faida hai. Is command ko repeated spaces ke saath problem ho sakti hai:

```bash
cut -d' ' -f2 servers.txt
```

Repeated spaces `cut` ke liye empty fields bana sakti hain, jabke AWK unhein naturally handle karta hai.

### `-F` se delimiter define karna

Colon-separated data:

```text
web01:running:25
web02:stopped:80
db01:running:65
```

Command:

```bash
awk -F: '{print $1}' servers-colon.txt
```

Isay yun bhi likh sakte hain:

```bash
awk -F ':' '{print $1}' servers-colon.txt
```

---

## 8. `/etc/passwd` ko parse karna

`/etc/passwd` ka example record:

```text
ali:x:1001:1001:Ali Khan:/home/ali:/bin/bash
```

| Field | Information |
|---:|---|
| `$1` | Username |
| `$2` | Password placeholder |
| `$3` | UID |
| `$4` | GID |
| `$5` | User information |
| `$6` | Home directory |
| `$7` | Login shell |

### Usernames display karna

```bash
awk -F: '{print $1}' /etc/passwd
```

### Usernames aur UIDs display karna

```bash
awk -F: '{print $1, $3}' /etc/passwd
```

### Formatted user information display karna

```bash
awk -F: '{print "User:", $1, "UID:", $3, "Shell:", $7}' /etc/passwd
```

---

## 9. Conditions se filtering

Conditions AWK ko `cut` se zyada powerful banati hain.

### Sirf running servers display karna

```bash
awk '$2 == "running" {print $0}' servers.txt
```

Is ka short form:

```bash
awk '$2 == "running" {print}' servers.txt
```

### Sirf running servers ke names display karna

```bash
awk '$2 == "running" {print $1}' servers.txt
```

Output:

```text
web01
db01
```

### Usage 50 se zyada ho to display karna

```bash
awk '$3 > 50 {print $1, $3}' servers.txt
```

Output:

```text
web02 80
db01 65
```

### Comparison operators

| Operator | Matlab |
|---|---|
| `==` | Barabar hai |
| `!=` | Barabar nahi hai |
| `>` | Se zyada |
| `<` | Se kam |
| `>=` | Barabar ya zyada |
| `<=` | Barabar ya kam |
| `~` | Regular expression se match karta hai |
| `!~` | Regular expression se match nahi karta |

### AND se conditions combine karna

Jab dono conditions true honi zaroori hon to `&&` use karein:

```bash
awk '$2 == "running" && $3 > 50 {print $1}' servers.txt
```

Output:

```text
db01
```

### OR se conditions combine karna

Jab kisi ek condition ka true hona kafi ho to `||` use karein:

```bash
awk '$1 == "web01" || $1 == "db01" {print}' servers.txt
```

### Not equal condition

```bash
awk '$2 != "running" {print}' servers.txt
```

Output:

```text
web02 stopped 80
```

---

## 10. AWK mein regular expressions

### `running` contain karne wale records

```bash
awk '/running/ {print}' servers.txt
```

Yeh is command jaisa kaam karta hai:

```bash
grep "running" servers.txt
```

### Specific field ko match karna

```bash
awk '$2 ~ /running/ {print $1}' servers.txt
```

Yahan:

- `$2` doosri field hai.
- `~` ka matlab regular expression se match karna hai.
- `/running/` regex pattern hai.

### Match na karne wali fields

```bash
awk '$2 !~ /running/ {print}' servers.txt
```

### Field ka beginning match karna

```bash
awk '$1 ~ /^web/ {print}' servers.txt
```

Yeh un records ko select karta hai jin ki pehli field `web` se shuru hoti hai.

---

## 11. Important built-in variables

| Variable | Matlab |
|---|---|
| `NR` | Tamam input mein current record ya line number |
| `FNR` | Current file ke andar current line number |
| `NF` | Current record mein fields ki tadaad |
| `FS` | Input field separator |
| `OFS` | Output field separator |
| `RS` | Input record separator |
| `ORS` | Output record separator |
| `FILENAME` | Current input file ka name |

### `NR` se line numbers display karna

```bash
awk '{print NR, $0}' servers.txt
```

Output:

```text
1 web01 running 25
2 web02 stopped 80
3 db01 running 65
```

### Sirf line 2 display karna

```bash
awk 'NR == 2 {print}' servers.txt
```

### Line 2 se 3 tak display karna

```bash
awk 'NR >= 2 && NR <= 3 {print}' servers.txt
```

### Fields ki tadaad display karna

```bash
awk '{print "Fields:", NF, "Line:", $0}' servers.txt
```

### Aakhri field display karna

```bash
awk '{print $NF}' servers.txt
```

`NF` aakhri field ka number rakhta hai. `$NF` us aakhri field ki value ko represent karta hai.

### Aakhri se pehli field display karna

```bash
awk '{print $(NF-1)}' servers.txt
```

---

## 12. `FS` aur `OFS`

### Input field separator set karna

```bash
awk 'BEGIN {FS=":"} {print $1, $7}' /etc/passwd
```

Yeh is command ke barabar hai:

```bash
awk -F: '{print $1, $7}' /etc/passwd
```

### Output field separator set karna

```bash
awk -F: 'BEGIN {OFS=" -> "} {print $1, $7}' /etc/passwd
```

Example output:

```text
root -> /bin/bash
ali -> /bin/bash
```

---

## 13. `BEGIN` aur `END`

### `BEGIN`

`BEGIN` block input read hone se **pehle** sirf ek baar run hota hai.

```bash
awk 'BEGIN {print "Server Report"} {print $1, $2}' servers.txt
```

`BEGIN` ko use karein:

- Headings print karne ke liye.
- Separators set karne ke liye.
- Variables initialize karne ke liye.

### `END`

`END` block tamam input read hone ke **baad** sirf ek baar run hota hai.

```bash
awk '{print $1} END {print "Processing complete"}' servers.txt
```

`END` ko use karein:

- Totals print karne ke liye.
- Summaries print karne ke liye.
- Final message print karne ke liye.

---

## 14. Variables aur calculations

### Running servers count karna

```bash
awk '$2 == "running" {count++}
     END {print "Running servers:", count}' servers.txt
```

Output:

```text
Running servers: 2
```

Processing:

1. Check karo ke field 2 `running` hai.
2. `count` ko ek se barhao.
3. `END` block mein final count print karo.

### Values add karna

```bash
awk '{sum += $3} END {print "Total:", sum}' servers.txt
```

Output:

```text
Total: 170
```

### Average calculate karna

```bash
awk '{sum += $3}
     END {if (NR > 0) print "Average:", sum / NR}' servers.txt
```

`NR > 0` check empty input par division by zero se bachata hai.

### Sab se badi value dhoondhna

```bash
awk 'NR == 1 || $3 > max {max=$3; server=$1}
     END {print "Highest:", server, max}' servers.txt
```

Output:

```text
Highest: web02 80
```

---

## 15. `printf` se formatted output

`print` simple hai, jabke `printf` formatting par zyada control deta hai.

```bash
awk '{printf "%-10s %-10s %5s\n", $1, $2, $3}' servers.txt
```

Possible output:

```text
web01      running       25
web02      stopped       80
db01       running       65
```

### Common format specifiers

| Specifier | Matlab |
|---|---|
| `%s` | String |
| `%d` | Integer |
| `%f` | Decimal number |
| `%.2f` | Do decimal places wala number |
| `\n` | New line |

Example:

```bash
awk '{printf "Server: %-8s Usage: %d%%\n", $1, $3}' servers.txt
```

---

## 16. Simple CSV data process karna

CSV file banayein:

```bash
cat > employees.csv <<'EOF'
101,Khalid,Linux Administrator,Chicago,75000
102,Ali,DevOps Engineer,Dallas,90000
103,Sara,Cloud Engineer,Houston,85000
EOF
```

### Employee names display karna

```bash
awk -F, '{print $2}' employees.csv
```

### Names aur job titles display karna

```bash
awk -F, '{print $2, $3}' employees.csv
```

### 80,000 se zyada salary wale employees

```bash
awk -F, '$5 > 80000 {print $2, $3, $5}' employees.csv
```

### Total salary calculate karna

```bash
awk -F, '{sum += $5} END {print "Total salary:", sum}' employees.csv
```

> Simple `awk -F,` basic comma-separated data ke liye suitable hai. Yeh complete CSV parser nahi hai aur quoted fields ke andar commas hon to ghalat parsing kar sakta hai.

---

## 17. Shell variables aur quoting

Maan lein shell variable mein required status hai:

```bash
status="running"
```

Isay `-v` ke zariye safely AWK ko dein:

```bash
awk -v required_status="$status" \
    '$2 == required_status {print $1}' servers.txt
```

AWK programs aam tor par single quotes mein likhe jate hain:

```bash
awk '{print $1}' servers.txt
```

Agar double quotes carelessly use kiye jayein to shell, AWK ko program milne se pehle `$1` ko expand karne ki koshish kar sakta hai.

Recommended pattern:

```bash
awk -v name="$username" '$1 == name {print}' users.txt
```

---

## 18. Linux Administrator pipelines mein AWK

### Filesystem names aur usage display karna

```bash
df -P | awk 'NR > 1 {print $1, $5}'
```

`NR > 1` heading ko skip karta hai.

### 80 percent se zyada usage wale filesystems

```bash
df -P | awk 'NR > 1 {
    usage=$5
    sub(/%/, "", usage)
    if (usage > 80)
        print $1, usage "%"
}'
```

### Usernames aur login shells display karna

```bash
getent passwd | awk -F: '{print $1, $7}'
```

### Listening TCP addresses display karna

```bash
ss -lnt | awk 'NR > 1 {print $4}'
```

### `if` aur `else` se usage classify karna

```bash
awk '{
    if ($3 >= 80)
        print $1, "High usage"
    else
        print $1, "Normal usage"
}' servers.txt
```

---

## 19. AWK program file

Lambe AWK program ko separate file mein save kar sakte hain.

`report.awk` banayein:

```awk
BEGIN {
    print "Server Status Report"
    print "--------------------"
}

{
    printf "%-10s %-10s %s%%\n", $1, $2, $3
    total += $3
}

END {
    print "--------------------"
    print "Total usage:", total
}
```

Isay run karein:

```bash
awk -f report.awk servers.txt
```

`-f` option AWK ko batata hai ke program ko file se parhna hai.

---

## 20. Kya AWK parsing tool hai?

Ji haan. AWK structured text ko parse karne ke liye commonly use hota hai.

Is ka processing model:

```text
Input → records → fields → conditions → actions → output
```

Normal text input mein:

- Har line ek **record** hoti hai.
- Har word ya delimited hissa ek **field** hota hai.

Example:

```bash
awk -F: '$3 >= 1000 {print $1, $3}' /etc/passwd
```

Is ka matlab:

1. `/etc/passwd` ko parho.
2. `:` ko field delimiter banao.
3. Check karo ke field 3 ki value `1000` ya us se zyada hai.
4. Matching records ki fields 1 aur 3 display karo.

> Sirf UID threshold ko human user ki universal pehchan na samjhein, kyun ke account policies systems ke darmiyan mukhtalif ho sakti hain.

---

## 21. `grep`, `cut` aur `awk` ka muqabla

| Command | Main purpose |
|---|---|
| `grep` | Matching lines search aur filter karta hai |
| `cut` | Simple fields, characters ya bytes extract karta hai |
| `awk` | Fields parse karta, conditions check karta, calculation aur formatting karta hai |

Is data ke liye:

```text
web01:running:25
web02:stopped:80
db01:running:65
```

### `grep`: matching lines select karna

```bash
grep "running" servers-colon.txt
```

### `cut`: ek field extract karna

```bash
cut -d: -f1 servers-colon.txt
```

### `awk`: ek field check karke doosri extract karna

```bash
awk -F: '$2 == "running" {print $1}' servers-colon.txt
```

Output:

```text
web01
db01
```

---

## 22. AWK kab use karna chahiye?

AWK use karein jab:

- Fields ya columns process karne hon.
- Input mein inconsistent whitespace ho.
- Numeric ya string conditions lagani hon.
- Total, count, average ya doosri calculations karni hon.
- Formatted report banana ho.
- Structured text transform karna ho.

Sirf matching lines dhoondhni hon to `grep` use karein.

Simple aur consistent delimiter se fields extract karni hon to `cut` use karein.

---

## 23. AWK command likhne se pehle thinking process

Yeh process follow karein:

1. Input data ko dhyan se dekhein.
2. Ek record ya line identify karein.
3. Field separator identify karein.
4. Fields ko left se right number dein.
5. Faisla karein ke condition ki zaroorat hai ya nahi.
6. Faisla karein ke kya print ya calculate karna hai.
7. Sample data ke saath command test karein.

Basic formula:

```text
awk -F'DELIMITER' 'CONDITION {ACTION}' FILE
```

Example:

```bash
awk -F: '$2 == "running" {print $1}' servers-colon.txt
```

Breakdown:

- Delimiter: `:`
- Condition: Field 2 `running` ke barabar honi chahiye.
- Action: Field 1 print karo.
- Input: `servers-colon.txt`

---

## 24. Practice lab

Practice file banayein:

```bash
cat > employees.txt <<'EOF'
101 Khalid LinuxAdmin Chicago 75000
102 Ali DevOpsEngineer Dallas 90000
103 Sara CloudEngineer Houston 85000
104 Ahmed SupportEngineer Chicago 65000
EOF
```

Yeh tasks complete karein:

1. Employee names display karein.
2. Names aur job titles display karein.
3. Chicago mein rehne wale employees display karein.
4. 80,000 se zyada salary wale employees display karein.
5. Heading ke saath names aur salaries display karein.
6. Total salary calculate karein.
7. Average salary calculate karein.
8. Sab se zyada salary wala employee display karein.
9. Chicago ke employees count karein.
10. Har employee ka name aur us ke record ki field count display karein.

### Solutions

```bash
# 1. Employee names
awk '{print $2}' employees.txt

# 2. Names aur job titles
awk '{print $2, $3}' employees.txt

# 3. Chicago ke employees
awk '$4 == "Chicago" {print}' employees.txt

# 4. 80,000 se zyada salary
awk '$5 > 80000 {print $2, $5}' employees.txt

# 5. Heading ke saath names aur salaries
awk 'BEGIN {print "Name Salary"} {print $2, $5}' employees.txt

# 6. Total salary
awk '{sum += $5} END {print "Total:", sum}' employees.txt

# 7. Average salary
awk '{sum += $5}
     END {if (NR > 0) print "Average:", sum / NR}' employees.txt

# 8. Sab se zyada salary wala employee
awk 'NR == 1 || $5 > max {max=$5; name=$2}
     END {print name, max}' employees.txt

# 9. Chicago ke employees count karna
awk '$4 == "Chicago" {count++}
     END {print "Chicago employees:", count}' employees.txt

# 10. Name aur field count
awk '{print $2, NF}' employees.txt
```

---

## 25. Quick knowledge check

1. AWK ka naam kin logon ke surnames se bana hai?
2. `$0` ka kya matlab hai?
3. `$1` kya represent karta hai?
4. `NR` aur `NF` mein kya farq hai?
5. `$NF` kya display karta hai?
6. `-F` option kya karta hai?
7. `BEGIN` aur `END` blocks kab run hote hain?
8. `FS` aur `OFS` mein kya farq hai?
9. Matching records ka count kaise karte hain?
10. Shell variable ko safely AWK mein kaise pass karte hain?
11. AWK programs aam tor par single quotes mein kyun likhe jate hain?
12. AWK, `grep` aur `cut` se kis tarah mukhtalif hai?

---

## 26. Quick reference

```bash
# Poori line display karna
awk '{print $0}' file

# Field 1 display karna
awk '{print $1}' file

# Multiple fields display karna
awk '{print $1, $3}' file

# Colon delimiter use karna
awk -F: '{print $1}' file

# String condition apply karna
awk '$2 == "running" {print $1}' file

# Numeric condition apply karna
awk '$3 > 50 {print $1, $3}' file

# Line numbers display karna
awk '{print NR, $0}' file

# Aakhri field display karna
awk '{print $NF}' file

# Aakhri se pehli field display karna
awk '{print $(NF-1)}' file

# Heading print karna
awk 'BEGIN {print "Report"} {print}' file

# Records count karna
awk '{count++} END {print count}' file

# Values add karna
awk '{sum += $3} END {print sum}' file

# Output delimiter set karna
awk -F: 'BEGIN {OFS=" -> "} {print $1, $2}' file

# Regular expression use karna
awk '$2 ~ /running/ {print}' file

# Shell variable pass karna
awk -v value="$variable" '$1 == value {print}' file

# AWK program file run karna
awk -f program.awk file
```

## Final summary

AWK ek powerful text-processing aur parsing language hai. Yeh input ko records ke tor par parhta hai, records ko fields mein divide karta hai, conditions apply karta hai, calculations karta hai aur output format karta hai.

Yaad rakhein:

```text
grep = lines search ya filter karna
cut  = simple fields ya characters extract karna
awk  = parse, filter, calculate aur format karna
```
