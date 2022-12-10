#!/bin/sh

export DOTDIR="${DOTDIR:-"$PWD/.."}"
# realpath doesn't work if the directory doesn't exist
mkdir -p "$DOTDIR"
DOTDIR="$(realpath "$DOTDIR")"

export TMUX_PLUGIN_DIR="${TMUX_PLUGIN_DIR:-"$HOME/.tmux/plugins"}"
mkdir -p "$TMUX_PLUGIN_DIR"
TMUX_PLUGIN_DIR="$(realpath "$TMUX_PLUGIN_DIR")"

export ZDOTDIR="${ZDOTDIR:-"$HOME/.zsh"}"
mkdir -p "$ZDOTDIR"
ZDOTDIR="$(realpath "$ZDOTDIR")"

export RCFIXES="zsh/.zshrc"

rcfixes() {
  (IFS=','; for f in $RCFIXES; do echo $f; done; )
}

fail() { echo "$*" 1>&2; exit 1; }
command_exists() { command -v "$1" >/dev/null 2>&1; }
require() { if ! command_exists "$1"; then fail "$1 is required for rcm post-up"; fi }

pname () { /bin/ps -o comm -p "$1" | tail -1; };
