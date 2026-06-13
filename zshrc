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

setopt HIST_IGNORE_SPACE
export SAVEHIST=32000

export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"
eval $(thefuck --alias)

# Bind Alt + Left/Right for word movement
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word

# Bind Shift + Left/Right for word movement (if desired)
bindkey '^[[1;2D' backward-word
bindkey '^[[1;2C' forward-word

alias cd=pushd

