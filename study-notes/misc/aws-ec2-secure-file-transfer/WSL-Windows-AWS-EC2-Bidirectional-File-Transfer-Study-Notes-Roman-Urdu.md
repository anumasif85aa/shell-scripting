# WSL, Windows aur AWS EC2 Bidirectional File Transfer — Roman Urdu Study Notes


---

## Learning objectives

In notes ko parhne ke baad aap:

- WSL ya Windows se AWS EC2 par files upload kar sakenge.
- AWS EC2 se WSL ya Windows par files download kar sakenge.
- Single files, multiple files aur complete directories transfer kar sakenge.
- Local aur remote source/destination ka order samajh sakenge.
- EC2 `.pem` private key ko prepare aur protect kar sakenge.
- SSH ke liye EC2 Security Group configure kar sakenge.
- `scp` aur `rsync` ko sahi situation mein use kar sakenge.
- Protected directories ke saath safely kaam kar sakenge.
- Accidental directory merging aur destructive synchronization se bach sakenge.
- Listings, size, file count aur checksum se transfer verify kar sakenge.
- Common SSH, SCP, permission aur path errors troubleshoot kar sakenge.

---

# Part 1 — Core concepts aur preparation

## 1. Bidirectional transfer flow

### Upload

```text
WSL ya Windows local source
             ↓
         SSH port 22
             ↓
     AWS EC2 remote destination
```

### Download

```text
AWS EC2 remote source
             ↓
         SSH port 22
             ↓
WSL ya Windows local destination
```

`scp` ka matlab **Secure Copy Protocol** hai. Yeh encrypted SSH connection par data securely transfer karta hai.

---

## 2. Source aur destination ka rule

Basic pattern hamesha yeh hota hai:

```text
command SOURCE DESTINATION
```

### WSL se EC2

```bash
scp -i PRIVATE-KEY \
LOCAL-SOURCE \
USER@EC2-IP:REMOTE-DESTINATION
```

### EC2 se WSL

```bash
scp -i PRIVATE-KEY \
USER@EC2-IP:REMOTE-SOURCE \
LOCAL-DESTINATION
```

Remote path ki pehchan:

```text
USER@HOST:/path
```

Colon `:` remote host ko us ke filesystem path se separate karta hai.

---

## 3. Requirements

Transfer se pehle confirm karein ke:

- EC2 instance running hai.
- Current public IPv4 address ya public DNS name available hai.
- EC2 ka sahi SSH username maloom hai.
- Matching private key, jaise `bakar-key.pem`, maujood hai.
- Security Group mein aap ke IP se TCP port `22` allowed hai.
- Source ko read karne ki permission hai.
- Destination mein write permission hai.
- Destination par enough free disk space hai.

---

## 4. Common EC2 usernames

| EC2 operating system | Common SSH username |
|---|---|
| Ubuntu | `ubuntu` |
| Amazon Linux | `ec2-user` |
| Rocky Linux | `rocky` |
| AlmaLinux | `ec2-user` ya `almalinux` |
| RHEL | `ec2-user` |
| Debian | `admin` ya `debian` |

Username AMI par depend karta hai. Agar common username kaam na kare to AMI documentation check karein.

---

## 5. PEM key WSL mein prepare karna

SSH directory banayein:

```bash
mkdir -p ~/.ssh
```

Agar key Windows Downloads mein hai to WSL mein copy karein:

```bash
cp /mnt/c/Users/YOUR-WINDOWS-USERNAME/Downloads/bakar-key.pem ~/.ssh/
```

Key protect karein:

```bash
chmod 400 ~/.ssh/bakar-key.pem
```

Verify karein:

```bash
ls -l ~/.ssh/bakar-key.pem
```

Expected permission pattern:

```text
-r--------
```

Key ko WSL Linux filesystem mein rakhne se aam tor par Windows-mounted filesystem ke permission issues nahi aate.

Private key ko EC2, GitHub, email, chat ya shared directory mein kabhi upload na karein.

---

## 6. Windows Zone Identifier files remove karna

Windows extra file bana sakta hai:

```text
bakar-key.pem:Zone.Identifier
```

Pehle preview karein:

```bash
find . -type f -name '*:Zone.Identifier' -print
```

