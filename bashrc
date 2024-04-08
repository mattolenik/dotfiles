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


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/mambaforge/base/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/mambaforge/base/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/mamba.sh" ]; then
    . "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

