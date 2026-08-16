#!/bin/bash

# Task 4: Process any number of fruits

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 FRUIT [FRUIT ...]" >&2
    exit 1
fi

counter=1

for fruit in "$@"
do
    echo "Fruit $counter: $fruit"
    counter=$((counter + 1))
done

