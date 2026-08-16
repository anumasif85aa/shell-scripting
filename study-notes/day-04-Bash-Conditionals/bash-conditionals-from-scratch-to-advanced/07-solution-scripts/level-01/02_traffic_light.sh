#!/bin/bash

read -r -p "Enter traffic-light color (red/yellow/green): " light

if [[ "$light" == "red" ]]; then
    echo "Stop"
elif [[ "$light" == "yellow" ]]; then
    echo "Get ready"
elif [[ "$light" == "green" ]]; then
    echo "Go"
else
    echo "Error: enter red, yellow, or green." >&2
    exit 1
fi

exit 0
