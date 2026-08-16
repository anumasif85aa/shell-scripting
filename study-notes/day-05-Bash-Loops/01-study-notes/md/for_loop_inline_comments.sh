
#!/bin/bash

# Loop through a predefined list of items ("apple", "banana", "cherry")
for fruit in apple banana cherry  # Assigns each item one by one to the variable $fruit
do                                # Marks the start of the loop body
    echo "Fruit: $fruit"          # Prints "Fruit:" followed by the current value of $fruit
done                              # Marks the end of the loop body and moves to the next item

