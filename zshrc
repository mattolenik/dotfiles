# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export P10K_DIR="$HOME/.powerlevel10k"
export P10K_VERSION="v1.16.1"

BREWDIR=/opt/homebrew

export EDITOR=nvim

command_exists() {
  command -v "$@" &> /dev/null
}

source_if_exists() {
  if [[ -f $1 ]]; then
    source $1
  fi
}

error() { echo "$*" >&2; }
fail() { echo "$1" >&2; exit "${2:-1}"; }

_zsh_settings() {
  unsetopt auto_cd
  # Save history shared but only when exiting session
  #setopt noincappendhistory
  setopt inc_append_history
  setopt nosharehistory
}

_custom_plugins() {
  # Source everything under zsh config dir
  zshrcd="$HOME/.config/zsh"
  [[ -d $zshrcd ]] && for f in $zshrcd/*; do source "$f"; done
}

_fuzzy_finder() {
  [[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
}

_macos() {
  if [[ $(uname) != Darwin ]]; then
    return
  fi
  [[ -f $BREWDIR/bin/brew ]] && eval "$($BREWDIR/bin/brew shellenv)"
  source_if_exists $BREWDIR/../Cellar/asdf/*/libexec/asdf.sh
}

_p10k() {
  source_if_exists "$P10K_DIR/powerlevel10k.zsh-theme"
  # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
  source_if_exists ~/.p10k.zsh
}

_zsh_settings
_custom_plugins
_fuzzy_finder
_macos
_p10k