Result confirm karne ke baad delete karein:

```bash
find . -type f -name '*:Zone.Identifier' -delete
```

Verify karein:

```bash
find . -type f -name '*:Zone.Identifier' -print
```

Original `.pem` file delete nahi honi chahiye.

---

## 7. EC2 Security Group check karna

Inbound rule aam tor par:

| Type | Protocol | Port | Source |
|---|---|---:|---|
| SSH | TCP | `22` | My IP |

SSH ko permanently is source se allow na karein:

```text
0.0.0.0/0
```

Yeh port `22` ko poori internet ke liye expose kar deta hai.

---

## 8. Pehle SSH test karein

```bash
ssh -i ~/.ssh/bakar-key.pem ubuntu@EC2-PUBLIC-IP
```

Example:

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247
```

EC2 se exit:

```bash
exit
```

Agar SSH kaam nahi karta to `scp` aur SSH-based `rsync` bhi aam tor par kaam nahi karenge. Pehle SSH access solve karein.

---

## 9. Local aur remote prompt pehchanein

Local WSL prompt:

```text
khalid@Khalid-laptop:~/nit$
```

Remote EC2 prompt:

```text
ubuntu@ip-172-31-27-4:~$
```

Upload aur download ki `scp` commands local WSL prompt se run karein.

---

# Part 2 — WSL ya Windows se EC2 upload

## 10. WSL se ek file upload karna

```bash
scp -i bakar-key.pem \
script.sh \
ubuntu@18.116.39.247:/home/ubuntu/
```

Remote verification:

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247
ls -lh /home/ubuntu/script.sh
exit
```

---

## 11. Upload ke waqt file rename karna

```bash
scp -i bakar-key.pem \
script.sh \
ubuntu@18.116.39.247:/home/ubuntu/setup.sh
```

Local `script.sh`, EC2 par `setup.sh` ke naam se save hogi.

---

## 12. Complete directory upload karna

Directory ke liye `-r` use karein:

```bash
scp -r -i bakar-key.pem \
shell-scripting \
ubuntu@18.116.39.247:/home/ubuntu/
```

Yeh create karega:

```text
/home/ubuntu/shell-scripting
```

Agar `-r` na ho to error aa sakta hai:

```text
scp: local "shell-scripting" is not a regular file
```

Solution: command mein `-r` add karein.

---

## 13. Multiple files upload karna

```bash
scp -i bakar-key.pem \
file1.txt file2.txt script.sh \
ubuntu@18.116.39.247:/home/ubuntu/
```

Wildcard matches pehle check karein:

```bash
printf '%s\n' *.sh
```

Phir upload:

```bash
scp -i bakar-key.pem \
*.sh \
ubuntu@18.116.39.247:/home/ubuntu/scripts/
```

---

## 14. Windows file ko WSL ke through upload karna

Windows path ko WSL mein is tarah samjhein:

```text
C:\Users\Khalid\Desktop\test.txt
                 ↓
/mnt/c/Users/Khalid/Desktop/test.txt
```

Example:

```bash
scp -i ~/.ssh/bakar-key.pem \
"/mnt/c/Users/YOUR-WINDOWS-USERNAME/Desktop/test.txt" \
ubuntu@18.116.39.247:/home/ubuntu/
```

Spaces wale path ko quotes mein rakhein:

```bash
scp -i ~/.ssh/bakar-key.pem \
"/mnt/c/Users/YOUR-WINDOWS-USERNAME/Desktop/My Files/report.txt" \
ubuntu@18.116.39.247:/home/ubuntu/
```

---

## 15. Protected EC2 directory mein upload karna

Normal EC2 user aam tor par `/etc`, `/var/www` ya doosri root-owned directory mein directly copy nahi kar sakta.

Pehle home directory mein upload karein:

```bash
scp -i bakar-key.pem \
index.html \
ubuntu@18.116.39.247:/home/ubuntu/
```

Phir connect karke `sudo` se move karein:

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247
sudo mv /home/ubuntu/index.html /var/www/html/index.html
exit
```

---

# Part 3 — EC2 se WSL ya Windows download

## 16. Download se pehle remote source check karna

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247
ls -la /home/ubuntu/
ls -lh /home/ubuntu/file.txt
ls -ld /home/ubuntu/shell-scripting
du -sh /home/ubuntu/shell-scripting
exit
```

