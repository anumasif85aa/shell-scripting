# Level 2 Solutions — Input, Files, Arrays, and Menus

Try each task before reading its solution.

---

## Solution 1 — `01_read_fruits.sh`

```bash
#!/bin/bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 FRUIT_FILE" >&2
    exit 2
fi

fruit_file="$1"

if [[ ! -f "$fruit_file" ]]; then
    echo "Error: file not found: $fruit_file" >&2
    exit 1
fi

number=0

while IFS= read -r fruit || [[ -n "$fruit" ]]
do
    number=$((number + 1))
    echo "$number. $fruit"
done < "$fruit_file"
```

---

## Solution 2 — `02_text_files.sh`

```bash
#!/bin/bash

if [[ "$#" -ne 1 ]]; then
    echo "Usage: $0 DIRECTORY" >&2
    exit 2
fi

directory="$1"

if [[ ! -d "$directory" ]]; then
    echo "Error: directory not found: $directory" >&2
    exit 1
fi

found=0

for file in "$directory"/*.txt
do
    [[ -e "$file" ]] || continue
    echo "Text file: $file"
    found=$((found + 1))
done

if [[ "$found" -eq 0 ]]; then
    echo "No .txt files found in $directory"
fi
```

The glob is used directly. The script does not parse the output of `ls`.

---

## Solution 3 — `03_weather_loop.sh`

```bash
#!/bin/bash

while true
do
    read -r -p "Is it raining? Enter yes or no: " answer

    if [[ "$answer" == "yes" ]]; then
        echo "Take an umbrella"
        break
    elif [[ "$answer" == "no" ]]; then
        echo "No umbrella needed"
        break
    else
        echo "Invalid answer. Try again."
    fi
done
```

---

## Solution 4 — `04_nested_loop.sh`

```bash
#!/bin/bash

for student in Ali Omar
do
    for subject in Linux Bash
    do
        echo "$student is studying $subject"
    done
done
```

The inner loop completes for every round of the outer loop.

---

## Solution 5 — `05_server_array.sh`

```bash
#!/bin/bash

servers=("web01" "web02" "database01")

for server in "${servers[@]}"
do
    echo "Checking server: $server"
done
```

`"${servers[@]}"` preserves every array element as a separate value.

---

## Solution 6 — `06_utility_menu.sh`

```bash
#!/bin/bash

while true
do
    echo
    echo "1. Show date"
    echo "2. Show current directory"
    echo "3. Show current user"
    echo "4. Exit"

    read -r -p "Choose an option: " choice

    case "$choice" in
        1)
            date
            ;;
        2)
            pwd
            ;;
        3)
            whoami
            ;;
        4)
            echo "Goodbye"
            break
            ;;
        *)
            echo "Invalid selection"
            ;;
    esac
done
```

---

## Verification ideas

```bash
bash 01_read_fruits.sh
bash 01_read_fruits.sh missing.txt
bash 01_read_fruits.sh ../03-lab-data/fruits.txt
bash 02_text_files.sh ../03-lab-data
```

Test both valid and invalid inputs.

