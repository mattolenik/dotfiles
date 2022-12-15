if ! [[ $COLORTERM = *(24bit|truecolor)* ]]; then
  zmodload zsh/nearcolor
fi

source "$ZDOTDIR/loadfuncs"

autoload -Uz compinit
compinit

disabled_plugins=(F-Sy-H fzf-tab)

source "$ZPLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh"

for f in $ZPLUGIN_DIR/*/*.plugin.zsh; do
  name="${$(basename $f)%.plugin.zsh}"
  if (( $disabled_plugins[(Ie)$name] )); then
    continue
  fi
  source "$f";
done
unset f name disabled_plugins

source "$ZPLUGIN_DIR/fast-syntax-highlighting/F-Sy-H.plugin.zsh"

bindkey -v  # vi keybindings, starts in insert mode

export EDITOR="nvim"

unsetopt auto_cd
# Save history shared but only when exiting session
#setopt noincappendhistory
setopt inc_append_history
setopt nosharehistory
setopt PROMPT_SUBST
setopt autopushd
setopt ignoreeof # don't exit on ^D

autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^[[A' history-beginning-search-backward-end
bindkey '^[[B' history-beginning-search-forward-end

source "$ZDOTDIR/aliases"
source "$ZDOTDIR/prompt"

# fzf-tab preferences and theming
#
# autocomplete for cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'tree-compact $realpath'
# autocomplete for kill

zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

if ! is_macos && command_exists systemctl; then
  zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
fi

zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $word | delta'

zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
	'git log --color=always $word'

zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
	'git help $word | bat -plman --color=always'

zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
	esac'

zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'

