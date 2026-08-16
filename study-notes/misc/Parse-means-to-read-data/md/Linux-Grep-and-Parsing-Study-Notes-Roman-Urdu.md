# Linux `grep` Command aur Parsing — Roman Urdu Study Notes

## Learning objectives

In notes ko parhne ke baad aap:

- `grep` ka purpose aur us ke naam ki origin samjha sakenge.
- Files aur command output mein text ya patterns search kar sakenge.
- `grep` ke common options use kar sakenge.
- Basic aur extended regular expressions use kar sakenge.
- `grep` ko `cut` aur doosri Linux commands ke saath combine kar sakenge.
- Linux administration aur troubleshooting mein `grep` use kar sakenge.

---

## 1. `grep` kya hai?

`grep` ek Linux command hai jo files ya command output mein **matching text ya pattern search** karti hai.

Asaan alfaaz mein:

> `grep` required word ya pattern wali lines dhoond kar display karta hai.

`cut` aam tor par selected fields ya characters nikalta hai, jabke `grep` aam tor par **poori matching lines** select aur display karta hai.

---

## 2. `grep` kis cheez ka short form hai?

`grep` ka naam purane `ed` text-editor ke is command se aya hai:

```text
g/re/p
```

| Hissa | Matlab |
|---|---|
| `g` | Globally, yani har jagah |
| `re` | Regular expression |
| `p` | Print |

Asaan alfaaz mein:

> Regular expression ko globally search karo aur matching lines print karo.

---

## 3. Basic syntax

```bash
grep [OPTIONS] "PATTERN" FILE
```

Example:

```bash
grep "root" /etc/passwd
```

Possible output:

```text
root:x:0:0:root:/root:/bin/bash
```

### Command breakdown

| Hissa | Matlab |
|---|---|
| `grep` | Search command run karta hai |
| `"root"` | Search kiya jane wala text ya pattern hai |
| `/etc/passwd` | Woh file hai jis mein search karna hai |

Asaan alfaaz mein:

> `/etc/passwd` mein search karo aur har woh line display karo jis mein `root` ho.

---

## 4. Practice file banana

```bash
cat > servers.txt <<'EOF'
web01 running 25
web02 stopped 80
db01 running 65
EOF
```

> Redirection operator `>` here-document ka content `servers.txt` mein save karta hai. Aakhri `EOF` apni line par akela hona chahiye.

`running` search karein:

```bash
grep "running" servers.txt
```

Output:

```text
web01 running 25
db01 running 65
```

`grep` har woh line display karta hai jis mein search pattern milta hai.

---

## 5. Command output mein search karna

Pipe (`|`) ek command ka output doosri command ko input ke tor par deta hai.

```bash
ps aux | grep "sshd"
```

Processing steps:

1. `ps aux` running processes display karta hai.
2. `|` output ko `grep` ke paas bhejta hai.
3. `grep "sshd"` sirf `sshd` wali lines display karta hai.

Doosre examples:

```bash
ip address | grep "inet"
```

```bash
systemctl list-units --type=service | grep "running"
```

---

## 6. Common `grep` options

| Option | Matlab |
|---|---|
| `-i` | Uppercase aur lowercase ka farq ignore karta hai |
| `-v` | Woh lines display karta hai jo match nahi kartin |
| `-n` | Line numbers display karta hai |
| `-c` | Matching lines count karta hai |
| `-w` | Poora word match karta hai |
| `-x` | Poori line exact match karta hai |
| `-r` ya `-R` | Directory mein recursively search karta hai |
| `-l` | Sirf matching files ke names display karta hai |
| `-L` | Un files ke names display karta hai jin mein match na ho |
| `-o` | Sirf matching hissa display karta hai |
| `-E` | Extended regular expressions use karta hai |
| `-F` | Pattern ko regex ke bajaye plain text samajhta hai |
| `-q` | Quiet mode; normal output display nahi karta |
| `-A` | Match ke baad wali lines display karta hai |
| `-B` | Match se pehle wali lines display karta hai |
| `-C` | Match se pehle aur baad wali lines display karta hai |

---

## 7. Important option examples

### `-i` se case ignore karna

```bash
grep -i "error" app.log
```

