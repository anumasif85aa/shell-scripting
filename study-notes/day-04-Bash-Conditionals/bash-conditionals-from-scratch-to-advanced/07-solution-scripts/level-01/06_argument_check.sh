#!/bin/bash

if [[ "$#" -ne 2 ]]; then
    echo "Usage: $0 FRUIT1 FRUIT2" >&2
    exit 1
else
    echo "First fruit: $1"
    echo "Second fruit: $2"
    exit 0
fi
