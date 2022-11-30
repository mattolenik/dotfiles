# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#--------------------------------------#
# P10K variables are used by the rcm post-up hook, see ~/.dotfiles/hooks/post-up
export P10K_DIR="$HOME/.powerlevel10k"
export P10K_VERSION="v1.16.1"
#--------------------------------------#
export EDITOR="nvim"

HOMEBREW_PREFIX="/opt/homebrew"

log() {
  [[ -z $DEBUG ]] && return
  echo "$*" 1>&2
}

warn() {
  log "WARNING: $*"
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

aliases() {
  alias ls='ls -C --color'
  alias l='ls -lAh --color'
  alias cd=pushd
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

p10k() {
  source_if_exists "$P10K_DIR/powerlevel10k.zsh-theme"
  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  source_if_exists ~/.p10k.zsh
}

zsh_settings() {
  unsetopt auto_cd
  # Save history shared but only when exiting session
  #setopt noincappendhistory
  setopt inc_append_history
  setopt nosharehistory
}

aliases
asdf
custom_plugins
fuzzy_finder
homebrew
p10k
zsh_settings

# These functions helped with organization in this file and are unneeded elsewhere
unset -f aliases
unset -f asdf
unset -f custom_plugins
unset -f fuzzy_finder
unset -f homebrew
unset -f p10k
unset -f zsh_settings

