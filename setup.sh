#!/usr/bin/env bash
set -exuo pipefail

brew install git bash dash zsh coreutils go jq ranger tree tmux thefuck wget xz upx shellcheck ripgrep neovim
brew cask install miniconda
brew tap thoughtbot/formulae
brew install rcm

git clone git@github.com:mattolenik/dotfiles.git "$HOME/.dotfiles"
git clone git@github.com:mattolenik/stdlib.sh.git "$HOME/.local/lib/stdlib.sh"

"$HOME/.local/share/nvim/install-envs.sh"

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

rcup
