# Linux `sed` Command aur Parsing — Roman Urdu Study Notes

## Learning objectives

In notes ko parhne ke baad aap:

- Samjha sakenge ke `sed` kya hai aur stream editing kaise kaam karti hai.
- Text ko search, replace, print, delete, insert, append aur change kar sakenge.
- Line addresses, ranges, patterns, flags aur regular expressions use kar sakenge.
- Changes preview karke backup ke saath files safely edit kar sakenge.
- Linux Administrator pipelines mein `sed` use kar sakenge.
- Faisla kar sakenge ke `grep`, `cut`, `awk` ya `sed` kab use karna hai.

---

## 1. `sed` kya hai?

`sed` ka matlab hai:

```text
Stream Editor
```

Yeh Linux text-processing command hai jo:

- Text search karti hai.
- Text replace karti hai.
- Lines delete karti hai.
- Selected lines print karti hai.
- Text insert ya append karti hai.
- Command output transform karti hai.
- Repeated file edits automate karti hai.

Asaan alfaaz mein:

> `sed` text ko stream ke tor par parhta hai, editing instructions apply karta hai aur transformed result display karta hai.

Stream file, pipe, command output ya standard input se aa sakti hai.

---

## 2. Isay stream editor kyun kehte hain?

`vim` ya `nano` jaisa interactive editor file kholta hai aur aap manually edit karte hain. `sed` text ko automatically process karta hai:

```text
Input stream → sed instruction → transformed output
```

Example:

```bash
echo "I like Linux" | sed 's/Linux/Bash/'
```

Output:

```text
I like Bash
```

---

## 3. Kya `sed` parsing tool hai?

`sed` mainly stream editor aur text-transformation tool hai. Yeh parsing workflow mein yeh kaam kar sakta hai:

- Patterns dhoondhna.
- Records select karna.
- Unwanted text remove karna.
- Matching hissa extract karna.
- Delimiters replace karna.
- Doosre tool se pehle input clean karna.

Lekin yeh AWK ki tarah primarily field-processing tool nahi hai.

```text
grep = lines search ya filter karna
cut  = simple fields extract karna
awk  = fields parse, calculate aur format karna
sed  = text search, replace aur transform karna
```

---

## 4. Basic syntax aur behavior

```bash
sed [OPTIONS] 'COMMAND' FILE
```

Example:

```bash
sed 's/Linux/Bash/' notes.txt
```

| Hissa | Matlab |
|---|---|
| `sed` | Stream editor run karta hai |
| `'...'` | `sed` instruction ko contain karta hai |
| `s` | Substitute command |
| `Linux` | Search pattern |
| `Bash` | Replacement text |
| `notes.txt` | Input file |

Default tor par `sed`:

1. Ek line parhta hai.
2. Instruction apply karta hai.
3. Resulting line print karta hai.
4. Har line ke liye yeh process repeat karta hai.

Jab tak in-place editing request na ki jaye, original file modify nahi hoti.

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

## 6. Substitute command

Sab se common `sed` instruction substitution hai:

```text
s/search/replacement/flags
```

| Hissa | Matlab |
|---|---|
| `s` | Substitute yani replace karna |
| `search` | Dhoondhne wala text ya pattern |
| `replacement` | Naya text |
| `flags` | Optional controls |

### Har line ka pehla match replace karna

```bash
sed 's/running/active/' servers.txt
```

Output:

```text
web01 active 25
web02 stopped 80
db01 active 65
```

### Sirf pehla occurrence replace karna

```bash
echo "Linux Linux Linux" | sed 's/Linux/Bash/'
```

Output:

```text
Bash Linux Linux
```

### `g` se har occurrence replace karna

```bash
echo "Linux Linux Linux" | sed 's/Linux/Bash/g'
```

Output:

```text
Bash Bash Bash
```

> `g` ka matlab har processed line ke andar tamam matches hain, poori file ka sirf ek global match nahi.

### Common substitution flags

