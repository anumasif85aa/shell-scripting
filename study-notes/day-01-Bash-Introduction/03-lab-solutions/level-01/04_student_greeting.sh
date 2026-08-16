#!/bin/bash

# Read and validate a student name.

course="Bash Scripting"

read -r -p "Enter student name: " student_name

if [[ -z "$student_name" ]]; then
    echo "Error: student name cannot be empty." >&2
    exit 1
fi

echo "Student: $student_name"
echo "Course: $course"

