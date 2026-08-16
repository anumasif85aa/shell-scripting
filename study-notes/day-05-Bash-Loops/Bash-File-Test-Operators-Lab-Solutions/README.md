# Bash File-Test Operators — Lab Solutions

Complete solutions for the six-task student lab.

## Files

```text
01_path_exists.sh
02_file_or_directory.sh
03_permission_check.sh
04_empty_check.sh
05_link_check.sh
06_path_inspector.sh
```

## Before testing

Place this solution directory beside the student lab:

```text
Bash-File-Test-Operators-Student-Lab/
Bash-File-Test-Operators-Lab-Solutions/
```

Enter the solution directory:

```bash
cd Bash-File-Test-Operators-Lab-Solutions
```

The commands below assume this location:

```text
../Bash-File-Test-Operators-Student-Lab/lab-data
```

---

## Solution 1 — Path existence

Main test:

```bash
[[ -e "$path" ]]
```

Test:

```bash
./01_path_exists.sh ../Bash-File-Test-Operators-Student-Lab/lab-data/notes.txt
./01_path_exists.sh ../Bash-File-Test-Operators-Student-Lab/lab-data/missing.txt
echo "$?"
```

The script returns:

- `0` when the path exists
- `1` when the path does not exist
- `2` when the argument is missing

---

## Solution 2 — File or directory

The testing order is:

```text
-f → regular file
-d → directory
else → missing or another path type
```

Test:

```bash
./02_file_or_directory.sh ../Bash-File-Test-Operators-Student-Lab/lab-data/notes.txt
./02_file_or_directory.sh ../Bash-File-Test-Operators-Student-Lab/lab-data/reports
./02_file_or_directory.sh ../Bash-File-Test-Operators-Student-Lab/lab-data/missing.txt
```

---

## Solution 3 — Access permissions

The script tests all three permissions independently:

| Operator | Regular file | Directory |
|---|---|---|
| `-r` | Can read file contents | Can list directory names, subject to other permissions |
| `-w` | Can modify the file | Can create or remove directory entries, subject to other permissions |
| `-x` | Can execute the file | Can search or enter the directory |

Test:

```bash
./03_permission_check.sh ../Bash-File-Test-Operators-Student-Lab/lab-data/notes.txt
./03_permission_check.sh ../Bash-File-Test-Operators-Student-Lab/lab-data/run_me.sh
./03_permission_check.sh ../Bash-File-Test-Operators-Student-Lab/lab-data/reports
```

Results depend on the permissions of the user running the script.

---

## Solution 4 — Empty or nonempty file

The script first confirms that the path is a regular file:

```bash
[[ -f "$file" ]]
```

It then checks:

```bash
[[ -s "$file" ]]
```

`-s` is true when the file exists and its size is greater than zero.

Test:

```bash
./04_empty_check.sh ../Bash-File-Test-Operators-Student-Lab/lab-data/notes.txt
./04_empty_check.sh ../Bash-File-Test-Operators-Student-Lab/lab-data/empty.txt
./04_empty_check.sh ../Bash-File-Test-Operators-Student-Lab/lab-data/reports
```

---

## Solution 5 — Symbolic link

The script checks `-L` first:

```bash
[[ -L "$path" ]]
```

This matters because a working symbolic link pointing to a regular file can also satisfy `-f`.

Test:

```bash
./05_link_check.sh ../Bash-File-Test-Operators-Student-Lab/lab-data/notes-link
./05_link_check.sh ../Bash-File-Test-Operators-Student-Lab/lab-data/notes.txt
./05_link_check.sh ../Bash-File-Test-Operators-Student-Lab/lab-data/reports
```

For a broken symbolic link:

- `-L` is true because the link itself exists.
- `-e` is false because its target does not exist.

---

## Solution 6 — Path inspector capstone

The capstone combines:

- Argument validation
- `-e` and `-L`
- `-f` and `-d`
- `-r`, `-w`, and `-x`
- `-s`
- Standard error
- Exit statuses

Test:

```bash
data="../Bash-File-Test-Operators-Student-Lab/lab-data"

./06_path_inspector.sh "$data/notes.txt"
./06_path_inspector.sh "$data/empty.txt"
./06_path_inspector.sh "$data/run_me.sh"
./06_path_inspector.sh "$data/reports"
./06_path_inspector.sh "$data/notes-link"
./06_path_inspector.sh "$data/missing.txt"
echo "$?"
```

The script reports `Contains data` only for a regular file that is not itself a symbolic link.

---

## Validate every solution

```bash
for script in 0*.sh
do
    echo "Checking: $script"
    bash -n "$script" || exit 1
done

echo "All solution scripts have valid Bash syntax."
```

## Important lesson

Choose the most specific test for the question:

| Question | Test |
|---|---|
| Does any target path exist? | `-e` |
| Is this a regular file? | `-f` |
| Is this a directory? | `-d` |
| Is this a symbolic link? | `-L` |
| Can this user read it? | `-r` |
| Can this user write it? | `-w` |
| Can this user execute/search it? | `-x` |
| Is this file nonempty? | `-s` |

