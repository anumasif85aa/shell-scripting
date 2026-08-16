# Linux `tr` Command and Parsing — Study Notes

## Learning objectives

After studying these notes, you should be able to:

- Explain that `tr` is a character-processing command.
- Translate one character set into another.
- Delete and squeeze selected characters.
- Use POSIX character classes.
- Clean delimiters, whitespace, line endings, and mixed text.
- Use input redirection and pipelines correctly.
- Apply `tr` safely in Linux Administrator workflows.

---

## 1. What is `tr`?

`tr` is short for:

```text
Translate
```

It is used to:

- Translate one group of characters into another.
- Delete selected characters.
- Squeeze repeated characters.
- Convert uppercase and lowercase letters.
- Change delimiters.
- Clean and normalize text.

In simple words:

> `tr` reads text character by character and translates, deletes, or squeezes selected characters.

---

## 2. Is `tr` a parsing command?

`tr` participates in parsing and data-cleaning pipelines, but it is not a field parser like AWK. It processes characters.

```text
Input → character set → tr operation → transformed output
```

```text
grep = search lines
cut  = extract fields
awk  = parse fields and calculate
sed  = edit text with patterns
sort = arrange records
uniq = process adjacent duplicates
tr   = translate, delete, or squeeze characters
```

---

## 3. Important input behavior

`tr` normally reads from standard input rather than accepting an input filename as a regular argument.

Correct:

```bash
tr 'a-z' 'A-Z' < file.txt
```

Also correct:

```bash
cat file.txt | tr 'a-z' 'A-Z'
```

Incorrect:

```bash
tr 'a-z' 'A-Z' file.txt
```

Preferred form:

```bash
tr 'a-z' 'A-Z' < file.txt
```

This avoids an unnecessary `cat` process.

---

## 4. Basic syntax and mapping

```bash
tr [OPTIONS] SET1 [SET2]
```

| Part | Meaning |
|---|---|
| `tr` | Runs the command |
| `SET1` | Characters to find |
| `SET2` | Replacement characters |
| `OPTIONS` | Delete, squeeze, or complement controls |

Example:

```bash
echo "abc" | tr 'abc' '123'
```

Output:

```text
123
```

Mapping:

| SET1 | SET2 |
|---|---|
| `a` | `1` |
| `b` | `2` |
| `c` | `3` |

---

## 5. Convert letter case

### Lowercase to uppercase

```bash
echo "linux administrator" |
tr 'a-z' 'A-Z'
```

Preferred character-class form:

```bash
echo "linux administrator" |
tr '[:lower:]' '[:upper:]'
```

### Uppercase to lowercase

```bash
echo "LINUX ADMINISTRATOR" |
tr '[:upper:]' '[:lower:]'
```

Output:

```text
linux administrator
```

---

## 6. Common POSIX character classes

| Character class | Meaning |
|---|---|
| `[:lower:]` | Lowercase letters |
| `[:upper:]` | Uppercase letters |
| `[:alpha:]` | Alphabetic characters |
| `[:digit:]` | Digits |
| `[:alnum:]` | Letters and digits |
| `[:space:]` | Whitespace characters, including newlines |
| `[:blank:]` | Spaces and tabs |
| `[:punct:]` | Punctuation |
| `[:print:]` | Printable characters |
| `[:cntrl:]` | Control characters |

Use quoted character classes:

```bash
tr '[:lower:]' '[:upper:]'
```

---

## 7. Replace characters and delimiters

### Spaces to underscores

```bash
echo "linux system administrator" |
tr ' ' '_'
```

Output:

```text
linux_system_administrator
```

### Colons to commas

```bash
echo "web01:running:25" |
tr ':' ','
```

Output:

```text
web01,running,25
```

### Multiple input delimiters to one output delimiter

```bash
echo "web01:running,25" |
tr ':,' '||'
```

Output:

```text
web01|running|25
```

Using equal-length sets makes the intended mapping clear.

---

## 8. Delete characters with `-d`

### Remove digits

