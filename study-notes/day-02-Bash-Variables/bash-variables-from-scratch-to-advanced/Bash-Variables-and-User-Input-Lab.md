# Bash Variables and User Input - Hands-on Lab

## Lab Objectives

After completing this lab, you will be able to:

- Create shell variables
- Read user input
- Read hidden passwords
- Store command output in variables
- Create environment variables
- Remove variables
- Build a simple interactive Bash script

---

# Lab 1 - Create Variables

### Task

Create the following variables:

```bash
name="Khalid"
city="Chicago"
country="USA"
```

Display them:

```bash
echo "$name"
echo "$city"
echo "$country"
```

---

# Lab 2 - Multiple Variables

Display all variables on one line.

Expected output:

```text
Khalid, Chicago, USA
```

---

# Lab 3 - User Input

Read the user's name.

```bash
read -p "Enter your name: " username
echo "Welcome $username"
```

---

# Lab 4 - Read Multiple Inputs

Ask for:

- Name
- Age
- City

Display a summary.

---

# Lab 5 - Hidden Password

```bash
read -sp "Password: " pass
echo
echo "Password saved successfully."
```

Do **not** print the password.

---

# Lab 6 - Command Substitution

Store the output of the following commands in variables.

```bash
current_user=$(whoami)
today=$(date)
directory=$(pwd)
hostname=$(hostname)
```

Display:

```bash
echo "$current_user"
echo "$today"
echo "$directory"
echo "$hostname"
```

---

# Lab 7 - Environment Variables

Create:

```bash
export COURSE="Linux Administration"
```

Verify:

```bash
echo "$COURSE"
printenv COURSE
```

---

# Lab 8 - Delete Variables

Create:

```bash
city="Chicago"
```

Display it.

Delete it:

```bash
unset city
```

Display it again.

---

# Lab 9 - View Variables

Display shell variables:

```bash
set
```

Display environment variables:

```bash
env
printenv
```

Compare the outputs.

---

# Mini Project

Create a script named:

```text
student-profile.sh
```

The script should ask for:

- Full Name
- Age
- City
- Country
- Favorite Linux Distribution
- Favorite Editor

Display the information in a formatted report.

---

# Challenge Project

Create a script named:

```text
system-info.sh
```

Collect and display:

- Current User
- Hostname
- Current Directory
- Current Date
- Current Shell
- Kernel Version
- Uptime

Store every value in a variable before displaying it.

---

# Self-Assessment Checklist

- [ ] I can create variables.
- [ ] I can read user input.
- [ ] I can read hidden passwords.
- [ ] I can use command substitution.
- [ ] I can create environment variables.
- [ ] I can remove variables.
- [ ] I can write an interactive Bash script.

---

# Bonus Questions

1. What is the difference between a shell variable and an environment variable?
2. Why should passwords be read using `read -sp`?
3. What does `unset` do?
4. What is command substitution?
5. What is the purpose of `export`?

---

# Roman Urdu Summary

- Variable data ko store karta hai.
- `read` user se input leta hai.
- `read -sp` password ko hide karta hai.
- `$(command)` command ka output variable mein save karta hai.
- `export` variable ko child processes tak available karta hai.
- `unset` variable ko delete karta hai.

Happy Bash Scripting!
