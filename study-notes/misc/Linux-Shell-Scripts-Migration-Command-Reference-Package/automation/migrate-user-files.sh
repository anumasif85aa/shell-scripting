#!/bin/bash

# Title: Reusable User File Migration Tool
# Purpose: Safely copy or move selected files into an existing user's home.
# Safety: Dry-run by default; changes require --apply.

set -Eeuo pipefail

readonly script_name="${0##*/}"

source_dir=""
target_user=""
target_home_override=""
destination=""
action="copy"
recursive=false
apply=false
overwrite=false
dir_mode="750"
file_mode="640"
exec_mode="750"
patterns=()

show_help()
{
    echo "Usage:"
    echo "  sudo ./$script_name --source DIR --user USER --destination RELATIVE_PATH \\"
    echo "      --pattern GLOB [--pattern GLOB ...] [OPTIONS]"
    echo
    echo "Required options:"
    echo "  --source DIR             Directory containing files to migrate"
    echo "  --user USER              Existing target user"
    echo "  --destination PATH       Relative path beneath the target home"
    echo "  --pattern GLOB           Filename pattern; repeat for more types"
    echo
    echo "Operation options:"
    echo "  --copy                    Copy files; this is the default"
    echo "  --move                    Move files instead of copying"
    echo "  --recursive               Search through source subdirectories"
    echo "  --overwrite               Replace existing destination files"
    echo "  --apply                   Perform changes; otherwise dry-run"
    echo
    echo "Permission options:"
    echo "  --dir-mode MODE           Directory mode; default: 750"
    echo "  --file-mode MODE          Non-executable file mode; default: 640"
    echo "  --exec-mode MODE          Executable file mode; default: 750"
    echo
    echo "Advanced option:"
    echo "  --target-home DIR         Override the home returned by getent"
    echo "  -h, --help                Display this help"
    echo
    echo "Examples:"
    echo "  sudo ./$script_name --source /root --user khan \\"
    echo "      --destination shell-scripts --pattern '*.sh'"
    echo
    echo "  sudo ./$script_name --source /root --user ali \\"
    echo "      --destination migrated-files --pattern '*.sh' \\"
    echo "      --pattern '*.py' --pattern '*.conf' --recursive --apply"
}

error()
{
    echo "Error: $*" >&2
}

die()
{
    error "$*"
    exit 1
}

is_valid_mode()
{
    [[ "$1" =~ ^[0-7]{3,4}$ ]]
}

