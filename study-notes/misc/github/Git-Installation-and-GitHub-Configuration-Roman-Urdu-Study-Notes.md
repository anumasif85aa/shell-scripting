# Git Installation aur GitHub Configuration — Roman Urdu Study Notes

## Table of Contents

1. [Learning Objectives](#learning-objectives)
2. [Version Control Kya Hai?](#version-control-kya-hai)
3. [Git Kya Hai?](#git-kya-hai)
4. [Git aur GitHub Mein Farq](#git-aur-github-mein-farq)
5. [Git Kaam Kaisay Karta Hai?](#git-kaam-kaisay-karta-hai)
6. [Git Installation](#git-installation)
7. [First-Time Git Configuration](#first-time-git-configuration)
8. [GitHub Account Setup](#github-account-setup)
9. [GitHub Authentication](#github-authentication)
10. [Pehli Local Git Repository](#pehli-local-git-repository)
11. [Local Repository Ko GitHub Par Upload Karna](#local-repository-ko-github-par-upload-karna)
12. [Existing Repository Clone Karna](#existing-repository-clone-karna)
13. [Daily Git Workflow](#daily-git-workflow)
14. [Git Ki Aham Terms](#git-ki-aham-terms)
15. [`.gitignore` Ka Istemal](#gitignore-ka-istemal)
16. [Basic Branching](#basic-branching)
17. [Common Errors aur Solutions](#common-errors-aur-solutions)
18. [Command Cheat Sheet](#command-cheat-sheet)
19. [Practice Activity](#practice-activity)
20. [Quick Revision](#quick-revision)

---

## Learning Objectives

In notes ko complete karne ke baad aap:

- Git, GitHub aur version control ko explain kar sakein ge.
- Windows, Linux, WSL aur macOS par Git install kar sakein ge.
- Git username, email aur default branch configure kar sakein ge.
- Local Git repository create aur initialize kar sakein ge.
- Working directory, staging area aur repository ka farq samajh sakein ge.
- Commits create aur project history check kar sakein ge.
- Local repository ko GitHub ke saath connect kar sakein ge.
- Repository ko clone, pull aur push kar sakein ge.
- `.gitignore` file istemal kar sakein ge.
- Common Git errors ko samajh kar solve kar sakein ge.

---

## Version Control Kya Hai?

**Version control** aik aisa system hai jo waqt ke saath files mein hone wali tabdeeliyon ka record rakhta hai.

Yeh aap ko madad deta hai:

- Dekhne mein ke kya change hua.
- Maloom karne mein ke change kis ne kiya.
- File ka purana version restore karne mein.
- Stable project ko kharab kiye baghair new feature par kaam karne mein.
- Doosre developers ke saath collaboration karne mein.
- Project ki complete history maintain karne mein.

### Example

Version control ke baghair files kuch is tarah ban sakti hain:

```text
project-final.txt
project-final-new.txt
project-final-new-2.txt
project-really-final.txt
```

Yeh approach confusing hoti hai. Git is ke bajaye changes ko organized **commits** ki form mein save karta hai.

---

## Git Kya Hai?

**Git aik distributed version control system hai.** Yeh files mein hone wali tabdeeliyon ko track karta hai aur project ki history save karta hai.

Git ko **Linus Torvalds ne 2005 mein** Linux kernel development ke liye create kiya tha.

### Aham wazahat

Git ki official full form **“Global Information Tracker” nahi hai**. Yeh sirf aik humorous backronym hai. Professional definition yeh hai:

> Git aik distributed version control system hai.

### Git ko distributed kyun kehte hain?

Har developer ke computer par repository ki complete copy ho sakti hai, jis mein project ki history bhi shamil hoti hai. Isi liye bohat se Git operations internet ke baghair local computer par perform kiye ja sakte hain.

### Git kya kar sakta hai?

- Files ke changes track kar sakta hai.
- Project ke snapshots save kar sakta hai.
- Old aur new versions compare kar sakta hai.
- Alag branches create kar sakta hai.
- Merge ke zariye different work combine kar sakta hai.
- Purana version restore kar sakta hai.
- Remote repositories ke saath code exchange kar sakta hai.

---

## Git aur GitHub Mein Farq

| Git | GitHub |
|---|---|
| Computer par install hone wala software | Online platform aur hosting service |
| Changes ko locally track karta hai | Git repositories ko online store karta hai |
| Internet ke baghair bhi kaam kar sakta hai | Aam tor par internet chahiye hota hai |
| `add` aur `commit` jaisi commands use karta hai | Pull requests, issues, Actions aur collaboration deta hai |
| Local repository maintain karta hai | Remote repository maintain karta hai |
| Open-source version-control system hai | Git par based aik online service hai |

### Asaan misaal

- **Git** version-control engine hai.
- **GitHub** Git repositories ka online ghar hai.

> Git aur GitHub aik doosre se related hain, lekin dono aik cheez nahi hain.

---

## Git Kaam Kaisay Karta Hai?

```mermaid
flowchart LR
    A[Working Directory] -->|git add| B[Staging Area]
    B -->|git commit| C[Local Repository]
    C -->|git push| D[GitHub Repository]
    D -->|git pull| C
```

### 1. Working directory

Yeh aap ka project folder hota hai jahan aap files create, edit ya delete karte hain.

### 2. Staging area

Staging area mein woh changes rakhe jate hain jinhein aap next commit mein shamil karna chahte hain.

```bash
git add filename
```

### 3. Local repository

Local repository mein woh commits hote hain jo aap ke computer par save hue hain.

```bash
git commit -m "Add project README"
```

### 4. Remote repository

Remote repository project ki online copy hoti hai jo GitHub ya kisi doosre Git server par host hoti hai.

```bash
git push
```

---

## Git Installation

### Windows 10 ya Windows 11

1. [Official Git for Windows download page](https://git-scm.com/download/win) open karein.
2. Installer download karke run karein.
3. Agar aap ke environment ki koi special requirement nahi, to recommended default settings rehne dein.
4. Agar PATH ke bare mein poocha jaye to **Git from the command line and also from third-party software** select karein.
5. Installation complete karein.
6. **Git Bash** open karein.

Installation verify karein:

```bash
git --version
```

Windows Package Manager se install karne ke liye PowerShell mein:

```powershell
winget install --id Git.Git -e
```

### Ubuntu, Debian ya WSL Ubuntu

```bash
sudo apt update
sudo apt install git -y
git --version
```

### RHEL, AlmaLinux, Rocky Linux ya Fedora

```bash
sudo dnf install git -y
git --version
```

### macOS

```bash
git --version
```

Agar Git installed na ho, to macOS Xcode Command Line Tools install karne ka option de sakta hai. Homebrew users yeh command chala sakte hain:

```bash
brew install git
```

---

## First-Time Git Configuration

Git ko pata hona chahiye ke commits kis shakhs ne create kiye hain.

### Apna naam configure karein

```bash
git config --global user.name "Muhammad Khalid Khan"
```

### Apna email configure karein

Woh email use karein jo aap ke GitHub account mein verified ho:

```bash
git config --global user.email "your-email@example.com"
```

Git email ka GitHub username hona zaroori nahi. Jab commit ka email GitHub account ke verified email se match karta hai, to GitHub us commit ko aap ke profile ke saath associate kar deta hai.

### Default branch ko `main` set karein

```bash
git config --global init.defaultBranch main
```

### Configuration check karein

```bash
git config --global --list
```

Individual values check karne ke liye:

```bash
git config --global user.name
git config --global user.email
git config --global init.defaultBranch
```

### `--global` ka kya matlab hai?

`--global` setting ko current operating-system user ki tamam Git repositories par apply karta hai.

Agar kisi aik repository ke liye different identity use karni ho, to us repository mein ja kar `--global` ke baghair command run karein:

```bash
cd project-name
git config user.name "Different Name"
git config user.email "different@example.com"
```

### Configuration levels

| Level | Example | Scope |
|---|---|---|
| System | `git config --system` | Computer ke tamam users |
| Global | `git config --global` | Current operating-system user |
| Local | `git config` | Sirf current repository |

Local setting global ko override karti hai, aur global setting system setting ko override karti hai.

---

## GitHub Account Setup

1. [GitHub](https://github.com) open karein.
2. Account create karein.
3. Apna email verify karein.
4. Two-factor authentication enable karein.
5. Professional username choose karein.
6. Profile picture aur short biography add karein.

---

## GitHub Authentication

Git identity aur GitHub authentication alag cheezein hain:

- `user.name` aur `user.email` aap ke commits ko identify karte hain.
- Authentication prove karti hai ke aap ko GitHub repository access karne ki permission hai.

GitHub command-line Git operations ke liye normal account password accept nahi karta. Common authentication methods yeh hain:

1. HTTPS with Git Credential Manager
2. GitHub CLI
3. SSH keys
4. Zaroorat par Personal Access Token

### Beginners ke liye recommended method: HTTPS

HTTPS repository address is tarah hota hai:

```text
https://github.com/USERNAME/REPOSITORY.git
```

Git for Windows aam tor par Git Credential Manager ke saath aata hai. Pehli `push` par browser open ho sakta hai jahan aap GitHub mein sign in karke access authorize karte hain.

Agar Git seedha password maange, to apna normal GitHub password enter na karein. Git Credential Manager, GitHub CLI, SSH ya Personal Access Token use karein.

### Optional method: GitHub CLI

GitHub CLI install karne ke baad:

```bash
gh auth login
```

Prompts follow karein aur HTTPS ya SSH select karein.

### Optional method: SSH

Ed25519 SSH key generate karein:

```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
```
[For More Information Click here](./md/SSH-Keygen-Ed25519-Roman-Urdu-Study-Notes.md)

Linux ya Git Bash mein SSH agent start karke private key add karein:

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

[For More Information Click here](./md/SSH-Agent-and-SSH-Add-Roman-Urdu-Study-Notes.md)

Public key display karein:

```bash
cat ~/.ssh/id_ed25519.pub
```

Public key copy karke yahan add karein:

```text
GitHub → Settings → SSH and GPG keys → New SSH key
```

Connection test karein:

```bash
ssh -T git@github.com
```

SSH remote address is tarah hota hai:

```text
git@github.com:USERNAME/REPOSITORY.git
```

> Apni private key kabhi share na karein. Sirf `.pub` par end hone wali public key GitHub mein add ki jati hai.

---

## Pehli Local Git Repository

### Step 1: Directory create karke us mein jayein

```bash
mkdir git-practice
cd git-practice
```

### Step 2: File create karein

```bash
echo "# Git Practice" > README.md
```

### Step 3: Git initialize karein

```bash
git init
```

Git aik hidden `.git` directory create karta hai. Is directory mein repository ki information aur history store hoti hai.

### Step 4: Status check karein

```bash
git status
```

Is stage par `README.md` aik **untracked file** hogi. Is ka matlab hai ke Git abhi is file ko track nahi kar raha.

### Step 5: File staging area mein add karein

```bash
git add README.md
```

Current directory ke tamam changes stage karne ke liye:

```bash
git add .
```

### Step 6: Pehla commit create karein

```bash
git commit -m "Add initial README"
```

### Step 7: History dekhein

```bash
git log
```

Short output ke liye:

```bash
git log --oneline
```

---

## Local Repository Ko GitHub Par Upload Karna

### Step 1: GitHub par empty repository create karein

GitHub par:

1. **New repository** select karein.
2. Repository ka naam `git-practice` rakhein.
3. Public ya Private choose karein.
4. Is workflow ke liye README, `.gitignore` aur license add na karein.
5. **Create repository** select karein.

Repository ko empty rakhne se unnecessary history conflict nahi hota, kyun ke local project mein pehla commit pehle se mojood hai.

### Step 2: Local repository ko GitHub se connect karein

```bash
git remote add origin https://github.com/USERNAME/git-practice.git
```

Example:

```bash
git remote add origin https://github.com/krmaryum/git-practice.git
```

Is command mein:

- `remote` remote repositories ko manage karta hai.
- `add` naya remote connection create karta hai.
- `origin` primary remote ka conventional naam hai.
- URL GitHub repository ka address hai.

Remote verify karein:

```bash
git remote -v
```

### Step 3: Branch ka naam confirm karein

```bash
git branch -M main
```

### Step 4: Repository push karein

```bash
git push -u origin main
```

`-u` local `main` branch ko remote `main` branch ke saath connect karta hai. Pehli push ke baad aam tor par sirf yeh command kafi hoti hai:

```bash
git push
```

---

## Existing Repository Clone Karna

Agar repository pehle se GitHub par mojood ho, to `git clone` ke zariye download karein:

```bash
git clone https://github.com/USERNAME/REPOSITORY.git
cd REPOSITORY
```

Example:

```bash
git clone https://github.com/krmaryum/linux-practice-lab.git
cd linux-practice-lab
```

Cloning yeh cheezein download karta hai:

- Project files
- Commit history
- Branch information
- Remote configuration

Clone ke baad aam tor par `git init` run na karein, kyun ke cloned directory pehle hi Git repository hoti hai.

---

## Daily Git Workflow

Project edit karne ke baad yeh workflow use karein:

```bash
git status
git diff
git add .
git commit -m "Describe the change clearly"
git pull
git push
```

| Command | Roman Urdu Explanation |
|---|---|
| `git status` | Untracked, modified aur staged files show karta hai |
| `git diff` | Unstaged changes show karta hai |
| `git add .` | Current directory ke changes stage karta hai |
| `git commit -m "message"` | Local snapshot save karta hai |
| `git pull` | Remote changes download karke integrate karta hai |
| `git push` | Local commits remote repository par upload karta hai |

### Achhay commit messages

```bash
git commit -m "Add user creation script"
git commit -m "Fix input validation"
git commit -m "Update installation instructions"
```

Unclear messages se parhez karein:

```bash
git commit -m "changes"
git commit -m "update"
git commit -m "final"
```

Commit message ko batana chahiye ke commit mein kya kaam kiya gaya hai.

---

## Git Ki Aham Terms

| Term | Roman Urdu Meaning |
|---|---|
| Repository | Git ke zariye track kiya jane wala project |
| Commit | Staged changes ka saved snapshot |
| Branch | Development ki aik independent line |
| `main` | Default branch ka common naam |
| Working directory | Project files jin par abhi kaam ho raha hai |
| Staging area | Next commit ke liye select kiye gaye changes |
| Local repository | Aap ke computer par repository aur us ki history |
| Remote repository | GitHub ya kisi server par stored repository |
| `origin` | Primary remote ka conventional naam |
| Clone | Complete repository ko download karna |
| Push | Local commits ko remote par upload karna |
| Pull | Remote changes download aur integrate karna |
| Fetch | Remote data download karna lekin foran integrate na karna |
| Merge | Different histories ya branches ko combine karna |
| Conflict | Aisay competing changes jinhein Git automatically combine na kar sake |
| `.gitignore` | Woh file jo batati hai ke Git kin files ko ignore kare |

---

## `.gitignore` Ka Istemal

`.gitignore` file Git ko batati hai ke kin untracked files ya directories ko commits mein shamil nahi karna.

Example:

```gitignore
# Log files
*.log

# Environment files aur secrets
.env

# Temporary files
*.tmp

# Editor settings
.vscode/

# Dependency directory
node_modules/

# Large video files
videos/*.mp4
```

### Aham limitation

`.gitignore` us file ko automatically untrack nahi karti jo pehle hi Git mein add ho chuki ho.

File ko local computer par rakhte hue tracking se remove karne ke liye:

```bash
git rm --cached filename
```

Directory ko local computer par rakhte hue tracking se remove karne ke liye:

```bash
git rm -r --cached directory-name
```

Us ke baad change commit karein:

```bash
git commit -m "Stop tracking ignored files"
```

### Secrets kabhi commit na karein

Yeh cheezein commit na karein:

- Passwords
- Personal Access Tokens
- SSH private keys
- AWS access keys
- Database credentials
- Secret `.env` files

---

## Basic Branching

Branch aap ko `main` ko foran change kiye baghair independently kaam karne deti hai.

### Branches list karein

```bash
git branch
```

### New branch create karke us par switch karein

```bash
git switch -c add-documentation
```

Changes karke commit karein:

```bash
git add .
git commit -m "Add documentation"
```

`main` par wapas jayein:

```bash
git switch main
```

Branch ka kaam merge karein:

```bash
git merge add-documentation
```

Merge hone ke baad agar local branch ki zaroorat na ho to delete karein:

```bash
git branch -d add-documentation
```

---

## Common Errors aur Solutions

### Error: `Author identity unknown`

Git ko aap ka naam ya email maloom nahi.

```bash
git config --global user.name "Muhammad Khalid Khan"
git config --global user.email "your-email@example.com"
```

### Error: `not a git repository`

Aap wrong directory mein hain, ya directory Git repository ke tor par initialize nahi hui.

```bash
pwd
ls
git status
```

Agar yeh new local project hai:

```bash
git init
```

Agar project clone kiya tha, to pehle repository directory mein jayein:

```bash
cd repository-name
```

### Error: `remote origin already exists`

Current remote check karein:

```bash
git remote -v
```

Remote URL change karein:

```bash
git remote set-url origin https://github.com/USERNAME/REPOSITORY.git
```

### Error: `src refspec main does not match any`

Is ka common reason yeh hai ke abhi koi commit nahi bana, ya local branch ka naam different hai.

```bash
git status
git add .
git commit -m "Initial commit"
git branch -M main
git push -u origin main
```

### GitHub password reject kar raha hai

GitHub command-line Git operations ke liye normal account password accept nahi karta. Git Credential Manager, GitHub CLI, SSH ya Personal Access Token use karein.

### Push reject ho rahi hai kyun ke remote par new work hai

Pehle remote commits download aur integrate karein:

```bash
git pull --rebase origin main
git push
```

Agar conflict aaye, to conflicting files ko carefully resolve karke hi process continue karein.

### Large file ghalti se stage ho gayi

Local file delete kiye baghair staging area se remove karein:

```bash
git restore --staged path/to/large-file
```

Us ke baad `.gitignore` mein appropriate pattern add karein.

---

## Command Cheat Sheet

### Installation aur configuration

```bash
git --version
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
git config --global --list
```

### Repository create ya download karna

```bash
git init
git clone REPOSITORY-URL
```

### Changes inspect karna

```bash
git status
git diff
git diff --staged
```

### Stage aur commit karna

```bash
git add filename
git add .
git commit -m "Commit message"
```

### History dekhna

```bash
git log
git log --oneline
git log --oneline --graph --all
```

### Remote repositories

```bash
git remote -v
git remote add origin REPOSITORY-URL
git remote set-url origin REPOSITORY-URL
git push -u origin main
git push
git pull
git fetch
```

### Branches

```bash
git branch
git switch -c branch-name
git switch main
git merge branch-name
git branch -d branch-name
```

### Safe undo commands

```bash
# File ko unstage karein, changes ko rehne dein
git restore --staged filename

# Unstaged changes discard karein — ehtiyat se use karein
git restore filename

# Existing commit ko reverse karne wala new commit banayein
git revert COMMIT-ID
```

---

## Practice Activity

### Objective

Aik local project create karein, Git se track karein aur GitHub par upload karein.

### Instructions

1. `git-practice-lab` naam ki directory create karein.
2. `README.md` aur `notes.txt` files create karein.
3. Directory ko Git repository ke tor par initialize karein.
4. Repository status check karein.
5. Dono files stage karein.
6. Meaningful message ke saath commit create karein.
7. GitHub par `git-practice-lab` naam ki empty repository create karein.
8. GitHub ko `origin` remote ke tor par add karein.
9. `main` branch push karein.
10. `notes.txt` modify karein, change commit karein aur dobara push karein.

### Suggested commands

```bash
mkdir git-practice-lab
cd git-practice-lab

echo "# Git Practice Lab" > README.md
echo "My first Git notes" > notes.txt

git init
git status
git add .
git commit -m "Create initial practice files"

git branch -M main
git remote add origin https://github.com/USERNAME/git-practice-lab.git
git push -u origin main

echo "Git tracks changes to files." >> notes.txt
git status
git diff
git add notes.txt
git commit -m "Expand Git notes"
git push
```

### Verification

```bash
git status
git remote -v
git log --oneline
```

Expected final status:

```text
nothing to commit, working tree clean
```

Is ka matlab hai ke tamam changes commit ho chuke hain aur working directory clean hai.

---

## Quick Revision

### Complete first-time setup

```bash
git --version
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
git config --global init.defaultBranch main
```

### Complete first repository sequence

```bash
mkdir my-project
cd my-project
git init
echo "# My Project" > README.md
git add README.md
git commit -m "Add initial README"
git branch -M main
git remote add origin https://github.com/USERNAME/my-project.git
git push -u origin main
```

### Normal daily cycle

```text
Edit → Check → Stage → Commit → Pull → Push
```

```bash
git status
git diff
git add .
git commit -m "Describe the change"
git pull
git push
```

---

## Official References

- [Installing Git — Git SCM](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- [Set up Git — GitHub Docs](https://docs.github.com/en/get-started/git-basics/set-up-git)
- [About authentication to GitHub](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/about-authentication-to-github)
- [Connecting to GitHub with SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [Adding locally hosted code to GitHub](https://docs.github.com/en/migrations/importing-source-code/using-the-command-line-to-import-source-code/adding-locally-hosted-code-to-github)
- [Managing remote repositories](https://docs.github.com/en/get-started/git-basics/managing-remote-repositories)

---

**Study Tip:** Har command ko aik choti practice repository mein khud run karein. Git us waqt asaan lagta hai jab aap samajhte hain ke har command working directory, staging area, local repository ya remote repository mein kya tabdeeli karti hai.
