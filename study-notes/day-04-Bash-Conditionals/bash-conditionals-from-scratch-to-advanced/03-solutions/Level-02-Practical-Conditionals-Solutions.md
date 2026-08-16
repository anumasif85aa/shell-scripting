# Level 02 Solutions: Practical Conditionals

## Solution 1: `01_grade.sh`

```bash
#!/bin/bash

score="${1:-}"

if [[ -z "$score" ]]; then
    echo "Usage: $0 SCORE" >&2
    exit 1
elif [[ ! "$score" =~ ^[0-9]+$ ]]; then
    echo "Error: score must contain digits only." >&2
    exit 1
elif (( score < 0 || score > 100 )); then
    echo "Error: score must be from 0 to 100." >&2
    exit 1
elif (( score >= 90 )); then
    echo "Grade: A"
elif (( score >= 80 )); then
    echo "Grade: B"
elif (( score >= 70 )); then
    echo "Grade: C"
elif (( score >= 60 )); then
    echo "Grade: D"
else
    echo "Grade: F"
fi
```

## Solution 2: `02_username_validator.sh`

```bash
#!/bin/bash

username="${1:-}"

if [[ -z "$username" ]]; then
    echo "Usage: $0 USERNAME" >&2
    exit 1
elif [[ "$username" =~ ^[a-z][a-z0-9_-]{2,}$ ]]; then
    echo "Valid username: $username"
    exit 0
else
    echo "Invalid username: $username" >&2
    exit 1
fi
```

## Solution 3: `03_path_inspector.sh`

```bash
#!/bin/bash

path="${1:-}"

if [[ -z "$path" ]]; then
    echo "Usage: $0 PATH" >&2
    exit 1
elif [[ ! -e "$path" ]]; then
    echo "Path is missing." >&2
    exit 1
elif [[ -d "$path" ]]; then
    echo "Path type: directory"
elif [[ -f "$path" && ! -s "$path" ]]; then
    echo "Path type: empty regular file"
elif [[ -f "$path" && -s "$path" ]]; then
    echo "Path type: non-empty regular file"
else
    echo "Path exists but is another type."
fi

if [[ -r "$path" ]]; then
    echo "Readable: yes"
else
    echo "Readable: no"
fi
```

## Solution 4: `04_log_filename.sh`

```bash
#!/bin/bash

filename="${1:-}"

if [[ -z "$filename" ]]; then
    echo "Usage: $0 FILENAME" >&2
    exit 1
elif [[ "$filename" == *.log ]]; then
    echo "Valid log filename: $filename"
    exit 0
else
    echo "Invalid log filename: $filename" >&2
    exit 1
fi
```

## Solution 5: `05_error_search.sh`

```bash
#!/bin/bash

log_file="${1:-}"

if [[ -z "$log_file" ]]; then
    echo "Usage: $0 LOG_FILE" >&2
    exit 1
elif [[ ! -f "$log_file" || ! -r "$log_file" || ! -s "$log_file" ]]; then
    echo "Error: log file must be readable and non-empty." >&2
    exit 1
elif grep -q "ERROR" "$log_file"; then
    echo "Errors were found."
    exit 0
else
    echo "No errors were found."
    exit 0
fi
```

## Solution 6: `06_access_check.sh`

```bash
#!/bin/bash

role="${1:-}"
active="${2:-}"
maintenance="${3:-}"

if [[ -z "$role" || -z "$active" || -z "$maintenance" ]]; then
    echo "Usage: $0 ROLE ACTIVE MAINTENANCE" >&2
    exit 1
elif [[ ( "$role" == "admin" || "$role" == "operator" ) &&
        "$active" == "yes" &&
        ! "$maintenance" == "yes" ]]; then
    echo "Access allowed."
    exit 0
else
    echo "Access denied." >&2
    exit 1
fi
```

## Suggested tests

```bash
bash 01_grade.sh 90
bash 01_grade.sh 59
bash 01_grade.sh 101

bash 02_username_validator.sh ali
bash 02_username_validator.sh user_01
bash 02_username_validator.sh 2ali

bash 06_access_check.sh admin yes no
bash 06_access_check.sh viewer yes no
bash 06_access_check.sh operator yes yes
```
