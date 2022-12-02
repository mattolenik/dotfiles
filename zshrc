# TODO: sort this file
for f in ~/.zsh/plugins/*/*.plugin.zsh; do source "$f"; done
autoload -U add-zsh-hook

bindkey -v  # vi keybindings, starts in insert mode

export EDITOR="nvim"

HOMEBREW_PREFIX="/opt/homebrew"

log() {
  [[ -z $LOG ]] && return
  print -P "$*\n" 1>&2
}

warn() {
  print -P "$(deco -n -f yellow "WARNING: $*")"
}

command_exists() {
  command -v "$@" &> /dev/null
}

source_if_exists() {
  for file in "$@"; do
    if [[ -f $1 ]]; then
      log "sourcing file: '$file'"
      source "$file"
    else
      warn "file not found, unable to source: '$file'"
    fi
  done
}

is_git() {
  local pwd="$1"
  [[ $(git -C "$pwd" rev-parse --is-inside-work-tree 2>/dev/null) == true ]]
}

git_info() {
  local pwd="$1"
  if ! is_git "$pwd"; then
    return
  fi
  alias _git="git -C $pwd"
  local changes branch remote remote_hash local_hash

  changes="$([[ -n $(_git status --porcelain) ]] && print -nP " *")"
  branch="$(_git symbolic-ref --short HEAD 2>/dev/null)"
  if [[ -z $branch ]]; then
    branch="$(_git branch | awk -F'[ ()]' '/HEAD detached at/ {print $3,$4,$5,$6}') | tr -d '\n')"
  else
    remote="$(_git rev-parse --abbrev-ref --symbolic-full-name @{u})"
    remote="${remote%%/*}"
    remote_hash=($(_git ls-remote --head --exit-code "$remote"))
    remote_hash="${remote_hash[1]}"
    local_hash="$(_git rev-parse "$branch")"
    if [[ $local_hash != $remote_hash ]]; then
      # TODO: differentiate which is newer, show up/down accordingly
      branch="$branch ^"
    fi
  fi
  unalias _git
  print -n "$changes $branch"
}

go_version() {
  command_exists go || return
  go version | awk -F'go| ' '/go version go/ {print $5}'
}

versions() {
  print -n "Go $(go_version)"
}

laststatus() {
  local s=$1
  if (( s == 0 )); then
    print -n "%{%F{green}%}$s%{%F{reset}%}"
  else
    print -n "%{%F{red}%}$s%{%F{reset}%}"
  fi
}

aliases() {
  alias ls='ls -C --color'
  alias l='ls -lAh --color'
  alias tree='tree -lahC'
  alias cd=pushd
  alias gco='git checkout'
  alias gb='git branch'
  alias gr='git remote'
  alias gl='git pull'
  alias gcmsg='git commit -m'
  alias gca='git commit --amend'
}

asdf() {
  if [[ $(uname) == Darwin ]]; then
    source_if_exists "$HOMEBREW_PREFIX"/Cellar/asdf/*/libexec/asdf.sh
  else
    # TODO: asdf for Linux
  fi
}

custom_plugins() {
  # Source everything under zsh config dir
  zshrcd="$HOME/.config/zsh"
  [[ -d $zshrcd ]] && for f in $zshrcd/*; do source "$f"; done
}

fuzzy_finder() {
  command_exists fzf && source_if_exists ~/.fzf.zsh
}

homebrew() {
  [[ -f $HOMEBREW_PREFIX/bin/brew ]] && eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
}

zsh_settings() {
  unsetopt auto_cd
  # Save history shared but only when exiting session
  #setopt noincappendhistory
  setopt inc_append_history
  setopt nosharehistory
  setopt PROMPT_SUBST
  PROMPT=$'\n''%~ $GIT_INFO'$'\n$ '
  RPROMPT='$(laststatus $?) at ${date_string}'
}

worker_start() {
  async_start_worker prompt_worker
  async_register_callback prompt_worker prompt_callback
}

prompt_callback() {
  GIT_INFO="$3"
  if [[ $job == '[async]' ]]; then
    if (( return_code == 2 )); then
        # Need to restart the worker. Stolen from
        # https://github.com/mengelbrecht/slimline/blob/master/lib/async.zsh
        worker_start
    fi
    GIT_INFO="return code $return_code"
  fi
  #async_job prompt_worker git_info
  #[ $more == 1 ]] || zle reset-prompt ??
}

TMOUT=1
TRAPALRM() { zle reset-prompt }

worker_start

add-zsh-hook precmd (){
  date_string="$(date +'%Y-%m-%d %H:%M:%S')"
  async_job prompt_worker git_info "$PWD"
}

add-zsh-hook chpwd (){
  if ! is_git "$PWD"; {
    GIT_INFO=""
  }
}


aliases
asdf
custom_plugins
fuzzy_finder
homebrew
zsh_settings

# These functions helped with organization in this file and are unneeded elsewhere
unset -f aliases
unset -f asdf
unset -f custom_plugins
unset -f fuzzy_finder
unset -f homebrew
unset -f zsh_settings

