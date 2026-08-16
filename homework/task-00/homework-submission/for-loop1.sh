 #!/bin/bash
 # enlist the fruit as a list
 fruits=("apple" "banana" "grapes" "mango" "orange")
   fruit_item=1
   for fruits in "${fruits[@]}"
   do
	   echo "fruit_item:$fruit_item=$fruits"
	   fruit_item=$((fruit_item+1))
   done
