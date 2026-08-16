# Bash Functions — Complete Learning Package

This package teaches Bash functions in a gradual flow: first define and call a
function, then pass arguments and return status codes, and finally build
reusable DevOps-style helper functions.

## Package Contents

| Folder | Content |
|---|---|
| `01-study-notes/` | Functions from scratch to advanced |
| `02-student-labs/` | Three progressive labs, six tasks per lab |
| `03-lab-solutions/` | Separate, beginner-friendly Bash solutions |
| `04-poster/` | Printable Bash Functions learning poster |
| `05-mcqs/` | Interactive 25-question HTML quiz |

## Recommended Learning Order

1. Read `01-study-notes/Bash-Functions-From-Scratch-to-Advanced.md`.
2. Complete Lab 01 without looking at its solutions.
3. Complete Lab 02 and verify every return status.
4. Complete Lab 03 using the supplied artifacts.
5. Compare your scripts with `03-lab-solutions/`.
6. Open the poster for revision.
7. Open the MCQ HTML file in a browser and attempt the quiz.

## Safe Practice

Run the labs as a regular user. The exercises do not require root access and do
not modify system services.

Before executing a script, check its syntax:

```bash
bash -n script_name.sh
```

Then make it executable and run it:

```bash
chmod u+x script_name.sh
./script_name.sh
```

## Learning Outcomes

After completing the package, students should be able to:

- Define and call Bash functions.
- Pass values through function arguments.
- Use `$1`, `$#`, and `"$@"` inside functions.
- Understand output versus return status.
- Use `local` variables to avoid unwanted changes.
- Validate input and return success or failure.
- Call functions inside conditions.
- Reuse functions from a separate library file.
- Build readable automation scripts from small reusable blocks.

