# Bash Variables and User Input – Study Notes

## Learning Objectives
- Create shell variables
- Read user input
- Store command output in variables
- Use environment variables
- Remove variables
- Display shell and environment variables

## 1. What is a Variable?
A variable is a named container that stores data for later use.

```bash
name="Khalid"
echo "$name"
```

## 2. Creating Variables

```bash
city="Chicago"
state="Illinois"
country="USA"
echo "$city, $state, $country"
```

## 3. Reading User Input

```bash
read -p "Enter your name: " username
echo "Welcome $username"
```

## 4. Hidden Password

```bash
read -sp "Password: " pass
echo
```

- `-s` hides typed characters.
- `-p` displays a prompt.

## 5. Command Substitution

```bash
current_user=$(whoami)
today=$(date)
directory=$(pwd)
```

## 6. Environment Variables

```bash
export COURSE="Linux Administration"
echo "$COURSE"
```

View them:

```bash
env
printenv
```

## 7. Remove a Variable

```bash
unset COURSE
```

## Shell vs Environment Variables

| Shell Variable | Environment Variable |
|---|---|
| `name="Ali"` | `export name="Ali"` |
| Current shell only | Available to child processes |

## Practice Lab

1. Create variables for your name, city, and country.
2. Read your name using `read -p`.
3. Read a hidden password using `read -sp`.
4. Store the output of `whoami`, `date`, and `pwd` in variables.
5. Create an environment variable using `export`.
6. Remove a variable using `unset`.

## Interview Questions

1. What is a Bash variable?
2. What is the difference between a shell variable and an environment variable?
3. What does `export` do?
4. What is command substitution?
5. Why is `read -sp` used?

## Roman Urdu Summary

- Variable data store karta hai.
- `read` user se input leta hai.
- `read -sp` password ko hide karta hai.
- `$(command)` command ka output variable mein store karta hai.
- `export` variable ko child processes tak bhejta hai.
- `unset` variable delete karta hai.

## One-Line Summary

Bash variables help store, reuse, and manage data efficiently in the terminal and scripts.