Yeh in sab ko match kar sakta hai:

```text
error
Error
ERROR
```

### `-n` se line numbers display karna

```bash
grep -n "failed" app.log
```

Example output:

```text
15:Login failed
28:Backup failed
```

Yahan `15` aur `28` line numbers hain.

### `-c` se matching lines count karna

```bash
grep -c "running" servers.txt
```

Output:

```text
2
```

> `grep -c` matching **lines** count karta hai, zaroori nahi ke total matching words count kare.

### `-v` se nonmatching lines display karna

```bash
grep -v "running" servers.txt
```

Output:

```text
web02 stopped 80
```

`-v` match ko invert yani ulta kar deta hai.

### `-w` se poora word match karna

Maan lein file mein yeh data hai:

```text
user
username
superuser
```

Command:

```bash
grep -w "user" file.txt
```

Output:

```text
user
```

`-w` ke baghair `grep "user"` teenon lines ko match kar sakta hai.

### `-x` se poori line exact match karna

```bash
grep -x "running" status.txt
```

Yeh sirf us line ko match karega jis ka poora content exactly `running` ho.

### `-o` se sirf matching hissa display karna

```bash
echo "Server IP is 192.168.1.10" | grep -o "192.168.1.10"
```

Output:

```text
192.168.1.10
```

Normal tor par `grep` poori matching line display karta hai. `-o` sirf matched hissa display karta hai.

### `-F` se fixed-string matching

```bash
grep -F "192.168.1.10" network.txt
```

`-F` ke saath dot jaise characters regex symbols ke bajaye literal plain text samjhe jate hain.

### `-q` se quiet mode

```bash
grep -q "sshd" services.txt
echo $?
```

- Exit status `0`: Match mil gaya.
- Exit status `1`: Match nahi mila.
- Exit status `1` se bara: Koi error hua.

Shell script condition mein example:

```bash
if grep -q "running" servers.txt; then
    echo "At least one running server was found"
fi
```

---

## 8. Multiple patterns search karna

### Multiple `-e` options use karna

```bash
grep -e "error" -e "failed" app.log
```

Yeh `error` ya `failed` mein se kisi ek ko contain karne wali lines display karta hai.

### Extended regular expression use karna

```bash
grep -E "error|failed" app.log
```

Extended regular expression mein `|` ka matlab **OR** hota hai.

Letter case bhi ignore karein:

```bash
grep -Ei "error|failed" app.log
```

---

## 9. Directories mein recursively search karna

`/etc/ssh/` aur us ki subdirectories ki files mein search karein:

```bash
grep -r "PermitRootLogin" /etc/ssh/
```

Line numbers bhi display karein:

```bash
grep -rn "PermitRootLogin" /etc/ssh/
```

Letter case ignore karein:

```bash
grep -rni "error" /var/log/
```

Sirf matching filenames display karein:

```bash
grep -rl "PermitRootLogin" /etc/ssh/
```

Woh filenames display karein jin mein match nahi hai:

```bash
grep -rL "PermitRootLogin" /etc/ssh/
```

> Permissions ki wajah se normal user kuch system files nahi parh sakta. `sudo` sirf tab use karein jab aap authorized hon aur us ki zaroorat ho.

---

## 10. Match ke aas paas ki lines display karna

Context options logs investigate karte waqt bohat useful hain.

### Match ke baad do lines

```bash
grep -A 2 "ERROR" app.log
```

### Match se pehle do lines

```bash
grep -B 2 "ERROR" app.log
```

### Match se pehle aur baad do-do lines

```bash
grep -C 2 "ERROR" app.log
```

---

## 11. `grep` aur regular expressions

**Regular expression**, jise regex bhi kehte hain, text ko describe karne wala pattern hota hai.

### `^` se line ka beginning match karna

```bash
grep "^root" /etc/passwd
```

Yeh un lines ko match karta hai jo `root` se shuru hoti hain.

### `$` se line ka ending match karna

```bash
grep "bash$" /etc/passwd
```

Yeh un lines ko match karta hai jo `bash` par khatam hoti hain.

### `.` se koi bhi ek character match karna

```bash
grep "web0." servers.txt
```

Dot kisi bhi ek character ko represent karta hai. Is liye yeh `web01` aur `web02` ko match kar sakta hai.

