#!/bin/bash

# Give instructions for a traffic-light color.

read -r -p "Enter red, yellow, or green: " light

if [[ "$light" == "red" ]]; then
    echo "Stop."
elif [[ "$light" == "yellow" ]]; then
    echo "Get ready."
elif [[ "$light" == "green" ]]; then
    echo "Go."
else
    echo "Error: unknown traffic-light color." >&2
    exit 1
fi

