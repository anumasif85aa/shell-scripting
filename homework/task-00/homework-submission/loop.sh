#!/bin/bash
# title: fruit items
# purpose: creating fruits list with item no
  fruits=("grapes" "apple" "banana" "mango" "orange") 
   item_number=1
   for fruit in "${fruits[@]}"
   do
	   echo "item_number: $fruit"
	   item_number=$((item_number + 1))
   done 
