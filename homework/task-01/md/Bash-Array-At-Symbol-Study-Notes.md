# Bash Array `[@]` — Study Notes

## Table of Contents

- [Introduction](#introduction)
- [Create a Bash Array](#create-a-bash-array)
- [Meaning of Every Symbol](#meaning-of-every-symbol)
- [Use It in a Loop](#use-it-in-a-loop)
- [Why Double Quotes Are Important](#why-double-quotes-are-important)
- [Access One Array Element](#access-one-array-element)
- [Count Array Elements](#count-array-elements)
- [`[@]` Versus `[*]`](#array-at-versus-array-star)
- [Pass an Array to a Function](#pass-an-array-to-a-function)
- [Common Mistakes](#common-mistakes)
- [Quick Reference](#quick-reference)
- [Key Lesson](#key-lesson)

## Introduction

In Bash:

```bash
"${fruits[@]}"
```

means:

> Expand all elements of the `fruits` array while keeping every element separate and unchanged.

The `[@]` part is used with an array name to select all its elements.

## Create a Bash Array

```bash
fruits=("apple" "banana" "red cherry")
```

This array contains three elements:

| Index | Element |
|---:|---|
| `0` | `apple` |
| `1` | `banana` |
| `2` | `red cherry` |

Bash arrays normally begin at index `0`.

## Meaning of Every Symbol

Consider:

```bash
"${fruits[@]}"
```

| Part | Meaning |
|---|---|
| `$` | Request a value from Bash |
| `{ }` | Clearly mark the parameter-expansion expression |
| `fruits` | Name of the array |
| `[@]` | Select all array elements |
| `" "` | Preserve each element safely |

You can read it as:

> Dollar, opening brace, fruits array at, closing brace—in double quotes.

The most important practical meaning is:

```text
Use every array element as a separate value.
```

## Use It in a Loop

```bash
#!/bin/bash

fruits=("apple" "banana" "red cherry")

for fruit in "${fruits[@]}"
do
    echo "Fruit: $fruit"
done
```

Output:

```text
Fruit: apple
Fruit: banana
Fruit: red cherry
```

The loop runs three times because the array has three elements.

| Loop run | Value of `fruit` |
|---:|---|
| 1 | `apple` |
| 2 | `banana` |
| 3 | `red cherry` |

## Why Double Quotes Are Important

Recommended form:

```bash
for fruit in "${fruits[@]}"
```

The quotes preserve `red cherry` as one element.

Without quotes:

```bash
for fruit in ${fruits[@]}
```

Bash can perform word splitting. The two-word element may be separated:

```text
Fruit: apple
Fruit: banana
Fruit: red
Fruit: cherry
```

The loop would incorrectly process four words instead of three array elements.

Therefore, normally use:

```bash
"${fruits[@]}"
```

## Access One Array Element

Use an individual index inside the square brackets.

### First element

```bash
echo "${fruits[0]}"
```

Output:

```text
apple
```

### Second element

```bash
echo "${fruits[1]}"
```

Output:

```text
banana
```

### Third element

```bash
echo "${fruits[2]}"
```

Output:

```text
red cherry
```

### All elements

```bash
echo "${fruits[@]}"
```

Displayed output:

```text
apple banana red cherry
```

Although `echo` displays the values on one line, quoted `[@]` still expands them as separate arguments.

## Count Array Elements

```bash
echo "${#fruits[@]}"
```

Output:

```text
3
```

Meaning:

| Part | Meaning |
|---|---|
| `${fruits[@]}` | All elements |
| `#` | Count the selected elements |
| `${#fruits[@]}` | Number of elements in the array |

Example:

```bash
echo "Total fruits: ${#fruits[@]}"
```

Output:

```text
Total fruits: 3
```

## Array At Versus Array Star

These expressions behave differently when they are enclosed in double quotes.

### Quoted `[@]`

```bash
"${fruits[@]}"
```

Expands every element as a separate argument:

```text
Argument 1: apple
Argument 2: banana
Argument 3: red cherry
```

### Quoted `[*]`

```bash
"${fruits[*]}"
```

Joins all elements into one argument:

```text
Argument 1: apple banana red cherry
```

### Comparison

| Expression | Number of arguments | Normal use |
|---|---:|---|
| `"${fruits[@]}"` | One argument per array element | Loops, functions and commands |
| `"${fruits[*]}"` | One combined argument | Joining the complete array into one string |

For most array loops and function calls, use:

```bash
"${fruits[@]}"
```

## Pass an Array to a Function

```bash
#!/bin/bash

fruits=("apple" "banana" "red cherry")

show_items()
{
    echo "Argument count: $#"

    for item in "$@"
    do
        echo "Item: $item"
    done
}

show_items "${fruits[@]}"
```

Output:

```text
Argument count: 3
Item: apple
Item: banana
Item: red cherry
```

The expansion:

```bash
show_items "${fruits[@]}"
```

passes three separate arguments to the function.

Inside the function:

```bash
"$@"
```

represents all function arguments while preserving each one separately.

### What happens with `[*]`?

```bash
show_items "${fruits[*]}"
```

Output:

```text
Argument count: 1
Item: apple banana red cherry
```

All array elements were joined and passed as one argument.

## Common Mistakes

### Mistake 1: Forgetting double quotes

```bash
for fruit in ${fruits[@]}
```

This can split elements containing spaces.

Correct:

```bash
for fruit in "${fruits[@]}"
```

### Mistake 2: Using only `$fruits`

```bash
echo "$fruits"
```

This normally accesses only element `0`.

Use this for all elements:

```bash
echo "${fruits[@]}"
```

### Mistake 3: Confusing array `[@]` with positional `"$@"`

```bash
"${fruits[@]}"
```

means all elements of the named array `fruits`.

```bash
"$@"
```

means all positional arguments passed to the script or current function.

Both preserve their values as separate arguments when quoted.

## Quick Reference

```bash
fruits=("apple" "banana" "red cherry")
```

| Expression | Meaning |
|---|---|
| `${fruits[0]}` | First element |
| `${fruits[1]}` | Second element |
| `${fruits[@]}` | All elements |
| `"${fruits[@]}"` | All elements, safely preserved separately |
| `${#fruits[@]}` | Number of elements |
| `"${fruits[*]}"` | All elements joined into one argument |
| `"$@"` | All script or function arguments, preserved separately |
| `$#` | Number of script or function arguments |

## Complete Practice Script

```bash
#!/bin/bash

fruits=("apple" "banana" "red cherry")

echo "Total fruits: ${#fruits[@]}"

item_number=1

for fruit in "${fruits[@]}"
do
    echo "Item $item_number: $fruit"
    ((item_number++))
done
```

Output:

```text
Total fruits: 3
Item 1: apple
Item 2: banana
Item 3: red cherry
```

Check the script's syntax:

```bash
bash -n array-practice.sh
```

Run it:

```bash
bash array-practice.sh
```

## Key Lesson

```bash
"${array[@]}"
```

means:

> Expand every array element separately and preserve spaces and special characters within each element.

For Bash array loops and function arguments, quoted `[@]` is normally the safest and most appropriate form.
