# Linux `$PATH` Environment Variable — Roman Urdu Study Notes

## Learning objectives

In notes ko parhne ke baad aap:

- Samjha sakenge ke `$PATH` environment variable kya karta hai.
- Samajh sakenge ke Bash command ko kaise find karta hai.
- Aliases, functions, built-ins aur external commands mein farq kar sakenge.
- PATH directories ko clearly display aur inspect kar sakenge.
- Directory ko temporarily ya permanently `$PATH` mein add kar sakenge.
- Samajh sakenge ke existing command ke bawajood `command not found` kyun aa sakta hai.
- Ubuntu ke `bat` aur `batcat` naming issue ko troubleshoot kar sakenge.
- Troubleshooting mein `command -v`, `type` aur `hash` use kar sakenge.
- Insecure ya destructive PATH configuration se bach sakenge.
- Broken PATH ko safely recover kar sakenge.

---

## Quick navigation

- [Section 17: `bat` command case study par jayein](#bat-command-case-study)

---

## 1. `$PATH` kya hai?

`PATH` ek environment variable hai jis mein directories ki ordered list hoti hai. Jab aap kisi **external command** ka naam complete path ke baghair enter karte hain to shell in directories mein us command ko search karta hai.

Example:

```bash
ls
```

Complete filesystem search karne ke bajaye Bash `$PATH` mein listed directories check karta hai aur `ls` naam ki executable file milne par usay run karta hai.

Asaan alfaaz mein:

> `$PATH` shell ko batata hai ke external commands kahan search karni hain.

---

## 2. `PATH` aur `$PATH` ka farq

| Form | Matlab |
|---|---|
| `PATH` | Variable ka naam |
| `$PATH` | Variable ki current value |

Example:

```bash
echo "$PATH"
```

Dollar sign `$` shell ko variable expand karke us ki value return karne ke liye kehta hai.

---

## 3. PATH value ka example

```text
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
```

Directories colon (`:`) se separate hoti hain:

```text
directory1:directory2:directory3
```

---

## 4. Bash command ko kaise find karta hai?

Bash sirf `$PATH` search nahi karta. Simplified command-resolution order:

1. Reserved words aur shell syntax.
2. Aliases.
3. Shell functions.
4. Shell built-ins.
5. Cached command locations.
6. `$PATH` se milne wali external executables.

Example:

```bash
cd /tmp
```

`cd` Bash built-in hai. Yeh `$PATH` se milne wali external executable nahi.

Check karein:

```bash
type cd
```

Expected result:

```text
cd is a shell builtin
```

External command check karein:

```bash
type ls
```

Typical result:

```text
ls is /usr/bin/ls
```

Important correction:

> `$PATH` mainly external executable commands locate karta hai—aliases, functions ya `cd` jaisi shell built-ins ko nahi.

---

## 5. Search order left se right hota hai

Agar `$PATH` mein yeh ho:

```text
/usr/local/bin:/usr/bin:/bin
```

Aur aap run karein:

```bash
mycommand
```

Bash check karega:

1. `/usr/local/bin/mycommand`
2. `/usr/bin/mycommand`
3. `/bin/mycommand`

Bash aam tor par pehli suitable match execute karta hai.

Is liye PATH ka order important hai. Shuru mein rakhi directory ki priority baad wali directories se zyada hoti hai.

---

## 6. Current PATH display karna

Predictable output ke liye `printf` use karein:

```bash
printf '%s\n' "$PATH"
```

Yeh bhi use kar sakte hain:

```bash
echo "$PATH"
```

`"$PATH"` ko quote karna achhi shell practice hai.

---

## 7. Har PATH directory ko alag line par dikhana

```bash
echo "$PATH" |
tr ':' '\n'
```

Example output:

```text
/usr/local/sbin
/usr/local/bin
/usr/sbin
/usr/bin
/sbin
/bin
```

Entries ko number karein:

```bash
echo "$PATH" |
tr ':' '\n' |
nl
```

Sirf nonempty unique entries dikhayein:

```bash
echo "$PATH" |
tr ':' '\n' |
awk 'NF' |
sort -u
```

---

## 8. Check karein directory PATH mein hai ya nahi

Readable method:

```bash
echo "$PATH" |
tr ':' '\n' |
grep -Fx "$HOME/.local/bin"
```

Agar directory present ho to print hogi. Agar absent ho to output nahi aayega aur `grep` nonzero status return karega.

Bash pattern method:

```bash
case ":$PATH:" in
    *":$HOME/.local/bin:"*)
        echo "Present in PATH"
        ;;
    *)
        echo "Not present in PATH"
        ;;
esac
```

Surrounding colons partial directory-name matches se bachate hain.

---

## 9. Check karein command kaise resolve hogi

### `command -v`

```bash
command -v ls
command -v bat
command -v batcat
```

Scripts mein yeh preferred check hai.

### `type`

```bash
type ls
type cd
type bat
```

Tamam available resolutions:

```bash
type -a python
```

`type` aliases, functions, built-ins aur external commands identify kar sakta hai.

### Sirf `which` par depend kyun na karein?

`which` mainly PATH mein external executables search karta hai aur aliases, functions ya built-ins ko sahi explain nahi karta. Prefer karein:

```bash
command -v COMMAND
type -a COMMAND
```

---

## 10. Complete path se command run karna

Agar command `$PATH` mein nahi hai tab bhi complete path se run ho sakti hai:

```bash
/usr/bin/batcat --version
```

User directory ki command:

```bash
$HOME/.local/bin/bat --version
```

Command mein slash `/` hone ki wajah se shell ko PATH search karne ki zaroorat nahi hoti.

---

## 11. `./script.sh` kyun required hota hai?

Security reasons ki wajah se current directory `.` normally PATH mein nahi hoti.

Script check karein:

```bash
ls -l script.sh
```

Explicitly run karein:

```bash
./script.sh
```

`./` Bash ko batata hai ke current directory ki file use karo.

Execute permission bhi chahiye:

```bash
chmod +x script.sh
```

Ya execute permission ke baghair Bash ke through run karein:

```bash
bash script.sh
```

---

## 12. Temporary PATH change

Current shell session ke liye `~/.local/bin` add karein:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Verify:

```bash
echo "$PATH" |
tr ':' '\n'
```

Shell close hone par yeh temporary change normally khatam ho jata hai.

---

## 13. Prepend aur append

### Prepend: high priority

```bash
export PATH="$HOME/.local/bin:$PATH"
```

User directory existing directories se pehle search hogi.

### Append: low priority

```bash
export PATH="$PATH:$HOME/.local/bin"
```

User directory existing directories ke baad search hogi.

Prepend tab use karein jab user-installed command ko intentionally priority deni ho. Append tab use karein jab system commands ko priority deni ho.

---

## 14. Bash ke liye permanent PATH configuration

Interactive Bash shells ke liye export statement `~/.bashrc` mein add ki ja sakti hai:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
```

Reload:

```bash
source ~/.bashrc
```

Verify:

```bash
command -v bat
```

Append karne se pehle duplicate line check karein:

```bash
grep -n 'local/bin' ~/.bashrc
```

Agar line pehle se hai to dobara add na karein.

---

## 15. Ubuntu ka `~/.profile` behavior

Ubuntu ke default `~/.profile` mein aam tor par logic hoti hai jo in directories ko un ke exist karne par add karti hai:

```text
$HOME/bin
$HOME/.local/bin
```

Inspect karein:

```bash
grep -n 'local/bin\|HOME/bin' ~/.profile
```

Agar `~/.local/bin` login ke baad create hui ho to current session ko updated PATH nahi mila hoga.

Profile reload karein:

```bash
source ~/.profile
```

Ya sign out karke new login session start karein.

Important:

> Ubuntu mein `~/.bashrc` manually edit karna unnecessary ho sakta hai agar default `~/.profile` pehle hi `~/.local/bin` add karta hai.

---

## 16. Kaun si startup file use karein?

| File | Common purpose |
|---|---|
| `~/.bashrc` | Interactive non-login Bash shells |
| `~/.profile` | Login environment; kai systems par shell-independent settings |
| `~/.bash_profile` | Bash login-shell configuration jab file present ho |
| `/etc/profile` | System-wide login-shell settings |
| `/etc/environment` | Kai Linux systems par system-wide environment assignments; shell script nahi |

Ubuntu par personal command directory ke liye default `~/.profile` handling aksar suitable hai. Interactive Bash-only customization ke liye `~/.bashrc` commonly use hoti hai.

`/etc/environment` mein `export`, command substitutions ya Bash syntax add na karein.

---

<a id="bat-command-case-study"></a>

## 17. Case study: Ubuntu par `bat` command not found

### Scenario

Package installed hai:

```bash
sudo apt install bat -y
```

Lekin yeh fail hota hai:

```bash
bat bakar-key.pem
```

Ubuntu report karta hai:

```text
Command 'bat' not found
```

### Cause 1: Ubuntu executable ka naam `batcat` rakhta hai

Ubuntu/Debian mein `bat` package ki executable commonly yeh hoti hai:

```text
batcat
```

Check:

```bash
command -v batcat
batcat --version
```

Directly use karein:

```bash
batcat FILE
```

### Cause 2: User symlink exists hai lekin searchable nahi

Agar yeh file exist karti hai:

```text
~/.local/bin/bat
```

Check:

```bash
ls -l ~/.local/bin/bat
readlink -f ~/.local/bin/bat
```

Complete path se run karein:

```bash
~/.local/bin/bat --version
```

Agar full path kaam kare lekin `bat` na kare to `~/.local/bin` current PATH mein missing ho sakti hai.

Ubuntu profile reload karein:

```bash
source ~/.profile
hash -r
```

Phir test:

```bash
command -v bat
bat --version
```

### User-level symlink create ya repair karein

```bash
mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat
```

Reload aur verify:

```bash
source ~/.profile
hash -r
command -v bat
```

Expected result:

```text
/home/USERNAME/.local/bin/bat
```

### Recommended priority

1. Immediate use ke liye `batcat` run karein.
2. Short `bat` name ke liye `~/.local/bin` mein user-level symlink banayein.
3. Confirm karein ke `~/.local/bin` PATH mein hai.
4. Real multi-user requirement ke baghair system-wide symlink na banayein.

Security note:

> `.pem` private key ka content screen sharing, screenshot, GitHub ya public group mein expose na karein.

Permissions check karna ho to:

```bash
ls -l bakar-key.pem
chmod 400 bakar-key.pem
```

---

## 18. Bash command hashing

Bash previously resolved executable location yaad rakh sakta hai.

Cached commands display karein:

```bash
hash
```

PATH ya symlink change karne ke baad cache clear karein:

```bash
hash -r
```

Phir check:

```bash
command -v bat
```

---

## 19. Permissions aur executability

Directory ka PATH mein hona kafi nahi. Target command usable bhi honi chahiye.

Check:

```bash
ls -l ~/.local/bin/mycommand
```

Regular script ko execute permission dein:

```bash
chmod +x ~/.local/bin/mycommand
```

Parent directories bhi check karein:

```bash
namei -l ~/.local/bin/mycommand
```

Executable tak pohanchne ke liye user ko directories par traversal permission chahiye.

---

## 20. Broken symbolic links

Filename `~/.local/bin` mein exist kar sakta hai lekin symlink target missing ho sakta hai.

Check:

```bash
ls -l ~/.local/bin/bat
readlink -f ~/.local/bin/bat
```

Agar `readlink -f` valid target na dikhaye to link recreate karein:

```bash
ln -sf /usr/bin/batcat ~/.local/bin/bat
```

---

## 21. Duplicate PATH entries se bachna

Same export line baar baar append karne se duplicate PATH entries ban sakti hain.

Inspect:

```bash
echo "$PATH" |
tr ':' '\n' |
nl
```

Startup files search karein:

```bash
grep -n 'PATH=' ~/.profile ~/.bashrc ~/.bash_profile 2>/dev/null
```

Responsible file edit karke sirf intended configuration rakhein.

Required system directories preserve karein; unreviewed text processing se PATH blindly rebuild na karein.

---

## 22. Security: `.` ko PATH mein add na karein

Is tarah ki configuration avoid karein:

```bash
export PATH=".:$PATH"
```

Agar current directory mein trusted command ke naam wali malicious executable ho to shell usay pehle run kar sakta hai.

Explicit relative path use karein:

```bash
./script.sh
```

Empty PATH entries bhi check karein:

```text
/usr/bin::/bin
```

Kuch contexts mein empty entry current directory represent kar sakti hai aur security risk create karti hai.

Detect karein:

```bash
echo "$PATH" |
tr ':' '\n' |
nl -ba
```

Blank numbered lines empty entries show karti hain.

---

## 23. Security: directory ownership important hai

Privileged ya important PATH entries aisi directories mein na rakhein jo untrusted users ke liye writable hon.

Check:

```bash
ls -ld ~/.local/bin /usr/local/bin /usr/bin
```

Personal directory ke liye:

```bash
chmod 700 ~/.local/bin
```

Yeh tab karein jab directory sirf aap ke user ke liye ho.

System directories ko appropriately `root` own aur manage kare.

---

## 24. `sudo` different PATH kyun use kar sakta hai?

Yeh aap ka user PATH dikhata hai:

```bash
echo "$PATH"
```

Lekin `sudo` sudoers mein defined restricted `secure_path` use kar sakta hai.

Compare karein:

```bash
command -v mycommand
sudo sh -c 'command -v mycommand'
```

`~/.local/bin` ki command user ke liye kaam kar sakti hai lekin `sudo` ke through fail ho sakti hai.

Sirf is behavior ko bypass karne ke liye personal scripts privileged directories mein copy na karein. Decide karein command user-specific honi chahiye ya system-wide.

---

## 25. Broken PATH recover karna

Agar ghalat assignment standard directories remove kar de to common commands bhi kaam karna band kar sakti hain.

Typical Ubuntu system ke liye temporary recovery:

```bash
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
```

Startup files inspect karein:

```bash
grep -n 'PATH=' ~/.profile ~/.bashrc ~/.bash_profile 2>/dev/null
```

Ghalat line correct karke appropriate file reload karein.

Agar command ab bhi na mile to complete path use karein:

```bash
/usr/bin/nano ~/.bashrc
/usr/bin/vim ~/.bashrc
```

Important:

> PATH ko sirf custom directory se replace na karein.

Ghalat:

```bash
export PATH="$HOME/.local/bin"
```

Sahi:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

---

## 26. Safe troubleshooting workflow

Jab `command not found` aaye to is order mein check karein:

### Step 1: Package executable check karein

```bash
command -v batcat
```

### Step 2: Expected custom path check karein

```bash
ls -l ~/.local/bin/bat
```

### Step 3: Complete path test karein

```bash
~/.local/bin/bat --version
```

### Step 4: PATH inspect karein

```bash
echo "$PATH" |
tr ':' '\n' |
nl
```

### Step 5: Correct startup file reload karein

```bash
source ~/.profile
```

Ya jab setting `~/.bashrc` mein ho:

```bash
source ~/.bashrc
```

### Step 6: Bash cache clear karein

```bash
hash -r
```

### Step 7: Resolution verify karein

```bash
command -v bat
type -a bat
bat --version
```

---

## 27. Practice lab

### Task 1: Personal command directory banayein

```bash
mkdir -p ~/.local/bin
```

### Task 2: Small command banayein

```bash
cat > ~/.local/bin/hello-path <<'EOF'
#!/bin/bash
echo "Hello from ~/.local/bin"
EOF
```

### Task 3: Executable banayein

```bash
chmod +x ~/.local/bin/hello-path
```

### Task 4: Complete path se run karein

```bash
~/.local/bin/hello-path
```

### Task 5: Check karein directory PATH mein hai ya nahi

```bash
echo "$PATH" |
tr ':' '\n' |
grep -Fx "$HOME/.local/bin"
```

### Task 6: Zaroorat ho to temporarily add karein

```bash
export PATH="$HOME/.local/bin:$PATH"
```

### Task 7: Command name se run karein

```bash
hello-path
```

### Task 8: Command resolution inspect karein

```bash
command -v hello-path
type -a hello-path
```

### Task 9: New shell mein persistence test karein

```bash
bash
command -v hello-path
exit
```

Agar new shell mein missing ho to earlier guidance se `~/.profile` aur `~/.bashrc` review karein.

---

## 28. Knowledge check

1. `$PATH` mein kya store hota hai?
2. PATH directories ko kaun sa character separate karta hai?
3. Bash PATH ko left-to-right search karta hai ya right-to-left?
4. `cd` PATH se kyun find nahi hota?
5. `PATH` aur `$PATH` mein kya farq hai?
6. Jab `script.sh` na chale to `./script.sh` kyun chal sakta hai?
7. `command -v` kya dikhata hai?
8. Directory prepend aur append karne mein kya farq hai?
9. `~/.local/bin/bat` exist hone ke bawajood `bat` par `command not found` kyun aa sakta hai?
10. Ubuntu executable commonly `batcat` kyun kehlati hai?
11. `hash -r` kya karta hai?
12. `.` ko PATH ke shuru mein kyun add nahi karna chahiye?
13. Command normally chal kar `sudo` ke saath kyun fail ho sakti hai?
14. Broken PATH temporarily kaise restore karenge?

---

## 29. Quick reference

```bash
# PATH display karein
echo "$PATH"

# Har directory alag line par
echo "$PATH" | tr ':' '\n'

# PATH directories number karein
echo "$PATH" | tr ':' '\n' | nl

# Command resolution check karein
command -v COMMAND
type -a COMMAND

# Directory temporarily high priority par add karein
export PATH="$HOME/.local/bin:$PATH"

# Directory temporarily low priority par add karein
export PATH="$PATH:$HOME/.local/bin"

# Ubuntu login environment reload karein
source ~/.profile

# Interactive Bash configuration reload karein
source ~/.bashrc

# Bash command cache clear karein
hash -r

# Ubuntu par bat install karein
sudo apt install bat -y

# Ubuntu executable directly use karein
batcat FILE

# Short user-level command name banayein
mkdir -p ~/.local/bin
ln -sf /usr/bin/batcat ~/.local/bin/bat
source ~/.profile
hash -r

# Typical Ubuntu PATH temporarily recover karein
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
```

---

## Final summary

`$PATH` directories ki ordered, colon-separated list hai jise shell external executable commands find karne ke liye use karta hai.

Yaad rakhein:

```text
PATH                      = variable ka naam
$PATH                     = variable ki value
Directories               = colons se separate
Search direction          = left se right
User command directory    = ~/.local/bin
Temporary change          = export PATH="...:$PATH"
Ubuntu profile reload     = source ~/.profile
Bash cache clear          = hash -r
Ubuntu bat executable     = batcat
```

Sab se important troubleshooting distinction:

> File exist aur executable ho sakti hai, lekin agar us ki directory current PATH se searchable na ho to command name enter karne par command fail hogi.