validate_relative_destination()
{
    local value="$1"
    local component
    local components=()

    [[ -n "$value" ]] || die "destination cannot be empty"
    [[ "$value" != /* ]] || die "destination must be relative to the target home"

    IFS='/' read -r -a components <<< "$value"
    for component in "${components[@]}"
    do
        [[ -n "$component" ]] || die "destination contains an empty path component"
        [[ "$component" != "." && "$component" != ".." ]] || \
            die "destination cannot contain '.' or '..' components"
    done
}

while (( $# > 0 ))
do
    case "$1" in
        --source)
            (( $# >= 2 )) || die "--source requires a value"
            source_dir="$2"
            shift 2
            ;;
        --user)
            (( $# >= 2 )) || die "--user requires a value"
            target_user="$2"
            shift 2
            ;;
        --target-home)
            (( $# >= 2 )) || die "--target-home requires a value"
            target_home_override="$2"
            shift 2
            ;;
        --destination)
            (( $# >= 2 )) || die "--destination requires a value"
            destination="$2"
            shift 2
            ;;
        --pattern)
            (( $# >= 2 )) || die "--pattern requires a value"
            patterns+=("$2")
            shift 2
            ;;
        --copy)
            action="copy"
            shift
            ;;
        --move)
            action="move"
            shift
            ;;
        --recursive)
            recursive=true
            shift
            ;;
        --overwrite)
            overwrite=true
            shift
            ;;
        --apply)
            apply=true
            shift
            ;;
        --dir-mode)
            (( $# >= 2 )) || die "--dir-mode requires a value"
            dir_mode="$2"
            shift 2
            ;;
        --file-mode)
            (( $# >= 2 )) || die "--file-mode requires a value"
            file_mode="$2"
            shift 2
            ;;
        --exec-mode)
            (( $# >= 2 )) || die "--exec-mode requires a value"
            exec_mode="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            die "unknown option: $1"
            ;;
    esac
done

(( EUID == 0 )) || die "run this script with sudo or as root"

[[ -n "$source_dir" ]] || die "--source is required"
[[ -n "$target_user" ]] || die "--user is required"
[[ -n "$destination" ]] || die "--destination is required"
(( ${#patterns[@]} > 0 )) || die "provide at least one --pattern"

getent passwd "$target_user" >/dev/null || die "user does not exist: $target_user"
target_group=$(id -gn "$target_user") || die "cannot determine primary group for $target_user"

[[ -d "$source_dir" ]] || die "source directory does not exist: $source_dir"
source_dir=$(readlink -f -- "$source_dir") || die "cannot resolve source directory"

if [[ -n "$target_home_override" ]]; then
    target_home="$target_home_override"
else
    target_home=$(getent passwd "$target_user" | cut -d: -f6)
fi

[[ -d "$target_home" ]] || die "target home does not exist: $target_home"
target_home=$(readlink -f -- "$target_home") || die "cannot resolve target home"

validate_relative_destination "$destination"
destination_root="$target_home/$destination"

if $recursive && [[ "$destination_root/" == "$source_dir/"* ]]; then
    die "recursive destination cannot be located inside the source directory"
fi

is_valid_mode "$dir_mode" || die "invalid directory mode: $dir_mode"
is_valid_mode "$file_mode" || die "invalid file mode: $file_mode"
is_valid_mode "$exec_mode" || die "invalid executable mode: $exec_mode"

find_command=(find "$source_dir")
$recursive || find_command+=(-maxdepth 1)
find_command+=(-type f '(')

for pattern_index in "${!patterns[@]}"
do
    (( pattern_index == 0 )) || find_command+=(-o)
    find_command+=(-name "${patterns[$pattern_index]}")
done

find_command+=(')' -print0)

matched_files=()
mapfile -d '' -t matched_files < <("${find_command[@]}" | sort -z)

if (( ${#matched_files[@]} == 0 )); then
    echo "No matching files found."
    exit 3
fi

echo "===== Migration Plan ====="
echo "Source:       $source_dir"
echo "Target user:  $target_user"
echo "Target group: $target_group"
echo "Target home:  $target_home"
echo "Destination:  $destination_root"
echo "Action:       $action"
echo "Recursive:    $recursive"
echo "Overwrite:    $overwrite"
echo "Apply:        $apply"
echo "Patterns:     ${patterns[*]}"
echo "Matches:      ${#matched_files[@]}"
echo

if ! $apply; then
    echo "DRY RUN: no files or directories will be changed."
    echo "Add --apply after reviewing the plan."
    echo
fi

if $apply; then
    install -d -o "$target_user" -g "$target_group" -m "$dir_mode" -- "$destination_root"
fi

processed=0
skipped=0

for source_file in "${matched_files[@]}"
do
    relative_path="${source_file#"$source_dir"/}"
    target_file="$destination_root/$relative_path"
    target_parent="${target_file%/*}"

    if [[ ( -e "$target_file" || -L "$target_file" ) && "$overwrite" == false ]]; then
        echo "SKIP: target already exists: $target_file"
        (( skipped += 1 ))
        continue
    fi

    if [[ -x "$source_file" ]]; then
        selected_mode="$exec_mode"
    else
        selected_mode="$file_mode"
    fi

    if ! $apply; then
        echo "DRY-RUN ${action^^}: $source_file -> $target_file"
        continue
    fi

    install -d -o "$target_user" -g "$target_group" -m "$dir_mode" -- "$target_parent"

    if [[ "$action" == "copy" ]]; then
        if $overwrite; then
            cp -a -f -- "$source_file" "$target_file"
        else
            cp -a -- "$source_file" "$target_file"
        fi
    else
        if $overwrite; then
            mv -f -- "$source_file" "$target_file"
        else
            mv -- "$source_file" "$target_file"
        fi
    fi

    chown "$target_user:$target_group" -- "$target_file"
    chmod "$selected_mode" -- "$target_file"
    echo "${action^^}: $source_file -> $target_file"
    (( processed += 1 ))
done

echo
echo "===== Summary ====="
echo "Matched:   ${#matched_files[@]}"
echo "Processed: $processed"
echo "Skipped:   $skipped"

if ! $apply; then
    echo "Status:    dry run completed"
else
    echo "Status:    migration completed"
fi