| Flag | Matlab |
|---|---|
| `g` | Har line ke tamam occurrences replace karta hai |
| `I` | GNU `sed` mein letter case ignore karta hai |
| `p` | Substitution successful ho to line print karta hai |
| Number | Sirf us numbered occurrence ko replace karta hai |

### GNU `sed` mein letter case ignore karna

```bash
echo "Linux LINUX linux" | sed 's/linux/Bash/gI'
```

### Sirf doosra occurrence replace karna

```bash
echo "Linux Linux Linux" | sed 's/Linux/Bash/2'
```

Output:

```text
Linux Bash Linux
```

---

## 7. Delimiter choose karna

Slash traditional delimiter hai:

```bash
sed 's/old/new/' file
```

Paths ke liye doosra character zyada clear ho sakta hai:

```bash
echo "/home/ali/scripts" | sed 's|/home/ali|/opt/admin|'
```

Output:

```text
/opt/admin/scripts
```

Possible delimiters mein `|`, `#`, `@` aur `:` shamil hain.

---

## 8. Selected lines print karna

Default tor par `sed` har processed line automatically print karta hai. `-n` automatic printing band karta hai aur `p` selected lines print karta hai.

### Line 2 print karna

```bash
sed -n '2p' servers.txt
```

Output:

```text
web02 stopped 80
```

`-n` ke baghair yeh line 2 ko do baar print karega:

```bash
sed '2p' servers.txt
```

### Lines 1 se 2 tak print karna

```bash
sed -n '1,2p' servers.txt
```

### Aakhri line print karna

```bash
sed -n '$p' servers.txt
```

### Pattern se match hone wali lines print karna

```bash
sed -n '/running/p' servers.txt
```

Output:

```text
web01 running 25
db01 running 65
```

Yeh is ke similar hai:

```bash
grep "running" servers.txt
```

---

## 9. Lines delete karna

`d` command selected records ko output se delete karta hai.

### Line 2 delete karna

```bash
sed '2d' servers.txt
```

### Lines 1 se 2 tak delete karna

```bash
sed '1,2d' servers.txt
```

### Aakhri line delete karna

```bash
sed '$d' servers.txt
```

### Matching lines delete karna

```bash
sed '/stopped/d' servers.txt
```

### Blank ya sirf whitespace wali lines delete karna

```bash
sed '/^[[:space:]]*$/d' file.txt
```

### Comment lines delete karna

```bash
sed '/^[[:space:]]*#/d' configuration.conf
```

### Comments aur blank lines dono delete karna

```bash
sed -E '/^[[:space:]]*(#|$)/d' configuration.conf
```

Yeh active configuration lines display karne ke liye useful hai.

---

## 10. Addresses aur ranges

**Address** `sed` ko batata hai ke command kis line ya pattern par apply karni hai.

### Sirf line 2 par text replace karna

```bash
sed '2s/stopped/maintenance/' servers.txt
```

### Sirf lines 1 se 2 par replace karna

```bash
sed '1,2s/running/active/' servers.txt
```

### Sirf `web` wali lines par replace karna

```bash
sed '/web/s/running/active/' servers.txt
```

Processing:

1. `web` contain karne wale records select karo.
2. Sirf un records par substitution run karo.

### Ek pattern se doosre pattern tak print karna

```bash
sed -n '/START/,/END/p' file.txt
```

Yeh `START` se matching record se `END` se matching record tak print karta hai.

---

## 11. Insert, append aur change

### `i` se line se pehle text insert karna

```bash
sed '1i Server Status Report' servers.txt
```

### `a` se line ke baad text append karna

```bash
sed '$a End of Report' servers.txt
```

### Matching record se pehle insert karna

```bash
sed '/web02/i Attention: Check the next server' servers.txt
```

### Matching record ke baad append karna

```bash
sed '/web02/a Investigation required' servers.txt
```

### `c` se poori line change karna

```bash
sed '2c web02 maintenance 80' servers.txt
```

### Har matching line change karna

