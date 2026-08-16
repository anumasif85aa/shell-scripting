# Linux Admin Dotfiles - Roman Urdu Study Notes

## Dotfiles kya hoti hain?
Dotfiles Linux ki hidden configuration files hoti hain jin ka naam `.` se shuru hota hai. Ye shell, Vim aur doosri command-line applications ko customize karti hain.

### Important Files
- `.bashrc` → Interactive Bash shell settings
- `.bash_profile` → Login shell
- `.profile` → General shell startup
- `.vimrc` → Vim settings
- `.gitconfig` → Git settings

## Bash Configuration
```bash
export EDITOR="vim"
export VISUAL="vim"
export PAGER="less"
source ~/.bashrc
```

## Vim
- syntax on
- line numbers
- autoindent
- smartindent
- mouse support

## Environment Variables
```bash
export PATH="$HOME/.local/bin:$PATH"
export TZ="America/Chicago"
```

## Terminal Colors
`grep --color=auto` aur `ls --color=auto` output ko colorful banate hain.

## Bash History
History ko zyada commands aur timestamps ke sath save karta hai.

## PS1
Prompt mein username, hostname, current directory aur Git branch dikhayi ja sakti hai.

## Aliases
```bash
alias ll='ls -alF'
alias gs='git status'
```

## Installation
```bash
chmod +x install.sh
./install.sh
source ~/.bashrc
```

## Best Practices
- Backup lo.
- `source ~/.bashrc` chalana na bhoolo.
- Dotfiles ko Git mein rakho.
