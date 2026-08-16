#!/bin/bash

# Demonstrate stdout and stderr.

echo "Script started successfully"
echo "This is a practice error" >&2

# Example:
# ./03_streams.sh > output.log 2> error.log

