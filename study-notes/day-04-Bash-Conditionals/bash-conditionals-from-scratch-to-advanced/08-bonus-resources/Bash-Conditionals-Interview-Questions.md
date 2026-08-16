# Bash Conditionals Interview Questions

## Questions with short answers

1. **How does Bash represent true and false?**  
   Status `0` means success/true; non-zero normally means failure/false.

2. **What closes an `if` block?**  
   `fi`.

3. **What is the role of `elif`?**  
   It tests another condition when previous branches were false.

4. **Why are spaces required inside `[[ ]]`?**  
   `[[` and `]]` are Bash syntax tokens and must be separate words.

5. **What is the difference between `[ ]` and `[[ ]]`?**  
   `[[ ]]` is Bash syntax with safer string handling and built-in pattern/regex support.

6. **How do you test an empty string?**  
   `[[ -z "$value" ]]`.

7. **How do you test a non-empty string?**  
   `[[ -n "$value" ]]`.

8. **How do you compare integers?**  
   Use `-eq`, `-ne`, `-gt`, `-ge`, `-lt`, and `-le`, or arithmetic `(( ))`.

9. **How do you test a regular file?**  
   `[[ -f "$file" ]]`.

10. **How do you test a directory?**  
    `[[ -d "$directory" ]]`.

11. **What does `-s` test?**  
    The file exists and has a size greater than zero.

12. **What does `&&` mean inside `[[ ]]`?**  
    Both conditions must be true.

13. **What does `||` mean?**  
    At least one condition must be true.

14. **What does `!` do?**  
    It reverses the condition result.

15. **Can a command be used directly after `if`?**  
    Yes. Bash checks the command's exit status.

16. **Why use `grep -q` in a condition?**  
    It returns a useful status without printing matching lines.

17. **How do you match filenames ending in `.log`?**  
    `[[ "$file" == *.log ]]`.

18. **How do you perform regex matching?**  
    `[[ "$value" =~ regex ]]`.

19. **Should the regex normally be quoted?**  
    No. Quoting the entire right-hand regex can change matching behavior.

20. **How do you validate argument count?**  
    Compare `$#` with the required number.

21. **Why send errors to `stderr`?**  
    It separates error messages from normal script output.

22. **When should a script return `exit 1`?**  
    When validation or the requested operation fails.

23. **Is `else` required?**  
    No. An `if` block can finish directly with `fi`.

24. **What does `bash -n` verify?**  
    Syntax only, not runtime logic.

25. **What is a safe automation decision flow?**  
    Validate input, check current state, perform the action, and verify the result.
