# Bash Arrays and Lists — Complete Study Notes

## Table of Contents

1. [Introduction](#1-introduction)
2. [Create an Indexed Array](#2-create-an-indexed-array)
3. [Understand Array Indexes](#3-understand-array-indexes)
4. [Print Array Elements](#4-print-array-elements)
5. [Add New Elements](#5-add-new-elements)
6. [Replace Existing Elements](#6-replace-existing-elements)
7. [Remove Elements](#7-remove-elements)
8. [Count Elements and Inspect Indexes](#8-count-elements-and-inspect-indexes)
9. [Loop Through an Array](#9-loop-through-an-array)
10. [`[@]` vs `[*]`](#10--vs-)
11. [Values Containing Spaces](#11-values-containing-spaces)
12. [Array Slicing](#12-array-slicing)
13. [Read Input into an Array](#13-read-input-into-an-array)
14. [Copy and Combine Arrays](#14-copy-and-combine-arrays)
15. [Check Whether an Array Is Empty](#15-check-whether-an-array-is-empty)
16. [Associative Arrays](#16-associative-arrays)
17. [Complete Friends Script](#17-complete-friends-script)
18. [Common Mistakes](#18-common-mistakes)
19. [Practical Examples](#19-practical-examples)
20. [Quick Reference](#20-quick-reference)
21. [Practice Tasks](#21-practice-tasks)
22. [Final Summary](#22-final-summary)

## Script Naming Rule

Every complete runnable Bash example in these notes includes a filename in this format:

```text
Create: descriptive_name.sh
```

Short one-line examples that demonstrate only syntax are **command snippets**, not complete scripts, so they do not require separate filenames.

## Suggested Script Files

| Script name | Main concept |
|---|---|
| `array_index_demo.sh` | Create an array and access elements by index |
| `print_array_elements.sh` | Print one or all array elements |
| `append_array_elements.sh` | Append one or more elements |
| `replace_array_element.sh` | Replace an existing element |
| `remove_array_elements.sh` | Remove and reindex elements |
| `inspect_array.sh` | Count elements and display indexes |
| `loop_array_values.sh` | Loop through array values |
| `loop_array_indexes.sh` | Loop through indexes and values |
| `number_array_items.sh` | Print human-friendly item numbers |
| `array_at_vs_star.sh` | Compare `[@]` and `[*]` |
| `array_values_with_spaces.sh` | Preserve multi-word elements |
| `array_slice.sh` | Select a range of elements |
| `read_names_array.sh` | Read space-separated input into an array |
| `read_csv_array.sh` | Read comma-separated input into an array |
| `copy_combine_arrays.sh` | Copy and combine arrays |
| `check_empty_array.sh` | Test whether an array is empty |
| `associative_array.sh` | Store information with text keys |
| `friends_array.sh` | Complete friends-array demonstration |
| `package_list.sh` | Loop through package names |
| `server_list.sh` | Loop through server names |
| `show_items.sh` | Store command-line arguments in an array |
| `check_installed_packages.sh` | Check packages listed in an array |
| `array_basics_summary.sh` | Review the most important array operations |

---

## 1. Introduction

A Bash array stores multiple values under one variable name.

```bash
friends=("a" "b" "c")
```

The array named `friends` contains three elements:

```text
a
b
c
```

Other programming languages may use the word **list**, but Bash normally calls this structure an **array**.

### Why use an array?

Without an array, you might create several variables:

```bash
friend1="a"
friend2="b"
friend3="c"
```

With an array, the values remain together:

```bash
friends=("a" "b" "c")
```

This makes it easier to:

- Store related values.
- Loop through them.
- Add or remove elements.
- Access one specific element.
- Pass a collection of values to a command safely.

Bash supports two major array types:

| Type | Index style | Example |
|---|---|---|
| Indexed array | Numeric indexes such as `0`, `1`, and `2` | `friends[0]="Ali"` |
| Associative array | Text keys such as `name` or `role` | `student[name]="Ali"` |

Beginners should learn indexed arrays first.

---

## 2. Create an Indexed Array

### Basic method

```bash
friends=("a" "b" "c")
```

There must be no commas between the values.

Incorrect:

```bash
friends=("a", "b", "c")
```

Correct:

```bash
friends=("a" "b" "c")
```

### Declare the array explicitly

You can also use `declare -a`:

```bash
declare -a friends=("a" "b" "c")
```

The `-a` option declares an indexed array.

### Assign values by index

```bash
friends[0]="a"
friends[1]="b"
friends[2]="c"
```

### Create an empty array

```bash
friends=()
```

Or:

```bash
declare -a friends=()
```

---

## 3. Understand Array Indexes

Bash indexed arrays normally begin at index `0`.

**Create: `array_index_demo.sh`**

```bash
#!/bin/bash

friends=("a" "b" "c")

echo "Index 0: ${friends[0]}"
echo "Index 1: ${friends[1]}"
echo "Index 2: ${friends[2]}"

exit 0
```

| Index | Value |
|---:|---|
| `0` | `a` |
| `1` | `b` |
| `2` | `c` |

Access one element with:

```bash
echo "${friends[0]}"
echo "${friends[1]}"
echo "${friends[2]}"
```

Output:

```text
a
b
c
```

This command:

```bash
echo "Happy Birthday: ${friends[2]}"
```

prints:

```text
Happy Birthday: c
```

Remember:

```text
First element  = index 0
Second element = index 1
Third element  = index 2
```

### Arrays can have missing indexes

Bash indexed arrays can be sparse:

```bash
friends[0]="a"
friends[5]="f"
```

Only indexes `0` and `5` exist. Indexes `1` through `4` do not need to contain values.

---

## 4. Print Array Elements

**Create: `print_array_elements.sh`**

```bash
#!/bin/bash

friends=("a" "b" "c")

echo "First friend: ${friends[0]}"
echo "All friends: ${friends[@]}"

printf 'One per line: %s\n' "${friends[@]}"

exit 0
```

### Print the first element

```bash
echo "$friends"
```

For an indexed array, this normally behaves like:

```bash
echo "${friends[0]}"
```

Output:

```text
a
```

### Print one selected element

```bash
echo "${friends[1]}"
```

Output:

```text
b
```

### Print every element

```bash
echo "${friends[@]}"
```

Output:

```text
a b c
```

### Print every element reliably with `printf`

```bash
printf '%s\n' "${friends[@]}"
```

Output:

```text
a
b
c
```

`printf` is often better when you want predictable formatting.

---

## 5. Add New Elements

**Create: `append_array_elements.sh`**

```bash
#!/bin/bash

friends=("a" "b" "c")

friends+=("d")
friends+=("e" "f")

echo "Updated friends: ${friends[@]}"

exit 0
```

### Append one element

```bash
friends+=("d")
```

The array becomes:

```text
a b c d
```

### Append multiple elements

```bash
friends+=("d" "e")
```

The array becomes:

```text
a b c d e
```

### Why `.append()` failed

This is Python-style syntax:

```bash
friends.append("d")
```

Bash does not support an `.append()` method. Bash tries to parse that text as shell syntax and reports an error such as:

```text
syntax error near unexpected token `"d"'
```

Use Bash array syntax:

```bash
friends+=("d")
```

Memory rule:

```text
Python: list.append("d")
Bash:   array+=("d")
```

### Add a value at a specific index

```bash
friends[5]="f"
```

This assigns `f` to index `5`. It does not necessarily fill missing indexes before it.

---

## 6. Replace Existing Elements

Use the element's index:

**Create: `replace_array_element.sh`**

```bash
#!/bin/bash

friends=("a" "b" "c")
friends[2]="d"

echo "Updated friends: ${friends[@]}"

exit 0
```

The value at index `2` changes from `c` to `d`.

```bash
echo "${friends[@]}"
```

Output:

```text
a b d
```

### Replace vs append

| Requirement | Syntax | Result from `a b c` |
|---|---|---|
| Replace index `2` | `friends[2]="d"` | `a b d` |
| Append a new element | `friends+=("d")` | `a b c d` |

---

## 7. Remove Elements

**Create: `remove_array_elements.sh`**

```bash
#!/bin/bash

friends=("a" "b" "c")

unset 'friends[1]'

echo "Remaining indexes: ${!friends[@]}"
echo "Remaining values: ${friends[@]}"

# Rebuild consecutive indexes.
friends=("${friends[@]}")

echo "Rebuilt indexes: ${!friends[@]}"

exit 0
```

### Remove one element

```bash
unset 'friends[1]'
```

If the array was:

```text
index 0 = a
index 1 = b
index 2 = c
```

then index `1` is removed, but index `2` remains index `2`.

Existing indexes:

```text
0 2
```

Important: Bash does not automatically renumber the remaining indexes.

### Remove the entire array

```bash
unset friends
```

### Reset to an empty array

```bash
friends=()
```

This keeps the variable as an array but removes its elements.

### Rebuild consecutive indexes

After deleting elements, you can rebuild the array:

```bash
friends=("${friends[@]}")
```

The remaining elements receive consecutive indexes beginning at `0`.

---

## 8. Count Elements and Inspect Indexes

**Create: `inspect_array.sh`**

```bash
#!/bin/bash

friends=("Ali" "Omar" "Red Cherry")

echo "Element count: ${#friends[@]}"
echo "Indexes: ${!friends[@]}"
echo "Length of index 2: ${#friends[2]}"

exit 0
```

### Count the elements

```bash
friends=("a" "b" "c")
echo "${#friends[@]}"
```

Output:

```text
3
```

### Print all existing indexes

```bash
echo "${!friends[@]}"
```

Output:

```text
0 1 2
```

### Print one element's string length

```bash
friends=("Ali" "Omar" "Red Cherry")
echo "${#friends[2]}"
```

Output:

```text
10
```

The space is included in the string length.

### Count vs indexes

| Expression | Meaning |
|---|---|
| `${#friends[@]}` | Number of existing elements |
| `${!friends[@]}` | Existing array indexes |
| `${#friends[2]}` | Length of the value at index `2` |

---

## 9. Loop Through an Array

### Loop through values

**Create: `loop_array_values.sh`**

```bash
#!/bin/bash

friends=("a" "b" "c")

for friend in "${friends[@]}"
do
    echo "Friend: $friend"
done

exit 0
```

Output:

```text
Friend: a
Friend: b
Friend: c
```

Use the singular variable name `friend` for the current element and the plural name `friends` for the complete array.

### Loop through indexes and values

**Create: `loop_array_indexes.sh`**

```bash
#!/bin/bash

friends=("a" "b" "c")

for index in "${!friends[@]}"
do
    echo "Index $index: ${friends[index]}"
done

exit 0
```

Output:

```text
Index 0: a
Index 1: b
Index 2: c
```

### Print human-friendly item numbers

Array indexes begin at `0`, but a display can begin at `1`:

**Create: `number_array_items.sh`**

```bash
#!/bin/bash

friends=("a" "b" "c")

for index in "${!friends[@]}"
do
    echo "Friend $((index + 1)): ${friends[index]}"
done

exit 0
```

Output:

```text
Friend 1: a
Friend 2: b
Friend 3: c
```

### Use a separate counter

```bash
item_number=1

for friend in "${friends[@]}"
do
    echo "Friend $item_number: $friend"
    item_number=$((item_number + 1))
done
```

---

## 10. `[@]` vs `[*]`

These expansions behave differently when quoted.

**Create: `array_at_vs_star.sh`**

```bash
#!/bin/bash

friends=("Ali" "Omar" "Red Cherry")

printf 'Using @: <%s>\n' "${friends[@]}"
printf 'Using *: <%s>\n' "${friends[*]}"

exit 0
```

### Quoted `[@]`

```bash
"${friends[@]}"
```

Each array element remains a separate argument:

```text
Argument 1 = Ali
Argument 2 = Omar
Argument 3 = Red Cherry
```

This is normally the safest form for loops and commands.

### Quoted `[*]`

```bash
"${friends[*]}"
```

All elements become one string, joined by the first character of `IFS`—normally a space:

```text
Ali Omar Red Cherry
```

### Comparison

| Expansion | Quoted behavior | Recommended use |
|---|---|---|
| `"${array[@]}"` | Preserves each element as a separate argument | Loops and passing values to commands |
| `"${array[*]}"` | Joins all elements into one argument | When one combined string is required |

Recommended beginner rule:

```bash
for item in "${array[@]}"
```

---

## 11. Values Containing Spaces

Create an array containing a multi-word value:

**Create: `array_values_with_spaces.sh`**

```bash
#!/bin/bash

fruits=("apple" "banana" "red cherry")

for fruit in "${fruits[@]}"
do
    echo "Fruit: $fruit"
done

exit 0
```

The quotes ensure `red cherry` is stored as one element.

Correct loop:

```bash
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

Less safe:

```bash
for fruit in ${fruits[@]}
```

The unquoted expansion can split `red cherry` into two words.

Golden rule:

```text
Quote array values when creating the array.
Use "${array[@]}" when expanding all elements.
```

---

## 12. Array Slicing

Array slicing selects a range of elements.

Syntax:

```bash
"${array[@]:start:length}"
```

Example:

**Create: `array_slice.sh`**

```bash
#!/bin/bash

friends=("a" "b" "c" "d" "e")
printf '%s\n' "${friends[@]:1:3}"

exit 0
```

Output:

```text
b
c
d
```

Explanation:

| Part | Meaning |
|---|---|
| `1` | Start at index `1` |
| `3` | Return three elements |

From a positional-parameter context, slicing rules can differ slightly, so beginners should first practice slicing named arrays.

---

## 13. Read Input into an Array

### Read space-separated words

**Create: `read_names_array.sh`**

```bash
#!/bin/bash

read -r -a friends -p "Enter names separated by spaces: "

printf 'Friend: %s\n' "${friends[@]}"

exit 0
```

If the user enters:

```text
Ali Omar Sara
```

then:

```bash
echo "${friends[@]}"
```

prints:

```text
Ali Omar Sara
```

Options:

| Option | Meaning |
|---|---|
| `-r` | Do not treat backslashes as escape characters |
| `-a friends` | Store the words in the `friends` array |
| `-p "..."` | Display a prompt |

### Read comma-separated values

**Create: `read_csv_array.sh`**

```bash
#!/bin/bash

IFS=',' read -r -a fruits -p "Enter fruits separated by commas: "

printf 'Fruit: %s\n' "${fruits[@]}"

exit 0
```

Input:

```text
apple,banana,mango
```

Then:

```bash
printf '%s\n' "${fruits[@]}"
```

prints each fruit on a separate line.

---

## 14. Copy and Combine Arrays

**Create: `copy_combine_arrays.sh`**

```bash
#!/bin/bash

group_one=("Ali" "Omar")
group_two=("Sara" "Red Cherry")

group_one_copy=("${group_one[@]}")
everyone=("${group_one_copy[@]}" "${group_two[@]}")

printf 'Person: %s\n' "${everyone[@]}"

exit 0
```

### Copy an array

```bash
friends=("a" "b" "c")
friends_copy=("${friends[@]}")
```

Always use the quoted `[@]` expansion so values containing spaces remain intact.

### Combine two arrays

```bash
group_one=("Ali" "Omar")
group_two=("Sara" "Red Cherry")

everyone=("${group_one[@]}" "${group_two[@]}")
```

Print the result:

```bash
printf '%s\n' "${everyone[@]}"
```

Output:

```text
Ali
Omar
Sara
Red Cherry
```

---

## 15. Check Whether an Array Is Empty

**Create: `check_empty_array.sh`**

```bash
#!/bin/bash

friends=()

if (( ${#friends[@]} == 0 )); then
    echo "The friends array is empty."
else
    echo "The friends array contains elements."
fi

exit 0
```

Output:

```text
The friends array is empty.
```

For a non-empty array:

```bash
friends=("a" "b" "c")
```

the condition is false because the array contains three elements.

---

## 16. Associative Arrays

An associative array uses text keys instead of numeric indexes.

It must be declared with `declare -A`:

**Create: `associative_array.sh`**

```bash
#!/bin/bash

declare -A student

student[name]="Ali"
student[course]="Bash Scripting"
student[status]="Active"

for key in "${!student[@]}"
do
    echo "$key: ${student[$key]}"
done

exit 0
```

Access a value by key:

```bash
echo "Name: ${student[name]}"
echo "Course: ${student[course]}"
echo "Status: ${student[status]}"
```

Output:

```text
Name: Ali
Course: Bash Scripting
Status: Active
```

Loop through keys:

```bash
for key in "${!student[@]}"
do
    echo "$key: ${student[$key]}"
done
```

The display order of associative-array keys should not be assumed unless you sort them explicitly.

### Indexed vs associative arrays

| Feature | Indexed array | Associative array |
|---|---|---|
| Declaration | `declare -a names` | `declare -A student` |
| Index type | Number | Text key |
| Example access | `${names[0]}` | `${student[name]}` |
| Best use | Ordered collections | Key-value information |

---

## 17. Complete Friends Script

**Create: `friends_array.sh`**

```bash
#!/bin/bash

# Title: Friends Array Demonstration
# Purpose: Create, display, update, and loop through a Bash array.

friends=("a" "b" "c")

echo "Original list: ${friends[@]}"
echo "Happy Birthday: ${friends[2]}"

# Append a new element.
friends+=("d")

echo "Updated list: ${friends[@]}"
echo "Total friends: ${#friends[@]}"

echo
echo "Friends with item numbers:"

for index in "${!friends[@]}"
do
    echo "Friend $((index + 1)): ${friends[index]}"
done

exit 0
```

Expected output:

```text
Original list: a b c
Happy Birthday: c
Updated list: a b c d
Total friends: 4

Friends with item numbers:
Friend 1: a
Friend 2: b
Friend 3: c
Friend 4: d
```

Check the syntax:

```bash
bash -n friends_array.sh
```

Run the script:

```bash
bash friends_array.sh
```

---

## 18. Common Mistakes

### Mistake 1: Using commas

Incorrect:

```bash
friends=("a", "b", "c")
```

Correct:

```bash
friends=("a" "b" "c")
```

### Mistake 2: Using Python `.append()` syntax

Incorrect:

```bash
friends.append("d")
```

Correct:

```bash
friends+=("d")
```

### Mistake 3: Printing only the first element

```bash
echo "$friends"
```

This normally prints only index `0`.

Print all elements:

```bash
echo "${friends[@]}"
```

### Mistake 4: Putting braces in the wrong place

Incorrect:

```bash
echo "$friends[@]"
```

Possible output:

```text
a[@]
```

Correct:

```bash
echo "${friends[@]}"
```

The complete array expression must be placed inside `${...}`.

### Mistake 5: Forgetting that indexes start at zero

For:

```bash
friends=("a" "b" "c")
```

the third value is:

```bash
${friends[2]}
```

not:

```bash
${friends[3]}
```

### Mistake 6: Expanding the array without quotes

Less safe:

```bash
for friend in ${friends[@]}
```

Preferred:

```bash
for friend in "${friends[@]}"
```

### Mistake 7: Expecting indexes to renumber after `unset`

```bash
unset 'friends[1]'
```

This removes index `1`; it does not automatically move index `2` to index `1`.

### Mistake 8: Confusing element count with the highest index

An array can contain elements at indexes `0` and `5` only.

```bash
friends[0]="a"
friends[5]="f"
```

The element count is `2`, even though the highest index is `5`.

---

## 19. Practical Examples

### Example 1: Package list

**Create: `package_list.sh`**

```bash
#!/bin/bash

packages=("nginx" "curl" "wget")

for package in "${packages[@]}"
do
    echo "Package: $package"
done

exit 0
```

### Example 2: Server list

**Create: `server_list.sh`**

```bash
#!/bin/bash

servers=("web01" "web02" "db01")

for server in "${servers[@]}"
do
    echo "Checking server: $server"
done

exit 0
```

### Example 3: Validate command-line arguments as an array

Bash stores script arguments in the special positional-parameter collection `"$@"`.

**Create: `show_items.sh`**

```bash
#!/bin/bash

if (( $# == 0 )); then
    echo "Usage: $0 ITEM..." >&2
    exit 1
fi

items=("$@")

for item in "${items[@]}"
do
    echo "Item: $item"
done

exit 0
```

Run:

```bash
bash items.sh apple banana "red cherry"
```

Output:

```text
Item: apple
Item: banana
Item: red cherry
```

### Example 4: Print only installed package names

**Create: `check_installed_packages.sh`**

```bash
#!/bin/bash

packages=("nginx" "curl" "wget")

for package in "${packages[@]}"
do
    if dpkg -s "$package" >/dev/null 2>&1; then
        echo "[INSTALLED] $package"
    else
        echo "[MISSING] $package"
    fi
done

exit 0
```

This example is intended for Debian- or Ubuntu-based systems that provide `dpkg`.

---

## 20. Quick Reference

| Task | Syntax | Example |
|---|---|---|
| Create indexed array | `array=(values)` | `friends=("a" "b" "c")` |
| Declare indexed array | `declare -a array` | `declare -a friends` |
| Create empty array | `array=()` | `friends=()` |
| First element | `${array[0]}` | `${friends[0]}` |
| Selected element | `${array[index]}` | `${friends[2]}` |
| All elements | `"${array[@]}"` | `echo "${friends[@]}"` |
| All indexes | `"${!array[@]}"` | `echo "${!friends[@]}"` |
| Element count | `${#array[@]}` | `echo "${#friends[@]}"` |
| Element string length | `${#array[index]}` | `echo "${#friends[2]}"` |
| Append one value | `array+=("value")` | `friends+=("d")` |
| Append several values | `array+=("x" "y")` | `friends+=("d" "e")` |
| Replace an element | `array[index]="value"` | `friends[2]="d"` |
| Remove one element | `unset 'array[index]'` | `unset 'friends[1]'` |
| Remove entire array | `unset array` | `unset friends` |
| Copy an array | `copy=("${array[@]}")` | `copy=("${friends[@]}")` |
| Slice an array | `"${array[@]:start:length}"` | `"${friends[@]:1:2}"` |
| Loop through values | `for item in "${array[@]}"` | `for friend in "${friends[@]}"` |
| Loop through indexes | `for i in "${!array[@]}"` | `for i in "${!friends[@]}"` |
| Read words into array | `read -r -a array` | `read -r -a friends` |
| Declare associative array | `declare -A array` | `declare -A student` |

---

## 21. Practice Tasks

### Task 1: Print all fruits

Create this array:

```bash
fruits=("apple" "banana" "mango" "orange" "red cherry")
```

Print each fruit on a separate line.

### Task 2: Append a fruit

Add `grapes` to the end of the array and print the updated array.

### Task 3: Replace a fruit

Replace `mango` with `peach` by using its index.

### Task 4: Count the fruits

Print:

```text
Total fruits: 5
```

Use `${#fruits[@]}` rather than typing the number manually.

### Task 5: Number the items

Produce output like:

```text
Item 1: apple
Item 2: banana
Item 3: mango
Item 4: orange
Item 5: red cherry
```

### Task 6: Accept command-line values

Create `show_items.sh` that copies `"$@"` into an array and prints every item separately.

Test it with:

```bash
bash show_items.sh apple banana "red cherry"
```

---

## 22. Final Summary

The most important indexed-array pattern is:

**Create: `array_basics_summary.sh`**

```bash
#!/bin/bash

friends=("a" "b" "c")
friends+=("d")

echo "All friends: ${friends[@]}"
echo "Total: ${#friends[@]}"

for friend in "${friends[@]}"
do
    echo "Friend: $friend"
done

exit 0
```

Golden rules:

```text
1. Bash calls the structure an array.
2. Array indexes normally begin at 0.
3. Use ${array[index]} for one element.
4. Use "${array[@]}" for all elements.
5. Use array+=("value") to append.
6. Use array[index]="value" to replace.
7. Quote expansions to preserve values containing spaces.
8. Use ${#array[@]} to count existing elements.
9. Use ${!array[@]} to obtain existing indexes.
10. Bash does not support Python's list.append() syntax.
```
