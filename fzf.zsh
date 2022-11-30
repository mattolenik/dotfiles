# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/matt/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/matt/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/matt/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/matt/.fzf/shell/key-bindings.zsh"
