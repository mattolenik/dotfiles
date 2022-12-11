export ZDOTDIR="$HOME/.zsh"
export ZPLUGIN_DIR="$ZDOTDIR/plugins"
export ZFUNC_DIR="$ZDOTDIR/functions"

zmodload zsh/parameter

source "$ZDOTDIR/loadfuncs"

if is_macos; then
  HOMEBREW_PREFIX="/opt/homebrew"
  if [[ -f $HOMEBREW_PREFIX/bin/brew ]]; then
    shellenv="$($HOMEBREW_PREFIX/bin/brew shellenv)"
    unexpected="$(grep -Ev '^export [A-Z_]+="[A-Za-z\_\-\$\:\{\}\/\+]+' <<< "$shellenv")"
    if [[ -n $unexpected ]]; then
      print "WARNING: brew shellenv created output that looks unusual.\n         Only export statements were expected but the following was found:\n$unexpected\n\nOutput of 'brew shellenv':\n$shellenv\n"
    else
      eval "$shellenv"
    fi
  fi
  unset shellenv unexpected

  source_if_exists "$HOMEBREW_PREFIX"/Cellar/asdf/*/libexec/asdf.sh
else
  # TODO: asdf for Linux
  #source_if_exists "$HOMEBREW_PREFIX"/Cellar/asdf/*/libexec/asdf.sh
fi

goroot=/usr/local/go
if [[ -x $goroot/bin/go ]]; then
  export GOPATH="$HOME/go"
  append_path "$GOPATH/bin"
  append_path "$goroot/bin"
fi
unset goroot

prepend_path "$HOME/.local/bin"

