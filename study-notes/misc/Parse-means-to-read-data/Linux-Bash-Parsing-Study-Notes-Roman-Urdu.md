# Linux Bash Parsing — Study Notes (Roman Urdu)

## Mauzu

Linux aur Bash mein **parse** ka matlab aur istemal.

---

## 1. Parse Ka Matlab Kya Hai?

**Parse** ka matlab data ko parhna, use kaam ke hisson mein divide karna, uski structure ko samajhna, aur required information nikalna hai.

Seedhi definition:

```text
Parse = data ko parhna aur required information nikalna
```

### Asaan Alfaaz Mein

> Parse ka matlab data ko parhna, uske hisson ko samajhna, aur us mein se zaroori information nikalna hai.

---

## 2. Simple Example

Farz karen ke ek log file mein yeh data hai:

```text
2026-07-31 INFO Application started
2026-07-31 ERROR Database connection failed
2026-07-31 WARNING Disk usage is high
```

`ERROR` wali line nikalne ke liye:

```bash
grep "ERROR" application.log
```

Output:

```text
2026-07-31 ERROR Database connection failed
```

Yeh command log file ko parh kar sirf required information dikhati hai.

---

## 3. “Parse Logs and Configurations” Ka Kya Matlab Hai?

Linux Administrator ke liye **parse logs and configurations** ka matlab hai:

- Log ya configuration files ko parhna.
- Important entries search karna.
- Fields ya columns ko alag karna.
- Errors, usernames, IP addresses, ports, ya settings nikalna.
- Raw data ko useful report mein convert karna.
- Nikali hui information ko troubleshooting ya automation mein use karna.

Seedhi baat:

> Log aur configuration files ko parh kar un mein se required information nikalna parsing kehlata hai.

---

## 4. Common Linux Parsing Tools

| Tool | Asal Maqsad | Simple Example |
|---|---|---|
| `grep` | Matching lines dhoondhna | `grep "ERROR" app.log` |
| `awk` | Fields aur columns process karna | `awk '{print $1}' file` |
| `cut` | Selected fields nikalna | `cut -d: -f1 /etc/passwd` |
| `sed` | Text search, transform, ya replace karna | `sed 's/error/ERROR/g' file` |
| `sort` | Lines ko order mein lagana | `sort names.txt` |
| `uniq` | Repeated lines remove ya count karna | `uniq -c` |
| `tr` | Characters translate ya remove karna | `tr 'a-z' 'A-Z'` |
| `jq` | JSON data parse karna | `jq '.name' data.json` |

---

## SORT:


[`Sort` Explanation](./md/Linux-Sort-and-Parsing-Study-Notes.md)

[`Sort` Explanation-roman-Urdu](./md/Linux-Sort-and-Parsing-Study-Notes-Roman-Urdu.md)

## Uniq

[`Uniq` Explanation](./md/Linux-Uniq-and-Parsing-Study-Notes.md)

[`Uniq` Explanation-roman-Urdu](./md/Linux-Uniq-and-Parsing-Study-Notes-Roman-Urdu.md)

## TR

[`TR` Explanation](./md/Linux-TR-and-Parsing-Study-Notes.md)

[`TR` Explanation-roman-Urdu](./md/Linux-TR-and-Parsing-Study-Notes-Roman-Urdu.md)

---

## 5. `grep` Ke Sath Parsing

[`grep` Explanation](./md/Linux-Grep-and-Parsing-Study-Notes.md)

[`grep` Explanation-roman-Urdu](./md/Linux-Grep-and-Parsing-Study-Notes-Roman-Urdu.md)

`grep` kisi word ya pattern wali lines dhoondhta hai.

Example:

```bash
grep "failed" /var/log/syslog
```

Uppercase aur lowercase ko ignore karke search karne ke liye:

```bash
grep -i "error" application.log
```

Matching lines ke numbers dikhane ke liye:

```bash
grep -n "ERROR" application.log
```

### Matlab

