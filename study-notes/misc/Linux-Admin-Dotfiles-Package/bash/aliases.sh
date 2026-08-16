# Linux administration aliases
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'
alias c='clear'
alias h='history'
alias ports='ss -tulpn'
alias myip='hostname -I'
alias dfh='df -hT'
alias duh='du -sh'
alias freeh='free -h'
alias jc='journalctl -xe'
alias jcf='journalctl -f'
alias services='systemctl --type=service --state=running'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gl='git log --oneline --graph --decorate --all'
alias gp='git push'
alias gpl='git pull'
alias gd='git diff'
alias gb='git branch'
alias ..='cd ..'
alias ...='cd ../..'

mkcd() {
  [[ $# -eq 1 ]] || { echo 'Usage: mkcd <directory>' >&2; return 2; }
  mkdir -p -- "$1" && cd -- "$1"
}

extract() {
  [[ $# -eq 1 && -f "$1" ]] || { echo 'Usage: extract <archive-file>' >&2; return 2; }
  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz) tar xzf "$1" ;;
    *.tar.xz|*.txz) tar xJf "$1" ;;
    *.tar) tar xf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.gz) gunzip "$1" ;;
    *.zip) unzip "$1" ;;
    *.7z) 7z x "$1" ;;
    *.rar) unrar x "$1" ;;
    *) echo "Unsupported archive: $1" >&2; return 1 ;;
  esac
}
