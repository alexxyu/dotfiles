#!/bin/bash

mkdir -vp ~/.config

if [ "$(uname)" = "Darwin" ]; then
    echo "Detected Darwin platform, running MacOS setup..."
    ./install/macos/setup.sh
elif [ "$(uname)" = "Linux" ]; then
    echo "Detected Linux platform, running Linux setup..."
    ./install/linux/setup.sh
else
    echo "$(uname) is not supported!"
    exit 1
fi

# Delete existing dotfiles
BACKUP_DIR=~/.backup
mkdir -vp $BACKUP_DIR 2>/dev/null
mv -v ~/.gitconfig $BACKUP_DIR 2>/dev/null
mv -v ~/.gitignore_global $BACKUP_DIR 2>/dev/null
mv -v ~/.zshrc $BACKUP_DIR 2>/dev/null
mv -v ~/.config $BACKUP_DIR 2>/dev/null

# Create symlinks to dotfiles in repo
echo "Your old dotfiles have been moved to $BACKUP_DIR. Now linking dotfiles to this repo..."
REPO_DIR=$(git rev-parse --show-toplevel)
cd $REPO_DIR
stow -vt ~ git
stow -vt ~ zsh
mkdir -vp ~/.config && stow -vt ~/.config config

echo "Installing vim plugins for convenience..."
zsh -c ". ~/.zshrc; nvim +PlugInstall +qall"

