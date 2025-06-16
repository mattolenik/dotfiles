# ~/.zshrc
export ZSH_DOT_DIR="$HOME/.zsh"

export PATH="$HOME/go/bin:/opt/homebrew/bin:$PATH"

eval "$(starship init zsh)"

for f in "$ZSH_DOT_DIR"/functions/*; do
  source $f
done
source "$ZSH_DOT_DIR/aliases"

source ~/.zsh/plugins/fzf/fzf.plugin.zsh


# bun completions
[ -s "/Users/matt/.bun/_bun" ] && source "/Users/matt/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"


export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"

