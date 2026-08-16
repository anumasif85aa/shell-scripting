#!/bin/bash

read -r -p "Choose apple, banana, or cherry: " fruit

if [[ "$fruit" == "apple" ]]; then
    echo "You selected a red fruit."
elif [[ "$fruit" == "banana" ]]; then
    echo "You selected a yellow fruit."
elif [[ "$fruit" == "cherry" ]]; then
    echo "You selected a small red fruit."
else
    echo "Fruit is not available."
fi
