#!/bin/bash

# Task 4: Local variable

fruit="apple"

change_fruit()
{
    local fruit="banana"
    echo "Inside function: $fruit"
}

change_fruit
echo "Outside function: $fruit"

