# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

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
plugins=(git docker)

source $ZSH/oh-my-zsh.sh

unsetopt auto_cd

# Save history shared but only when exiting session
setopt noincappendhistory
setopt nosharehistory

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
export PATH="$PATH:$HOME/bin"
export EDITOR=nvim

export AWS_DEFAULT_PROFILE=qa
alias livecat='watch --color -n 1 ccat --color=always'
alias edit-zshrc="$EDITOR ~/.zshrc"
alias source-zshrc='source ~/.zshrc'
alias edit-tmuxconf="$EDITOR ~/.tmux.conf"
alias checkaws='env | grep AWS'

if [ -d $HOME/.config/zshrc ]; then
  source $HOME/.config/zshrc/*
fi
alias mvn-debug='mvn -Dmaven.surefire.debug test'

alias http-get='curl -w "\n%{http_code}"'
alias http-post='curl -w "\n%{http_code}" -X POST'
alias http-put='curl -w "\n%{http_code}" -X PUT'
alias http-delete='curl -w "\n%{http_code}" -X DELETE'
alias http-head='curl -w "\n%{http_code}" -I'

pidof() { ps aux | grep -i "$1" | awk '{print $2}' }
mypidof() { ps ux | grep -i "$1" | awk '{print $2}' }
psinfo() { ps aux | grep -i "$1" }
mypsinfo() { ps ux | grep -i "$1" }

spy() { fswatch -0 -o "$1" | xargs -0 -n 1 -I {} ${@[2, -1]} }

aws-set-qa() { export AWS_PROFILE=qa; export AWS_DEFAULT_PROFILE=qa; export AWS_REGION=us-east-1; }
aws-set-personal() { export AWS_PROFILE=personal; export AWS_DEFAULT_PROFILE=personal; }
aws-set-profile() { export AWS_PROFILE=$1; export AWS_DEFAULT_PROFILE=$1; }


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FUZ_SEPARATOR="@@"
fuz() {
  local args="$*"
  local fzf_out=($(fzf))
  local subst="${args/$FUZ_SEPARATOR/$fzf_out[@]}"
  eval ${subst}
}

export GOPATH=$HOME/dev/go
export PATH="$PATH:$GOPATH/bin"
PY2BIN="$HOME/Library/Python/2.7/bin"
export PATH="$PY2BIN:$PATH"

powerline-daemon -q
loc=$(pip show powerline-status | grep Location)
powerline_repo_root=$([[ $loc =~ "^Location:[[:space:]](.*)$" ]] && echo $match[1])