---

## 17. EC2 se ek file WSL par download karna

```bash
scp -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/file.txt \
~/Downloads/
```

Verify:

```bash
ls -lh ~/Downloads/file.txt
```

---

## 18. Download ke waqt file rename karna

```bash
scp -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/report.txt \
~/Downloads/ec2-report.txt
```

Remote file `report.txt` hi rahegi, local copy `ec2-report.txt` hogi.

---

## 19. Complete directory download karna

```bash
scp -r -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/shell-scripting \
~/Downloads/
```

Verify:

```bash
ls -la ~/Downloads/shell-scripting
```

---

## 20. Current WSL directory mein download karna

Dot `.` current directory ko represent karta hai:

```bash
pwd
ls -la
```

```bash
scp -r -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/shell-scripting \
.
```

Agar current directory `~/nit` hai to yeh `~/nit/shell-scripting` create ya existing folder mein merge kar sakta hai.

---

## 21. Existing local directory ke saath merge hone se bachna

Separate destination banayein:

```bash
mkdir -p ~/nit/ec2-download
```

```bash
scp -r -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/shell-scripting \
~/nit/ec2-download/
```

Verify:

```bash
ls -la ~/nit/ec2-download/shell-scripting
```

---

## 22. Seedha Windows mein download karna

File ko Windows Downloads mein:

```bash
scp -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/file.txt \
"/mnt/c/Users/YOUR-WINDOWS-USERNAME/Downloads/"
```

Directory ko Windows Downloads mein:

```bash
scp -r -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/shell-scripting \
"/mnt/c/Users/YOUR-WINDOWS-USERNAME/Downloads/"
```

Windows username check karein:

```bash
cmd.exe /c echo %USERNAME%
```

Ya Windows user directories list karein:

```bash
ls /mnt/c/Users/
```

---

## 23. WSL files Windows Explorer mein kholna

Current directory:

```bash
explorer.exe .
```

WSL Downloads:

```bash
explorer.exe "$(wslpath -w ~/Downloads)"
```

---

## 24. Multiple remote files download karna

Matches pehle inspect karein:

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247 \
'printf "%s\n" /home/ubuntu/*.txt'
```

Phir download:

```bash
scp -i bakar-key.pem \
'ubuntu@18.116.39.247:/home/ubuntu/*.txt' \
~/Downloads/
```

Quotes local shell ko remote wildcard expand karne se rokti hain.

---

## 25. Protected EC2 file download karna

Agar normal user root-owned file nahi parh sakta to EC2 par user-owned copy banayein:

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247
sudo cp /root/protected-file.txt /home/ubuntu/
sudo chown ubuntu:ubuntu /home/ubuntu/protected-file.txt
exit
```

Phir download:

```bash
scp -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/protected-file.txt \
~/Downloads/
```

Sirf transfer ke liye system-wide permissions weak na karein.

---

# Part 4 — `rsync` se efficient synchronization

## 26. `rsync` kyun use karein?

`scp` direct copy ke liye convenient hai. Repeated ya large transfers ke liye `rsync` behtar hai kyun ke yeh sirf changed data copy kar sakta hai.

Ubuntu WSL mein install:

```bash
sudo apt update
sudo apt install rsync -y
```

---

## 27. WSL se EC2 synchronize karna

```bash
rsync -avz --progress \
-e "ssh -i bakar-key.pem" \
shell-scripting/ \
ubuntu@18.116.39.247:/home/ubuntu/shell-scripting/
```

Git metadata exclude karna:

```bash
rsync -avz --progress \
--exclude='.git/' \
-e "ssh -i bakar-key.pem" \
shell-scripting/ \
ubuntu@18.116.39.247:/home/ubuntu/shell-scripting/
```

---

## 28. EC2 se WSL synchronize karna

```bash
mkdir -p ~/nit/ec2-download/shell-scripting
```

```bash
rsync -avz --progress \
-e "ssh -i bakar-key.pem" \
ubuntu@18.116.39.247:/home/ubuntu/shell-scripting/ \
~/nit/ec2-download/shell-scripting/
```

`.git` exclude karna:

