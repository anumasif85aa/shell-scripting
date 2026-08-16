# Linux Admin Bash Configuration
[[ -n "${LINUX_ADMIN_DOTFILES_LOADED:-}" ]] && return
export LINUX_ADMIN_DOTFILES_LOADED=1

export EDITOR="${EDITOR:-vim}"
export VISUAL="${VISUAL:-vim}"
export PAGER="${PAGER:-less}"
export LESS="${LESS:--R -F -X}"
export GREP_COLORS="${GREP_COLORS:-ms=01;31:mc=01;31:fn=35:ln=32:bn=32:se=36}"

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTTIMEFORMAT="%F %T  "
shopt -s histappend checkwinsize cdspell globstar cmdhist lithist

PROMPT_COMMAND="history -a; history -n${PROMPT_COMMAND:+; $PROMPT_COMMAND}"

if command -v tput >/dev/null 2>&1 && [[ -t 1 ]] && [[ $(tput colors 2>/dev/null || echo 0) -ge 8 ]]; then
  export LESS_TERMCAP_mb="$(tput bold; tput setaf 1)"
  export LESS_TERMCAP_md="$(tput bold; tput setaf 6)"
  export LESS_TERMCAP_me="$(tput sgr0)"
  export LESS_TERMCAP_se="$(tput sgr0)"
  export LESS_TERMCAP_so="$(tput bold; tput setaf 3; tput setab 4)"
  export LESS_TERMCAP_ue="$(tput sgr0)"
  export LESS_TERMCAP_us="$(tput smul; tput setaf 2)"
fi

git_branch() {
  command git symbolic-ref --quiet --short HEAD 2>/dev/null ||
  command git rev-parse --short HEAD 2>/dev/null
}

set_admin_prompt() {
  local reset='\[\e[0m\]' green='\[\e[1;32m\]' blue='\[\e[1;34m\]'
  local cyan='\[\e[1;36m\]' yellow='\[\e[1;33m\]' red='\[\e[1;31m\]'
  local symbol='$'
  [[ $EUID -eq 0 ]] && symbol='#' && green="$red"
  PS1="${green}\u@\h${reset}:${blue}\w${reset}"
  local branch
  branch=$(git_branch)
  [[ -n "$branch" ]] && PS1+=" ${yellow}(${branch})${reset}"
  PS1+="\n${cyan}${symbol}${reset} "
}
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }set_admin_prompt"

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
  source /usr/share/bash-completion/bash_completion
elif [[ -r /etc/bash_completion ]]; then
  source /etc/bash_completion
fi

[[ -r "$HOME/.config/linux-admin-dotfiles/aliases.sh" ]] && source "$HOME/.config/linux-admin-dotfiles/aliases.sh"
