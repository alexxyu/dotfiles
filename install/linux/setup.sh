#!/bin/bash

apt_install () {
    sudo apt -y install $1
    echo "$1 installed"
}

apt_install zsh
apt_install zsh-syntax-highlighting
apt_install zsh-autosuggestions
apt_install vim

apt install curl
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
apt_install python3
apt_install python-pip

apt_install bpython
apt_install tmux
apt_install tree
apt_install fzf
apt_install bat
apt_install jq
apt_install stow
sudo ln -s /usr/bin/batcat /usr/local/bin/bat

curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
echo "zoxide installed"

curl https://pyenv.run | bash
echo "pyenv installed"

curl -fsSL https://get.docker.com | sh
echo "docker installed"

