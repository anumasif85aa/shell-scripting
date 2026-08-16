#!/bin/bash
# Solutions to bash-tasks.md
# Each task is a separate function. Uncomment a call at the bottom to run it,
# or copy a single function out into its own script.

set -uo pipefail   # not using -e globally since some tasks expect failures

# ------------------------------------------------------------------
# BEGINNER
# ------------------------------------------------------------------

# 1. Hello You
task1_hello_you() {
    read -p "Enter your name: " name   # -p shows a prompt, reads into $name
    echo "Hello, $name!"
}

# 2. Two Numbers
task2_two_numbers() {
    local a=$1 b=$2                     # $1/$2 = first two args passed to the function
    echo "Sum: $((a + b))"
    echo "Difference: $((a - b))"
    echo "Product: $((a * b))"
    if [ "$b" -ne 0 ]; then
        echo "Quotient: $((a / b))"     # integer division only
    else
        echo "Quotient: undefined (division by zero)"
    fi
}

# 3. Even or Odd
task3_even_or_odd() {
    local n=$1
    if (( n % 2 == 0 )); then           # (( )) is arithmetic evaluation
        echo "$n is even"
    else
        echo "$n is odd"
    fi
}

# 4. Simple Countdown
task4_countdown() {
    for i in {10..1}; do                # brace expansion, counts down
        echo "$i"
        sleep 1                          # remove/reduce if testing quickly
    done
    echo "Liftoff!"
}

# 5. File Checker
task5_file_checker() {
    local target=$1
    if [ -e "$target" ]; then           # -e = exists
        if [ -f "$target" ]; then
            echo "$target exists and is a regular file."
        elif [ -d "$target" ]; then
            echo "$target exists and is a directory."
        fi
    else
        echo "$target does not exist."
    fi
}

# ------------------------------------------------------------------
# INTERMEDIATE
# ------------------------------------------------------------------

# 6. Multiplication Table
task6_multiplication_table() {
    local n=$1
    for i in {1..10}; do
        echo "$n x $i = $((n * i))"
    done
}

# 7. Word Counter
task7_word_counter() {
    local sentence=$1                    # expects a single quoted argument
    local count
    count=$(echo "$sentence" | wc -w)    # wc -w counts whitespace-separated words
    echo "Word count: $count"
}

# 8. Array of Fruits
task8_array_fruits() {
    local fruits=(apple banana cherry mango kiwi)
    for i in "${!fruits[@]}"; do         # ${!arr[@]} = indices of the array
        echo "$i: ${fruits[$i]}"
    done
    echo "Total fruits: ${#fruits[@]}"   # ${#arr[@]} = element count
}

# 9. Grade Calculator
task9_grade_calculator() {
    local score=$1
    if   (( score >= 90 )); then grade="A"
    elif (( score >= 80 )); then grade="B"
    elif (( score >= 70 )); then grade="C"
    elif (( score >= 60 )); then grade="D"
    else grade="F"
    fi
    echo "Score $score -> Grade $grade"
}

# 10. Backup Script
task10_backup_script() {
    local backup_dir="backup"
    mkdir -p "$backup_dir"               # -p avoids error if it already exists
    local found=0
    for file in *.txt; do
        [ -e "$file" ] || continue        # skips if no .txt files match (glob didn't expand)
        cp "$file" "$backup_dir/"
        found=1
    done
    if [ "$found" -eq 1 ]; then
        echo "Backed up .txt files to $backup_dir/"
    else
        echo "No .txt files found to back up."
    fi
}

# 11. Sum a File of Numbers
task11_sum_file() {
    local file=$1
    local total=0
    while IFS= read -r line; do          # IFS= and -r preserve exact line content
        [ -n "$line" ] || continue        # skip blank lines
        total=$((total + line))
    done < "$file"
    echo "Total: $total"
}

# 12. Simple Menu
task12_simple_menu() {
    while true; do
        echo "1) Show date"
        echo "2) Show disk usage"
        echo "3) Exit"
        read -p "Choose an option: " choice
        case "$choice" in
            1) date ;;
            2) df -h ;;
            3) echo "Goodbye!"; break ;;  # break exits the while loop
            *) echo "Invalid option" ;;
        esac
    done
}

# ------------------------------------------------------------------
# ADVANCED
# ------------------------------------------------------------------

# 13. Password Generator
task13_password_generator() {
    local length=${1:-12}                # default to 12 if no argument given
    # /dev/urandom -> tr to keep only safe chars -> head -c to cut to length
    tr -dc 'A-Za-z0-9!@#$%^&*()_+' < /dev/urandom | head -c "$length"
    echo
}