```bash
sed '/stopped/c Server unavailable' servers.txt
```

---

## 12. Multiple commands

### Multiple `-e` options

```bash
sed -e 's/running/active/g' \
    -e 's/stopped/inactive/g' servers.txt
```

### Semicolon se commands separate karna

```bash
sed 's/running/active/g; s/stopped/inactive/g' servers.txt
```

### Multiline command block

```bash
sed '
s/running/active/g
s/stopped/inactive/g
' servers.txt
```

---

## 13. Regular expressions

Extended regular expressions ke liye `-E` use karein:

```bash
sed -E 's/error|failed/PROBLEM/g' application.log
```

### Common regex symbols

| Symbol | Matlab |
|---|---|
| `^` | Line ka beginning |
| `$` | Line ka ending |
| `.` | Koi bhi ek character |
| `*` | Zero ya zyada repetitions |
| `+` | `-E` ke saath ek ya zyada repetitions |
| `?` | `-E` ke saath zero ya ek occurrence |
| `[abc]` | Set mein se koi ek character |
| `[^abc]` | Set mein na hone wala koi ek character |
| `[0-9]` | Ek digit |
| `( )` | `-E` ke saath grouping |
| `|` | `-E` ke saath OR |

### Har line ke shuru mein prefix add karna

```bash
sed 's/^/SERVER: /' servers.txt
```

### Har line ke aakhir mein suffix add karna

```bash
sed 's/$/ checked/' servers.txt
```

### Leading whitespace remove karna

```bash
sed 's/^[[:space:]]*//' file.txt
```

### Trailing whitespace remove karna

```bash
sed 's/[[:space:]]*$//' file.txt
```

### Leading aur trailing whitespace dono remove karna

```bash
sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//' file.txt
```

---

## 14. Capturing groups aur backreferences

Capturing groups `sed` ko matched text ke hisse yaad rakhne dete hain.

```bash
echo "Khalid Khan" | sed -E 's/([A-Za-z]+) ([A-Za-z]+)/\2, \1/'
```

Output:

```text
Khan, Khalid
```

Explanation:

- Pehla `([A-Za-z]+)` pehla word capture karta hai.
- Doosra group doosra word capture karta hai.
- `\1` pehle captured group ko refer karta hai.
- `\2` doosre captured group ko refer karta hai.

### `&` se poora match dobara use karna

```bash
echo "Server web01 is running" | sed 's/web01/[&]/'
```

Output:

```text
Server [web01] is running
```

Replacement text mein `&` poore matched text ko represent karta hai.

---

## 15. Line ka hissa extract karna

`sed` primarily field extractor nahi hai, lekin substitution, `-n` aur `p` se matching text extract kiya ja sakta hai.

```bash
echo "User: khalid" | sed -n 's/^User: //p'
```

Output:

```text
khalid
```

Yeh is tarah kaam karta hai:

1. `s/^User: //` prefix remove karta hai.
2. `p` sirf successful substitution par line print karta hai.
3. `-n` automatic printing band karta hai.

IP jaisi value extract karna:

```bash
echo "Server IP: 192.168.1.10" |
sed -nE 's/^Server IP: ([0-9.]+)$/\1/p'
```

Output:

```text
192.168.1.10
```

---

## 16. Delimiters transform karna

### Colons ko commas mein badalna

```bash
echo "web01:running:25" | sed 's/:/,/g'
```

Output:

```text
web01,running,25
```

### Ek ya zyada whitespace characters ko commas mein badalna

```bash
sed -E 's/[[:space:]]+/,/g' servers.txt
```

Output:

```text
web01,running,25
web02,stopped,80
db01,running,65
```

---

## 17. Safe in-place editing

Default tor par `sed` transformed text display karta hai aur original file nahi badalta.

File ko directly edit karne ke liye:

```bash
sed -i 's/running/active/g' servers.txt
```

### Editing ke waqt backup banana

```bash
sed -i.bak 's/running/active/g' servers.txt
```

