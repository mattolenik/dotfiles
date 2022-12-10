if ! [[ $COLORTERM = *(24bit|truecolor)* ]]; then
  zmodload zsh/nearcolor
fi

source "$ZDOTDIR/loadfuncs"

disabled_plugins=(zsh-autocomplete F-Sy-H)

for f in ~/.zsh/plugins/*/*.plugin.zsh; do
  name="${$(basename $f)%.plugin.zsh}"
  if (( $disabled_plugins[(Ie)$name] )); then
    continue
  fi
  source "$f";
done
unset f name disabled_plugins
source ~/.zsh/plugins/fast-syntax-highlighting/F-Sy-H.plugin.zsh

bindkey -v  # vi keybindings, starts in insert mode

export EDITOR="nvim"

unsetopt auto_cd
# Save history shared but only when exiting session
#setopt noincappendhistory
setopt inc_append_history
setopt nosharehistory
setopt PROMPT_SUBST
setopt autopushd

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^[[A' history-beginning-search-backward-end
bindkey '^[[B' history-beginning-search-forward-end

source "$HOME/.zsh/aliases"
source "$HOME/.zsh/prompt"

