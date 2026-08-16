# Level 2 Lab — Input, Files, Arrays, and Menus

## Objective

Use loops with files, input validation, arrays, nested data, and terminal menus.

## Lab data

Use:

```text
../03-lab-data/fruits.txt
../03-lab-data/students.txt
```

If you run scripts from the package root, use:

```text
03-lab-data/fruits.txt
03-lab-data/students.txt
```

---

## Task 1 — Read fruits from a file

Create `01_read_fruits.sh`.

Requirements:

- Accept the filename as `$1`.
- Show usage and exit `2` if the argument is missing.
- Verify that the file exists.
- Read it with `while IFS= read -r`.
- Number every fruit.

Run:

```bash
bash 01_read_fruits.sh ../03-lab-data/fruits.txt
```

Expected output:

```text
1. apple
2. banana
3. cherry
4. mango
```

---

## Task 2 — Process text files

Create `02_text_files.sh`.

Requirements:

- Loop through `*.txt` in a directory supplied as `$1`.
- Display each filename.
- Use `[[ -e "$file" ]] || continue` to handle no matches.
- Do not use `ls` inside command substitution.

Example:

```bash
bash 02_text_files.sh ../03-lab-data
```

---

## Task 3 — Validate a weather answer

Create `03_weather_loop.sh`.

Keep asking:

```text
Is it raining? Enter yes or no:
```

Behavior:

- `yes` → display `Take an umbrella` and exit the loop.
- `no` → display `No umbrella needed` and exit the loop.
- Anything else → display `Invalid answer. Try again.` and repeat.

Use `while true`, `if`, `elif`, `else`, and `break`.

---

## Task 4 — Student and subject combinations

Create `04_nested_loop.sh`.

Use these students:

```text
Ali Omar
```

Use these subjects:

```text
Linux Bash
```

Use nested loops to display every student-subject combination.

Expected output:

```text
Ali is studying Linux
Ali is studying Bash
Omar is studying Linux
Omar is studying Bash
```

---

## Task 5 — Server array

Create `05_server_array.sh`.

Create this array:

```bash
servers=("web01" "web02" "database01")
```

Loop safely through the array and display:

```text
Checking server: web01
Checking server: web02
Checking server: database01
```

---

## Task 6 — Utility menu

Create `06_utility_menu.sh`.

The menu must repeat until the user chooses Exit:

```text
1. Show date
2. Show current directory
3. Show current user
4. Exit
```

Use:

- `while true`
- `read -r`
- `case`
- `break`

Invalid choices must show an error without closing the menu.

---

## Level 2 verification

Test:

- Missing argument
- Valid file
- Missing file
- Directory with matching `.txt` files
- Directory without matching `.txt` files
- Valid and invalid weather answers
- Every menu choice

