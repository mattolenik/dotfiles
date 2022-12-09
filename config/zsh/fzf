# vi: ft=zsh

if command_exists rzf || ! command_exists rg; then
  print "WARNING: fuzzy finder setup requires fzf and ripgrep to be installed:\nhttps://github.com/junegunn/fzf\nhttps://github.com/BurntSushi/ripgrep"
fi

[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null

source "$HOME/.fzf/shell/key-bindings.zsh"
source ~/.fzf.zsh

export FZF_TMUX_OPTS="-d"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_CTRL_T_COMMAND='rg --files --smart-case --glob "!Applications/" --glob "!Applications (Parallels)" --glob "!Library"'
export FZF_DEFAULT_COMMAND='rg --files --hidden --smart-case --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border --extended'
