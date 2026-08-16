# CPU Load Generation & Testing in Linux / WSL

## 1. Overview
In Linux environments, stress testing or putting a synthetic load on the CPU is a common administrative task used to:
- Test system performance, stability, and thermal limits.
- Benchmark system response under heavy utilization.
- Test auto-scaling rules, monitoring tools (`top`, `htop`), or resource limits (cgroups/Docker).

---

## 2. Quick Built-in Bash Methods (No Extra Tools)

These methods use standard Linux utilities available on almost every distribution without needing `sudo` or package installation.

### A. Single-Core CPU Load (100% on 1 Core)
Runs an endless loop calculating hashes from infinite zero bytes:

```bash
cat /dev/zero | md5sum
```

- **Mechanism:** Redirects `/dev/zero` stream into `md5sum` hash computation.
- **How to stop:** Press `Ctrl + C`.

---

### B. Multi-Core CPU Load (100% on All Cores)
Spawns background jobs equal to the exact number of CPU cores detected by `nproc`:

```bash
for i in $(seq 1 $(nproc)); do sha1sum /dev/zero & done
```

- **Mechanism:** `$(nproc)` dynamically returns the number of active CPU cores/threads.
- **`&` operator:** Pushes each process to the background.

#### Stopping Multi-Core Background Jobs
Since background processes won't stop with `Ctrl + C`, kill them using `killall`:

```bash
killall sha1sum
```

---

## 3. Using Dedicated Stress Testing Tools (`stress`)

For controlled, timed, and precise CPU loading, dedicated tools like `stress` or `stress-ng` are recommended.

### A. Installation
```bash
sudo apt update && sudo apt install -y stress
```

### B. Usage Examples

#### Load All Cores for a Fixed Duration
```bash
# Stresses all available CPU cores for 30 seconds
stress --cpu $(nproc) --timeout 30s
```

#### Load a Specific Number of Cores
```bash
# Stresses exactly 2 CPU cores for 60 seconds
stress --cpu 2 --timeout 60s
```

---

## 4. Monitoring CPU Load

Always run a monitor in a **second terminal window** while running stress tests to observe core behavior.

### Popular Monitoring Commands
| Command | Description | Package Required |
| :--- | :--- | :--- |
| `top` | Classic, built-in process monitor | Pre-installed |
| `htop` | Interactive, color-coded visual core monitor | `sudo apt install htop` |
| `uptime` / `cat /proc/loadavg` | Displays 1, 5, and 15-minute load averages | Pre-installed |

---

## 5. Summary Cheat Sheet

| Task | Command | Stop Method |
| :--- | :--- | :--- |
| **1 Core Load** | `cat /dev/zero \| md5sum` | `Ctrl + C` |
| **All Cores Load** | `for i in $(seq 1 $(nproc)); do sha1sum /dev/zero & done` | `killall sha1sum` |
| **Timed Test (30s)** | `stress --cpu $(nproc) --timeout 30s` | Auto-stops after 30s |
| **Check Cores Count** | `nproc` | N/A |
