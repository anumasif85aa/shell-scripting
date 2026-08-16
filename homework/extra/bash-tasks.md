# Bash Scripting Practice Tasks
Beginner → Advanced. Solutions in `bash-solutions.sh`.

## Beginner

1. **Hello You** — Write a script that prints `"Hello, <name>!"` where `<name>` is read from user input via `read`.
2. **Two Numbers** — Take two numbers as command-line arguments and print their sum, difference, product, and quotient.
3. **Even or Odd** — Take a number as an argument and print whether it's even or odd.
4. **Simple Countdown** — Print numbers from 10 down to 1, then print "Liftoff!".
5. **File Checker** — Take a filename as an argument and print whether it exists, and if so, whether it's a file or a directory.

## Intermediate

6. **Multiplication Table** — Take a number `n` as an argument and print its multiplication table from 1 to 10.
7. **Word Counter** — Take a sentence as an argument (quoted) and print how many words it contains.
8. **Array of Fruits** — Create an array of 5 fruits, then print each one with its index, and print the total count.
9. **Grade Calculator** — Take a numeric score as an argument and print a letter grade (A/B/C/D/F) using if/elif or case.
10. **Backup Script** — Write a script that copies all `.txt` files in the current directory into a `backup/` folder, creating the folder if it doesn't exist.
11. **Sum a File of Numbers** — Given a file with one number per line, read it line by line and print the total sum.
12. **Simple Menu** — Build a loop-driven menu (using `case`) with options like "1) Show date, 2) Show disk usage, 3) Exit" that keeps prompting until the user exits.

## Advanced

13. **Password Generator** — Write a function that generates a random password of a given length (passed as an argument) using letters, digits, and symbols.
14. **Log File Analyzer** — Given a log file where each line starts with a log level (`INFO`, `WARN`, `ERROR`), count and print how many lines of each level exist.
15. **Directory Size Report** — Recursively find all subdirectories of the current directory and print each one's total size, sorted largest to smallest.
16. **Retry Wrapper** — Write a function `retry` that takes a command as an argument and retries it up to 3 times with a 2-second delay if it fails, then reports success/failure.
17. **CSV Column Extractor** — Given a CSV file and a column number as arguments, extract and print just that column for every row.
18. **Process Monitor** — Write a script that checks every 5 seconds whether a given process name is running, and prints an alert if it stops (use a loop + `trap` to allow clean exit on Ctrl+C).
19. **Argument Parser** — Write a script that accepts flags in any order (e.g. `-n name -a 30 -v`) using `getopts`, with a `-v` verbose flag and a usage message on invalid input.
20. **Mini Task Runner** — Build a script that reads a list of shell commands from a file (one per line), runs each one, logs its exit code and runtime to a report file, and stops early if `set -e`-style strict mode is enabled via a `--strict` flag.

## Tips for Attempting These
- Try each task yourself first — even a partial or broken attempt is more useful than reading the solution cold.
- Use `set -euo pipefail` as you get to intermediate tasks to build good habits early.
- For anything involving loops over files, test with `echo` before switching to real commands, to avoid surprises.
