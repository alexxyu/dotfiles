#!/bin/bash

# update apt
sudo apt update && sudo apt upgrade && sudo apt autoremove

# apt install packages
sudo apt -y install zsh zsh-syntax-highlighting zsh-autosuggestions vim-gtk \
    curl python3 python3-pip python3-setuptools bpython tmux tree fzf jq \
    stow btop

# install packages that rely on custom scripts
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install cargo-update
cargo install git-delta
cargo install dua-cli
cargo install --locked zoxide
cargo install --locked bat

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

curl https://pyenv.run | bash

curl -fsSL https://get.docker.com | sh

curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

pip3 install thefuck --user

# git setup
echo "Setting up git-credential-manager..."
curl -L https://aka.ms/gcm/linux-install-source.sh | sh
sudo apt -y install pass
gpg --gen-key
read -p "Enter the gpg uid that you just created: " gpg_uid
pass init $gpg_uid

# set zsh as default shell
chsh -s $(which zsh)

