 #!/bin/bash
 # table of num entred by user
   echo "koi num entre karen"
   read num

   echo "table of sum"echo "----------"
   for i in {1..10}
  do
	 result=$((num * i ))
	 echo "sum x $i = $result"
 done

