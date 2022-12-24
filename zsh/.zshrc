if ! [[ $COLORTERM = *(24bit|truecolor)* ]]; then
  zmodload zsh/nearcolor
fi

export EDITOR="nvim"
autoload -Uz compinit
compinit

_source() {
  for file in "$@"; do
    source "$ZDOTDIR/$file"
  done
}

## Plugins
_plugins() {
  local first_plugins=(fzf-tab)
  local last_plugins=(F-Sy-H)
  local other_plugins=()

  for f in "$ZPLUGIN_DIR"/*/*.plugin.zsh; do
    local name="${$(basename $f)%.plugin.zsh}"
    if ! (( $first_plugins[(Ie)$name] )) && ! (( $last_plugins[(Ie)$name] )); then
      other_plugins+=($name)
    fi
  done

  for p in $first_plugins; do
    loadplugin "$p"
  done

  for p in $other_plugins; do
    loadplugin "$p"
  done

  for p in $last_plugins; do
    loadplugin "$p"
  done
}

_setup() {
  _source shellopts loadfuncs widgets
  _plugins
  _source aliases prompt autocomplete
}

_setup

unfunction _plugins _setup _source

