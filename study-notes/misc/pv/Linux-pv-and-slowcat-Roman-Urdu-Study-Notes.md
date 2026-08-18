# Linux `pv` aur `slowcat` — Mukammal Roman Urdu Study Notes

## Table of Contents

1. [Seekhnay ke Maqasid](#1-seekhnay-ke-maqasid)
2. [`pv` Kya Hai?](#2-pv-kya-hai)
3. [`slowcat` Kya Hai?](#3-slowcat-kya-hai)
4. [RHEL-Based Systems par Installation](#4-rhel-based-systems-par-installation)
5. [Ubuntu ya Debian par Installation](#5-ubuntu-ya-debian-par-installation)
6. [Temporary Alias Banana](#6-temporary-alias-banana)
7. [Global Alias Banana](#7-global-alias-banana)
8. [Recommended Global Executable](#8-recommended-global-executable)
9. [`slowcat` ko Test Karna](#9-slowcat-ko-test-karna)
10. [Progress-Bar Example Banana](#10-progress-bar-example-banana)
11. [Options ki Explanation](#11-options-ki-explanation)
12. [Alias, Function aur Executable ka Farq](#12-alias-function-aur-executable-ka-farq)
13. [Useful Practical Examples](#13-useful-practical-examples)
14. [Troubleshooting](#14-troubleshooting)
15. [Global Configuration Remove Karna](#15-global-configuration-remove-karna)
16. [Quick Reference](#16-quick-reference)
17. [Aakhri Khulasa](#17-aakhri-khulasa)

---

## 1. Seekhnay ke Maqasid

In notes ko parhnay ke baad aap:

- Samajh saken ge ke `pv` Linux pipeline mein kya karta hai.
- RHEL-based aur Ubuntu-based systems par `pv` install kar saken ge.
- English dictionary ya word-list package install kar saken ge.
- Temporary `slowcat` alias bana saken ge.
- Tamam users ke liye system-wide alias bana saken ge.
- Bash aliases ki limitations samajh saken ge.
- Zyada reliable global `slowcat` executable bana saken ge.
- Output ko selected lines-per-second speed par chala saken ge.
- Progress, speed, percentage aur ETA display kar saken ge.

---

## 2. `pv` Kya Hai?

`pv` ka matlab **Pipe Viewer** hai.

Yeh Linux pipeline mein behnay walay data ko monitor karta hai. Options ke mutabiq `pv` yeh information dikha sakta hai:

- Kitna data process ho chuka hai
- Kitna waqt guzar chuka hai
- Current transfer speed
- Progress percentage
- Kaam complete honay ka estimated remaining time

Basic flow:

```text
Input command ya file
         ↓
        pv
         ↓
Output command ya file
```

Basic example:

```bash
pv large_file.iso > copied_file.iso
```

Is example mein `pv` data ko copy karta hai aur sath progress bhi dikhata hai.

Package references:

- [Fedora `pv` package](https://packages.fedoraproject.org/pkgs/pv/pv/)
- [Debian `pv` package](https://packages.debian.org/sid/pv)

---

## 3. `slowcat` Kya Hai?

Is exercise mein `slowcat` koi alag standard Linux program nahi hai. Yeh `pv` ko use karke banaya gaya custom alias ya command hai:

```bash
alias slowcat='pv -l -L 5 -q'
```

Yeh `cat` ki tarah file display karta hai, lekin output ko slow karke taqreeban paanch lines per second dikhata hai.

```text
Normal cat             slowcat
----------             -------
Foran print karta hai  Controlled speed par print karta hai
Rate limit nahi        5 lines per second
```

Example:

```bash
slowcat /usr/share/dict/words
```

---

## 4. RHEL-Based Systems par Installation

Yeh commands DNF use karnay walay systems ke liye hain, jaise:

- Fedora
- RHEL
- Rocky Linux
- AlmaLinux

Enabled repositories mein packages available hon to `pv` aur English dictionary install karein:

```bash
sudo dnf install -y pv words
```

`words` package `/usr/share/dict` directory mein English dictionary provide karta hai. Mazeed maloomat ke liye [Fedora `words` package](https://packages.fedoraproject.org/pkgs/words/words/fedora-38.html) dekhein.

### `pv` verify karein

```bash
command -v pv
pv --version
```

Possible path:

```text
/usr/bin/pv
```

### Dictionary verify karein

```bash
ls -l /usr/share/dict/words
```

Pehli das lines dekhein:

```bash
head /usr/share/dict/words
```

### Installation flow

```text
dnf install chalayein
        ↓
pv install hoga
        ↓
words install hoga
        ↓
/usr/bin/pv verify karein
        ↓
/usr/share/dict/words verify karein
```

---

## 5. Ubuntu ya Debian par Installation

Pehle package index update karein:

```bash
sudo apt update
```

`pv` aur American English word list install karein:

```bash
sudo apt install -y pv wamerican
```

Ubuntu ka `wamerican` package `/usr/share/dict/american-english` aur `/usr/share/dict/words` provide karta hai. Mazeed maloomat ke liye [Ubuntu `wamerican` file list](https://packages.ubuntu.com/stonking/all/wamerican/filelist) dekhein.

### `pv` verify karein

```bash
command -v pv
pv --version
```

### Dictionary verify karein

```bash
ls -l /usr/share/dict/words
```

Dictionary preview karein:

```bash
head /usr/share/dict/words
```

### Distribution comparison

| Distribution family | Install command | Dictionary package |
|---|---|---|
| RHEL, Fedora, Rocky, AlmaLinux | `sudo dnf install -y pv words` | `words` |
| Ubuntu ya Debian | `sudo apt install -y pv wamerican` | `wamerican` |

---

## 6. Temporary Alias Banana

Current Bash session mein alias banayein:

```bash
alias slowcat='pv -l -L 5 -q'
```

Alias verify karein:

```bash
type slowcat
```

Expected output:

```text
slowcat is aliased to `pv -l -L 5 -q'
```

Test karein:

```bash
slowcat /usr/share/dict/words
```

Command rokne ke liye `Ctrl+C` press karein.

### Important limitation

Yeh alias sirf current shell session mein mojood rahega. Terminal close honay ke baad temporary alias khatam ho jayega.

---

## 7. Global Alias Banana

Global alias ko `/etc/profile.d/` ke andar define kiya ja sakta hai. Jin users ka Bash environment system profile load karta hai unko yeh alias mil jayega.

### Global configuration file banayein

```bash
sudo tee /etc/profile.d/slowcat.sh >/dev/null <<'EOF'
# Global slowcat alias
alias slowcat='pv -l -L 5 -q'
EOF
```

### Permissions set karein

```bash
sudo chmod 644 /etc/profile.d/slowcat.sh
```

Permissions ka matlab:

| Permission | Matlab |
|---|---|
| Owner: `rw-` | Root file ko read aur modify kar sakta hai |
| Group: `r--` | Group members file read kar saktay hain |
| Others: `r--` | Doosray users file read kar saktay hain |

Yeh file shell configuration ke tor par source hoti hai, is liye isay executable permission ki zaroorat nahi.

### Current shell mein load karein

```bash
source /etc/profile.d/slowcat.sh
```

Doosray users:

- Log out karke dobara log in kar saktay hain.
- Naya login shell start kar saktay hain.
- Ya file ko manually source kar saktay hain:

```bash
source /etc/profile.d/slowcat.sh
```

### Global alias verify karein

```bash
type slowcat
```

Expected output:

```text
slowcat is aliased to `pv -l -L 5 -q'
```

### Alias ki important limitation

Bash aliases bunyadi tor par interactive shells ke liye hotay hain. Non-interactive Bash scripts mein aliases normally expand nahi hotay jab tak alias expansion explicitly enable na ki jaye.

Is liye global executable zyada reliable hai agar `slowcat` ko use karna ho:

- Tamam users ke liye
- Bash scripts ke andar
- Non-login shell mein
- Automation tools se

---

## 8. Recommended Global Executable

Sirf alias par depend karnay ke bajaye `/usr/local/bin` ke andar real command banayein.

Suggested script name aur path:

```text
/usr/local/bin/slowcat
```

Command banayein:

```bash
sudo tee /usr/local/bin/slowcat >/dev/null <<'EOF'
#!/bin/bash

# Display text at approximately five lines per second.
exec pv -l -L 5 -q -- "$@"
EOF
```

Executable permission dein:

```bash
sudo chmod 755 /usr/local/bin/slowcat
```

Verify karein:

```bash
type -a slowcat
```

Agar same name ka alias defined nahi hai to possible output hoga:

```text
slowcat is /usr/local/bin/slowcat
```

Test karein:

```bash
slowcat /usr/share/dict/words
```

### Line-by-line explanation

```bash
#!/bin/bash
```

Yeh shebang Bash ko interpreter select karta hai.

```bash
exec pv -l -L 5 -q -- "$@"
```

| Hissa | Matlab |
|---|---|
| `exec` | Wrapper Bash process ko `pv` process se replace karta hai |
| `pv` | Pipe Viewer run karta hai |
| `-l` | Line-based counting use karta hai |
| `-L 5` | Output ko taqreeban paanch lines per second tak limit karta hai |
| `-q` | `pv` ka apna progress display hide karta hai |
| `--` | Command options ke end ko mark karta hai |
| `"$@"` | Tamam supplied filenames aur arguments ko safely forward karta hai |

### `/usr/local/bin` kyun?

`/usr/local/bin` aam tor par administrator ke banaye huay commands ke liye use hota hai jo operating system package manager manage nahi karta. Yeh directory normally users ke `PATH` mein hoti hai.

---

## 9. `slowcat` ko Test Karna

System dictionary ko slow speed par display karein:

```bash
slowcat /usr/share/dict/words
```

Possible output:

```text
A
a
aa
aal
aalii
aam
Aani
aardvark
aardwolf
Aaron
```

Taqreeban paanch lines har second display hongi.

Command ko rokne ke liye:

```text
Ctrl+C
```

`Ctrl+C`, signal number `2` bhejta hai jisko `SIGINT` kehte hain. Yeh running process ko interrupt karta hai.

Aapko aisa message nazar aa sakta hai:

```text
pv: interrupted by a signal: Interrupt: 2
```

---

## 10. Progress-Bar Example Banana

Dictionary ka path variable mein store karein:

```bash
dictionary="/usr/share/dict/words"
```

Complete pipeline chalayein:

```bash
slowcat "$dictionary" |
pv --size "$(stat -c %s "$dictionary")" > /dev/null
```

Isay aik line par bhi likh saktay hain:

```bash
slowcat "$dictionary" | pv --size "$(stat -c %s "$dictionary")" > /dev/null
```

### Pipeline flow

```text
/usr/share/dict/words
          ↓
slowcat 5 lines per second bhejta hai
          ↓
pv bytes, speed, percentage aur ETA measure karta hai
          ↓
/dev/null final normal output discard karta hai
```

### Command breakdown

| Hissa | Maqsad |
|---|---|
| `slowcat "$dictionary"` | Dictionary ko controlled speed par read karta hai |
| `|` | `slowcat` ka stdout, next `pv` ke stdin se connect karta hai |
| `stat -c %s "$dictionary"` | Dictionary ka size bytes mein deta hai |
| `pv --size SIZE` | Expected size se percentage aur ETA calculate karta hai |
| `> /dev/null` | Final normal output discard karta hai |

### Example progress display

```text
1.64KiB 0:00:37 [56.5 B/s] [>                 ] 0% ETA 14:58:57
```

| Display | Matlab |
|---|---|
| `1.64KiB` | Ab tak process hua data |
| `0:00:37` | Guzra hua waqt |
| `56.5 B/s` | Current data-transfer speed |
| `0%` | Complete honay ka percentage |
| `ETA 14:58:57` | Estimated remaining time |

---

## 11. Options ki Explanation

| Short option | Long option | Matlab |
|---|---|---|
| `-l` | `--line-mode` | Rate ke liye bytes ke bajaye lines count karta hai |
| `-L RATE` | `--rate-limit RATE` | Data-transfer rate limit karta hai |
| `-q` | `--quiet` | `pv` ki normal progress information hide karta hai |
| `-s SIZE` | `--size SIZE` | Expected total data size provide karta hai |

Custom command yeh options use karta hai:

```bash
pv -l -L 5 -q
```

Iska matlab:

```text
Line mode use karo
       +
Flow ko 5 lines per second tak limit karo
       +
Internal progress display na dikhao
```

Demonstration mein doosra `pv` progress bar display karta hai.

---

## 12. Alias, Function aur Executable ka Farq

| Method | Example location | Interactive shell | Bash scripts | Tamam users ke liye |
|---|---|---:|---:|---:|
| Temporary alias | Current terminal | Haan | Normally nahi | Nahi |
| User alias | `~/.bashrc` | Haan | Normally nahi | Nahi |
| Global alias | `/etc/profile.d/slowcat.sh` | Profile load ho to haan | Normally nahi | Profile load ho to haan |
| User function | `~/.bashrc` | Haan | Define ya load ho to | Nahi |
| Global executable | `/usr/local/bin/slowcat` | Haan | Haan | Haan |

### Recommendation

Jab reliability important ho to global executable use karein. Jab sirf personal interactive shortcut chahiye ho to alias use karein.

Aik hi name ka alias aur executable dono na banayein jab tak aap command-resolution order na samajhtay hon. Alias same name ke executable ko hide kar sakta hai.

Tamam matching definitions check karein:

```bash
type -a slowcat
```

---

## 13. Useful Practical Examples

### Log file ko slow display karna

```bash
slowcat application.log
```

### Command output ko slow display karna

```bash
find /etc -type f 2>/dev/null | pv -l -L 5 -q
```

### File copy ko monitor karna

```bash
pv source.iso > destination.iso
```

### Compressed archive ko monitor karna

```bash
tar -czf - project/ | pv > project.tar.gz
```

### Archive extract karte waqt flow dekhna

```bash
pv archive.tar.gz | tar -xzf -
```

### Mukhtalif line speed use karna

Do lines per second:

```bash
pv -l -L 2 -q /usr/share/dict/words
```

Das lines per second:

```bash
pv -l -L 10 -q /usr/share/dict/words
```

---

## 14. Troubleshooting

### Problem: `pv: command not found`

Check karein ke `pv` installed hai ya nahi:

```bash
command -v pv
```

RHEL family par install karein:

```bash
sudo dnf install -y pv
```

Ubuntu ya Debian par install karein:

```bash
sudo apt update
sudo apt install -y pv
```

### Problem: `/usr/share/dict/words` mojood nahi

DNF-based system par:

```bash
sudo dnf install -y words
```

Ubuntu ya Debian par:

```bash
sudo apt update
sudo apt install -y wamerican
```

Dobara verify karein:

```bash
ls -l /usr/share/dict/words
```

### Problem: `slowcat: command not found`

Alias configuration load karein:

```bash
source /etc/profile.d/slowcat.sh
```

Executable ka path aur permissions check karein:

```bash
ls -l /usr/local/bin/slowcat
```

Expected executable permissions:

```text
-rwxr-xr-x
```

Check karein ke `/usr/local/bin` aapke `PATH` mein hai:

```bash
echo "$PATH"
```

### Problem: alias executable ko hide kar raha hai

Tamam definitions inspect karein:

```bash
type -a slowcat
```

Current shell se alias temporary remove karein:

```bash
unalias slowcat
```

Bash ki remembered command locations clear karein:

```bash
hash -r
```

### Problem: global file banatay waqt permission denied

`/etc/profile.d` aur `/usr/local/bin` ke andar files create ya modify karne ke liye normally administrative privileges chahiye hoti hain. Diye gaye `tee` aur `chmod` commands ko `sudo` ke sath chalayein.

---

## 15. Global Configuration Remove Karna

### Global alias remove karna

Pehle exact file verify karein:

```bash
ls -l /etc/profile.d/slowcat.sh
```

Phir remove karein:

```bash
sudo rm -- /etc/profile.d/slowcat.sh
```

Current shell se loaded alias remove karein:

```bash
unalias slowcat
```

### Global executable remove karna

Pehle executable verify karein:

```bash
ls -l /usr/local/bin/slowcat
```

Phir remove karein:

```bash
sudo rm -- /usr/local/bin/slowcat
```

---

## 16. Quick Reference

| Task | Command |
|---|---|
| RHEL family par install | `sudo dnf install -y pv words` |
| Ubuntu/Debian par install | `sudo apt install -y pv wamerican` |
| `pv` verify karna | `command -v pv` |
| Version check karna | `pv --version` |
| Word list verify karna | `ls -l /usr/share/dict/words` |
| Temporary alias banana | `alias slowcat='pv -l -L 5 -q'` |
| `slowcat` ki type check karna | `type -a slowcat` |
| Dictionary slowly display karna | `slowcat /usr/share/dict/words` |
| Global alias reload karna | `source /etc/profile.d/slowcat.sh` |
| Running command rokna | `Ctrl+C` |
| File size maloom karna | `stat -c %s FILE` |
| stdout discard karna | `> /dev/null` |

---

## 17. Aakhri Khulasa

`pv` asal installed program hai. `slowcat` aik custom name hai jo `pv` ko use karke text ko taqreeban paanch lines per second par display karta hai.

### Complete installation commands

```bash
# RHEL, Fedora, Rocky Linux ya AlmaLinux
sudo dnf install -y pv words

# Ubuntu ya Debian
sudo apt update
sudo apt install -y pv wamerican
```

### Global alias

```bash
alias slowcat='pv -l -L 5 -q'
```

### Recommended global executable logic

```bash
#!/bin/bash
exec pv -l -L 5 -q -- "$@"
```

### Progress demonstration

```bash
dictionary="/usr/share/dict/words"
slowcat "$dictionary" | pv --size "$(stat -c %s "$dictionary")" > /dev/null
```

### Learning flow

```text
pv aur dictionary install karein
           ↓
slowcat alias ya executable banayein
           ↓
type aur command -v se verify karein
           ↓
Dictionary ko controlled speed par read karein
           ↓
Doosra pv laga kar progress display karein
```

### Final recommendation

```text
Sirf personal terminal shortcut chahiye → alias
Tamam users aur scripts ke liye chahiye → global executable
```

