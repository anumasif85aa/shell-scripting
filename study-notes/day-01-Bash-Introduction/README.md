# Bash and Bash Scripting — Complete Learning Package

This package teaches Bash from the first terminal command to reliable
DevOps-style automation.

## Package Contents

| Folder | Contents |
|---|---|
| `01-study-notes/` | Bash from scratch to advanced |
| `02-student-labs/` | Three progressive labs with six tasks each |
| `02-student-labs/artifacts/` | Safe practice data, configuration, and logs |
| `03-lab-solutions/` | Separate solutions for all 18 tasks |
| `04-posters/` | Two printable classroom posters |
| `05-mcqs/` | Interactive 50-question HTML exam |

## Recommended Learning Order

1. Read the study notes section by section.
2. Complete Level 1 without looking at the solutions.
3. Check scripts with `bash -n`.
4. Complete Level 2 using the supplied artifacts.
5. Complete Level 3 as a small DevOps automation project.
6. Compare your work with the solutions.
7. Review both posters.
8. Attempt the MCQ exam and review missed questions.

## Learning Outcomes

Students will be able to:

- Explain the shell, terminal, kernel, and Bash.
- Navigate Linux and combine commands safely.
- Write, document, validate, and execute Bash scripts.
- Work with streams, redirection, variables, input, and arguments.
- Use conditions, loops, functions, arrays, files, and commands.
- Handle errors, exit statuses, traps, and temporary files.
- Debug scripts and write safer automation.
- Build a practical system-report and log-analysis workflow.

## Safe Practice

The supplied labs do not require `sudo` and do not modify real services or user
accounts.

```bash
bash -n script.sh
chmod u+x script.sh
./script.sh
```

