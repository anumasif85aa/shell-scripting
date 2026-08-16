# Bash Error Handling — Complete Learning Package

This package teaches Bash error handling from checking `$?` to building
reliable DevOps-style automation with validation, logging, retries, traps,
cleanup, and meaningful exit statuses.

## Package Contents

| Folder | Contents |
|---|---|
| `01-study-notes/` | Error handling from scratch to advanced |
| `02-student-labs/` | Three progressive labs with six tasks each |
| `02-student-labs/artifacts/` | Safe configuration, log, data, and source files |
| `03-lab-solutions/` | Separate solutions for all 18 tasks |
| `04-posters/` | Two printable classroom posters |
| `05-mcqs/` | Interactive 25-question HTML exam |

## Recommended Learning Order

1. Read the notes through the basic error-handling sections.
2. Complete Lab 01 without checking the solutions.
3. Check scripts with `bash -n`.
4. Complete Lab 02 using commands, pipelines, and functions.
5. Complete Lab 03 as a safe DevOps-style workflow.
6. Compare your scripts with the separate solutions.
7. Review both posters.
8. Attempt the MCQ exam and review missed questions.

## Learning Outcomes

Students will be able to:

- Distinguish syntax, runtime, validation, and logic errors.
- Understand and preserve command exit statuses.
- Send normal output to stdout and errors to stderr.
- Use `if`, `!`, `&&`, and `||` for controlled command handling.
- Design meaningful script and function return codes.
- Handle pipelines with `pipefail` and `PIPESTATUS`.
- Use strict-mode options with an understanding of their limitations.
- Create retries, timeouts, logs, traps, and safe cleanup.
- Test both successful and failing execution paths.

## Safe Practice

The labs do not require `sudo`, do not manage real services, and do not deploy
anything.

```bash
bash -n script.sh
chmod u+x script.sh
./script.sh
echo "$?"
```

