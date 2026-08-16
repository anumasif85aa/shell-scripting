# Level 01 Solutions: Variables Fundamentals

These are simple reference solutions. Try each task before opening this file.

## Solution 1: `01_fruits.sh`

```bash
#!/bin/bash

first_fruit="apple"
second_fruit="banana"
third_fruit="cherry"

echo "First fruit: $first_fruit"
echo "Second fruit: $second_fruit"
echo "Third fruit: $third_fruit"
echo "My fruits are $first_fruit, $second_fruit, and $third_fruit."
```

## Solution 2: `02_student_profile.sh`

```bash
#!/bin/bash

read -r -p "Enter student name: " student_name
read -r -p "Enter course name: " course_name
read -r -p "Enter city: " city

echo
echo "Student: $student_name"
echo "Course: $course_name"
echo "City: $city"
```

## Solution 3: `03_quoting.sh`

```bash
#!/bin/bash

topic="Bash Variables"

echo "$topic"
echo '$topic'
echo "${topic} Lab"
```

The second `echo` uses single quotes, so Bash prints `$topic` literally.

## Solution 4: `04_fruit_arguments.sh`

```bash
#!/bin/bash

echo "Script name: $0"
echo "First fruit: $1"
echo "Second fruit: $2"
echo "Third fruit: $3"
echo "Number of arguments: $#"
echo "All fruits: $*"
```

Run:

```bash
bash 04_fruit_arguments.sh apple banana cherry
```

## Solution 5: `05_system_report.sh`

```bash
#!/bin/bash

current_user="$(whoami)"
current_host="$(hostname)"
current_date="$(date)"
current_directory="$(pwd)"
bash_version="$BASH_VERSION"

echo "User: $current_user"
echo "Hostname: $current_host"
echo "Date: $current_date"
echo "Directory: $current_directory"
echo "Bash version: $bash_version"
```

## Solution 6: `06_fruit_calculator.sh`

```bash
#!/bin/bash

apples=5
bananas=3
total=$((apples + bananas))

echo "Apples: $apples"
echo "Bananas: $bananas"
echo "Total fruits: $total"
```

## Verification

```bash
bash -n 01_fruits.sh
bash -n 02_student_profile.sh
bash -n 03_quoting.sh
bash -n 04_fruit_arguments.sh
bash -n 05_system_report.sh
bash -n 06_fruit_calculator.sh
```
