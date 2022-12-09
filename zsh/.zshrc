
disabled_plugins=(zsh-autocomplete hue)  # hue is loaded in .zshenv

for f in ~/.zsh/plugins/*/*.plugin.zsh; do
  name="${$(basename $f)%.plugin.zsh}"
  if (( $disabled_plugins[(Ie)$name] )); then
    continue
  fi
  source "$f";
done

[[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor

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

tfunc() {
  is_int 1 2 3
}
