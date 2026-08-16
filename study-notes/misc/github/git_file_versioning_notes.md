# Git Versioning Study Notes — Managing Multiple File Versions & Branches

This document provides a comprehensive guide on managing multiple versions of a file using Git, using tags for linear progress or branches for parallel development.

---

## 1. Overview: Tags vs. Branches

When working with multiple versions of a file, Git offers two primary strategies:

* **Linear Tracking with Tags:** Best when Version 2 replaces Version 1 over time (e.g., progressive improvements/updates). You commit sequentially and bookmark each release using a `tag`.
* **Parallel Tracking with Branches:** Best when you need to maintain multiple variations of a project simultaneously (e.g., `v1-stable`, `v2-beta`, `v3-experimental`).

---

## 2. Method A: Linear History with Git Tags

Use this method when Version 1, Version 2, and Version 3 represent chronological updates to the same file.

```
(v1.0) ---> (v2.0) ---> (v3.0) [main]
```

### Step-by-Step Implementation

1. **Initialize repository:**
   ```bash
   git init
   ```

2. **Commit Version 1 & tag it:**
   ```bash
   cp script_v1.sh script.sh
   git add script.sh
   git commit -m "Add version 1 of script"
   git tag v1.0
   ```

3. **Commit Version 2 & tag it:**
   ```bash
   cp script_v2.sh script.sh
   git add script.sh
   git commit -m "Add version 2 of script"
   git tag v2.0
   ```

4. **Commit Version 3 & tag it:**
   ```bash
   cp script_v3.sh script.sh
   git add script.sh
   git commit -m "Add version 3 of script"
   git tag v3.0
   ```

### Reviewing History
```bash
git log --oneline
```
*Sample Output:*
```text
a1b2c3d (HEAD -> main, tag: v3.0) Add version 3 of script
e4f5g6h (tag: v2.0) Add version 2 of script
i7j8k9l (tag: v1.0) Add version 1 of script
```

---

## 3. How to Call Back Any Version (Tag-Based)

| Goal | Command | Description |
| :--- | :--- | :--- |
| **Inspect past version** | `git checkout v1.0` | Enters "Detached HEAD" state to view code without modifying current progress. |
| **Return to latest** | `git checkout main` | Returns working folder to the latest main branch code. |
| **Restore into file** | `git checkout v1.0 -- script.sh` | Overwrites current `script.sh` in workspace with Version 1 content. |
| **Export to separate file** | `git show v1.0:script.sh > script_v1.sh` | Extracts Version 1 into a new file without switching branches/HEAD. |

---

## 4. Method B: Parallel Tracking with Git Branches

Use this method if you need to actively maintain or work on 3 distinct variations of the file independently.

```
         +---> [version-1]
         |
[main] --+---> [version-2]
         |
         +---> [version-3]
```

### Step-by-Step Implementation

1. **Create & commit Version 1 branch:**
   ```bash
   git checkout -b version-1
   cp script_v1.sh script.sh
   git add script.sh
   git commit -m "Version 1 code"
   ```

2. **Create & commit Version 2 branch:**
   ```bash
   git checkout main
   git checkout -b version-2
   cp script_v2.sh script.sh
   git add script.sh
   git commit -m "Version 2 code"
   ```

3. **Create & commit Version 3 branch:**
   ```bash
   git checkout main
   git checkout -b version-3
   cp script_v3.sh script.sh
   git add script.sh
   git commit -m "Version 3 code"
   ```

---

## 5. Working with Branches

### Switching Between Versions
To instantly load a specific version into your working directory:
```bash
git checkout version-1    # Switch to Version 1
git checkout version-2    # Switch to Version 2
git checkout version-3    # Switch to Version 3
```

### Useful Branch Management Commands

* **List all local branches:**
  ```bash
  git branch
  ```
  *(An asterisk `*` indicates the active branch.)*

* **Update code in a specific branch:**
  ```bash
  git checkout version-2
  # ... edit script.sh ...
  git add script.sh
  git commit -m "Update logic in version 2"
  ```

* **Merge changes from one branch into another:**
  ```bash
  git checkout version-3
  git merge version-2
  ```

---

## 6. Quick Cheat Sheet Matrix

| Requirement | Command / Strategy |
| :--- | :--- |
| Create a permanent marker | `git tag <tag-name>` |
| Create and switch to new branch | `git checkout -b <branch-name>` |
| Switch active working branch | `git checkout <branch-name>` |
| View tagged commits | `git log --oneline --decorate` |
| Pull past version into current file | `git checkout <tag-or-hash> -- <file>` |
| Save past version under new name | `git show <tag>:<file> > <new-file>` |
