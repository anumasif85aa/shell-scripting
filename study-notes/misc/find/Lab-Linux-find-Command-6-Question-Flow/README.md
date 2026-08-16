# Linux `find` Command — Six-Question Flow Lab

This package provides a connected hands-on lab for practising the Linux `find` command in a realistic application-support scenario.

## Package Contents

```text
Linux-find-Command-6-Question-Flow-Lab/
├── README.md
├── Linux-find-Command-6-Question-Flow-Lab.md
├── setup_find_lab.sh
└── supplied-data/
    └── find-lab-data/
```

## Quick Start

```bash
cd Linux-find-Command-6-Question-Flow-Lab
cd supplied-data/find-lab-data
```

Open the student lab in another terminal or Markdown viewer:

```bash
less ../../Linux-find-Command-6-Question-Flow-Lab.md
```

## Regenerate a Fresh Dataset

The supplied data is already included. To create a separate fresh copy:

```bash
cd Linux-find-Command-6-Question-Flow-Lab
chmod +x setup_find_lab.sh
bash setup_find_lab.sh ./find-lab-data
```

The setup script refuses to overwrite an existing path. Choose a new target name when repeating the lab.

## Skills Practised

- Starting paths and recursive searches
- `-name`, `-iname`, and `-type`
- `-maxdepth`, `-size`, `-mtime`, and `-empty`
- AND, OR, NOT, and grouped expressions
- `-exec ... {} +`
- `-print0` with a safe Bash read loop
- Preview-first cleanup and controlled deletion

## Safety

All destructive practice must remain inside the supplied lab directory. Never replace the lab path with `/`, `$HOME`, `/etc`, `/var`, or another real system location.

