#!/bin/bash

read -r -p "Enter username: " username
read -r -s -p "Enter fake practice token: " token
echo

token_length="${#token}"

echo "Username: $username"
echo "Token length: $token_length"
echo "The token will not be displayed."

unset token
