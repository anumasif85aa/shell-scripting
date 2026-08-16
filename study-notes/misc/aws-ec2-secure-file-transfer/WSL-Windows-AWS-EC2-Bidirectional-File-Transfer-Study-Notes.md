# WSL, Windows, and AWS EC2 Bidirectional File Transfer — Complete Study Notes

---

## Learning objectives

After studying these notes, you should be able to:

- Upload files from WSL or Windows to AWS EC2.
- Download files from AWS EC2 to WSL or Windows.
- Transfer single files, multiple files, and complete directories.
- Understand local and remote source/destination order.
- Prepare and protect an EC2 `.pem` private key.
- Configure the EC2 Security Group for SSH.
- Use `scp` and `rsync` appropriately.
- Work safely with protected directories.
- Avoid accidental directory merging and destructive synchronization.
- Verify transfers with file listings, sizes, counts, and checksums.
- Troubleshoot common SSH, SCP, permissions, and path errors.

---

# Part 1 — Core concepts and preparation

## 1. Bidirectional transfer flow

### Upload

```text
WSL or Windows local source
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
WSL or Windows local destination
```

`scp` stands for **Secure Copy Protocol**. It securely transfers data over an encrypted SSH connection.

---

## 2. Source and destination rule

The basic pattern is always:

```text
command SOURCE DESTINATION
```

### WSL to EC2

```bash
scp -i PRIVATE-KEY \
LOCAL-SOURCE \
USER@EC2-IP:REMOTE-DESTINATION
```

### EC2 to WSL

```bash
scp -i PRIVATE-KEY \
USER@EC2-IP:REMOTE-SOURCE \
LOCAL-DESTINATION
```

A remote path is identified by:

```text
USER@HOST:/path
```

The colon `:` separates the remote host from its filesystem path.

---

## 3. Requirements

Before transferring data, confirm that you have:

- A running EC2 instance.
- Its current public IPv4 address or public DNS name.
- The correct EC2 SSH username.
- The matching private key, such as `bakar-key.pem`.
- An inbound Security Group rule allowing SSH on TCP port `22` from your IP.
- Read permission for the source.
- Write permission for the destination.
- Enough free disk space at the destination.

---

## 4. Common EC2 usernames

| EC2 operating system | Common SSH username |
|---|---|
| Ubuntu | `ubuntu` |
| Amazon Linux | `ec2-user` |
| Rocky Linux | `rocky` |
| AlmaLinux | `ec2-user` or `almalinux` |
| RHEL | `ec2-user` |
| Debian | `admin` or `debian` |

The username depends on the AMI. Consult the AMI documentation if the common username does not work.

---

## 5. Prepare the PEM key in WSL

Create the SSH directory:

```bash
mkdir -p ~/.ssh
```

If the key is in Windows Downloads, copy it to WSL:

```bash
cp /mnt/c/Users/YOUR-WINDOWS-USERNAME/Downloads/bakar-key.pem ~/.ssh/
```

Protect it:

```bash
chmod 400 ~/.ssh/bakar-key.pem
```

Verify:

```bash
ls -l ~/.ssh/bakar-key.pem
```

Expected permission pattern:

```text
-r--------
```

Keeping the key in the WSL Linux filesystem normally avoids Windows-mounted filesystem permission problems.

Never upload the private key to EC2, GitHub, email, chat, or a shared directory.

---

## 6. Remove Windows Zone Identifier files

Windows may create an additional file such as:

```text
bakar-key.pem:Zone.Identifier
```

Preview these files:

```bash
find . -type f -name '*:Zone.Identifier' -print
```

After confirming the results, delete them:

```bash
find . -type f -name '*:Zone.Identifier' -delete
```

Verify:

```bash
find . -type f -name '*:Zone.Identifier' -print
```

The original `.pem` file must remain.

---

## 7. Check the EC2 Security Group

The inbound rule should normally be:

| Type | Protocol | Port | Source |
|---|---|---:|---|
| SSH | TCP | `22` | My IP |

Avoid permanently allowing SSH from:

```text
0.0.0.0/0
```

That source exposes port `22` to the entire internet.

---

## 8. Test SSH first

From WSL:

```bash
ssh -i ~/.ssh/bakar-key.pem ubuntu@EC2-PUBLIC-IP
```