# 14. Log File Analyzer
task14_log_analyzer() {
    local logfile=$1
    echo "INFO:  $(grep -c '^INFO'  "$logfile")"
    echo "WARN:  $(grep -c '^WARN'  "$logfile")"
    echo "ERROR: $(grep -c '^ERROR' "$logfile")"
    # grep -c counts matching lines; ^ anchors to start of line
}

# 15. Directory Size Report
task15_directory_size_report() {
    # du -sh */ : summarized, human-readable size of each top-level dir
    # sort -rh  : reverse sort, human-numeric aware (handles K/M/G suffixes)
    du -sh */ 2>/dev/null | sort -rh
}

# 16. Retry Wrapper
retry() {
    local max_attempts=3
    local delay=2
    local attempt=1
    local cmd=("$@")                     # capture the full command + its args as an array

    until "${cmd[@]}"; do                # run the command; loop until it succeeds
        if (( attempt >= max_attempts )); then
            echo "Command failed after $attempt attempts: ${cmd[*]}"
            return 1
        fi
        echo "Attempt $attempt failed. Retrying in ${delay}s..."
        sleep "$delay"
        ((attempt++))
    done
    echo "Command succeeded on attempt $attempt."
}
# usage: retry curl -sf https://example.com

# 17. CSV Column Extractor
task17_csv_column_extractor() {
    local file=$1
    local col=$2
    # -F',' sets comma as field separator; $col is dynamic via awk -v
    awk -F',' -v c="$col" '{print $c}' "$file"
}

# 18. Process Monitor
task18_process_monitor() {
    local proc_name=$1
    trap 'echo "Monitor stopped."; exit 0' INT   # catch Ctrl+C for clean exit
    echo "Monitoring '$proc_name' (Ctrl+C to stop)..."
    while true; do
        if ! pgrep -x "$proc_name" > /dev/null; then
            echo "ALERT: $proc_name is not running!"
        fi
        sleep 5
    done
}

# 19. Argument Parser
task19_argument_parser() {
    local name="" age="" verbose=0

    usage() {
        echo "Usage: $0 -n <name> -a <age> [-v]"
        return 1
    }

    # getopts reads flags defined in "n:a:v" — colon means the flag takes a value
    OPTIND=1                              # reset in case getopts was used before in this shell
    while getopts "n:a:v" opt "$@"; do
        case "$opt" in
            n) name=$OPTARG ;;
            a) age=$OPTARG ;;
            v) verbose=1 ;;
            *) usage; return 1 ;;
        esac
    done

    [ -z "$name" ] && { usage; return 1; }
    (( verbose )) && echo "[verbose] parsing complete"
    echo "Name: $name, Age: $age"
}
# usage: task19_argument_parser -n Alice -a 30 -v

# 20. Mini Task Runner
task20_mini_task_runner() {
    local commands_file=$1
    local strict=0
    [ "${2:-}" = "--strict" ] && strict=1

    local report="task_report.log"
    : > "$report"                        # truncate/create the report file

    while IFS= read -r cmd; do
        [ -n "$cmd" ] || continue
        local start end duration exit_code
        start=$(date +%s)
        eval "$cmd"                       # runs the line as a shell command
        exit_code=$?
        end=$(date +%s)
        duration=$((end - start))

        echo "CMD: $cmd | EXIT: $exit_code | TIME: ${duration}s" >> "$report"

        if [ "$strict" -eq 1 ] && [ "$exit_code" -ne 0 ]; then
            echo "Strict mode: stopping after failed command: $cmd"
            return 1
        fi
    done < "$commands_file"

    echo "Done. See $report"
}
# usage: task20_mini_task_runner commands.txt --strict

# ------------------------------------------------------------------
# Uncomment a line below to try a specific task when running this file directly
# ------------------------------------------------------------------
# task1_hello_you
# task2_two_numbers 10 3
# task3_even_or_odd 7
# task4_countdown
# task5_file_checker ./bash-solutions.sh
# task6_multiplication_table 5
# task7_word_counter "the quick brown fox"
# task8_array_fruits
# task9_grade_calculator 85
# task10_backup_script
# task11_sum_file numbers.txt
# task12_simple_menu
# task13_password_generator 16
# task14_log_analyzer app.log
# task15_directory_size_report
# retry echo "hi"
# task17_csv_column_extractor data.csv 2
# task18_process_monitor firefox
# task19_argument_parser -n Alice -a 30 -v
# task20_mini_task_runner commands.txt
