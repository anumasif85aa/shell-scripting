#!/bin/bash

score="${1:-}"

if [[ -z "$score" ]]; then
    echo "Usage: $0 SCORE" >&2
    exit 1
elif [[ ! "$score" =~ ^[0-9]+$ ]]; then
    echo "Error: score must contain digits only." >&2
    exit 1
elif (( score < 0 || score > 100 )); then
    echo "Error: score must be from 0 to 100." >&2
    exit 1
elif (( score >= 90 )); then
    echo "Grade: A"
elif (( score >= 80 )); then
    echo "Grade: B"
elif (( score >= 70 )); then
    echo "Grade: C"
elif (( score >= 60 )); then
    echo "Grade: D"
else
    echo "Grade: F"
fi
