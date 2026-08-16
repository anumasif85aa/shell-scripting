# Level 1 Solutions — Bash Loop Foundations

Try each task before reading its solution.

---

## Solution 1 — `01_fruit_basket.sh`

```bash
#!/bin/bash

for fruit in apple banana cherry
do
    echo "Fruit: $fruit"
done
```

---

## Solution 2 — `02_fruit_counter.sh`

```bash
#!/bin/bash

for (( number=1; number<=5; number++ ))
do
    echo "Fruit number: $number"
done
```

---

## Solution 3 — `03_fruit_arguments.sh`

```bash
#!/bin/bash

echo "Script: $0"
echo "Number of fruits: $#"

for fruit in "$@"
do
    echo "Fruit: $fruit"
done
```

Test:

```bash
bash 03_fruit_arguments.sh apple banana cherry
bash 03_fruit_arguments.sh "green apple" banana
```

`"$@"` keeps `green apple` as one argument.

---

## Solution 4 — `04_skip_banana.sh`

```bash
#!/bin/bash

for fruit in apple banana cherry mango
do
    if [[ "$fruit" == "banana" ]]; then
        continue
    fi

    echo "$fruit"
done
```

`continue` skips the remaining commands for the current round.

---

## Solution 5 — `05_stop_at_cherry.sh`

```bash
#!/bin/bash

for fruit in apple banana cherry mango
do
    if [[ "$fruit" == "cherry" ]]; then
        echo "Cherry found. Stopping the loop."
        break
    fi

    echo "Checking: $fruit"
done
```

`break` exits the loop, so `mango` is not processed.

---

## Solution 6 — `06_countdown.sh`

```bash
#!/bin/bash

for (( number=5; number>=1; number-- ))
do
    echo "$number"
done

echo "Go!"
```

---

## Verification

```bash
for script in 0*.sh
do
    echo "Checking: $script"
    bash -n "$script" || exit 1
done

echo "All Level 1 scripts passed the syntax check."
```