Example:

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247
```

Exit EC2:

```bash
exit
```

If SSH does not work, `scp` and SSH-based `rsync` will normally not work. Resolve SSH access first.

---

## 9. Know which terminal you are using

Local WSL prompt:

```text
khalid@Khalid-laptop:~/nit$
```

Remote EC2 prompt:

```text
ubuntu@ip-172-31-27-4:~$
```

Run upload and download `scp` commands from your local WSL prompt unless you intentionally need a different workflow.

---

# Part 2 — Upload from WSL or Windows to EC2

## 10. Upload one file from WSL to EC2

General syntax:

```bash
scp -i PRIVATE-KEY \
LOCAL-FILE \
USER@EC2-IP:REMOTE-DESTINATION
```

Example:

```bash
scp -i bakar-key.pem \
script.sh \
ubuntu@18.116.39.247:/home/ubuntu/
```

Verify remotely:

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247
ls -lh /home/ubuntu/script.sh
exit
```

---

## 11. Rename a file during upload

```bash
scp -i bakar-key.pem \
script.sh \
ubuntu@18.116.39.247:/home/ubuntu/setup.sh
```

The local `script.sh` arrives as `setup.sh`.

---

## 12. Upload a complete directory

Use `-r` for recursive copying:

```bash
scp -r -i bakar-key.pem \
shell-scripting \
ubuntu@18.116.39.247:/home/ubuntu/
```

This creates:

```text
/home/ubuntu/shell-scripting
```

The error below means that `-r` was omitted for a directory:

```text
scp: local "shell-scripting" is not a regular file
```

Correct it by adding `-r`.

---

## 13. Upload multiple files

```bash
scp -i bakar-key.pem \
file1.txt file2.txt script.sh \
ubuntu@18.116.39.247:/home/ubuntu/
```

Use a controlled wildcard when appropriate:

```bash
printf '%s\n' *.sh
```

After confirming the matches:

```bash
scp -i bakar-key.pem \
*.sh \
ubuntu@18.116.39.247:/home/ubuntu/scripts/
```

---

## 14. Upload a Windows file through WSL

Windows drives are mounted under `/mnt` in WSL:

```text
C:\Users\Khalid\Desktop\test.txt
                 ↓
/mnt/c/Users/Khalid/Desktop/test.txt
```

Upload example:

```bash
scp -i ~/.ssh/bakar-key.pem \
"/mnt/c/Users/YOUR-WINDOWS-USERNAME/Desktop/test.txt" \
ubuntu@18.116.39.247:/home/ubuntu/
```

Always quote paths containing spaces:

```bash
scp -i ~/.ssh/bakar-key.pem \
"/mnt/c/Users/YOUR-WINDOWS-USERNAME/Desktop/My Files/report.txt" \
ubuntu@18.116.39.247:/home/ubuntu/
```

---

## 15. Upload into a protected EC2 directory

The normal EC2 user usually cannot copy directly into `/etc`, `/var/www`, or another root-owned directory.

Upload into the user's home directory first:

```bash
scp -i bakar-key.pem \
index.html \
ubuntu@18.116.39.247:/home/ubuntu/
```

Then connect and move it with `sudo`:

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247
sudo mv /home/ubuntu/index.html /var/www/html/index.html
exit
```

---

# Part 3 — Download from EC2 to WSL or Windows

## 16. Check the remote source before downloading

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247
```

```bash
ls -la /home/ubuntu/
ls -lh /home/ubuntu/file.txt
ls -ld /home/ubuntu/shell-scripting
du -sh /home/ubuntu/shell-scripting
exit
```

---

## 17. Download one file from EC2 to WSL

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

## 18. Download and rename a file

```bash
scp -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/report.txt \
~/Downloads/ec2-report.txt
```

The remote file remains `report.txt`; the local copy becomes `ec2-report.txt`.

---

## 19. Download a complete directory

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

## 20. Download into the current WSL directory

The dot `.` means the current directory:

```bash
pwd
ls -la
```

```bash
scp -r -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/shell-scripting \
.
```

If the current directory is `~/nit`, this normally creates or merges into:

```text
~/nit/shell-scripting
```

---

## 21. Avoid merging with an existing local directory

If `~/nit/shell-scripting` already exists, create a separate destination:

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

## 22. Download directly to Windows

File to Windows Downloads:

```bash
scp -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/file.txt \
"/mnt/c/Users/YOUR-WINDOWS-USERNAME/Downloads/"
```

Directory to Windows Downloads:

```bash
scp -r -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/shell-scripting \
"/mnt/c/Users/YOUR-WINDOWS-USERNAME/Downloads/"
```

Find the Windows username from WSL:

```bash
cmd.exe /c echo %USERNAME%
```

Or list Windows users:

```bash
ls /mnt/c/Users/
```

---

## 23. Open WSL files in Windows Explorer

Open the current directory:

```bash
explorer.exe .
```

Open WSL Downloads:

```bash
explorer.exe "$(wslpath -w ~/Downloads)"
```

---

## 24. Download multiple remote files