```bash
echo "server123" |
tr -d '[:digit:]'
```

Output:

```text
server
```

### Remove spaces

```bash
echo "linux administrator" |
tr -d ' '
```

### Remove punctuation

```bash
echo "Error: server-down!" |
tr -d '[:punct:]'
```

### Remove colons

```bash
echo "web01:running:25" |
tr -d ':'
```

---

## 9. Remove Windows carriage returns

Windows line endings commonly use `\r\n`, while Linux uses `\n`.

```bash
tr -d '\r' < windows-file.txt > linux-file.txt
```

This is useful when a script reports:

```text
/bin/bash^M: bad interpreter
```

Another purpose-built tool is:

```bash
dos2unix script.sh
```

---

## 10. Squeeze repetitions with `-s`

### Squeeze repeated spaces

```bash
echo "web01     running     25" |
tr -s ' '
```

Output:

```text
web01 running 25
```

### Normalize spaces and tabs

```bash
printf 'web01\t\t   running    25\n' |
tr -s '[:blank:]' ' '
```

Output:

```text
web01 running 25
```

### Squeeze repeated newlines

```bash
tr -s '\n' < file.txt
```

This reduces consecutive newline characters to one newline.

### `[:space:]` versus `[:blank:]`

This may translate newline characters too:

```bash
tr -s '[:space:]' ' '
```

To target only spaces and tabs while preserving line boundaries:

```bash
tr -s '[:blank:]' ' '
```

---

## 11. Complement a set with `-c`

`-c` selects every character not in the supplied set. It is often combined with `-d`.

### Keep only digits

```bash
echo "Phone: 123-456-7890" |
tr -cd '[:digit:]'
```

Output:

```text
1234567890
```

### Keep letters and newlines

```bash
tr -cd '[:alpha:]\n' < file.txt
```

### Keep printable text and newlines

```bash
tr -cd '[:print:]\n' < file.txt
```

Character whitelisting can remove meaningful data, so inspect the result carefully.

---

## 12. Convert records and delimiters

### Newlines to commas

For:

```text
web01
web02
db01
```

```bash
tr '\n' ',' < servers.txt
```

Output:

```text
web01,web02,db01,
```

The final newline becomes a trailing comma. Remove it:

```bash
tr '\n' ',' < servers.txt |
sed 's/,$/\n/'
```

Or use the more direct line-joining command:

```bash
paste -sd, servers.txt
```

### Commas to newlines

```bash
echo "web01,web02,db01" |
tr ',' '\n'
```

---

## 13. Normalize names and shell variables

### Simple URL-style name

```bash
echo "Linux System Administrator" |
tr '[:upper:]' '[:lower:]' |
tr ' ' '-'
```

Output:

```text
linux-system-administrator
```

Normalize repeated blanks too:

```bash
echo "Linux    System   Administrator" |
tr '[:upper:]' '[:lower:]' |
tr -s '[:blank:]' '-'
```

### Use with a shell variable

```bash
name="Linux Administrator"

normalized_name=$(printf '%s\n' "$name" |
    tr '[:upper:]' '[:lower:]' |
    tr ' ' '_')

echo "$normalized_name"
```

Use `printf` when exact input handling matters.

---

## 14. Data-cleaning pipeline

Input:

```text
web01       running       25
web02    stopped      80
db01        running       65
```

Normalize blanks:

```bash
tr -s '[:blank:]' ' ' < servers.txt
```

Convert blanks to colons:

```bash
tr -s '[:blank:]' ':' < servers.txt
```

Then filter with AWK:

```bash
tr -s '[:blank:]' ':' < servers.txt |
awk -F: '$2 == "running" {print $1}'
```

Output:

```text
web01
db01
```

---

## 15. Linux Administrator examples

### Normalize blanks in command output

```bash
command |
tr -s '[:blank:]' ' '
```

### Uppercase service names

```bash
systemctl list-units --type=service --no-legend |
awk '{print $1}' |
tr '[:lower:]' '[:upper:]'
```

### Display PATH directories separately

