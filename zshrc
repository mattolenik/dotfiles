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
export SAVEHIST=320000

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

EDITOR=nvim

# Instruct Claude Code to force output hyperlinks when running in herdr,
# which it does not normally recognize as a supported terminal for links.
[[ $TERM_PROGRAM == herdr ]] && export FORCE_HYPERLINK=1

# Codex prints "label (url)" for links in terminals it doesn't recognize, and it
# doesn't know herdr. Claim VTE (a generic emulator Codex treats as link-capable)
# so it shows only the link label.
codex() {
  if [[ $TERM_PROGRAM == herdr ]]; then
    TERM_PROGRAM=vte command codex "$@"
  else
    command codex "$@"
  fi
}

# Home sent as CSI H (e.g. Ghostty cmd+left) in addition to the default ^[OH.
bindkey '^[[H' beginning-of-line