Inspect the matches first:

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247 \
'printf "%s\n" /home/ubuntu/*.txt'
```

Then download:

```bash
scp -i bakar-key.pem \
'ubuntu@18.116.39.247:/home/ubuntu/*.txt' \
~/Downloads/
```

Quoting prevents the local shell from expanding the remote wildcard.

---

## 25. Download a protected EC2 file

If the normal user cannot read a root-owned file, prepare a user-owned copy on EC2:

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247
sudo cp /root/protected-file.txt /home/ubuntu/
sudo chown ubuntu:ubuntu /home/ubuntu/protected-file.txt
exit
```

Download it:

```bash
scp -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/protected-file.txt \
~/Downloads/
```

Do not weaken system-wide permissions merely to transfer a file.

---

# Part 4 — Efficient synchronization with rsync

## 26. Why use `rsync`?

`scp` is convenient for a direct copy. `rsync` is better for repeated or larger transfers because it can copy only changed data.

Install it in Ubuntu WSL if necessary:

```bash
sudo apt update
sudo apt install rsync -y
```

---

## 27. Synchronize from WSL to EC2

```bash
rsync -avz --progress \
-e "ssh -i bakar-key.pem" \
shell-scripting/ \
ubuntu@18.116.39.247:/home/ubuntu/shell-scripting/
```

Exclude Git metadata if required:

```bash
rsync -avz --progress \
--exclude='.git/' \
-e "ssh -i bakar-key.pem" \
shell-scripting/ \
ubuntu@18.116.39.247:/home/ubuntu/shell-scripting/
```

---

## 28. Synchronize from EC2 to WSL

```bash
mkdir -p ~/nit/ec2-download/shell-scripting
```

```bash
rsync -avz --progress \
-e "ssh -i bakar-key.pem" \
ubuntu@18.116.39.247:/home/ubuntu/shell-scripting/ \
~/nit/ec2-download/shell-scripting/
```

Exclude `.git`:

```bash
rsync -avz --progress \
--exclude='.git/' \
-e "ssh -i bakar-key.pem" \
ubuntu@18.116.39.247:/home/ubuntu/shell-scripting/ \
~/nit/ec2-download/shell-scripting/
```

---

## 29. Important `rsync` options

| Option | Purpose |
|---|---|
| `-a` | Archive mode; preserves important attributes |
| `-v` | Verbose output |
| `-z` | Compress data during transfer |
| `--progress` | Display transfer progress |
| `-e` | Specify the SSH command and key |
| `--exclude` | Skip selected files or directories |

Trailing slash difference:

```text
directory/ = copy the contents inside the directory
directory  = copy the directory itself
```

Do not add `--delete` until you fully understand and test it. It can remove files from the destination.

---

# Part 5 — Convenience and verification

## 30. Use an SSH configuration alias

Create or edit:

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

Protect it:

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

## 31. Verify transferred data

Check a file:

```bash
ls -lh PATH/TO/FILE
```

Check directory size:

```bash
du -sh PATH/TO/DIRECTORY
```

Count files:

```bash
find PATH/TO/DIRECTORY -type f | wc -l
```

For an important file, compare SHA-256 checksums.

Remote checksum:

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247 \
'sha256sum /home/ubuntu/file.txt'
```

Local checksum:

```bash
sha256sum ~/Downloads/file.txt
```

Matching hashes confirm identical file content.

---

## 32. Verbose troubleshooting

Verbose SSH:

```bash
ssh -v -i bakar-key.pem ubuntu@18.116.39.247
```

Verbose SCP file transfer:

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

# Part 6 — Common errors and solutions

## 33. `not a regular file`

Cause: the source is a directory, but `-r` was not supplied.

Solution:

```bash
scp -r -i bakar-key.pem SOURCE-DIRECTORY DESTINATION
```

---

## 34. `Permission denied (publickey)`

Possible causes:

- Incorrect `.pem` key.
- Incorrect EC2 username.
- Key does not belong to the instance.
- Key permissions are too open.

Checks:

```bash
chmod 400 bakar-key.pem
ssh -i bakar-key.pem ubuntu@18.116.39.247
```

---

## 35. `WARNING: UNPROTECTED PRIVATE KEY FILE`

Copy the key into WSL and restrict it:

```bash
cp /mnt/c/Users/YOUR-WINDOWS-USERNAME/Downloads/bakar-key.pem ~/.ssh/
chmod 400 ~/.ssh/bakar-key.pem
```

---

## 36. `Connection timed out`

Check:

- EC2 is running.
- The current EC2 public IP is correct.
- Security Group allows TCP port `22` from your current public IP.
- The subnet and route table provide the required connectivity.
- Network ACLs are not blocking traffic.

---

## 37. `Connection refused`

The host responded, but SSH may not be listening. Check through an available management method:

```bash
sudo systemctl status sshd
```

---

## 38. `No such file or directory`

Check the local path:

```bash
ls -l LOCAL-PATH
```

Check the remote path:

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247 \
'ls -la /home/ubuntu/'
```

