PS1='$(code=${?##0};echo "\[\e[0;91m\]${code:+${code}}\[\e[0m\]")\n\w $(git symbolic-ref --short HEAD 2>/dev/null)\n\$ '
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
alias ls='ls -C --color'
alias l='ls -lAh --color'

eval "$(starship init bash)"

alias ga='git add'
alias gs='git status'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gc='git commit'
alias gb='git branch'
alias gr='git remote'
alias grb='git rebase'
alias gco='git checkout'
alias gcmsg='git commit -m'