File mein hazaron lines ho sakti hain, lekin `grep` sirf woh lines nikalta hai jo hamein chahiye hoti hain.

---

## 6. `cut` Ke Sath Parsing

[`Cut` Explanation](./md/Linux-Cut-and-Parsing-Study-Notes.md)

[`Cut` Explanation-roman-Urdu](./md/Linux-Cut-and-Parsing-Study-Notes-Roman-Urdu.md)

`/etc/passwd` file fields ko separate karne ke liye colon (`:`) use karti hai:

```text
khalid:x:1000:1000:Khalid:/home/khalid:/bin/bash
```

Pehla field nikalne ke liye, jis mein username hota hai:

```bash
cut -d: -f1 /etc/passwd
```

Explanation:

| Hissa | Matlab |
|---|---|
| `-d:` | `:` ko delimiter ya separator samjho |
| `-f1` | Field number 1 dikhao |
| `/etc/passwd` | Input file |

---

## 7. `awk` Ke Sath Parsing

[`AWK` Explanation](./md/Linux-AWK-and-Parsing-Study-Notes.md)

[`awk` Explanation-roman-Urdu](./md/Linux-AWK-and-Parsing-Study-Notes-Roman-Urdu.md)

Farz karen `servers.txt` mein yeh data hai:

```text
web01 running 25
web02 stopped 80
db01 running 65
```

Pehla column dikhane ke liye:

```bash
awk '{print $1}' servers.txt
```

Output:

```text
web01
web02
db01
```

Server ka naam aur status dikhane ke liye:

```bash
awk '{print $1, $2}' servers.txt
```

Sirf stopped server dikhane ke liye:

```bash
awk '$2 == "stopped" {print $1}' servers.txt
```

Output:

```text
web02
```

---

## 8. `sed` Ke Sath Parsing

[`SED` Explanation](./md/Linux-SED-and-Parsing-Study-Notes.md)

[`SED` Explanation-roman-Urdu](./md/Linux-SED-and-Parsing-Study-Notes-Roman-Urdu.md)

`sed` text ko search aur transform kar sakta hai.

Result dikhate waqt `error` ko `ERROR` se replace karne ke liye:

```bash
sed 's/error/ERROR/g' application.log
```

Yeh original file ko modify nahi karta jab tak `-i` jaisa in-place option use na kiya jaye.

Sirf `ERROR` wali lines dikhane ke liye:

```bash
sed -n '/ERROR/p' application.log
```

---

## 9. `jq` Ke Sath JSON Parsing

[`JQ-and-JSON` Explanation](./md/Linux-JQ-and-JSON-Parsing-Study-Notes.md)

[`JQ-and-JSON` Explanation-roman-Urdu](./md/Linux-JQ-and-JSON-Parsing-Study-Notes-Roman-Urdu.md)

Farz karen `server.json` mein yeh data hai:

```json
{
  "name": "web01",
  "status": "running",
  "ip": "192.168.1.10"
}
```

Server ka naam nikalne ke liye:

```bash
jq -r '.name' server.json
```

Output:

```text
web01
```

IP address nikalne ke liye:

```bash
jq -r '.ip' server.json
```

Jab Bash scripts APIs aur JSON output ke sath kaam karti hain, to `jq` bohat useful hota hai.

---

## 10. Linux Administrator Ke Real Examples

### Authentication Failures Dhoondhna

Ubuntu ya Debian systems par:

```bash
grep -i "failed" /var/log/auth.log
```

Kuch RHEL-family systems par:

```bash
grep -i "failed" /var/log/secure
```

### Filesystem Usage Nikalna

```bash
df -h | awk 'NR > 1 {print $1, $5, $6}'
```

### Listening Ports Dhoondhna

```bash
ss -tulnp
```

Sirf port `22` filter karne ke liye:

```bash
ss -tulnp | grep ':22'
```

### Configuration Setting Parhna

```bash
grep '^PermitRootLogin' /etc/ssh/sshd_config
```

