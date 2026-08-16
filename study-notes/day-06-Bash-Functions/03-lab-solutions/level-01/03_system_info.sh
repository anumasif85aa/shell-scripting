#!/bin/bash

# Task 3: Simple system information

show_system_info()
{
    echo "User: $(whoami)"
    echo "Hostname: $(hostname)"
    echo "Date: $(date)"
    echo "Working directory: $(pwd)"
}

show_system_info

