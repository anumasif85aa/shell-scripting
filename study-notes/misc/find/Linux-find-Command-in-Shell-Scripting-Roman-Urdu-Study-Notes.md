# Linux `find` Command in Shell Scripting — Roman Urdu Study Notes

## Table of Contents

1. [Ta'aruf](#1-taaruf)
2. [Basic Syntax](#2-basic-syntax)
3. [Naam Se Search Karna](#3-naam-se-search-karna)
4. [File Type Se Search Karna](#4-file-type-se-search-karna)
5. [Search Depth Control Karna](#5-search-depth-control-karna)
6. [Size Se Search Karna](#6-size-se-search-karna)
7. [Modification Time Se Search Karna](#7-modification-time-se-search-karna)
8. [Empty Files aur Directories Dhoondhna](#8-empty-files-aur-directories-dhoondhna)
9. [Owner ya Group Se Search Karna](#9-owner-ya-group-se-search-karna)
10. [Conditions Combine Karna](#10-conditions-combine-karna)
11. [`-exec` Se Action Perform Karna](#11--exec-se-action-perform-karna)
12. [Matching Files Copy Karna](#12-matching-files-copy-karna)
13. [Matching Files Safely Delete Karna](#13-matching-files-safely-delete-karna)
14. [Shell Script Mein `find` Use Karna](#14-shell-script-mein-find-use-karna)
15. [Matching Files Count Karna](#15-matching-files-count-karna)
16. [Filenames Ko Safely Process Karna](#16-filenames-ko-safely-process-karna)
17. [Real-World Log-Cleanup Script](#17-real-world-log-cleanup-script)
18. [Common Mistakes](#18-common-mistakes)
19. [Quick Reference](#19-quick-reference)
20. [Khulasa](#20-khulasa)

---

## 1. Ta'aruf

Linux ka `find` command directory tree ke andar files aur directories search karta hai. Yeh mukhtalif conditions ki bunyaad par items dhoondh sakta hai, jaise:

- Naam
- File type
- Size
- Owner ya group
- Modification time
- Permissions
- Directory depth

`find` matching paths par actions bhi perform kar sakta hai, jaise unhein display, inspect, copy ya delete karna.

> `find` filesystem mein search karta hai. Yeh shell wildcard expansion, jaise `*.txt`, se mukhtalif hai.

---

## 2. Basic Syntax

```bash
find STARTING_PATH CONDITIONS ACTION
```

Misal:

```bash
find /home/khalid -type f -name "*.sh" -print
```

Matlab:

> `/home/khalid` se search shuru karo aur tamam regular files display karo jin ke naam `.sh` par khatam hote hain.

### Command ki breakdown

| Hissa | Matlab |
|---|---|
| `find` | Search command |
| `/home/khalid` | Starting directory |
| `-type f` | Sirf regular files select karo |
| `-name "*.sh"` | `.sh` par khatam hone wale naam select karo |
| `-print` | Matching paths display karo |

### Common starting paths

| Path | Search area |
|---|---|
| `.` | Current directory aur us ke tamam descendants |
| `..` | Parent directory aur us ke descendants |
| `/tmp` | `/tmp` directory tree |
| `"$HOME"` | Current user ki home directory |
| `/` | Pura filesystem; permissions aur mounts ki wajah se ehtiyat zaroori hai |

---

## 3. Naam Se Search Karna

### `.txt` naam wale items dhoondhna

```bash
find . -name "*.txt"
```

Yeh regular files aur directories dono ko match kar sakta hai agar un ka naam `.txt` par khatam ho.

Sirf regular files ke liye:

```bash
find . -type f -name "*.txt"
```

### Wildcard ko quote kyun karte hain?

Sahi:

```bash
find . -name "*.txt"
```

Is par depend na karein:

```bash
find . -name *.txt
```

Quotes ke baghair shell, `find` command chalne se pehle `*.txt` ko expand kar sakti hai. Agar current directory mein multiple `.txt` files hon, to command unexpected arguments receive kar sakti hai.

### Case-insensitive search

```bash
find . -type f -iname "*.jpg"
```

`-iname` uppercase aur lowercase ka farq ignore karta hai. Yeh in sab ko match kar sakta hai:

```text
photo.jpg
PHOTO.JPG
Image.Jpg
```

### Exact naam dhoondhna

```bash
find . -type f -name "configuration.conf"
```

### Kisi text se shuru hone wale naam

```bash
find . -type f -name "backup*"
```

---

## 4. File Type Se Search Karna

### Regular files

```bash
find . -type f
```

### Directories

```bash
find . -type d
```

### Symbolic links

```bash
find . -type l
```

### Common file-type tests

| Test | Matlab |
|---|---|
| `-type f` | Regular file |
| `-type d` | Directory |
| `-type l` | Symbolic link |
| `-type b` | Block device |
| `-type c` | Character device |
| `-type p` | Named pipe |
| `-type s` | Socket |

### `backup` naam ki directories

```bash
find . -type d -name "backup"
```

### `/usr/local` ke andar symbolic links

```bash
find /usr/local -type l -print
```

---

## 5. Search Depth Control Karna

Default tor par `find` starting directory ke tamam accessible subdirectories mein recursively search karta hai.

### Sirf starting directory search karna

```bash
find . -maxdepth 1 -type f
```

`-maxdepth 1` ki wajah se `find` subdirectories ke andar nahi jata.

### Minimum depth set karna

```bash
find . -mindepth 2 -type f
```

Results starting directory se kam az kam do levels neeche hone chahiye.

### Limited levels search karna

```bash
find . -mindepth 1 -maxdepth 2 -type f
```

### Practical example

```bash
find /var/log -maxdepth 1 -type f -name "*.log"
```

Yeh sirf `/var/log` ke directly andar `.log` files search karta hai. Yeh us ki subdirectories ke andar nahi jata.

> `-maxdepth` aur `-mindepth` GNU `find` mein available hain, jo zyada tar Linux systems par use hota hai. Yeh basic POSIX `find` ka hissa nahi hain.

---

## 6. Size Se Search Karna

### 10 MiB se bari files

```bash
find . -type f -size +10M
```

### 1 MiB se chhoti files

```bash
find . -type f -size -1M
```

### Specific size unit

```bash
find . -type f -size 100k
```

`find` units ke mutabiq rounding karta hai. Is liye exact nazar aane wala size test lazmi nahi ke exact bytes ko represent kare.

### Common size suffixes

| Suffix | Unit |
|---|---|
| `c` | Bytes |
| `k` | KiB units |
| `M` | MiB units |
| `G` | GiB units |

Examples:

```bash
find /var/log -type f -size +100M
find "$HOME" -type f -size +1G
```

---

## 7. Modification Time Se Search Karna

`-mtime` 24-hour periods use karta hai, jabke `-mmin` minutes use karta hai.

### Aakhri saat 24-hour periods ke andar modified files

```bash
find . -type f -mtime -7
```

### Saat complete 24-hour periods se purani files

```bash
find . -type f -mtime +7
```

### Current 24-hour age bucket ke andar modified files

```bash
find . -type f -mtime 0
```

### Taqreeban aakhri 30 minutes mein modified files

```bash
find . -type f -mmin -30
```

### Common time tests

| Test | Matlab |
|---|---|
| `-mtime` | Data modification time, 24-hour periods mein |
| `-mmin` | Data modification time, minutes mein |
| `-atime` | Last access time, 24-hour periods mein |
| `-amin` | Last access time, minutes mein |
| `-ctime` | Metadata change time, 24-hour periods mein |
| `-cmin` | Metadata change time, minutes mein |

> Linux mein `ctime` inode metadata-change time hota hai. Yeh file-creation time nahi hota.

---

## 8. Empty Files aur Directories Dhoondhna

### Empty regular files

```bash
find . -type f -empty
```

### Empty directories

```bash
find . -type d -empty
```

### Non-empty regular files

```bash
find . -type f ! -empty
```

---

## 9. Owner ya Group Se Search Karna

### Kisi user ki owned files

```bash
find /home -type f -user khalid
```

Yeh `khalid` ki ownership wali regular files dhoondhta hai.

### Kisi group ki files

```bash
find /shared -type f -group developers
```

### Valid username ke baghair files

```bash
find /home -nouser
```

Yeh aisi files locate karne mein madad karta hai jin ka numeric owner UID ab kisi existing account se map nahi hota.

### Valid group name ke baghair files

```bash
find /home -nogroup
```

---

## 10. Conditions Combine Karna

### AND behavior

Saath likhi hui conditions aam tor par implicit AND use karti hain:

```bash
find . -type f -name "*.log" -size +10M
```

Matlab:

> Aise items dhoondo jo regular files hon, jin ke naam `.log` par khatam hon aur jin ka size 10 MiB se zyada ho.

### OR ke liye `-o`

```bash
find . -type f \( -name "*.txt" -o -name "*.md" \)
```

Yeh `.txt` ya `.md` par khatam hone wali regular files dhoondhta hai.

Parentheses ko escape kiya gaya hai:

```bash
\( ... \)
```

Is se shell un parentheses ko khud interpret nahi karti.

### NOT ke liye `!`

`.txt` ke ilawa files dhoondhne ke liye:

```bash
find . -type f ! -name "*.txt"
```

### Grouping kyun zaroori hai?

Yeh command:

```bash
find . -type f -name "*.txt" -o -name "*.md"
```

`-type f` ko dono name conditions par barabar apply nahi karti, kyun ke AND ki precedence OR se zyada hoti hai.

Sahi grouping:

```bash
find . -type f \( -name "*.txt" -o -name "*.md" \)
```

---

## 11. `-exec` Se Action Perform Karna

### Har matching path ke liye alag command

```bash
find . -type f -name "*.sh" -exec ls -l -- {} \;
```

| Hissa | Matlab |
|---|---|
| `-exec` | Matching paths par command chalao |
| `ls -l` | Chalne wali command |
| `--` | Options ka end; is ke baad pathnames hain |
| `{}` | Current matched pathname |
| `\;` | Action ka end aur har match par alag execution |

Semicolon ko escape kiya gaya hai kyun ke shell normally `;` ko command separator samajhti hai.

### Multiple matches ko ek command mein process karna

```bash
find . -type f -name "*.sh" -exec ls -l -- {} +
```

Farq:

| Ending | Behavior |
|---|---|
| `\;` | Har match ke liye command alag chalti hai |
| `+` | Multiple matches ko kam command executions mein pass karta hai |

Jab called command multiple pathnames accept karti ho, to `+` form aam tor par zyada efficient hota hai.

### Execute karne se pehle confirmation

```bash
find . -type f -name "*.bak" -ok rm -- {} \;
```

`-ok` har command se pehle confirmation mangta hai. Prompt aur accepted response system implementation aur locale ke mutabiq mukhtalif ho sakte hain.

---

## 12. Matching Files Copy Karna

```bash
destination="/tmp/script-backup"

mkdir -p -- "$destination"

find . -type f -name "*.sh" \
    -exec cp -- {} "$destination" \;
```

Yeh matching shell scripts ko destination directory mein copy karta hai.

### Name-collision warning

Agar yeh files mojood hon:

```text
project-a/start.sh
project-b/start.sh
```

Dono ko ek hi directory mein copy karne se ek `start.sh` doosri ko overwrite kar sakti hai. Duplicate basenames possible hon to directory structure preserve karein ya unique target names banayein.

---

## 13. Matching Files Safely Delete Karna

### Step 1: Preview

```bash
find /tmp -type f -name "*.tmp" -print
```

Dhyan se verify karein:

- Starting path
- File type
- Name pattern
- Complete result list

### Step 2: Verification ke baad delete

```bash
find /tmp -type f -name "*.tmp" -delete
```

### Safer script pattern

```bash
target_directory="/tmp/application-cache"

echo "Files selected for deletion:"
find "$target_directory" -type f -name "*.tmp" -print

read -r -p "Enter yes to delete these files: " answer

if [[ "$answer" == "yes" ]]; then
    find "$target_directory" -type f -name "*.tmp" -delete
    echo "Cleanup completed."
else
    echo "Cleanup cancelled."
fi
```

> `-delete` destructive hai. Ghalat starting path ya condition important files remove kar sakti hai. Hamesha pehle preview karein.

---

## 14. Shell Script Mein `find` Use Karna

```bash
#!/bin/bash

# Title: Find Shell Scripts
# Usage: bash find_scripts.sh DIRECTORY

search_directory="${1:-}"

if [[ -z "$search_directory" ]]; then
    echo "Usage: $0 DIRECTORY" >&2
    exit 1
fi

if [[ ! -d "$search_directory" ]]; then
    echo "Error: directory does not exist: $search_directory" >&2
    exit 1
fi

if [[ ! -r "$search_directory" ]]; then
    echo "Error: directory is not readable: $search_directory" >&2
    exit 1
fi

echo "Shell scripts found:"

find "$search_directory" -type f -name "*.sh" -print

exit 0
```

Script chalayein:

```bash
bash find_scripts.sh /home/khalid
```

### Variable ko quote kyun kiya?

```bash
find "$search_directory"
```

Quotes spaces wale directory path ko ek argument rakhti hain aur unwanted wildcard expansion rokti hain.

---

## 15. Matching Files Count Karna

### GNU/Linux method jo newline wale filenames se safe hai

```bash
count=$(find "$search_directory" -type f -name "*.sh" -printf '.' | wc -c)

echo "Total shell scripts: $count"
```

GNU `find` har match ke liye ek dot print karta hai aur `wc -c` un dots ko count karta hai.

> `-printf` GNU `find` ka feature hai. Yeh har Unix implementation mein available nahi hota.

### Bash loop method

```bash
count=0

while IFS= read -r -d '' file
do
    ((count += 1))
done < <(find "$search_directory" -type f -name "*.sh" -print0)

echo "Total shell scripts: $count"
```

Process substitution ki wajah se loop current Bash process mein rehta hai. Is liye loop ke baad final `count` available rehta hai.

---

## 16. Filenames Ko Safely Process Karna

### Unsafe approach

```bash
for file in $(find . -type f -name "*.txt")
do
    echo "$file"
done
```

Yeh unsafe hai kyun ke command substitution aur `for` loop whitespace par results split karte hain.

Yeh pathname:

```text
student notes.txt
```

Ghalti se do separate items samjha ja sakta hai.

### Safe null-separated loop

```bash
while IFS= read -r -d '' file
do
    echo "Processing: $file"
done < <(find . -type f -name "*.txt" -print0)
```

### Explanation

| Hissa | Maqsad |
|---|---|
| `-print0` | Pathnames ko null character se separate karta hai |
| `< <(...)` | Process-substitution output ko loop mein deta hai |
| `IFS=` | Unwanted whitespace trimming rokta hai |
| `read -r` | Backslash interpretation rokta hai |
| `-d ''` | Null separator tak input read karta hai |
| `"$file"` | Pathname ko ek argument ke taur par preserve karta hai |

Null byte woh character hai jo Unix pathname ke andar nahi aa sakta. Is liye yeh approach spaces, tabs aur newlines wale unusual filenames ke liye bhi safe hai.

### Jab `-exec` zyada simple ho

Agar external command direct results process kar sakti ho, to shell loop ke bajaye yeh zyada simple ho sakta hai:

```bash
find . -type f -name "*.txt" -exec chmod 640 -- {} +
```

---

## 17. Real-World Log-Cleanup Script

```bash
#!/bin/bash

# Title: Safe Log Cleanup
# Usage: bash cleanup_logs.sh LOG_DIRECTORY RETENTION_DAYS

set -Eeuo pipefail

log_directory="${1:-}"
retention_days="${2:-}"

if [[ -z "$log_directory" || -z "$retention_days" ]]; then
    echo "Usage: $0 LOG_DIRECTORY RETENTION_DAYS" >&2
    exit 1
fi

if [[ ! -d "$log_directory" ]]; then
    echo "Error: directory not found: $log_directory" >&2
    exit 1
fi

if [[ ! -r "$log_directory" ]]; then
    echo "Error: directory is not readable: $log_directory" >&2
    exit 1
fi

if [[ ! "$retention_days" =~ ^[0-9]+$ ]]; then
    echo "Error: retention days must be a non-negative whole number." >&2
    exit 1
fi

echo "Log files selected for deletion:"

find "$log_directory" \
    -type f \
    -name "*.log" \
    -mtime "+$retention_days" \
    -print

echo
read -r -p "Delete these files? Enter yes to continue: " answer

if [[ "$answer" == "yes" ]]; then
    find "$log_directory" \
        -type f \
        -name "*.log" \
        -mtime "+$retention_days" \
        -delete

    echo "Cleanup completed."
else
    echo "Cleanup cancelled."
fi

exit 0
```

### Script ka workflow

1. Log directory aur retention period receive karti hai.
2. Check karti hai ke dono arguments diye gaye hain.
3. Check karti hai ke directory mojood aur readable hai.
4. Digits-only regex se retention period validate karti hai.
5. Delete hone wali files ka preview dikhati hai.
6. User se explicit confirmation mangti hai.
7. Sirf exact `yes` input par files delete karti hai.
8. Clear exit status return karti hai.

### Example

```bash
bash cleanup_logs.sh /var/tmp/application-logs 30
```

Yeh un `.log` files ko target karta hai jin ki modification age 30 complete 24-hour periods se zyada ho.

### Script ki safety features

| Feature | Faida |
|---|---|
| `set -Eeuo pipefail` | Common unhandled errors ko jaldi expose karta hai |
| `${1:-}` aur `${2:-}` | Missing arguments ko `set -u` ke sath safely handle karta hai |
| `[[ -d ... ]]` | Directory existence validate karta hai |
| `[[ -r ... ]]` | Readability check karta hai |
| Regex validation | Invalid retention value reject karti hai |
| `-print` preview | Deletion se pehle targets dikhata hai |
| Exact `yes` | Accidental confirmation ka risk kam karta hai |
| Quoted variables | Spaces wale paths ko safe rakhti hain |

---

## 18. Common Mistakes

### Mistake 1: Pattern ko quote na karna

Ghalat ya unreliable:

```bash
find . -name *.txt
```

Sahi:

```bash
find . -name "*.txt"
```

### Mistake 2: Filenames ke liye command substitution

```bash
for file in $(find . -type f)
```

Is ke bajaye `-print0` ke sath null-separated loop ya `-exec` use karein.

### Mistake 3: Starting path bhoolna

```bash
find -name "*.log"
```

GNU `find` kuch omitted-path forms accept kar sakta hai, lekin portable aur readable scripts mein starting path explicitly dena behtar hai:

```bash
find . -name "*.log"
```

### Mistake 4: `-mtime` ko calendar dates samajhna

`-mtime` rounded 24-hour age periods use karta hai. Precise timestamps ke liye GNU `find` ka `-newermt` ya reference files ka method study karein.

### Mistake 5: Preview ke baghair delete karna

Pehle bilkul wohi expression `-print` ke sath chalayein. Results verify karne ke baad hi `-delete` use karein.

### Mistake 6: Permission errors ignore karna

Protected directories search karte waqt `find`, `stderr` par `Permission denied` report kar sakta hai. In errors ko automatically hide na karein jab tak script intentionally incomplete results accept na karti ho.

### Mistake 7: OR grouping ghalat karna

Alternatives combine karte waqt escaped parentheses use karein:

```bash
find . -type f \( -name "*.txt" -o -name "*.md" \)
```

### Mistake 8: Variable ko quote na karna

Unsafe:

```bash
find $search_directory -type f
```

Safe:

```bash
find "$search_directory" -type f
```

---

## 19. Quick Reference

| Task | Command |
|---|---|
| Tamam regular files dhoondhna | `find . -type f` |
| Tamam directories dhoondhna | `find . -type d` |
| Shell scripts dhoondhna | `find . -type f -name "*.sh"` |
| Filename case ignore karna | `find . -type f -iname "*.txt"` |
| Symbolic links dhoondhna | `find . -type l` |
| Sirf current level search karna | `find . -maxdepth 1 -type f` |
| Empty files dhoondhna | `find . -type f -empty` |
| Empty directories dhoondhna | `find . -type d -empty` |
| 100 MiB se bari files | `find . -type f -size +100M` |
| Recently modified files | `find . -type f -mtime -7` |
| Purani files | `find . -type f -mtime +30` |
| Aakhri 30 minutes mein modified | `find . -type f -mmin -30` |
| `khalid` ki owned files | `find . -type f -user khalid` |
| `.txt` ya `.md` match karna | `find . -type f \( -name "*.txt" -o -name "*.md" \)` |
| `.txt` files exclude karna | `find . -type f ! -name "*.txt"` |
| Efficient command execution | `find . -type f -exec ls -l -- {} +` |
| Deletion preview | `find . -type f -name "*.tmp" -print` |
| Matching files delete karna | `find . -type f -name "*.tmp" -delete` |
| Null-separated output | `find . -type f -print0` |

---

## 20. Khulasa

`find` command Linux administration aur shell scripting ke sab se useful tools mein se ek hai. Is ka basic structure hai:

```bash
find PATH TESTS ACTIONS
```

Ek reliable `find` command ko teen cheezen clearly define karni chahiye:

1. Search kahan se shuru hogi
2. Kaun se paths match hone chahiye
3. Matching paths par kya action perform hoga

Zaroori habits:

- Wildcard patterns ko quote karein, jaise `"*.log"`.
- Variable expansions ko quote karein, jaise `"$directory"`.
- Object type important ho to `-type f` ya `-type d` use karein.
- OR expressions ko `\(` aur `\)` mein group karein.
- External command multiple paths accept kare to `-exec ... {} +` prefer karein.
- Safe Bash processing ke liye `-print0` aur null-separated loop use karein.
- Destructive action se pehle complete results preview karein.

Sab se important safety rule:

> `-delete` ya destructive `-exec` command use karne se pehle hamesha starting path verify karein aur tamam matching results ka preview dekhein.
