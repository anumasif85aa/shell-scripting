#!/bin/bash

# Task 1: Default function argument

greet()
{
    local name="${1:-Guest}"
    echo "Hello, $name"
}

greet "Ayesha"
greet

