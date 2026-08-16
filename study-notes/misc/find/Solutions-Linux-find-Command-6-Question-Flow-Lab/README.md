# Linux `find` Command Flow Lab — Instructor Solutions

This package contains the answer guide and verified scripts for the six-question Linux `find` command flow lab.

## Contents

```text
Linux-find-Command-6-Question-Flow-Lab-Solutions/
├── README.md
├── Linux-find-Command-6-Question-Flow-Lab-Solutions.md
└── solution-scripts/
    ├── build-file-report.sh
    └── cleanup-cache.sh
```

## Use with the Student Package

Keep this solution package separate from the student lab. The scripts are designed to run inside a fresh copy of the supplied `find-lab-data` directory.

Copy the scripts into the data directory:

```bash
cp -- solution-scripts/*.sh /path/to/find-lab-data/
cd /path/to/find-lab-data
```

Validate them:

```bash
bash -n build-file-report.sh
bash -n cleanup-cache.sh
```

Run the report solution:

```bash
bash build-file-report.sh .
```

Test cleanup in dry-run mode first:

```bash
bash cleanup-cache.sh cache
```

Use apply mode only inside the disposable lab dataset:

```bash
bash cleanup-cache.sh cache --apply
```

## Safety

The cleanup script refuses `/`, the current user's home directory, an empty target, a missing directory, unsupported options, and extra arguments. It performs no deletion unless `--apply` is supplied and the user enters exactly `yes`.

