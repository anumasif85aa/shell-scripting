| Operator | Checks whether the path...                   | Example                 |
| -------- | -------------------------------------------- | ----------------------- |
| `-e`     | Exists                                       | `[[ -e "$file" ]]`      |
| `-f`     | Exists and is a regular file                 | `[[ -f "$file" ]]`      |
| `-d`     | Exists and is a directory                    | `[[ -d "$directory" ]]` |
| `-L`     | Is a symbolic link                           | `[[ -L "$link" ]]`      |
| `-r`     | Is readable by the current user              | `[[ -r "$file" ]]`      |
| `-w`     | Is writable by the current user              | `[[ -w "$file" ]]`      |
| `-x`     | Is executable/searchable by the current user | `[[ -x "$file" ]]`      |
| `-s`     | Exists and is not empty                      | `[[ -s "$file" ]]`      |
| `-b`     | Is a block-device file                       | `[[ -b "$device" ]]`    |
| `-c`     | Is a character-device file                   | `[[ -c "$device" ]]`    |
| `-p`     | Is a named pipe                              | `[[ -p "$pipe" ]]`      |
| `-S`     | Is a socket                                  | `[[ -S "$socket" ]]`    |
| `-u`     | Has the SUID permission                      | `[[ -u "$file" ]]`      |
| `-g`     | Has the SGID permission                      | `[[ -g "$file" ]]`      |
| `-k`     | Has the sticky bit                           | `[[ -k "$directory" ]]` |
| `-O`     | Is owned by the effective current user       | `[[ -O "$file" ]]`      |
| `-G`     | Is owned by the effective current group      | `[[ -G "$file" ]]`      |
| `-N`     | Was modified since it was last read          | `[[ -N "$file" ]]`      |