```bash
rsync -avz --progress \
--exclude='.git/' \
-e "ssh -i bakar-key.pem" \
ubuntu@18.116.39.247:/home/ubuntu/shell-scripting/ \
~/nit/ec2-download/shell-scripting/
```

---

## 29. Important `rsync` options

| Option | Kaam |
|---|---|
| `-a` | Archive mode; important attributes preserve karta hai |
| `-v` | Detailed output dikhata hai |
| `-z` | Transfer ke waqt data compress karta hai |
| `--progress` | Transfer progress dikhata hai |
| `-e` | SSH command aur key specify karta hai |
| `--exclude` | Selected files ya directories skip karta hai |

Trailing slash ka farq:

```text
directory/ = directory ke andar ka content copy hoga
directory  = directory khud copy hogi
```

`--delete` tab tak add na karein jab tak isay samajh aur test na kar lein. Yeh destination se files remove kar sakta hai.

---

# Part 5 — Convenience aur verification

## 30. SSH configuration alias use karna

File create ya edit karein:

```bash
~/.ssh/config
```

Example:

```text
Host my-ec2
    HostName 18.116.39.247
    User ubuntu
    IdentityFile ~/.ssh/bakar-key.pem
```

Protect karein:

```bash
chmod 600 ~/.ssh/config
```

Connect:

```bash
ssh my-ec2
```

Upload:

```bash
scp -r shell-scripting my-ec2:/home/ubuntu/
```

Download:

```bash
scp -r my-ec2:/home/ubuntu/shell-scripting ~/nit/ec2-download/
```

---

## 31. Transferred data verify karna

File check:

```bash
ls -lh PATH/TO/FILE
```

Directory size:

```bash
du -sh PATH/TO/DIRECTORY
```

Files count:

```bash
find PATH/TO/DIRECTORY -type f | wc -l
```

Important file ke liye SHA-256 compare karein.

Remote checksum:

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247 \
'sha256sum /home/ubuntu/file.txt'
```

Local checksum:

```bash
sha256sum ~/Downloads/file.txt
```

Matching hashes confirm karte hain ke file content identical hai.

---

## 32. Verbose troubleshooting

Verbose SSH:

```bash
ssh -v -i bakar-key.pem ubuntu@18.116.39.247
```

Verbose SCP:

```bash
scp -v -i bakar-key.pem \
file.txt \
ubuntu@18.116.39.247:/home/ubuntu/
```

Verbose recursive transfer:

```bash
scp -rv -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/shell-scripting \
~/nit/ec2-download/
```

---

# Part 6 — Common errors aur solutions

## 33. `not a regular file`

Cause: source directory hai lekin `-r` nahi diya.

Solution:

```bash
scp -r -i bakar-key.pem SOURCE-DIRECTORY DESTINATION
```

---

## 34. `Permission denied (publickey)`

Possible causes:

- Ghalat `.pem` key.
- Ghalat EC2 username.
- Key instance se belong nahi karti.
- Key permissions bohat open hain.

Checks:

```bash
chmod 400 bakar-key.pem
ssh -i bakar-key.pem ubuntu@18.116.39.247
```

---

## 35. `WARNING: UNPROTECTED PRIVATE KEY FILE`

Key WSL mein copy karke restrict karein:

```bash
cp /mnt/c/Users/YOUR-WINDOWS-USERNAME/Downloads/bakar-key.pem ~/.ssh/
chmod 400 ~/.ssh/bakar-key.pem
```

---

## 36. `Connection timed out`

Check karein:

- EC2 running hai.
- Current EC2 public IP sahi hai.
- Security Group mein aap ke current IP se port `22` allowed hai.
- Subnet aur route table required connectivity dete hain.
- Network ACL traffic block nahi kar rahi.

---

## 37. `Connection refused`

Host ne response diya lekin SSH listen nahi kar raha ho sakta. Available management method se check karein:

```bash
sudo systemctl status sshd
```

---

## 38. `No such file or directory`

Local path:

```bash
ls -l LOCAL-PATH
```

Remote path:

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247 \
'ls -la /home/ubuntu/'
```

---

## 39. Remote ya local `Permission denied`