### Brackets se set ka ek character match karna

```bash
grep "web0[12]" servers.txt
```

Yeh `web01` ya `web02` ko match karta hai.

### Comment se shuru hone wali lines

```bash
grep "^#" configuration.conf
```

### Blank lines display karna

```bash
grep "^$" configuration.conf
```

### Blank lines aur comments ignore karna

```bash
grep -vE '^[[:space:]]*(#|$)' configuration.conf
```

Yeh command remove karti hai:

- Blank lines
- Sirf spaces wali lines
- Woh comment lines jin ka pehla non-space character `#` ho

Configuration files ko clearly parhne mein yeh command useful hai.

---

## 12. Linux administration examples

### Bash login shell wale users dhoondhna

```bash
grep "/bin/bash$" /etc/passwd
```

### Specific user dhoondhna

```bash
grep "^ali:" /etc/passwd
```

Exact account lookup ke liye yeh command aksar zyada suitable hai:

```bash
getent passwd ali
```

### RHEL-based system par failed SSH logins dhoondhna

```bash
sudo grep "Failed password" /var/log/secure
```

### Ubuntu-based system par failed SSH logins dhoondhna

```bash
sudo grep "Failed password" /var/log/auth.log
```

### SSH configuration setting check karna

```bash
grep "^PermitRootLogin" /etc/ssh/sshd_config
```

### Application log mein errors dhoondhna

```bash
grep -i "error" application.log
```

### `grep` ki apni line ke baghair process search karna

```bash
ps aux | grep "[s]shd"
```

Pattern `[s]shd`, `sshd` ko match karta hai lekin aam tor par `grep` command ki apni line ko result mein aane se rokta hai.

Exact process lookup ke liye yeh command aksar zyada clean hai:

```bash
pgrep -a sshd
```

### Current boot logs mein errors search karna

```bash
journalctl -b | grep -i "error"
```

---

## 13. Kya `grep` parsing command hai?

`grep` Linux text processing ka hissa hai, lekin us ka main kaam **lines search aur filter karna** hai, fields nikalna nahi.

Maan lein `servers-colon.txt` mein yeh data hai:

```text
web01:running:25
web02:stopped:80
db01:running:65
```

### `grep` se matching lines select karna

```bash
grep "running" servers-colon.txt
```

Output:

```text
web01:running:25
db01:running:65
```

### `cut` se field nikalna

```bash
cut -d: -f1 servers-colon.txt
```

Output:

```text
web01
web02
db01
```

### `grep` aur `cut` ko combine karna

Sirf running servers ke names display karein:

```bash
grep "running" servers-colon.txt | cut -d: -f1
```

Output:

```text
web01
db01
```

Processing flow:

```text
File → grep matching lines select karta hai → cut required field nikalta hai
```

---

## 14. `grep`, `cut` aur `awk` ka muqabla

| Command | Main purpose |
|---|---|
| `grep` | Matching lines dhoondta ya filter karta hai |
| `cut` | Fields, characters ya bytes nikalta hai |
| `awk` | Advanced field processing, conditions aur calculations karta hai |

Examples:

```bash
# Running-server records dhoondhna
grep "running" servers-colon.txt

# Har server ka name nikalna
cut -d: -f1 servers-colon.txt

# Sirf un servers ke names jo exactly running hon
awk -F: '$2 == "running" {print $1}' servers-colon.txt
```

---

## 15. Patterns ko quotes mein likhna

Patterns ko aam tor par quotes mein likhna chahiye:

```bash
grep "Failed password" auth.log
```

Single quotes regular expressions ke liye khaas tor par useful hain, kyun ke shell un ke andar ke characters expand nahi karta:

```bash
grep -E 'error|failed' app.log
```

Jab pattern mein shell variable include karna ho to double quotes use karein:

```bash
search_word="running"
grep "$search_word" servers.txt
```

---

## 16. Exit status samajhna

`grep` run karne ke baad us ka exit status check karein:

```bash
grep "running" servers.txt
echo $?
```

| Exit status | Matlab |
|---:|---|
| `0` | Ek ya zyada matches mil gaye |
| `1` | Koi match nahi mila |
| `2` ya zyada | Koi error hua |