```bash
printf '%s\n' "$PATH" |
tr ':' '\n'
```

### Remove empty and repeated PATH entries, then number them

```bash
printf '%s\n' "$PATH" |
tr ':' '\n' |
awk 'NF' |
sort -u |
nl
```

### Count nonempty PATH entries

```bash
printf '%s\n' "$PATH" |
tr ':' '\n' |
awk 'NF' |
wc -l
```

### Extract digits from mixed text

```bash
printf '%s\n' 'PID=12345' |
tr -cd '[:digit:]\n'
```

---

## 16. `tr` versus other tools

| Command | Main purpose |
|---|---|
| `grep` | Search matching lines |
| `cut` | Extract simple fields |
| `awk` | Process fields, conditions, and calculations |
| `sed` | Edit text using patterns |
| `sort` | Arrange records |
| `uniq` | Process adjacent duplicates |
| `tr` | Translate, delete, or squeeze characters |
| `jq` | Parse and transform JSON |

### Character replacement: use `tr`

```bash
tr ':' ','
```

### Word or pattern replacement: use `sed`

```bash
sed 's/running/active/g'
```

### Field conditions: use AWK

```bash
awk -F: '$2 == "running" {print $1}'
```

---

## 17. `tr` does not replace words

This creates character mappings rather than replacing the word `cat`:

```bash
echo "cat" | tr 'cat' 'dog'
```

Mapping:

```text
c → d
a → o
t → g
```

For word replacement, use:

```bash
echo "cat" |
sed 's/cat/dog/g'
```

---

## 18. Unequal sets and locale

Unequal set lengths may be interpreted differently by implementations. For clear commands, make the mapping explicit:

```bash
echo "abc" | tr 'abc' '122'
```

Ranges such as `a-z` can depend on locale. Character classes are often clearer:

```bash
tr '[:lower:]' '[:upper:]'
```

For predictable byte-oriented processing:

```bash
LC_ALL=C tr 'a-z' 'A-Z'
```

Unicode and multibyte transformations may require Unicode-aware tools.

---

## 19. Save transformed output safely

Save to another file:

```bash
tr '[:lower:]' '[:upper:]' \
    < names.txt \
    > names-uppercase.txt
```

Do not use the same input and redirected output file:

```bash
tr '[:lower:]' '[:upper:]' \
    < names.txt \
    > names.txt
```

The shell may empty the file before `tr` reads it.

Safe replacement:

```bash
tr '[:lower:]' '[:upper:]' \
    < names.txt \
    > names.tmp &&
mv names.tmp names.txt
```

Safer workflow with a backup:

```bash
cp names.txt names.txt.bak

tr '[:lower:]' '[:upper:]' \
    < names.txt \
    > names.tmp &&
mv names.tmp names.txt
```

---

## 20. Common options

| Option | Purpose |
|---|---|
| `-d` | Delete characters from SET1 |
| `-s` | Squeeze repeated characters |
| `-c` or `-C` | Complement SET1 |
| `--help` | Display help |
| `--version` | Display version information |

---

## 21. Common mistakes

### Passing a filename directly

```bash
# Incorrect
tr 'a-z' 'A-Z' file.txt

# Correct
tr 'a-z' 'A-Z' < file.txt
```

### Expecting word replacement

Use `sed` for words and patterns rather than `tr`.

### Forgetting quotes

```bash
# Risky
tr [:lower:] [:upper:]

# Correct
tr '[:lower:]' '[:upper:]'
```

### Using `[:space:]` when newlines must remain unchanged

Use `[:blank:]` for spaces and tabs only:

```bash
tr -s '[:blank:]' ' '
```

### Overwriting the input

Use a temporary file instead of `tr ... < file > file`.

### Forgetting the trailing delimiter

`tr '\n' ','` also translates the final newline. Consider `paste -sd,` or remove the final delimiter afterward.

---

## 22. Thinking process before using `tr`

Ask:

