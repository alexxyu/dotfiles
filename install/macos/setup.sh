#!/bin/bash

echo_bold() {
    bold=$(tput bold)
    normal=$(tput sgr0)
    echo "${bold}$1${normal}"
}

#################
# Initial setup #
#################

echo_bold "Setting up homebrew"
sudo chown -R $(whoami):admin /usr/local
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew update

#########################
# Install brew packages #
#########################

echo_bold "Installing packages from brewfile"
REPO_PATH=$(git rev-parse --show-toplevel)
brew bundle --file="$REPO_PATH/homebrew/Brewfile"

##################################
# Install any extra dependencies #
##################################

# Rust
echo_bold "Installing rust via rustup script"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# bpython
echo_bold "Installing bpython via pip"
pip install --user bpython

# Temporarily source the cargo env to make it available in this shell
. "$HOME/.cargo/env"

# mise
echo_bold "Installing mise via cargo"
cargo install --root ~/.local mise

# rust-script
echo_bold "Installing rust-script via cargo"
cargo install rust-script

# set up symlink for coreutils ls
ln -s $(brew --prefix)/opt/coreutils/libexec/gnubin/ls ~/.local/bin/ls

################################
# Set zsh as the default shell #
################################

chsh -s $(which zsh)

