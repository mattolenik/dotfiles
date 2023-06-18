# Nushell Environment Config File

def create_left_prompt [] {
    let path_segment = if (is-admin) {
        $"(ansi red_bold)($env.PWD)"
    } else {
        $"(ansi green_bold)($env.PWD)"
    }

    $path_segment
}

def create_right_prompt [] {
    let time_segment = ([
        (date now | date format '%m/%d/%Y %r')
    ] | str join)

    $time_segment
}

# Use nushell functions to define your right and left prompt
let-env PROMPT_COMMAND = { create_left_prompt }
let-env PROMPT_COMMAND_RIGHT = { create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
let-env PROMPT_INDICATOR = { "〉" }
let-env PROMPT_INDICATOR_VI_INSERT = { ": " }
let-env PROMPT_INDICATOR_VI_NORMAL = { "〉" }
let-env PROMPT_MULTILINE_INDICATOR = { "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand -n }
    to_string: { |v| $v | path expand -n | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.config-path | path dirname | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.config-path | path dirname | path join 'plugins')
]

let paths = [
  $'($env.HOME)/.asdf/shims',
  '/opt/homebrew/bin',
  '/opt/homebrew/sbin',
  $'($env.HOME)/.local/bin',
  $'($env.HOME)/go/bin',
  '/usr/local/go/bin',
  '/usr/local/bin'
]

let newPaths = ($paths | where { |p| $p not-in $env.PATH })

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
let-env PATH = ($env.PATH | split row (char esep) | prepend $newPaths)

let-env EDITOR = nvim

alias l = ls
alias tmuxx = tmux new-session -t main
alias popd = cd -
alias gs = git status
alias gp = git push
alias gc = git commit
alias gcmsg = git commit -m
alias gl = git pull
alias ga = git add
alias gb = git branch
alias gco = git checkout
alias gd = git diff
alias br = broot
alias dc-down = docker-compose -f docker-compose.yml down -v --rmi all
alias dc-up = docker-compose -f docker-compose.yml up --build
alias tree = tree -hC

alias ? = echo $env.LAST_EXIT_CODE