Yeh do files deta hai:

```text
servers.txt
servers.txt.bak
```

Safe workflow:

```bash
# 1. Preview
sed 's/running/active/g' servers.txt

# 2. Backup ke saath edit
sed -i.bak 's/running/active/g' servers.txt

# 3. Verify
cat servers.txt
```

> In-place editing syntax GNU/Linux aur BSD/macOS implementations mein mukhtalif ho sakti hai. Yeh notes mainly GNU `sed` ko describe karte hain jo Linux par common hai.

---

## 18. `sed` script file use karna

Multiple reusable instructions ke liye `cleanup.sed` banayein:

```sed
/^[[:space:]]*#/d
/^[[:space:]]*$/d
s/[[:space:]]*$//
s/running/active/g
```

Run karein:

```bash
sed -f cleanup.sed configuration.txt
```

`-f` option instructions ko file se parhta hai.

---

## 19. Shell variables aur quoting

Maan lein:

```bash
old_status="running"
new_status="active"
```

Jab shell variables expand karne hon to double quotes use karein:

```bash
sed "s/$old_status/$new_status/g" servers.txt
```

Fixed instructions ke liye single quotes prefer karein:

```bash
sed 's/running/active/g' servers.txt
```

Agar variables mein delimiters, backslashes, `&` ya untrusted text ho sakta hai to careful validation aur escaping zaroori hai. Untrusted data ko directly `sed` program mein insert na karein.

---

## 20. Linux Administrator examples

### Active SSH configuration lines display karna

```bash
sed -E '/^[[:space:]]*(#|$)/d' /etc/ssh/sshd_config
```

### SSH configuration replacement preview karna

```bash
sed 's/^PermitRootLogin.*/PermitRootLogin no/' \
    /etc/ssh/sshd_config
```

Production configuration edit karne se pehle:

1. Backup banayein.
2. Change preview karein.
3. Exact target confirm karein.
4. Safely edit karein.
5. Configuration validate karein.
6. Successful validation ke baad hi service reload karein.

SSH configuration validate karein:

```bash
sudo sshd -t
```

### Log mein IPv4 jaisa text mask karna

```bash
sed -E 's/([0-9]{1,3}\.){3}[0-9]{1,3}/[IP-REMOVED]/g' \
    application.log
```

> Yeh IPv4 jaisa text identify karta hai, lekin yeh prove nahi karta ke har octet 0 se 255 ke darmiyan hai.

### `/etc/passwd` ke delimiters displayed output mein badalna

```bash
sed 's/:/ | /g' /etc/passwd
```

### Do markers ke darmiyan section display karna

```bash
sed -n '/START/,/END/p' file.txt
```

---

## 21. Pipelines mein `sed`

### Command output transform karna

```bash
systemctl list-units --type=service |
sed 's/loaded/AVAILABLE/g'
```

### Disk output se percent symbols remove karna

```bash
df -P | sed 's/%//g'
```

### AWK se pehle data clean karna

```bash
sed -E 's/[[:space:]]+/:/g' servers.txt |
awk -F: '$2 == "running" {print $1}'
```

Is example mein sirf AWK zyada simple hai:

```bash
awk '$2 == "running" {print $1}' servers.txt
```

Pipeline tab use karein jab har command real value add kare.

---

## 22. Command summary

| Command | Purpose |
|---|---|
| `s` | Text substitute ya replace karna |
| `p` | Selected lines print karna |
| `d` | Selected lines delete karna |
| `i` | Line se pehle text insert karna |
| `a` | Line ke baad text append karna |
| `c` | Poori selected line change karna |
| `q` | Processing band karna |
| `=` | Line numbers display karna |

### Selected line ke baad processing band karna

```bash
sed '5q' file.txt
```

Yeh line 5 tak display karke processing rok deta hai, jo large stream mein useful ho sakta hai.

---

## 23. Common mistakes

### Mistake 1: `p` ke saath `-n` bhoolna

```bash
sed '2p' file.txt
```

