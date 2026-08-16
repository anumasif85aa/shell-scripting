# `yes` Command in Linux / Bash

## 1. Overview
The `yes` command is a standard Unix utility that repeatedly outputs a given string (or default `y`) continuously until terminated.

- **Primary Purpose:** Automating interactive command line prompts and generating test inputs or synthetic CPU loads.
- **Default Behavior:** Outputs `y` followed by a newline character infinitely.

---

## 2. Basic Usage & Syntax

### Basic Syntax
```bash
yes [STRING]
```

### Examples

#### Default Execution
```bash
$ yes
y
y
y
... (continues endlessly)
```
> **How to Stop:** Press `Ctrl + C`.

#### Custom String Output
```bash
$ yes "Hello World"
Hello World
Hello World
...
```

---

## 3. Key Use Cases

### A. Automating Interactive Prompts
Piping `yes` into interactive commands automatically sends affirmative responses to repeated prompts.

```bash
# Automatically confirms prompts during package installation
yes | sudo apt install nginx
```

> **Note:** Many modern commands have built-in flags (e.g., `apt install -y` or `rm -f`), but `yes` acts as a universal fallback for scripts that lack confirmation flags.

---

### B. Custom Automation Responses
When an interactive command expects something other than `y` (e.g., `yes`, `OK`, or `continue`), supply the required string:

```bash
# Sends "continue" to every prompt in an installation script
yes "continue" | ./interactive_script.sh
```

---

### C. Quick CPU Stress Testing
Because `yes` runs in an unthrottled loop, discarding its output to `/dev/null` maxes out a single CPU core:

```bash
# Loads 1 CPU core to 100%
yes > /dev/null
```

To stress all available CPU cores using `yes`:
```bash
# Spawns 'yes > /dev/null' background jobs for all detected cores
for i in $(seq 1 $(nproc)); do yes > /dev/null & done
```

#### Stopping Multi-Core Background Jobs
```bash
killall yes
```

---

## 4. Summary Cheat Sheet

| Command / Example | Function / Purpose | Stop Method |
| :--- | :--- | :--- |
| `yes` | Prints `y` endlessly | `Ctrl + C` |
| `yes "text"` | Prints `text` endlessly | `Ctrl + C` |
| `yes \| command` | Automates `y` inputs to prompts | N/A (ends when command completes) |
| `yes > /dev/null` | 100% single-core CPU load test | `Ctrl + C` |
| `killall yes` | Kills all background `yes` processes | Execution command |
