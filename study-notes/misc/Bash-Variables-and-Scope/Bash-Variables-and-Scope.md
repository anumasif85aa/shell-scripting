# Bash Variables and Scope — English Study Notes

## Summary

A variable is a named container that temporarily stores a value. Scope determines where a variable is available within a script.

Important Bash variable and scope types:

| Type | Simple meaning |
|---|---|
| Global variable | Available throughout the script and its functions |
| Local variable | Available only inside the function where it is declared |
| Environment variable | Available to child processes after being exported |
| Positional parameter | An argument provided to a script or function |
| Readonly variable | Cannot be changed after it is declared readonly |
| Subshell variable | Changes made in a subshell do not return to the parent shell |

---

## Table of Contents

1. [What is a variable?](#1-what-is-a-variable)
2. [Rules for creating variables](#2-rules-for-creating-variables)
3. [What is scope?](#3-what-is-scope)
4. [Global variables](#4-global-variables)
5. [Global variables created inside functions](#5-global-variables-created-inside-functions)
6. [Local variables](#6-local-variables)
7. [Global and local variable comparison](#7-global-and-local-variable-comparison)
8. [Protecting a global variable](#8-protecting-a-global-variable)
9. [Function argument scope](#9-function-argument-scope)
10. [Difference between script and function arguments](#10-difference-between-script-and-function-arguments)
11. [Environment variables](#11-environment-variables)
12. [Parent and child shells](#12-parent-and-child-shells)
13. [Subshell scope](#13-subshell-scope)
14. [Command substitution scope](#14-command-substitution-scope)
15. [Readonly variables](#15-readonly-variables)
16. [Removing a variable](#16-removing-a-variable)
17. [Best practices](#17-best-practices)
18. [Complete practice script](#18-complete-practice-script)
19. [Quick revision](#19-quick-revision)
20. [Practice tasks](#20-practice-tasks)

---

## 1. What is a variable?

A variable is a named container in which a value is temporarily stored.

```bash
name="Khalid"
course="Bash Scripting"
age=25
```

Place `$` before a variable name when you want Bash to use its stored value:

```bash
echo "$name"
echo "$course"
echo "$age"
```

Output:

```text
Khalid
Bash Scripting
25
```

Variable name:

```bash
name
```

Stored value:

```text
Khalid
```

Variable expansion:

```bash
$name
```

[Back to Table of Contents](#table-of-contents)

---

## 2. Rules for creating variables

### Rule 1: Do not put spaces around `=`

Correct:

```bash
name="Ali"
```

Incorrect:

```bash
name = "Ali"
```

In the incorrect example, Bash tries to treat `name` as a command.

### Rule 2: Quote values containing spaces

```bash
course="Bash Scripting"
```

### Rule 3: Variable names are case-sensitive

```bash
name="Ali"
Name="Khalid"
```

`name` and `Name` are two different variables.

### Rule 4: A variable name cannot begin with a digit

Correct:

```bash
student1="Ali"
```

Incorrect:

```bash
1student="Ali"
```

### Rule 5: Underscores are allowed

```bash
student_name="Ali Khan"
course_name="Bash Scripting"
```

### Rule 6: Quote variable expansions

Recommended:

```bash
echo "$student_name"
```

Quotes safely preserve spaces and special characters in the value.

[Back to Table of Contents](#table-of-contents)

---

## 3. What is scope?

Scope means:

> The part of a script in which a variable is available and accessible.

For example:

- Can the variable be used throughout the script?
- Is it available only inside one function?
- Can a child process see it?
- Will a change made in a subshell return to the parent shell?

Bash has two fundamental variable scopes:

1. Global scope
2. Local scope

At a more advanced level, environment, child-process, and subshell behavior are also important.

[Back to Table of Contents](#table-of-contents)

---

## 4. Global variables

A variable created outside a function is normally global.

A global variable:

- Is available throughout the script.
- Can be accessed inside functions.
- Can also be changed by a function.

Example:

```bash
#!/bin/bash

course="Bash Scripting"

show_course()
{
    echo "Inside function: $course"
}

show_course

echo "Outside function: $course"
```

Output:

```text
Inside function: Bash Scripting
Outside function: Bash Scripting
```

`course` was created outside the function. It is therefore global and is available inside the function.

[Back to Table of Contents](#table-of-contents)

---

## 5. Global variables created inside functions

In Bash, a variable assigned inside a function can still be global when `local` is not used.

```bash
#!/bin/bash

create_name()
{
    student="Ali"
}

create_name

echo "$student"
```

Output:

```text
Ali
```

`student` was assigned inside the function, but it was not declared with `local`. It therefore remains available after the function has completed.

This behavior can cause accidental changes and variable-name conflicts.

[Back to Table of Contents](#table-of-contents)

---

## 6. Local variables

A local variable is available only inside the function where it is declared.

Syntax:

```bash
local variable_name="value"
```

Example:

```bash
#!/bin/bash

show_student()
{
    local student="Ali"

    echo "Inside function: $student"
}

show_student

echo "Outside function: $student"
```

Output:

```text
Inside function: Ali
Outside function:
```

The value of `student` is not printed outside the function because it is local.

Important:

```bash
local
```

can be used only inside a function.

[Back to Table of Contents](#table-of-contents)

---

## 7. Global and local variable comparison

| Feature | Global variable | Local variable |
|---|---|---|
| Where is it available? | Throughout the script | Only inside its function |
| How is it created? | Normal assignment | With the `local` keyword |
| Can it be used outside the function? | Yes | No |
| Can a function change it? | Yes | The function changes only its local copy |
| Risk of accidental changes | Higher | Lower |
| Recommended for temporary function data | No | Yes |

Quick example:

```bash
global_name="Khalid"

demo()
{
    local local_name="Ali"

    echo "$global_name"
    echo "$local_name"
}
```

Both variables are available inside the function. Only `global_name` is available outside it.

[Back to Table of Contents](#table-of-contents)

---

## 8. Protecting a global variable

### Without `local`

```bash
#!/bin/bash

name="Khalid"

change_name()
{
    name="Ali"
    echo "Inside function: $name"
}

change_name

echo "Outside function: $name"
```

Output:

```text
Inside function: Ali
Outside function: Ali
```

The function permanently changed the global `name` variable.

### With `local`

```bash
#!/bin/bash

name="Khalid"

change_name()
{
    local name="Ali"
    echo "Inside function: $name"
}

change_name

echo "Outside function: $name"
```

Output:

```text
Inside function: Ali
Outside function: Khalid
```

There are now two separate variables:

- Local `name="Ali"` inside the function
- Global `name="Khalid"` outside the function

The local variable did not change the global variable.

[Back to Table of Contents](#table-of-contents)

---

## 9. Function argument scope

A function receives its own positional parameters:

```bash
show_student()
{
    echo "First argument: $1"
    echo "Second argument: $2"
}

show_student "Ali" "Bash"
```

Output:

```text
First argument: Ali
Second argument: Bash
```

Inside a function:

| Parameter | Meaning |
|---|---|
| `$1` | First function argument |
| `$2` | Second function argument |
| `$#` | Number of function arguments |
| `"$@"` | All arguments, preserved as separate values |
| `"$*"` | All arguments represented as one combined string |

### Numbering function arguments

```bash
show_items()
{
    local item
    local count=1

    echo "Arguments count: $#"

    for item in "$@"
    do
        echo "Item $count: $item"
        ((count++))
    done
}

show_items "apple" "banana" "red cherry"
```

Output:

```text
Arguments count: 3
Item 1: apple
Item 2: banana
Item 3: red cherry
```

Because `"$@"` is quoted, `"red cherry"` remains one argument.

`item` and `count` are local, so they do not affect variables outside the function.

[Back to Table of Contents](#table-of-contents)

---

## 10. Difference between script and function arguments

Run a script like this:

```bash
bash script.sh Khalid
```

At the script level:

```bash
$1 = Khalid
```

However, if a function receives a different argument:

```bash
greet "Ali"
```

Inside the function:

```bash
$1 = Ali
```

Complete example:

```bash
#!/bin/bash

greet()
{
    echo "Function argument: $1"
}

echo "Script argument: $1"

greet "Ali"
```

Run:

```bash
bash script.sh Khalid
```

Output:

```text
Script argument: Khalid
Function argument: Ali
```

When a function is called, it temporarily receives its own positional parameters. Inside the function, `$1` refers to the function's first argument.

[Back to Table of Contents](#table-of-contents)

---

## 11. Environment variables

An environment variable is passed to child processes started from the current shell.

### Normal shell variable

```bash
course="Bash Scripting"
```

This variable is available in the current shell, but a child process does not automatically receive it.

### Exported environment variable

```bash
export course="Bash Scripting"
```

A child process can now receive the variable:

```bash
bash -c 'echo "$course"'
```

Output:

```text
Bash Scripting
```

An existing variable can also be exported later:

```bash
course="Bash Scripting"
export course
```

Common system environment variables:

```bash
echo "$USER"
echo "$HOME"
echo "$PATH"
echo "$SHELL"
```

[Back to Table of Contents](#table-of-contents)

---

## 12. Parent and child shells

Important rule:

> A child process can receive its parent's exported variables, but it cannot permanently change a variable in the parent process.

Example:

```bash
name="Khalid"

bash -c 'name="Ali"; echo "Child: $name"'

echo "Parent: $name"
```

Output:

```text
Child: Ali
Parent: Khalid
```

The child shell changed its own copy. The original variable in the parent shell remained unchanged.

### Direction of an export

```text
Parent shell
     |
     | exported variable
     v
Child process
```

The exported value moves from parent to child. Later changes made by the child do not return to the parent.

[Back to Table of Contents](#table-of-contents)

---

## 13. Subshell scope

Parentheses:

```bash
( commands )
```

run commands inside a subshell.

```bash
name="Khalid"

(
    name="Ali"
    echo "Subshell: $name"
)

echo "Main shell: $name"
```

Output:

```text
Subshell: Ali
Main shell: Khalid
```

The variable change made in the subshell does not return to the main shell.

### Difference between parentheses and braces

Commands inside braces:

```bash
{ commands; }
```

run in the current shell.

```bash
name="Khalid"

{
    name="Ali"
}

echo "$name"
```

Output:

```text
Ali
```

Comparison:

| Structure | Where does it run? | Are variable changes preserved? |
|---|---|---|
| `( commands )` | Subshell | No |
| `{ commands; }` | Current shell | Yes |

[Back to Table of Contents](#table-of-contents)

---

## 14. Command substitution scope

Command substitution:

```bash
$(command)
```

captures a command's output and normally runs in a subshell environment.

```bash
name="Khalid"

result=$(
    name="Ali"
    echo "$name"
)

echo "Result: $result"
echo "Original: $name"
```

Output:

```text
Result: Ali
Original: Khalid
```

The change made inside command substitution did not affect the original `name`.

Common example:

```bash
today=$(date)
echo "$today"
```

The output of `date` is stored in the `today` variable.

[Back to Table of Contents](#table-of-contents)

---

## 15. Readonly variables

Use `readonly` when a variable's value must not be changed:

```bash
readonly course="Bash Scripting"
```

An attempt to change it:

```bash
course="Linux"
```

produces an error.

Uppercase names are commonly used for constants:

```bash
readonly COURSE_NAME="Bash Scripting"
readonly MAX_ATTEMPTS=3
```

A local readonly variable inside a function:

```bash
demo()
{
    local -r message="Hello"
    echo "$message"
}
```

Here, `-r` means readonly.

[Back to Table of Contents](#table-of-contents)

---

## 16. Removing a variable

Use `unset` to remove a variable:

```bash
name="Ali"

echo "$name"

unset name

echo "$name"
```

The first `echo` prints:

```text
Ali
```

The second `echo` prints no value.

A readonly variable normally cannot be changed or unset.

Remove a function:

```bash
unset -f function_name
```

Remove a variable:

```bash
unset variable_name
```

[Back to Table of Contents](#table-of-contents)

---

## 17. Best practices

### 1. Make temporary function variables local

```bash
calculate_total()
{
    local price=$1
    local quantity=$2
    local total=$((price * quantity))

    echo "$total"
}
```

### 2. Quote variable expansions

```bash
echo "$name"
cp -- "$source" "$destination"
```

### 3. Use meaningful names

Clear:

```bash
student_name="Ali"
```

Less clear:

```bash
x="Ali"
```

### 4. Make constants uppercase and readonly

```bash
readonly MAX_RETRIES=3
```

### 5. Do not export variables unnecessarily

Export only the variables that child processes require.

### 6. Store function arguments in local variables

```bash
greet()
{
    local name=$1
    echo "Hello: $name"
}
```

### 7. Declare temporary loop variables as local

```bash
show_items()
{
    local item

    for item in "$@"
    do
        echo "$item"
    done
}
```

Benefits:

- Global variables are not changed accidentally.
- Functions become more reusable.
- Scripts become easier to understand.
- Variable-name conflicts are reduced.
- Debugging becomes easier.

[Back to Table of Contents](#table-of-contents)

---

## 18. Complete practice script

```bash
#!/bin/bash

# Global and readonly variables
course="Bash Scripting"
readonly MAX_STUDENTS=3

show_student()
{
    local student_name=$1
    local student_number=$2

    echo "Student $student_number: $student_name"
    echo "Course: $course"
}

show_all_students()
{
    local student
    local count=1

    echo "Total arguments: $#"

    for student in "$@"
    do
        show_student "$student" "$count"
        ((count++))
    done
}

show_all_students "Ali" "Khalid" "Sara"

echo
echo "Maximum students: $MAX_STUDENTS"
```

Output:

```text
Total arguments: 3
Student 1: Ali
Course: Bash Scripting
Student 2: Khalid
Course: Bash Scripting
Student 3: Sara
Course: Bash Scripting

Maximum students: 3
```

Scope explanation:

| Variable | Type | Where is it available? |
|---|---|---|
| `course` | Global | Throughout the script and its functions |
| `MAX_STUDENTS` | Global readonly | Throughout the script, but it cannot be changed |
| `student_name` | Local | Only inside `show_student` |
| `student_number` | Local | Only inside `show_student` |
| `student` | Local | Only inside `show_all_students` |
| `count` | Local | Only inside `show_all_students` |
| `"$@"` | Function arguments | Within the current function call |

[Back to Table of Contents](#table-of-contents)

---

## 19. Quick revision

| Concept | Syntax | Meaning |
|---|---|---|
| Normal variable | `name="Ali"` | Stores a value |
| Variable expansion | `"$name"` | Uses the stored value |
| Global variable | `course="Bash"` | Available throughout the script |
| Local variable | `local name="Ali"` | Available only inside the function |
| Environment variable | `export name="Ali"` | Also available to child processes |
| Readonly variable | `readonly MAX=3` | Cannot be changed |
| Remove variable | `unset name` | Removes the variable |
| Script arguments | `$1`, `$2`, `"$@"` | Arguments given to the script |
| Function arguments | `$1`, `$2`, `"$@"` | Arguments given to the function call |
| Subshell | `( commands )` | Changes do not return to the parent shell |
| Current-shell group | `{ commands; }` | Changes remain in the current shell |

## Final memory rules

> A variable created outside a function is normally global.

> A variable declared with `local` inside a function belongs only to that function call.

> `export` makes a variable available to child processes.

> A child process cannot permanently change a variable in its parent process.

> Changes made in a subshell do not return to the parent shell.

> Using `local` for temporary function variables is a Bash best practice.

[Back to Table of Contents](#table-of-contents)

---

## 20. Practice tasks

### Task 1 — Global variable

Create a global variable:

```bash
course="Bash Scripting"
```

Print it both inside and outside a function.

### Task 2 — Local variable

Inside a function, create:

```bash
local student="Ali"
```

Print it inside and outside the function to observe the difference.

### Task 3 — Protect a global variable

Create:

```bash
name="Khalid"
```

as a global variable. Use `local name="Ali"` inside a function and prove that the global value was not changed.

### Task 4 — Function arguments

Give a function these three arguments:

```bash
"apple" "banana" "red cherry"
```

Use `"$@"` and a local counter to produce:

```text
Item 1: apple
Item 2: banana
Item 3: red cherry
```

### Task 5 — Environment variable

Create a variable and test it with `bash -c`:

1. Without exporting it
2. After exporting it

### Task 6 — Subshell

Set this in the main shell:

```bash
name="Khalid"
```

Change it to `Ali` inside a subshell and prove that the main shell's value is still `Khalid`.

[Back to Table of Contents](#table-of-contents)
