# Bash Scripting Day 01 — Solutions

This package contains the verified solutions for the Day 01 Bash practice tasks.

## Included Files

| File | Purpose |
|---|---|
| `hello.sh` | Prints the first Bash greeting. |
| `variables.sh` | Demonstrates variables and quoting. |
| `greet.sh` | Reads and validates interactive input. |
| `check_number.sh` | Validates and classifies a whole number. |
| `file_check.sh` | Checks whether a path is a regular file. |
| `server_check.sh` | Checks a systemd service interactively. |
| `Bash-Scripting-Day-01-Solutions.md` | Complete explanations, outputs, and tests. |

## Prepare the Scripts

```bash
chmod +x ./*.sh
bash -n ./*.sh
```

## Run the Scripts

```bash
./hello.sh
./variables.sh
./greet.sh
./check_number.sh
./file_check.sh
./server_check.sh
```

## Important Note

`server_check.sh` requires Linux with systemd and a service named `nginx`. Install or select an existing service before testing it. The OpenSSH service may be called `ssh` on Ubuntu and `sshd` on RHEL-family systems.

