# TODO: sort this file, use plugin structure

for f in ~/.zsh/plugins/*/*.plugin.zsh; do source "$f"; done

autoload -U add-zsh-hook

[[ $COLORTERM = *(24bit|truecolor)* ]] || zmodload zsh/nearcolor

# Source everything under zsh config dir
zshrcd="$HOME/.config/zsh"
[[ -d $zshrcd ]] && for f in $zshrcd/*; do source "$f"; done

bindkey -v  # vi keybindings, starts in insert mode

export EDITOR="nvim"

benchmark_last() {
  local last="$(fc -ln -1)"
  hyperfine $@ "$last"
}

_prompt_git_info() {
  local pwd="$1"
  if ! is_git "$pwd"; then
    return
  fi
  alias _git="git -C $pwd"
  local changes branch remote remote_hash local_hash pushpull

  changes="$([[ -n $(_git status --porcelain) ]] && print -nP "$SYMBOL_CHANGES")"
  branch="$(_git symbolic-ref --short HEAD 2>/dev/null)"
  if [[ -z $branch ]]; then
    branch="$(_git branch | awk -F'[ ()]' '/HEAD detached at/ {print $3,$4,$5,$6}')"
  else
    remote="$(_git rev-parse --abbrev-ref --symbolic-full-name @{u})"
    remote="${remote%%/*}"
    remote_hash=($(_git ls-remote --head --exit-code "$remote"))
    remote_hash="${remote_hash[1]}"
    local_hash="$(_git rev-parse "$branch")"
    if [[ $local_hash != $remote_hash ]]; then
      if git merge-base --is-ancestor "$remote_hash" "$local_hash"; then
        pushpull="$SYMBOL_PUSH"
      elif git merge-base --is-ancestor "$local_hash" "$remote_hash"; then
        pushpull="$pushpull$SYMBOL_PULL"
      else
        # Often it won't be possible to tell if "pull" is truly the right thing to depict,
        # in those cases it's easier to just depict "out of sync."
        pushpull="$SYMBOL_OUTOFSYNC"
      fi
    fi
  fi
  unalias _git
  print -n "$(faintacc $branch) $changes${pushpull+"$pushpull"}"
}

_prompt_last_status() {
  local s=$1
  if (( s == 0 )); then
    pcolor "$s" green none bold
  else
    pcolor "$s" red none bold
  fi
}

_prompt_parts() {
  _prompt_vcs_info
}

_rprompt_parts() {
  _prompt_last_command_elapsed
}

_prompt_vcs_info() {
  print "$PROMPT_GIT_INFO"
}

_prompt_last_command_elapsed() {
  if [[ ! $TIMER_ELAPSED ]]; then return; fi
  local nt="$(nicetime $TIMER_ELAPSED)"
  if [[ -n $nt ]]; then
    print -n " took $nt"
  fi
}

_prompt_callback() {
### From https://github.com/mafredri/zsh-async
# 
# Get results from finished jobs and pass it to the to callback function. This is the only way to reliably return the job name,
# return code, output and execution time and with minimal effort.
# 
# If the async process buffer becomes corrupt, the callback will be invoked with the first argument being [async] (job name),
# non-zero return code and fifth argument describing the error (stderr).
# 
# The callback_function is called with the following parameters:
#
#    $1 job name, e.g. the function passed to async_job
#    $2 return code
#        Returns -1 if return code is missing, this should never happen, if it does, you have likely run into a bug.
#    $3 resulting (stdout) output from job execution
#    $4 execution time, floating point e.g. 0.0076138973 seconds
#    $5 resulting (stderr) error output from job execution
#    $6 has next result in buffer (0 = buffer empty, 1 = yes)
#        This means another async job has completed and is pending in the buffer, it's very likely that your callback function will be called a second time (or more) in this execution.
#        It's generally a good idea to e.g. delay prompt updates (zle reset-prompt) until the buffer is empty to prevent strange states in ZLE.
#
# Possible error return codes for the job name [async]:
#
#    1   Corrupt worker output.
#    2   ZLE watcher detected an error on the worker fd.
#    3   Response from async_job when worker is missing.
#    130 Async worker crashed, this should not happen but it can mean the file descriptor has become corrupt.
#        This must be followed by a async_stop_worker [name] and then the worker and tasks should be restarted.
#        It is unknown why this happens.
###
  if [[ $1 == '[async]' ]]; then
    if (( $2 > 0 )); then
      error "Async prompt update failed, exit code $2"
      print "Task stdout: $3\nTask stderr: $5"
      return
    fi
  fi

  PROMPT_GIT_INFO=$3
  if (( $6 == 0 )); then
    # Reset prompt but only if there are no other prompt callbacks going on
    zle reset-prompt
  fi
}

SYMBOL_PUSH="$(acc ⭡)"
SYMBOL_PULL="$(acc2 ⭣)"
SYMBOL_CHANGES="$(cau °)"
SYMBOL_OUTOFSYNC="$(cau ⮃)"
PROMPT_GIT_INFO=

add-zsh-hook preexec() {
  timer=$(($(print -P %D{%s%6.})/1000))
}

add-zsh-hook precmd (){
  PROMPT_DATETIME="$(date +'%Y-%m-%d %H:%M:%S')"
  async_job prompt_worker _prompt_git_info "$PWD"
  if [[ $timer ]]; then
    now=$(($(print -P %D{%s%6.})/1000))
    TIMER_ELAPSED=$((now-timer))
    unset timer
  fi
}

add-zsh-hook chpwd (){
  if is_git "$PWD"; then
    PROMPT_GIT_INFO="$(faintacc $(git_branchinfo_fast "$PWD"))"
  else
    PROMPT_GIT_INFO=""
  fi
  async_job prompt_worker _prompt_git_info "$PWD"
}

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

PROMPT=$'\n$(faint %~) $(_prompt_parts)\n%(!.#.\$) '
RPROMPT='$(_prompt_last_status $?)$(_rprompt_parts)'

# Setup async prompt
async_start_worker prompt_worker
async_register_callback prompt_worker _prompt_callback


### ALIASES ###

alias strip-color="$SED -r 's/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g'"
alias l='ls -lAh --color'
alias tree='tree -lahC'
alias gco='git checkout'
alias gb='git branch'
alias gr='git remote'
alias gl='git pull'
alias gs='git status'
alias ga='git add'
alias gcmsg='git commit -m'
alias gca='git commit --amend'
alias git-show-changed-files='git show --pretty="format:" --name-only'

alias livecat='watch --color -n 1 ccat --color=always'
alias edit-zshrc="$EDITOR ~/.zshrc"
alias source-zshrc='source ~/.zshrc'
alias edit-tmuxconf="$EDITOR ~/.tmux.conf"
alias http-get='curl -w "\n%{http_code}"'
alias http-post='curl -w "\n%{http_code}" -X POST'
alias http-put='curl -w "\n%{http_code}" -X PUT'
alias http-delete='curl -w "\n%{http_code}" -X DELETE'
alias http-head='curl -w "\n%{http_code}" -I'
alias http-get-status='curl -s -o /dev/null -w "%{http_code}"'
alias gitroot='git rev-parse --show-toplevel'
alias rg='rg --smart-case'

mkcd() { mkdir -p $1 && cd $1 }
pidof() { ps aux | grep -i "$1" | awk '{print $2}' }
mypidof() { ps ux | grep -i "$1" | awk '{print $2}' }
psinfo() { ps aux | grep -i "$1" }
mypsinfo() { ps ux | grep -i "$1" }
spy() { fswatch -0 -o "$1" | xargs -0 -n 1 -I {} ${@[2, -1]} }

command_exists mdfind && alias mdhere='mdfind -onlyin .'

tmuxx() {
  local session="${1:-main}"
  tmux new-session -t "$session"
}

alias grmg='() { go run main.go "$@"; }'

neovim() {
  if ! command -v &>/dev/null tmux; then
    echo "neovim function requires tmux" && return 1
  fi
  if ! command -v &>/dev/null nvr; then
    echo "neovim function requires neovim-remote pip package" && return 1
  fi
  NVIM_LISTEN_ADDRESS="/tmp/neovim-socket-$(tmux display-message -p '#I')" nvr --remote -s "$@"
}

alias pblast="echo \$(fc -ln -1) | tr -d '\n' | tee /dev/tty | pbcopy"

