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

unsetopt auto_cd

# Save history shared but only when exiting session
#setopt noincappendhistory
setopt inc_append_history
setopt nosharehistory

export EDITOR=nvim
#
# Source everything under zsh config dir
zshrcd="$HOME/.config/zsh"
[[ -d $zshrcd ]] && for f in $zshrcd/*; do source "$f"; done


# TODO: Verify this is needed, move to macOS specific file under .config if it i
# [[ $(uname) == Darwin ]] && launchctl setenv PATH $PATH