### Log Mein Repeated IP Addresses Count Karna

```bash
awk '{print $1}' access.log | sort | uniq -c | sort -nr
```

Yeh pipeline:

1. Pehla field nikalti hai.
2. Values ko sort karti hai.
3. Repeated values count karti hai.
4. Counts ko highest se lowest order mein dikhati hai.

---

## 11. Bash Automation Mein Parsing Ka Istemal

Bash script command ke output ko parse karke decision le sakti hai.

Example:

```bash
#!/bin/bash

usage=$(df / | awk 'NR == 2 {gsub("%", "", $5); print $5}')

if (( usage >= 80 )); then
    echo "Warning: root filesystem usage is ${usage}%" >&2
else
    echo "Disk usage is normal: ${usage}%"
fi
```

Yeh script:

1. `df /` command chalati hai.
2. `awk` se required line aur field select karti hai.
3. `%` symbol remove karti hai.
4. Result ko `usage` variable mein store karti hai.
5. Number ko threshold ke sath compare karti hai.
6. Normal ya warning message print karti hai.

Yeh data ko parse karke uske result ko automation mein use karne ki practical example hai.

---

## 12. Parse, Search, Filter, Aur Transform

Yeh terms aik doosre se related hain, lekin inka matlab bilkul same nahi hai:

| Term | Matlab |
|---|---|
| Parse | Structured data ko samajh kar useful parts nikalna |
| Search | Matching text ya patterns dhoondhna |
| Filter | Sirf required lines ya values rakhna |
| Transform | Data ko doosri form mein change karna |

Ek command pipeline yeh charon operations kar sakti hai.

---

## 13. Zaroori Safety Notes

- Command chalane se pehle use parhen.
- Scripts mein variable expansions ko quote karen.
- Parsing commands ko pehle sample data par test karen.
- Yeh assume na karen ke har file ki structure expected format mein hogi.
- Extract ki hui values ko use karne se pehle validate karen.
- Data format ke mutabiq `grep`, `awk`, `cut`, `sed`, ya `jq` use karen.
- Agar stable machine-readable format available ho, to human-formatted output ko parse karne se parhez karen.
- JSON ko ordinary text samajhne ke bajaye `jq` se parse karen.

---

## 14. Mini Practice Lab

Ek file banayen:

```bash
vim application.log
```

Yeh data add karen:

```text
2026-07-31 INFO Web service started
2026-07-31 ERROR Database connection failed
2026-07-31 WARNING Disk usage reached 75 percent
2026-07-31 ERROR Backup job failed
```

### Task 1: Error Lines Dikhayen

```bash
grep "ERROR" application.log
```

### Task 2: Error Lines Count Karen

```bash
grep -c "ERROR" application.log
```

### Task 3: Log Level Dikhayen

```bash
awk '{print $2}' application.log
```

### Task 4: Har Log Level Ko Count Karen

```bash
awk '{print $2}' application.log | sort | uniq -c
```

---

## 15. Practice Questions

1. Parse ka kya matlab hai?
2. Linux Administrators logs ko parse kyun karte hain?
3. Matching lines dhoondhne ke liye kaunsi command use hoti hai?
4. Fields aur columns process karne ke liye kaunsi command use hoti hai?
5. `cut` command mein `-d:` aur `-f1` ka kya matlab hai?
6. JSON parse karne ke liye kaunsa tool use karna chahiye?
7. Bash automation mein parsing kaise use hoti hai?
8. Extract ki hui values ko validate karna kyun zaroori hai?

---

## Final Summary

**Parse** ka matlab data ko parhna, uski structure ko samajhna, aur useful information nikalna hai.

Common Linux parsing tools:

```text
grep  awk  cut  sed  sort  uniq  tr  jq
```

Simple example:

```bash
grep "ERROR" application.log
```

Behtareen one-line definition:

```text
Parse ka matlab data ko parh kar us mein se zaroori information nikalna hai.
```