1. Am I processing characters or complete words?
2. Which characters should be translated?
3. Which replacement characters are required?
4. Should characters be deleted?
5. Should repetitions be squeezed?
6. Should the set be complemented?
7. Must spaces, tabs, and newlines be treated differently?
8. Could locale or Unicode affect the result?
9. Should output be displayed or saved?
10. Am I protecting the original file?

Basic flow:

```text
Input stream → SET1 → translate/delete/squeeze → output
```

Example:

```bash
tr -s '[:blank:]' ':' < servers.txt
```

---

## 23. Practice lab

Create the file:

```bash
cat > employee-data.txt <<'EOF'
KHALID     LINUX_ADMIN     75000
ALI        DEVOPS_ENGINEER 90000
SARA       CLOUD_ENGINEER  85000
EOF
```

Complete these tasks:

1. Convert all letters to lowercase.
2. Convert spaces to colons.
3. Normalize repeated spaces into one space.
4. Normalize repeated spaces and convert them to colons.
5. Remove all digits.
6. Keep only digits and newlines.
7. Convert underscores to hyphens.
8. Convert every record into one comma-separated line.
9. Convert a colon-separated PATH into separate lines.
10. Save a lowercase version in another file.

### Solutions

```bash
# 1. Convert to lowercase
tr '[:upper:]' '[:lower:]' < employee-data.txt

# 2. Convert every space to a colon
tr ' ' ':' < employee-data.txt

# 3. Normalize repeated blanks
tr -s '[:blank:]' ' ' < employee-data.txt

# 4. Normalize blanks and convert them to colons
tr -s '[:blank:]' ':' < employee-data.txt

# 5. Remove digits
tr -d '[:digit:]' < employee-data.txt

# 6. Keep only digits and newlines
tr -cd '[:digit:]\n' < employee-data.txt

# 7. Convert underscores to hyphens
tr '_' '-' < employee-data.txt

# 8. Join records with commas
tr '\n' ',' < employee-data.txt |
sed 's/,$/\n/'

# 9. Display PATH entries on separate lines
printf '%s\n' "$PATH" | tr ':' '\n'

# 10. Save lowercase output
tr '[:upper:]' '[:lower:]' \
    < employee-data.txt \
    > employee-data-lowercase.txt
```

---

## 24. Quick knowledge check

1. What does `tr` mean?
2. Does `tr` process characters, words, or fields?
3. Why does `tr` normally need a pipe or input redirection?
4. How do you convert lowercase letters to uppercase?
5. What does `-d` do?
6. What does `-s` do?
7. What does `-c` do?
8. What is the difference between `[:space:]` and `[:blank:]`?
9. How can carriage returns be removed from a Windows-formatted file?
10. Why should the input and redirected output not be the same file?
11. Why is `tr` unsuitable for word replacement?
12. When are `sed` or AWK more appropriate?

---

## 25. Quick reference

```bash
# Lowercase to uppercase
tr '[:lower:]' '[:upper:]'

# Uppercase to lowercase
tr '[:upper:]' '[:lower:]'

# Replace spaces with underscores
tr ' ' '_'

# Replace colons with commas
tr ':' ','

# Delete digits
tr -d '[:digit:]'

# Delete carriage returns
tr -d '\r'

# Squeeze spaces
tr -s ' '

# Normalize spaces and tabs
tr -s '[:blank:]' ' '

# Normalize blanks and use colons
tr -s '[:blank:]' ':'

# Keep only digits
tr -cd '[:digit:]'

# Keep digits and newlines
tr -cd '[:digit:]\n'

# Convert commas to newlines
tr ',' '\n'

# Read from a file
tr '[:lower:]' '[:upper:]' < file.txt

# Save to another file
tr ':' ',' < input.txt > output.txt
```

## Final summary

`tr` is a character-processing command used to translate, delete, or squeeze characters.

Remember:

```text
tr SET1 SET2 = translate characters
tr -d SET1   = delete characters
tr -s SET1   = squeeze repetitions
tr -cd SET1  = keep only selected characters
```

The key distinction is:

> `tr` works with individual characters—not complete words, fields, or JSON structures.
