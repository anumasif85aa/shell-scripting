#!/bin/bash
# table of a number entered by user
 echo "koi num entre karen"
 read num
   echo "table of $num"
   echo "-----------"
   for i in {1..10}
   do
     result=$((num*i))	   
  
	  echo "$num x $i = $result"
  done