Shell scripting mein exit status bohat important hota hai.

---

## 17. `grep` use karne se pehle thinking process

Yeh sawalat poochhein:

1. Mera input kahan hai: file mein ya command output mein?
2. Mujhe kaunsa text ya pattern search karna hai?
3. Kya search case-sensitive honi chahiye?
4. Mujhe matching lines chahiye ya nonmatching lines?
5. Kya mujhe line numbers, count ya surrounding context chahiye?
6. Main ek file search kar raha hoon ya poori directory?

Basic flow:

```text
Input → search pattern → grep options → matching lines
```

---

## 18. Practice lab

Practice log banayein:

```bash
cat > application.log <<'EOF'
2026-07-31 INFO Application started
2026-07-31 WARNING Disk usage is 80 percent
2026-07-31 ERROR Backup failed
2026-07-31 INFO User logged in
2026-07-31 error Network connection failed
2026-07-31 INFO Application stopped
EOF
```

Yeh tasks complete karein:

1. Uppercase `ERROR` wali lines display karein.
2. Letter case ignore karke tamam error lines display karein.
3. Matching line numbers display karein.
4. Letter case ignore karke error lines count karein.
5. Woh lines display karein jin mein `INFO` na ho.
6. Har error se ek line pehle aur ek line baad display karein.
7. `ERROR` ya `WARNING` mein se koi ek rakhne wali lines search karein.
8. Case ignore karke sirf matching word `failed` display karein.

### Solutions

```bash
# 1. Sirf uppercase ERROR
grep "ERROR" application.log

# 2. Case ignore karke tamam error lines
grep -i "error" application.log

# 3. Matching line numbers
grep -in "error" application.log

# 4. Matching lines count karna
grep -ic "error" application.log

# 5. Woh lines jin mein INFO nahi hai
grep -v "INFO" application.log

# 6. Har error se ek line pehle aur ek line baad
grep -iC 1 "error" application.log

# 7. ERROR ya WARNING
grep -E "ERROR|WARNING" application.log

# 8. Sirf matching word display karna
grep -io "failed" application.log
```

---

## 19. Quick knowledge check

1. `grep` ka main purpose kya hai?
2. `grep` ka naam kahan se aya hai?
3. `grep -i` kya karta hai?
4. `grep -v` ka purpose kya hai?
5. `-w` aur `-x` mein kya farq hai?
6. Kya `grep -c` matching lines count karta hai ya matching words?
7. Regular expressions mein `^` aur `$` ka kya matlab hai?
8. Directory mein recursively search kaise karte hain?
9. `-A`, `-B` aur `-C` kya display karte hain?
10. `grep` ke exit statuses `0` aur `1` ka kya matlab hai?
11. `grep`, `cut` aur `awk` ka farq explain karein.
12. Is pipeline ko explain karein:

```bash
grep "running" servers-colon.txt | cut -d: -f1
```

---

## 20. Quick reference

```bash
# Basic search
grep "pattern" file

# Letter case ignore karna
grep -i "pattern" file

# Line numbers display karna
grep -n "pattern" file

# Matching lines count karna
grep -c "pattern" file

# Nonmatching lines display karna
grep -v "pattern" file

# Poora word match karna
grep -w "word" file

# Sirf matching hissa display karna
grep -o "pattern" file

# Extended regular expressions use karna
grep -E 'error|failed' file

# Fixed-string search
grep -F "literal.text" file

# Recursively search karna
grep -rn "pattern" directory/

# Match ke aas paas context display karna
grep -C 2 "pattern" file

# Line ka beginning match karna
grep '^pattern' file

# Line ka ending match karna
grep 'pattern$' file

# Command output mein search karna
command | grep "pattern"

# Shell script ke liye quiet check
grep -q "pattern" file
```

## Final summary

`grep` files ya command output ko search karta hai aur word ya pattern se match hone wali lines display karta hai.

```bash
grep "running" servers.txt
```

Is ka matlab hai:

> `servers.txt` mein search karo aur har woh line display karo jis mein `running` ho.

Yaad rakhein:

```text
grep = lines dhoondhna ya filter karna
cut  = fields ya characters nikalna
awk  = advanced text processing
```
