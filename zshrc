# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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


_oh_my_zsh() {
  export ZSH="$HOME/.oh-my-zsh"
  #ZSH_THEME="robbyrussell"
  ZSH_THEME="powerlevel10k/powerlevel10k"
  plugins=(git)
  source $ZSH/oh-my-zsh.sh
}

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

# TODO: Verify this is needed, move to macOS specific file under .config if it i
# [[ $(uname) == Darwin ]] && launchctl setenv PATH $PATH

_oh_my_zsh
_zsh_settings
_custom_plugins

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

command_exists zoxide && eval "$(zoxide init zsh)"
command_exists /opt/homebrew/bin/brew && eval "$(/opt/homebrew/bin/brew shellenv)"
# TODO: make a source_if_exists function
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

[[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]] && source /opt/homebrew/opt/asdf/libexec/asdf.sh
