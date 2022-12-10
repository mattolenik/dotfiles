export ZDOTDIR="$HOME/.zsh"

zmodload zsh/parameter

source "$ZDOTDIR/loadfuncs"

# Setup homebrew if present
HOMEBREW_PREFIX="/opt/homebrew"
[[ -f $HOMEBREW_PREFIX/bin/brew ]] && eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

go_bin=/usr/local/go/bin
if [[ -x $go_bin ]]; then
  export GOPATH="$HOME/go"
  append_path "$GOPATH/bin"
  append_path "$go_bin"
fi

prepend_path "$HOME/.local/bin"

if is_macos; then
  source_if_exists "$HOMEBREW_PREFIX"/Cellar/asdf/*/libexec/asdf.sh
else
  # TODO: asdf for Linux
fi