Line 2 do baar nazar ayegi. Correct:

```bash
sed -n '2p' file.txt
```

### Mistake 2: Original file ke change hone ki umeed

```bash
sed 's/old/new/' file.txt
```

Yeh sirf transformed output display karta hai. Backup ke saath edit:

```bash
sed -i.bak 's/old/new/' file.txt
```

### Mistake 3: `g` bhoolna

```bash
sed 's/Linux/Bash/' file.txt
```

Har line ka sirf pehla occurrence change hoga. Tamam occurrences ke liye:

```bash
sed 's/Linux/Bash/g' file.txt
```

### Mistake 4: Path replacement ke liye `/` use karna

Parhna mushkil:

```bash
sed 's/\/home\/ali/\/opt\/ali/' file.txt
```

Zyada clear:

```bash
sed 's|/home/ali|/opt/ali|' file.txt
```

### Mistake 5: Preview se pehle edit karna

Risky:

```bash
sed -i 's/old/new/g' important.conf
```

Safer:

```bash
sed 's/old/new/g' important.conf
sed -i.bak 's/old/new/g' important.conf
```

---

## 24. `grep`, `cut`, `awk` aur `sed`

| Command | Main purpose |
|---|---|
| `grep` | Matching lines search aur filter karta hai |
| `cut` | Simple fields ya characters extract karta hai |
| `awk` | Fields parse, conditions apply, calculate aur format karta hai |
| `sed` | Text search, replace, delete, insert aur transform karta hai |

Colon-separated server data:

```text
web01:running:25
web02:stopped:80
db01:running:65
```

```bash
# grep: running records dhoondhna
grep "running" servers-colon.txt

# cut: server names extract karna
cut -d: -f1 servers-colon.txt

# awk: running servers select karke names print karna
awk -F: '$2 == "running" {print $1}' servers-colon.txt

# sed: running ko active se replace karna
sed 's/running/active/g' servers-colon.txt
```

---

## 25. `sed` kab use karna chahiye?

`sed` use karein jab:

- Text search aur replace karna ho.
- Matching records delete karne hon.
- Lines insert ya append karni hon.
- Text stream clean ya transform karni ho.
- Repeated text edits automate karne hon.
- Configuration changes preview karne hon.
- Delimiters change ya prefixes aur suffixes remove karne hon.

Simple line search ke liye `grep`, simple field extraction ke liye `cut`, aur field-based conditions, calculations aur reports ke liye AWK use karein.

---

## 26. `sed` use karne se pehle thinking process

Yeh process follow karein:

1. Input examine karein.
2. Text ya pattern identify karein.
3. Decide karein ke kaunsi transformation chahiye.
4. Decide karein ek occurrence change karna hai ya tamam.
5. `-i` ke baghair preview karein.
6. File edit karte waqt backup banayein.
7. Result verify karein.
8. Affected configuration ya service validate karein.

Basic flow:

```text
Input → address ya pattern → sed command → transformed output
```

Example:

```bash
sed 's/running/active/g' servers.txt
```

Breakdown:

- Input: `servers.txt`
- Command: `s`, yani substitute
- Search pattern: `running`
- Replacement: `active`
- Flag: `g`, yani har line par tamam occurrences

---

## 27. Practice lab

File banayein:

```bash
cat > employees.txt <<'EOF'
# Employee Data

101:Khalid:LinuxAdmin:Chicago
102:Ali:DevOpsEngineer:Dallas
103:Sara:CloudEngineer:Houston
104:Ahmed:SupportEngineer:Chicago
EOF
```

Yeh tasks complete karein:

1. `Chicago` ko `Illinois` se replace karein.
2. Har colon ko ` | ` se replace karein.
3. Sirf `Engineer` contain karne wali lines display karein.
4. Comment lines delete karein.
5. Blank lines delete karein.
6. Lines 2 se 4 display karein.
7. Pehli line se pehle `Employee Report` add karein.
8. Aakhri line ke baad `End of Report` add karein.
9. `Ali` contain karne wala complete record replace karein.
10. Ek command se comments aur blank lines remove karein.
11. Har data line ke shuru mein `RECORD: ` add karein.
12. `LinuxAdmin` ko `LinuxSystemsAdministrator` se replace karne ka preview karein.

