#!/bin/bash

path="${1:-/var/log/my-app.log}"
filename="${path##*/}"
base_name="${filename%.*}"
extension="${filename##*.}"
length="${#filename}"

echo "Original path: $path"
echo "Filename: $filename"
echo "Base name: $base_name"
echo "Extension: $extension"
echo "Filename length: $length"
