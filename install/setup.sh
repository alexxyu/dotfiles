#!/bin/bash

mkdir -p ~/.config

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
mv ~/.config/nvim $BACKUP_DIR 2>/dev/null
mv ~/.config/powerlevel10k $BACKUP_DIR 2>/dev/null

# Create symlinks to dotfiles in repo
REPO_DIR=$(git rev-parse --show-toplevel)
cd $REPO_DIR
stow -t ~ git
stow -t ~ zsh
mkdir -p ~/.config/nvim && stow -t ~/.config/nvim nvim
mkdir -p ~/.config/powerlevel10k && cd config && stow -t ~/.config/powerlevel10k powerlevel10k && cd -

echo "Successfully linked dotfiles to this repo! Your old dotfiles have been moved to $BACKUP_DIR."
echo

echo "Installing vim plugins for convenience..."
vim +'PlugInstall --sync' +qa