### Solutions

```bash
# 1. Chicago ko Illinois se replace karna
sed 's/Chicago/Illinois/g' employees.txt

# 2. Colons ko pipes se replace karna
sed 's/:/ | /g' employees.txt

# 3. Engineer wali lines display karna
sed -n '/Engineer/p' employees.txt

# 4. Comment lines delete karna
sed '/^[[:space:]]*#/d' employees.txt

# 5. Blank lines delete karna
sed '/^[[:space:]]*$/d' employees.txt

# 6. Lines 2 se 4 display karna
sed -n '2,4p' employees.txt

# 7. Heading add karna
sed '1i Employee Report' employees.txt

# 8. Footer add karna
sed '$a End of Report' employees.txt

# 9. Ali ka complete record replace karna
sed '/:Ali:/c 102:Ali:SiteReliabilityEngineer:Dallas' employees.txt

# 10. Comments aur blank lines remove karna
sed -E '/^[[:space:]]*(#|$)/d' employees.txt

# 11. Sirf data lines par prefix add karna
sed '/^[0-9]/s/^/RECORD: /' employees.txt

# 12. Job-title replacement preview karna
sed 's/LinuxAdmin/LinuxSystemsAdministrator/g' employees.txt
```

---

## 28. Quick knowledge check

1. `sed` ka full form kya hai?
2. Text stream kya hoti hai?
3. `s` command kya karta hai?
4. `g` flag ka kya matlab hai?
5. `p` ke saath aam tor par `-n` kyun use hota hai?
6. `d` command kya karta hai?
7. `i`, `a` aur `c` mein kya farq hai?
8. Kya `sed` default tor par original file modify karta hai?
9. `-i.bak` kya karta hai?
10. Delimiter ke liye `/` ke bajaye `|` kyun useful ho sakta hai?
11. Substitution mein `\1`, `\2` aur `&` ka kya matlab hai?
12. `sed`, `grep`, `cut` aur `awk` se kaise mukhtalif hai?

---

## 29. Quick reference

```bash
# Har line ka pehla match replace karna
sed 's/old/new/' file

# Har line ke tamam matches replace karna
sed 's/old/new/g' file

# Doosra delimiter use karna
sed 's|/old/path|/new/path|g' file

# Ek line print karna
sed -n '2p' file

# Line range print karna
sed -n '2,5p' file

# Matching lines print karna
sed -n '/pattern/p' file

# Ek line delete karna
sed '2d' file

# Matching lines delete karna
sed '/pattern/d' file

# Blank lines delete karna
sed '/^[[:space:]]*$/d' file

# Line se pehle insert karna
sed '1i Heading' file

# Line ke baad append karna
sed '$a Footer' file

# Poori line change karna
sed '2c New line' file

# Extended regular expressions use karna
sed -E 's/error|failed/PROBLEM/g' file

# Backup ke saath edit karna
sed -i.bak 's/old/new/g' file

# Script file se instructions run karna
sed -f commands.sed file

# Prefix add karna
sed 's/^/PREFIX: /' file

# Suffix add karna
sed 's/$/ :SUFFIX/' file

# Leading whitespace remove karna
sed 's/^[[:space:]]*//' file

# Trailing whitespace remove karna
sed 's/[[:space:]]*$//' file

# Do patterns ke darmiyan range print karna
sed -n '/START/,/END/p' file
```

## Final summary

`sed` ek stream editor hai jo text ko search, replace, delete, insert, append aur transform karta hai.

Yaad rakhein:

```text
grep = lines search aur filter karna
cut  = simple fields extract karna
awk  = parse, calculate aur format karna
sed  = text streams edit aur transform karna
```
