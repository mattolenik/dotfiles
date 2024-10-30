# ~/.zshrc
export ZSH_DOT_DIR="$HOME/.zsh"

export PATH="$HOME/go/bin:/opt/homebrew/bin:$PATH"

eval "$(starship init zsh)"

for f in "$ZSH_DOT_DIR"/functions/*; do
  source $f
done
source "$ZSH_DOT_DIR/aliases"

source ~/.zsh/plugins/fzf/fzf.plugin.zsh

