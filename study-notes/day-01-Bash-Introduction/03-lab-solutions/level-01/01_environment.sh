#!/bin/bash

# Create a labelled shell environment report.

{
    echo "Configured shell: $SHELL"
    echo "Current shell process: $0"
    echo "Bash version: $BASH_VERSION"
    echo "User: $USER"
    echo "Home directory: $HOME"
    echo "Working directory: $PWD"
    echo "PATH: $PATH"
} > environment.txt

echo "Environment report saved to environment.txt"

