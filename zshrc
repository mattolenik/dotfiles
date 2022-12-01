[[ -f ~/.zsh/deco.zsh/deco.plugin.zsh ]] && source ~/.zsh/deco.zsh/deco.plugin.zsh
[[ -f ~/.zsh/zsh-async/async.plugin.zsh ]] && source ~/.zsh/zsh-async/async.plugin.zsh

# TODO: move functions to proper zsh autoload thing so they can be used outside of interactive shell

export EDITOR="nvim"

HOMEBREW_PREFIX="/opt/homebrew"

log() {
  [[ -z $LOG ]] && return
  print -P "$*\n" 1>&2
}

warn() {
  print -P "$(deco -f yellow "WARNING: $*")"
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

git_smartbranch() {
  [[ $(git rev-parse --is-inside-work-tree 2>/dev/null) == true ]] || return
  local changes="$([[ -n $(git status --porcelain) ]] && print ' *')"
  (git symbolic-ref --short HEAD 2>/dev/null || git branch | awk -F'[ ()]' '/HEAD detached at/ {print $3,$4,$5,$6}') | tr -d '\n'
  print $changes
}

go_version() {
  command_exists go || return
  go version | awk -F'go| ' '/go version go/ {print $5}'
}

versions() {
  printf "Go %s" "$(go_version)"
}

laststatus() {
  local s=$1
  local res=""
  if (( $s == 0 )); then
    res="$(deco -f 34 $s)"
  else
    res="$(deco -f 203 -u $s)"
  fi
  print -P "$res"
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
  PROMPT=$'\n''%~ $(git_smartbranch)'$'\n$ '
  # TODO: make colored RPROMPT work
  #RPROMPT='$(deco -f 245 $(versions)) $(laststatus)'
  #RPROMPT='$(laststatus $?)'
  RPROMPT='$?'
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

