# Bash Arguments — Complete Learning Package

This package teaches Bash positional parameters and command-line options from
the first argument to practical DevOps-style script interfaces.

## Package Contents

| Folder | Content |
|---|---|
| `01-study-notes/` | Bash arguments from scratch to advanced |
| `02-student-labs/` | Three progressive labs with six tasks each |
| `03-lab-solutions/` | Separate beginner-friendly solution scripts |
| `04-poster/` | Printable Bash Arguments classroom poster |
| `05-mcqs/` | Interactive 25-question HTML quiz |

## Recommended Learning Order

1. Read the study notes.
2. Complete Lab 01 using the fruit examples.
3. Complete Lab 02 to practise validation, loops, and `shift`.
4. Complete Lab 03 using the supplied practice artifacts.
5. Compare your work with the separate solutions.
6. Review the poster.
7. Attempt the interactive quiz.

## Learning Outcomes

Students will learn how to:

- Pass values to a Bash script.
- Use `$0`, `$1`, `$2`, `$#`, `"$@"`, and `"$*"`.
- Preserve arguments containing spaces.
- Provide default values.
- Validate argument count, numbers, and file paths.
- Process any number of arguments with loops.
- Use `shift` to process arguments one at a time.
- Parse named options manually and with `getopts`.
- Provide clear usage and error messages.
- Build practical argument-driven automation scripts.

## Safe Practice

The included labs do not require `sudo` and do not modify real services.

Check syntax before execution:

```bash
bash -n script_name.sh
```

Run a script:

```bash
chmod u+x script_name.sh
./script_name.sh argument
```