---

## 39. Remote or local `Permission denied`

For an upload into a protected EC2 directory, upload to `/home/ubuntu` and use `sudo mv` after connecting.

For a protected remote download, create a readable, user-owned copy in `/home/ubuntu`.

For a local destination error, use a directory owned by your WSL user, such as:

```bash
~/Downloads/
```

---

## 40. `Host key verification failed`

First confirm that the IP belongs to the correct EC2 instance. Then remove only the confirmed outdated entry:

```bash
ssh-keygen -R 18.116.39.247
```

Reconnect and verify the new fingerprint before accepting it.

---

# Part 7 — Practice lab

## 41. Create local practice data

```bash
mkdir -p ~/ec2-transfer-lab/scripts

printf '%s\n' 'WSL and EC2 transfer test' \
> ~/ec2-transfer-lab/readme.txt

printf '%s\n' '#!/bin/bash' 'hostname' \
> ~/ec2-transfer-lab/scripts/check-host.sh

chmod +x ~/ec2-transfer-lab/scripts/check-host.sh
```

---

## 42. Upload the practice data

Upload one file:

```bash
scp -i bakar-key.pem \
~/ec2-transfer-lab/readme.txt \
ubuntu@18.116.39.247:/home/ubuntu/
```

Upload the directory:

```bash
scp -r -i bakar-key.pem \
~/ec2-transfer-lab/scripts \
ubuntu@18.116.39.247:/home/ubuntu/
```

---

## 43. Verify the upload on EC2

```bash
ssh -i bakar-key.pem ubuntu@18.116.39.247
ls -lh /home/ubuntu/readme.txt
ls -la /home/ubuntu/scripts/
/home/ubuntu/scripts/check-host.sh
exit
```

---

## 44. Download the data safely

Create a separate local destination:

```bash
mkdir -p ~/nit/ec2-download
```

Download the file:

```bash
scp -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/readme.txt \
~/nit/ec2-download/readme-from-ec2.txt
```

Download the directory:

```bash
scp -r -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/scripts \
~/nit/ec2-download/
```

---

## 45. Verify the download

```bash
ls -lh ~/nit/ec2-download/readme-from-ec2.txt
ls -la ~/nit/ec2-download/scripts
du -sh ~/nit/ec2-download/scripts
```

Open it in Windows Explorer:

```bash
explorer.exe "$(wslpath -w ~/nit/ec2-download)"
```

---

# Part 8 — Quick reference

## 46. Essential commands

```bash
# Protect the key
chmod 400 bakar-key.pem

# Test SSH
ssh -i bakar-key.pem ubuntu@18.116.39.247

# Upload a file
scp -i bakar-key.pem file.txt \
ubuntu@18.116.39.247:/home/ubuntu/

# Upload a directory
scp -r -i bakar-key.pem directory \
ubuntu@18.116.39.247:/home/ubuntu/

# Download a file
scp -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/file.txt \
~/Downloads/

# Download a directory
scp -r -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/directory \
~/nit/ec2-download/

# Download directly to Windows
scp -r -i bakar-key.pem \
ubuntu@18.116.39.247:/home/ubuntu/directory \
"/mnt/c/Users/YOUR-WINDOWS-USERNAME/Downloads/"

# Synchronize WSL to EC2
rsync -avz --progress \
-e "ssh -i bakar-key.pem" \
directory/ \
ubuntu@18.116.39.247:/home/ubuntu/directory/

# Synchronize EC2 to WSL
rsync -avz --progress \
-e "ssh -i bakar-key.pem" \
ubuntu@18.116.39.247:/home/ubuntu/directory/ \
~/nit/ec2-download/directory/
```

---

## Final summary

Remember the two central patterns:

```bash
# Upload
scp -i KEY LOCAL-SOURCE USER@EC2-IP:REMOTE-DESTINATION

# Download
scp -i KEY USER@EC2-IP:REMOTE-SOURCE LOCAL-DESTINATION
```

Key points:

- Run transfer commands from your local WSL terminal.
- `-i` selects the private key.
- `-r` is required for directories.
- The side containing `USER@HOST:/path` is remote.
- `/mnt/c/Users/...` accesses the Windows filesystem from WSL.
- Use separate download directories to avoid merging projects.
- Use `rsync` for repeated or large transfers.
- Test SSH before troubleshooting SCP.
- Verify important transfers with SHA-256 checksums.
- Protect the `.pem` key and never share it.
