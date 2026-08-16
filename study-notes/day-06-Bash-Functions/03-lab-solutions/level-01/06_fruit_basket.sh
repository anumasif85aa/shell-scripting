#!/bin/bash

# Task 6: All function arguments

show_basket()
{
    echo "Number of fruits: $#"

    for fruit in "$@"
    do
        echo "Fruit: $fruit"
    done
}

show_basket "apple" "banana" "red cherry" "mango"

