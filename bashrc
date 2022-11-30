PS1='$(code=${?##0};echo "\[\e[0;91m\]${code:+${code}}\[\e[0m\]")\n\w $(git symbolic-ref --short HEAD 2>/dev/null)\n\$ '
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
alias ls='ls -C --color'
alias l='ls -lAh --color'

