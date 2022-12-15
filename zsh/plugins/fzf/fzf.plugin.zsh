# vi: ft=zsh

if ! command_exists fzf || ! command_exists rg; then
  print "WARNING: fuzzy finder setup requires fzf and ripgrep to be installed:\nhttps://github.com/junegunn/fzf\nhttps://github.com/BurntSushi/ripgrep"
fi

FZF_DIR="$HOME/.fzf"

[[ $- == *i* ]] && source "$FZF_DIR/shell/completion.zsh" 2> /dev/null
source "$FZF_DIR/shell/key-bindings.zsh"

declare -a ctrl_t_globs
declare -a ctrl_t_args

ctrl_t_globs=(
  '!go/pkg'
)

if is_macos; then
  ctrl_t_globs+=(
    '!Applications (Parallels)'
    '!Applications/'
    '!Library'
    '!Parallels'
    '!Pictures/*.photoslibrary'
  )
fi

for glob in $ctrl_t_globs; do
  ctrl_t_args+=(-g "'$glob'")
done

export FZF_TMUX_OPTS="-d"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
export FZF_CTRL_T_COMMAND="rg --files --smart-case${ctrl_t_args:+ ${ctrl_t_args[@]}}"
export FZF_DEFAULT_COMMAND='rg --files --hidden --smart-case --glob "!.git/*"'
export FZF_DEFAULT_OPTS='--height 40% --reverse --border --extended'

source_if_exists "$HOME/.fzf.zsh"

