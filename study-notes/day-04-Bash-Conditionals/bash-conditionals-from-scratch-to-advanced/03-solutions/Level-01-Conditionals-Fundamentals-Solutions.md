# Level 01 Solutions: Conditionals Fundamentals

Try the lab before opening these reference solutions.

## Solution 1: `01_weather.sh`

```bash
#!/bin/bash

read -r -p "Is it raining? Enter yes or no: " weather

if [[ "$weather" == "yes" ]]; then
    echo "Take an umbrella."
else
    echo "You do not need an umbrella."
fi
```

## Solution 2: `02_traffic_light.sh`

```bash
#!/bin/bash

read -r -p "Enter traffic-light color (red/yellow/green): " light

if [[ "$light" == "red" ]]; then
    echo "Stop"
elif [[ "$light" == "yellow" ]]; then
    echo "Get ready"
elif [[ "$light" == "green" ]]; then
    echo "Go"
else
    echo "Error: enter red, yellow, or green." >&2
    exit 1
fi

exit 0
```

## Solution 3: `03_age_check.sh`

```bash
#!/bin/bash

read -r -p "Enter age: " age

if [[ -z "$age" ]]; then
    echo "Error: age cannot be empty." >&2
    exit 1
elif [[ ! "$age" =~ ^[0-9]+$ ]]; then
    echo "Error: age must contain digits only." >&2
    exit 1
elif (( age >= 18 )); then
    echo "Adult"
else
    echo "Minor"
fi

exit 0
```

## Solution 4: `04_fruit_choice.sh`

```bash
#!/bin/bash

read -r -p "Choose apple, banana, or cherry: " fruit

if [[ "$fruit" == "apple" ]]; then
    echo "You selected a red fruit."
elif [[ "$fruit" == "banana" ]]; then
    echo "You selected a yellow fruit."
elif [[ "$fruit" == "cherry" ]]; then
    echo "You selected a small red fruit."
else
    echo "Fruit is not available."
fi
```

## Solution 5: `05_file_check.sh`

```bash
#!/bin/bash

file="${1:-}"

if [[ -z "$file" ]]; then
    echo "Usage: $0 FILE" >&2
    exit 1
elif [[ -f "$file" ]]; then
    echo "Regular file found."
    exit 0
else
    echo "Regular file not found." >&2
    exit 1
fi
```

## Solution 6: `06_argument_check.sh`

```bash
#!/bin/bash

if [[ "$#" -ne 2 ]]; then
    echo "Usage: $0 FRUIT1 FRUIT2" >&2
    exit 1
else
    echo "First fruit: $1"
    echo "Second fruit: $2"
    exit 0
fi
```

## Verification

```bash
bash -n 01_weather.sh
bash -n 02_traffic_light.sh
bash -n 03_age_check.sh
bash -n 04_fruit_choice.sh
bash -n 05_file_check.sh
bash -n 06_argument_check.sh
```