- Protected EC2 directory mein upload ke liye pehle `/home/ubuntu` mein upload karein, phir `sudo mv` use karein.
- Protected remote file download ke liye `/home/ubuntu` mein readable user-owned copy banayein.
- Local destination error ke liye apne WSL user ki directory use karein:

```bash
~/Downloads/
```

---

## 40. `Host key verification failed`

Pehle confirm karein ke IP sahi EC2 instance ka hai. Sirf confirmed outdated entry remove karein:

```bash
ssh-keygen -R 18.116.39.247
```

Dobara connect karke new fingerprint verify karne ke baad accept karein.

---

# Part 7 — Practice lab

## 41. Local practice data banayein

```bash
mkdir -p ~/ec2-transfer-lab/scripts

printf '%s\n' 'WSL and EC2 transfer test' \
> ~/ec2-transfer-lab/readme.txt

printf '%s\n' '#!/bin/bash' 'hostname' \
> ~/ec2-transfer-lab/scripts/check-host.sh

chmod +x ~/ec2-transfer-lab/scripts/check-host.sh
```

---

## 42. Practice data upload karein

One file:

```bash
scp -i bakar-key.pem \
~/ec2-transfer-lab/readme.txt \
ubuntu@18.116.39.247:/home/ubuntu/
```

Directory:

```bash
scp -r -i bakar-key.pem \
~/ec2-transfer-lab/scripts \
ubuntu@18.116.39.247:/home/ubuntu/
```

---

## 43. EC2 par upload verify karein

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247
ls -lh /home/ubuntu/readme.txt
ls -la /home/ubuntu/scripts/
/home/ubuntu/scripts/check-host.sh
exit
```

---

## 44. Data safely download karein

Separate destination:

```bash
mkdir -p ~/nit/ec2-download
```

File download:

```bash
scp -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/readme.txt \
~/nit/ec2-download/readme-from-ec2.txt
```

Directory download:

```bash
scp -r -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/scripts \
~/nit/ec2-download/
```

---

## 45. Download verify karein

```bash
ls -lh ~/nit/ec2-download/readme-from-ec2.txt
ls -la ~/nit/ec2-download/scripts
du -sh ~/nit/ec2-download/scripts
```

Windows Explorer mein kholein:

```bash
explorer.exe "$(wslpath -w ~/nit/ec2-download)"
```

---

# Part 8 — Quick reference

## 46. Essential commands

```bash
# Key protect karein
chmod 400 bakar-key.pem

# SSH test
ssh -i bakar-key.pem ubuntu@18.116.39.247

# File upload
scp -i bakar-key.pem file.txt \
ubuntu@18.116.39.247:/home/ubuntu/

# Directory upload
scp -r -i bakar-key.pem directory \
ubuntu@18.116.39.247:/home/ubuntu/

# File download
scp -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/file.txt \
~/Downloads/

# Directory download
scp -r -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/directory \
~/nit/ec2-download/

# Seedha Windows mein download
scp -r -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/directory \
"/mnt/c/Users/YOUR-WINDOWS-USERNAME/Downloads/"

# WSL se EC2 synchronize
rsync -avz --progress \
-e "ssh -i bakar-key.pem" \
directory/ \
ubuntu@18.116.39.247:/home/ubuntu/directory/

# EC2 se WSL synchronize
rsync -avz --progress \
-e "ssh -i bakar-key.pem" \
ubuntu@18.116.39.247:/home/ubuntu/directory/ \
~/nit/ec2-download/directory/
```

---

## Final summary

Do central patterns yaad rakhein:

```bash
# Upload
scp -i KEY LOCAL-SOURCE USER@EC2-IP:REMOTE-DESTINATION

# Download
scp -i KEY USER@EC2-IP:REMOTE-SOURCE LOCAL-DESTINATION
```

Key points:

- Transfer commands local WSL terminal se run karein.
- `-i` private key select karta hai.
- Directories ke liye `-r` required hai.
- `USER@HOST:/path` wala side remote hota hai.
- `/mnt/c/Users/...` WSL se Windows filesystem access karta hai.
- Projects merge hone se bachane ke liye separate download directory use karein.
- Repeated ya large transfers ke liye `rsync` use karein.
- SCP troubleshoot karne se pehle SSH test karein.
- Important transfers SHA-256 checksum se verify karein.
- `.pem` key protect karein aur kabhi share na karein.
