#!/bin/bash

# update apt
sudo apt update && sudo apt upgrade && sudo apt autoremove

# apt install packages
sudo apt -y install zsh zsh-syntax-highlighting zsh-autosuggestions vim-gtk \
    curl python3 python-pip bpython tmux tree fzf bat jq stow btop

# cleanup
ln -s /usr/bin/batcat ~/.local/bin/bat

# install packages that rely on custom scripts
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

curl -LSfs https://raw.githubusercontent.com/Byron/dua-cli/master/ci/install.sh | \
    sh -s -- --git Byron/dua-cli --crate dua --tag v2.17.4

curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

curl https://pyenv.run | bash

curl -fsSL https://get.docker.com | sh

# git setup
echo "Setting up git-credential-manager..."
curl -L https://aka.ms/gcm/linux-install-source.sh | sh
sudo apt -y install pass
gpg --gen-key
read -p "Enter the gpg uid that you just created: " gpg_uid
pass init $gpg_uid

# set zsh as default shell
chsh -s $(which zsh)

