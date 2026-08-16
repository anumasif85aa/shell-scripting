#!/bin/bash

# Title: Variables and Quoting
# Purpose: Store and display a name and role.

# Define variables (no spaces around '=' sign)
NAME="Khalid"           # Assigns the string "Khalid" to the variable NAME
ROLE="DevOps Engineer"  # Assigns the string "DevOps Engineer" to the variable ROLE

# Print message using variable expansion inside double quotes
echo "Hello, I am $NAME and I am a $ROLE."

echo  # Output a blank line for formatting
echo "Double quotes: Hello, $NAME"  # Double quotes allow variable expansion ($NAME becomes Khalid)
echo 'Single quotes: Hello, $NAME'  # Single quotes treat text literally ($NAME is printed as text)

exit 0  # Exit the script successfully with status code 0