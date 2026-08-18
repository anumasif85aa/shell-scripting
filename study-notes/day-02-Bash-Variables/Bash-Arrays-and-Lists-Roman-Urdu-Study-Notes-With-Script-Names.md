# Bash Arrays aur Lists — Mukammal Roman Urdu Study Notes

## Table of Contents

1. [Introduction](#1-introduction)
2. [Indexed Array Banana](#2-indexed-array-banana)
3. [Array Indexes Samajhna](#3-array-indexes-samajhna)
4. [Array Elements Print Karna](#4-array-elements-print-karna)
5. [Naye Elements Add Karna](#5-naye-elements-add-karna)
6. [Existing Element Replace Karna](#6-existing-element-replace-karna)
7. [Elements Remove Karna](#7-elements-remove-karna)
8. [Elements Count aur Indexes Dekhna](#8-elements-count-aur-indexes-dekhna)
9. [Array par Loop Chalana](#9-array-par-loop-chalana)
10. [`[@]` aur `[*]` ka Farq](#10--aur--ka-farq)
11. [Spaces Wali Values](#11-spaces-wali-values)
12. [Array Slicing](#12-array-slicing)
13. [User Input ko Array Mein Read Karna](#13-user-input-ko-array-mein-read-karna)
14. [Arrays Copy aur Combine Karna](#14-arrays-copy-aur-combine-karna)
15. [Empty Array Check Karna](#15-empty-array-check-karna)
16. [Associative Arrays](#16-associative-arrays)
17. [Complete Friends Script](#17-complete-friends-script)
18. [Common Mistakes](#18-common-mistakes)
19. [Practical Examples](#19-practical-examples)
20. [Quick Reference](#20-quick-reference)
21. [Practice Tasks](#21-practice-tasks)
22. [Final Summary](#22-final-summary)

## Script Naming Rule

In notes mein har complete aur runnable Bash script se pehle filename is format mein diya gaya hai:

```text
Create: descriptive_name.sh
```

Chhoti one-line examples sirf **syntax snippets** hain. Un ke liye separate script banana zaroori nahi.

## Suggested Script Files

| Script name | Kis concept ke liye hai? |
|---|---|
| `array_index_demo.sh` | Array banana aur index se values lena |
| `print_array_elements.sh` | Aik ya tamam elements print karna |
| `append_array_elements.sh` | Naye elements end par add karna |
| `replace_array_element.sh` | Existing element replace karna |
| `remove_array_elements.sh` | Element remove aur indexes rebuild karna |
| `inspect_array.sh` | Count, indexes aur string length dekhna |
| `loop_array_values.sh` | Array values par loop chalana |
| `loop_array_indexes.sh` | Indexes aur values par loop chalana |
| `number_array_items.sh` | Human-friendly item numbers print karna |
| `array_at_vs_star.sh` | `[@]` aur `[*]` compare karna |
| `array_values_with_spaces.sh` | Multi-word values ko safe rakhna |
| `array_slice.sh` | Array ka selected hissa lena |
| `read_names_array.sh` | Space-separated input read karna |
| `read_csv_array.sh` | Comma-separated input read karna |
| `copy_combine_arrays.sh` | Arrays copy aur combine karna |
| `check_empty_array.sh` | Array empty hai ya nahi check karna |
| `associative_array.sh` | Text keys ke sath data store karna |
| `friends_array.sh` | Complete friends-array demonstration |
| `package_list.sh` | Packages ki list par loop chalana |
| `server_list.sh` | Servers ki list par loop chalana |
| `show_items.sh` | Command-line arguments ko array banana |
| `check_installed_packages.sh` | Array se installed packages check karna |
| `array_basics_summary.sh` | Important array operations ka review |

---

## 1. Introduction

Bash array aik hi variable name ke andar multiple values store karti hai.

```bash
friends=("a" "b" "c")
```

`friends` array mein teen elements hain:

```text
a
b
c
```

Doosri programming languages mein is tarah ki collection ko **list** kaha ja sakta hai, lekin Bash mein aam tor par isay **array** kehte hain.

### Array kyun use karte hain?

Array ke baghair:

```bash
friend1="a"
friend2="b"
friend3="c"
```

Array ke sath:

```bash
friends=("a" "b" "c")
```

Array se aap:

- Related values aik jagah store kar saktay hain.
- Sab values par loop chala saktay hain.
- Nayi value add ya existing value remove kar saktay hain.
- Kisi specific element ko index se access kar saktay hain.
- Multiple values command ko safely pass kar saktay hain.

Bash mein do major array types hain:

| Type | Index style | Example |
|---|---|---|
| Indexed array | Numeric indexes: `0`, `1`, `2` | `friends[0]="Ali"` |
| Associative array | Text keys: `name`, `role` | `student[name]="Ali"` |

Beginner ke liye pehle indexed arrays samajhna behtar hai.

---

## 2. Indexed Array Banana

Basic syntax:

```bash
friends=("a" "b" "c")
```

Values ke darmiyan commas nahi lagtay.

Ghalat:

```bash
friends=("a", "b", "c")
```

Sahi:

```bash
friends=("a" "b" "c")
```

Array ko explicitly declare karne ke liye:

```bash
declare -a friends=("a" "b" "c")
```

`-a` indexed array declare karta hai.

Values index ke zariye bhi assign ki ja sakti hain:

```bash
friends[0]="a"
friends[1]="b"
friends[2]="c"
```

Empty array:

```bash
friends=()
```

---

## 3. Array Indexes Samajhna

Bash indexed array aam tor par index `0` se start hoti hai.

```bash
friends=("a" "b" "c")
```

| Index | Value |
|---:|---|
| `0` | `a` |
| `1` | `b` |
| `2` | `c` |

**Create: `array_index_demo.sh`**

```bash
#!/bin/bash

# Title: Array Index Demonstration
# Purpose: Create an array and access values through indexes.

friends=("a" "b" "c")

echo "Index 0: ${friends[0]}"
echo "Index 1: ${friends[1]}"
echo "Index 2: ${friends[2]}"

exit 0
```

Output:

```text
Index 0: a
Index 1: b
Index 2: c
```

Memory rule:

```text
Pehla element  = index 0
Doosra element = index 1
Teesra element = index 2
```

### Sparse array

Bash array ke indexes ke darmiyan gaps ho saktay hain:

```bash
friends[0]="a"
friends[5]="f"
```

Is example mein sirf indexes `0` aur `5` exist karte hain. Indexes `1` se `4` tak values hona zaroori nahi.

---

## 4. Array Elements Print Karna

**Create: `print_array_elements.sh`**

```bash
#!/bin/bash

# Title: Print Array Elements
# Purpose: Print the first element and all array elements.

friends=("a" "b" "c")

echo "First friend: ${friends[0]}"
echo "All friends: ${friends[@]}"

printf 'One per line: %s\n' "${friends[@]}"

exit 0
```

Output:

```text
First friend: a
All friends: a b c
One per line: a
One per line: b
One per line: c
```

Important expansions:

| Syntax | Matlab |
|---|---|
| `$friends` | Aam tor par pehla element |
| `${friends[0]}` | Index `0` ki value |
| `${friends[2]}` | Index `2` ki value |
| `${friends[@]}` | Tamam elements |

Tamam elements ko separate lines par reliably print karne ke liye:

```bash
printf '%s\n' "${friends[@]}"
```

---

## 5. Naye Elements Add Karna

**Create: `append_array_elements.sh`**

```bash
#!/bin/bash

# Title: Append Array Elements
# Purpose: Add one or more values to the end of an array.

friends=("a" "b" "c")

friends+=("d")
friends+=("e" "f")

echo "Updated friends: ${friends[@]}"

exit 0
```

Output:

```text
Updated friends: a b c d e f
```

Aik element append karna:

```bash
friends+=("d")
```

Multiple elements append karna:

```bash
friends+=("d" "e")
```

Yeh Python syntax Bash mein kaam nahi karti:

```bash
friends.append("d")
```

Bash mein sahi syntax:

```bash
friends+=("d")
```

Memory rule:

```text
Python: list.append("d")
Bash:   array+=("d")
```

---

## 6. Existing Element Replace Karna

**Create: `replace_array_element.sh`**

```bash
#!/bin/bash

# Title: Replace an Array Element
# Purpose: Replace the value stored at a selected index.

friends=("a" "b" "c")
friends[2]="d"

echo "Updated friends: ${friends[@]}"

exit 0
```

Output:

```text
Updated friends: a b d
```

Replace aur append mein farq:

| Requirement | Syntax | `a b c` se result |
|---|---|---|
| Index `2` replace karein | `friends[2]="d"` | `a b d` |
| Naya element append karein | `friends+=("d")` | `a b c d` |

---

## 7. Elements Remove Karna

**Create: `remove_array_elements.sh`**

```bash
#!/bin/bash

# Title: Remove Array Elements
# Purpose: Remove an element and rebuild consecutive indexes.

friends=("a" "b" "c")

unset 'friends[1]'

echo "Remaining indexes: ${!friends[@]}"
echo "Remaining values: ${friends[@]}"

# Rebuild consecutive indexes.
friends=("${friends[@]}")

echo "Rebuilt indexes: ${!friends[@]}"

exit 0
```

Output:

```text
Remaining indexes: 0 2
Remaining values: a c
Rebuilt indexes: 0 1
```

Aik element remove karna:

```bash
unset 'friends[1]'
```

Poori array remove karna:

```bash
unset friends
```

Array ko empty reset karna:

```bash
friends=()
```

Important: `unset 'friends[1]'` ke baad Bash baqi indexes ko automatically renumber nahi karti.

---

## 8. Elements Count aur Indexes Dekhna

**Create: `inspect_array.sh`**

```bash
#!/bin/bash

# Title: Inspect an Array
# Purpose: Display element count, indexes, and string length.

friends=("Ali" "Omar" "Red Cherry")

echo "Element count: ${#friends[@]}"
echo "Indexes: ${!friends[@]}"
echo "Length of index 2: ${#friends[2]}"

exit 0
```

Output:

```text
Element count: 3
Indexes: 0 1 2
Length of index 2: 10
```

| Expression | Matlab |
|---|---|
| `${#friends[@]}` | Existing elements ki total tadaad |
| `${!friends[@]}` | Tamam existing indexes |
| `${#friends[2]}` | Index `2` ki string length |

`Red Cherry` ki length `10` hai kyunke space bhi character count hota hai.

---

## 9. Array par Loop Chalana

### Values par loop

**Create: `loop_array_values.sh`**

```bash
#!/bin/bash

# Title: Loop Through Array Values
# Purpose: Process every value stored in an array.

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

`friends` poori array ka naam hai. `friend` har iteration mein current element ko hold karta hai.

### Indexes aur values par loop

**Create: `loop_array_indexes.sh`**

```bash
#!/bin/bash

# Title: Loop Through Array Indexes
# Purpose: Display each existing index and its value.

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

### Item numbering `1` se start karna

**Create: `number_array_items.sh`**

```bash
#!/bin/bash

# Title: Number Array Items
# Purpose: Display array values with human-friendly numbering.

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

Array index `0` se start hota hai, is liye display number ke liye `index + 1` use hua.

---

## 10. `[@]` aur `[*]` ka Farq

Quoted form mein `[@]` aur `[*]` ka behavior mukhtalif hota hai.

**Create: `array_at_vs_star.sh`**

```bash
#!/bin/bash

# Title: Array At vs Star
# Purpose: Compare quoted [@] and [*] expansions.

friends=("Ali" "Omar" "Red Cherry")

printf 'Using @: <%s>\n' "${friends[@]}"
printf 'Using *: <%s>\n' "${friends[*]}"

exit 0
```

Output:

```text
Using @: <Ali>
Using @: <Omar>
Using @: <Red Cherry>
Using *: <Ali Omar Red Cherry>
```

### `"${array[@]}"`

Har element separate argument rehta hai:

```text
Argument 1 = Ali
Argument 2 = Omar
Argument 3 = Red Cherry
```

### `"${array[*]}"`

Tamam elements aik combined string ban jatay hain. Default tor par space unhein join karta hai.

| Expansion | Quoted behavior | Behtar use |
|---|---|---|
| `"${array[@]}"` | Har element separate argument | Loops aur commands ko values pass karna |
| `"${array[*]}"` | Tamam elements aik argument | Aik combined string banana |

Beginner rule:

```bash
for item in "${array[@]}"
```

---

## 11. Spaces Wali Values

Multi-word value ko quotes mein rakhein:

**Create: `array_values_with_spaces.sh`**

```bash
#!/bin/bash

# Title: Array Values with Spaces
# Purpose: Preserve and print multi-word array elements safely.

fruits=("apple" "banana" "red cherry")

for fruit in "${fruits[@]}"
do
    echo "Fruit: $fruit"
done

exit 0
```

Output:

```text
Fruit: apple
Fruit: banana
Fruit: red cherry
```

Quotes ki wajah se `red cherry` aik hi element rehta hai.

Kam safe form:

```bash
for fruit in ${fruits[@]}
```

Unquoted expansion `red cherry` ko do words mein split kar sakti hai.

Golden rule:

```text
Array banatay waqt multi-word values quote karein.
Tamam elements expand karte waqt "${array[@]}" use karein.
```

---

## 12. Array Slicing

Array slicing se array ka selected hissa milta hai.

Syntax:

```bash
"${array[@]:start:length}"
```

**Create: `array_slice.sh`**

```bash
#!/bin/bash

# Title: Array Slice
# Purpose: Select a range of values from an array.

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

| Part | Matlab |
|---|---|
| `1` | Index `1` se start karein |
| `3` | Teen elements return karein |

---

## 13. User Input ko Array Mein Read Karna

### Space-separated input

**Create: `read_names_array.sh`**

```bash
#!/bin/bash

# Title: Read Names into an Array
# Purpose: Read space-separated names from the user.

read -r -a friends -p "Enter names separated by spaces: "

printf 'Friend: %s\n' "${friends[@]}"

exit 0
```

Input:

```text
Ali Omar Sara
```

Output:

```text
Friend: Ali
Friend: Omar
Friend: Sara
```

| Option | Matlab |
|---|---|
| `-r` | Backslash ko escape character na samjhein |
| `-a friends` | Words ko `friends` array mein store karein |
| `-p "..."` | Prompt display karein |

### Comma-separated input

**Create: `read_csv_array.sh`**

```bash
#!/bin/bash

# Title: Read Comma-Separated Values
# Purpose: Split comma-separated input into an array.

IFS=',' read -r -a fruits -p "Enter fruits separated by commas: "

printf 'Fruit: %s\n' "${fruits[@]}"

exit 0
```

Input:

```text
apple,banana,mango
```

`IFS=','` comma ko field separator banata hai.

---

## 14. Arrays Copy aur Combine Karna

**Create: `copy_combine_arrays.sh`**

```bash
#!/bin/bash

# Title: Copy and Combine Arrays
# Purpose: Copy one array and combine two arrays safely.

group_one=("Ali" "Omar")
group_two=("Sara" "Red Cherry")

group_one_copy=("${group_one[@]}")
everyone=("${group_one_copy[@]}" "${group_two[@]}")

printf 'Person: %s\n' "${everyone[@]}"

exit 0
```

Output:

```text
Person: Ali
Person: Omar
Person: Sara
Person: Red Cherry
```

Array copy karne ka safe pattern:

```bash
copy=("${original[@]}")
```

Quoted `[@]` multi-word elements ko intact rakhta hai.

---

## 15. Empty Array Check Karna

**Create: `check_empty_array.sh`**

```bash
#!/bin/bash

# Title: Check Empty Array
# Purpose: Report whether an array contains any elements.

friends=()

if (( ${#friends[@]} == 0 )); then
    echo "The friends array is empty."
else
    echo "The friends array contains elements."
fi

exit 0
```

`${#friends[@]}` array ke existing elements count karta hai. Agar count `0` ho, to array empty hai.

---

## 16. Associative Arrays

Associative array numeric index ki bajaye text key use karti hai.

**Create: `associative_array.sh`**

```bash
#!/bin/bash

# Title: Associative Array Demonstration
# Purpose: Store and display values using text keys.

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

`declare -A` associative array declare karta hai.

| Feature | Indexed array | Associative array |
|---|---|---|
| Declaration | `declare -a names` | `declare -A student` |
| Index type | Number | Text key |
| Example | `${names[0]}` | `${student[name]}` |
| Best use | Ordered collection | Key-value information |

Associative-array keys ka display order fixed assume nahi karna chahiye. Agar order zaroori ho to keys ko explicitly sort karein.

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

Syntax check:

```bash
bash -n friends_array.sh
```

Script run karein:

```bash
bash friends_array.sh
```

---

## 18. Common Mistakes

### Mistake 1: Commas use karna

Ghalat:

```bash
friends=("a", "b", "c")
```

Sahi:

```bash
friends=("a" "b" "c")
```

### Mistake 2: Python `.append()` syntax use karna

Ghalat:

```bash
friends.append("d")
```

Sahi:

```bash
friends+=("d")
```

### Mistake 3: Sirf pehla element print hona

```bash
echo "$friends"
```

Yeh aam tor par sirf index `0` print karta hai.

Tamam elements:

```bash
echo "${friends[@]}"
```

### Mistake 4: Braces ghalat jagah lagana

Ghalat:

```bash
echo "$friends[@]"
```

Possible output:

```text
a[@]
```

Sahi:

```bash
echo "${friends[@]}"
```

Complete array expression `${...}` ke andar honi chahiye.

### Mistake 5: Index `1` se start samajhna

```bash
friends=("a" "b" "c")
```

Teesri value:

```bash
${friends[2]}
```

### Mistake 6: Array expansion quote na karna

Kam safe:

```bash
for friend in ${friends[@]}
```

Preferred:

```bash
for friend in "${friends[@]}"
```

### Mistake 7: `unset` ke baad automatic reindex expect karna

```bash
unset 'friends[1]'
```

Index `1` remove hota hai, lekin index `2` automatically index `1` nahi banta.

### Mistake 8: Element count aur highest index ko same samajhna

```bash
friends[0]="a"
friends[5]="f"
```

Is array mein element count `2` hai, chahe highest index `5` hai.

---

## 19. Practical Examples

### Example 1: Package list

**Create: `package_list.sh`**

```bash
#!/bin/bash

# Title: Package List
# Purpose: Loop through package names stored in an array.

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

# Title: Server List
# Purpose: Loop through server names stored in an array.

servers=("web01" "web02" "db01")

for server in "${servers[@]}"
do
    echo "Checking server: $server"
done

exit 0
```

### Example 3: Command-line arguments ko array banana

Bash script arguments ko special collection `"$@"` mein rakhti hai.

**Create: `show_items.sh`**

```bash
#!/bin/bash

# Title: Show Command-Line Items
# Purpose: Copy script arguments into an array and print every item.

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
bash show_items.sh apple banana "red cherry"
```

Output:

```text
Item: apple
Item: banana
Item: red cherry
```

### Example 4: Installed packages check karna

**Create: `check_installed_packages.sh`**

```bash
#!/bin/bash

# Title: Check Installed Packages
# Purpose: Check Debian/Ubuntu packages stored in an array.

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

Yeh example Debian/Ubuntu systems ke liye hai jahan `dpkg` available hota hai.

---

## 20. Quick Reference

| Task | Syntax | Example |
|---|---|---|
| Indexed array banana | `array=(values)` | `friends=("a" "b" "c")` |
| Indexed array declare karna | `declare -a array` | `declare -a friends` |
| Empty array banana | `array=()` | `friends=()` |
| Pehla element | `${array[0]}` | `${friends[0]}` |
| Selected element | `${array[index]}` | `${friends[2]}` |
| Tamam elements | `"${array[@]}"` | `echo "${friends[@]}"` |
| Tamam indexes | `"${!array[@]}"` | `echo "${!friends[@]}"` |
| Element count | `${#array[@]}` | `echo "${#friends[@]}"` |
| Element ki string length | `${#array[index]}` | `echo "${#friends[2]}"` |
| Aik value append karna | `array+=("value")` | `friends+=("d")` |
| Multiple values append karna | `array+=("x" "y")` | `friends+=("d" "e")` |
| Element replace karna | `array[index]="value"` | `friends[2]="d"` |
| Aik element remove karna | `unset 'array[index]'` | `unset 'friends[1]'` |
| Poori array remove karna | `unset array` | `unset friends` |
| Array copy karna | `copy=("${array[@]}")` | `copy=("${friends[@]}")` |
| Array slice lena | `"${array[@]:start:length}"` | `"${friends[@]:1:2}"` |
| Values par loop | `for item in "${array[@]}"` | `for friend in "${friends[@]}"` |
| Indexes par loop | `for i in "${!array[@]}"` | `for i in "${!friends[@]}"` |
| Input ko array mein read karna | `read -r -a array` | `read -r -a friends` |
| Associative array declare karna | `declare -A array` | `declare -A student` |

---

## 21. Practice Tasks

### Task 1: Tamam fruits print karein

```bash
fruits=("apple" "banana" "mango" "orange" "red cherry")
```

Har fruit separate line par print karein.

### Task 2: Fruit append karein

Array ke end par `grapes` add karein aur updated array print karein.

### Task 3: Fruit replace karein

Index use karke `mango` ko `peach` se replace karein.

### Task 4: Fruits count karein

Output:

```text
Total fruits: 5
```

Number manually type karne ki bajaye `${#fruits[@]}` use karein.

### Task 5: Item numbers print karein

```text
Item 1: apple
Item 2: banana
Item 3: mango
Item 4: orange
Item 5: red cherry
```

### Task 6: Command-line values accept karein

**Create: `show_items.sh`**

Script `"$@"` ko array mein copy kare aur har item separately print kare.

Test:

```bash
bash show_items.sh apple banana "red cherry"
```

---

## 22. Final Summary

**Create: `array_basics_summary.sh`**

```bash
#!/bin/bash

# Title: Array Basics Summary
# Purpose: Review the most important indexed-array operations.

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
1. Bash mein is structure ko array kehte hain.
2. Indexed array aam tor par index 0 se start hoti hai.
3. Aik element ke liye ${array[index]} use karein.
4. Tamam elements ke liye "${array[@]}" use karein.
5. Append ke liye array+=("value") use karein.
6. Replace ke liye array[index]="value" use karein.
7. Spaces wali values bachanay ke liye expansions quote karein.
8. Element count ke liye ${#array[@]} use karein.
9. Existing indexes ke liye ${!array[@]} use karein.
10. Bash Python ki list.append() syntax support nahi karti.
```
