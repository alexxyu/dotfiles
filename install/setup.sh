#!/bin/bash

if [ "$(uname)" = "Darwin" ]; then
    echo "Detected Darwin platform, running MacOS setup..."
    ./macos/setup.sh
elif [ "$(uname)" = "Linux" ]; then
    echo "Detected Linux platform, running Linux setup..."
    ./linux/setup.sh
else
    echo "$(uname) is not supported!"
    exit 1
fi

# Delete existing dotfiles
BACKUP_DIR=~/.backup
mkdir -p $BACKUP_DIR 2>/dev/null
mv ~/.gitconfig $BACKUP_DIR 2>/dev/null
mv ~/.gitignore_global $BACKUP_DIR 2>/dev/null
mv ~/.vim $BACKUP_DIR 2>/dev/null
mv ~/.vimrc $BACKUP_DIR 2>/dev/null
mv ~/.zshrc $BACKUP_DIR 2>/dev/null

# Create symlinks to dotfiles in repo
REPO_DIR=$(git rev-parse --show-toplevel)
cd $REPO_DIR
stow -t ~ git
stow -t ~ vim
stow -t ~ zsh

# Setup git-credential-manager now since the gitconfig got overridden
if [ "$(uname)" = "Linux" ]; then
    # This is a hacky way to set the config in the .local/.gitconfig
    HOME=$HOME/.local git-credential-manager configure
    HOME=$HOME/.local git config --global credential.credentialStore gpg
fi

echo "Successfully linked dotfiles to this repo! Your old dotfiles have been moved to $BACKUP_DIR."
echo

