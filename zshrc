# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

export STDLIB=$HOME/stdlib.sh/stdlib.sh

# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# DISABLE_AUTO_UPDATE="true"
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
#ENABLE_CORRECTION="false"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git docker shrink-path terraform pipenv)
zshrcd="$HOME/.config/zshrc.d/"

source "$ZSH/oh-my-zsh.sh"

[[ -f $STDLIB ]] && source "$STDLIB"

unsetopt auto_cd

# Save history shared but only when exiting session
#setopt noincappendhistory
setopt inc_append_history
setopt nosharehistory

export EDITOR=nvim

alias livecat='watch --color -n 1 ccat --color=always'
alias edit-zshrc="$EDITOR ~/.zshrc"
alias source-zshrc='source ~/.zshrc'
alias edit-tmuxconf="$EDITOR ~/.tmux.conf"

[ -d $HOME/.config/zshrc.d ] && for f in $HOME/.config/zshrc.d/*; do source "$f"; done

alias http-get='curl -w "\n%{http_code}"'
alias http-post='curl -w "\n%{http_code}" -X POST'
alias http-put='curl -w "\n%{http_code}" -X PUT'
alias http-delete='curl -w "\n%{http_code}" -X DELETE'
alias http-head='curl -w "\n%{http_code}" -I'
alias http-get-status='curl -s -o /dev/null -w "%{http_code}"'

command_exists rg && alias rg='rg --smart-case'

mkcd() { mkdir -p $1 && cd $1 }
pidof() { ps aux | grep -i "$1" | awk '{print $2}' }
mypidof() { ps ux | grep -i "$1" | awk '{print $2}' }
psinfo() { ps aux | grep -i "$1" }
mypsinfo() { ps ux | grep -i "$1" }
spy() { fswatch -0 -o "$1" | xargs -0 -n 1 -I {} ${@[2, -1]} }

command_exists mdfind && alias mdhere='mdfind -onlyin .'
command_exists go && export GOPATH="$HOME/go" && export PATH="$GOPATH/bin:$PATH"

#USE_NVM=1
# nvm slows down shell startup time, only use it when needed
if [[ ! -z "$USE_NVM" ]]; then
  export NVM_DIR="$HOME/.nvm"
  . "/usr/local/opt/nvm/nvm.sh"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if command_exists pyenv; then
  eval "$(pyenv init -)"
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
fi

alias gitroot='git rev-parse --show-toplevel'

command_exists thefuck && eval $(thefuck --alias)

export PERSONAL_ARN="arn:aws:iam::635432930383:user/mattolenik"
