#!/bin/bash

# https://stackoverflow.com/a/51761312
get_latest_tag() {
    repo_name=$1
    latest_tag=$(git ls-remote --tags --refs --sort="v:refname" $repo_name | tail -n1 | sed 's/.*\///')
    echo $latest_tag
}

echo_bold() {
    bold=$(tput bold)
    normal=$(tput sgr0)
    echo "${bold}$1${normal}"
}

##############
# update apt #
##############

sudo apt update && sudo apt upgrade && sudo apt autoremove

########################
# apt install packages #
########################

sudo apt -y install zsh zsh-syntax-highlighting zsh-autosuggestions \
    curl python3 python3-pip python3-setuptools bpython tmux tree jq \
    stow btop ripgrep libssl-dev pass

################################################
# install packages that rely on custom scripts #
################################################

echo_bold "Installing httpie via pip"
pip install httpie

echo_bold "Installing rust via rustup script"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo_bold "Installing cargo-update via cargo"
cargo install cargo-update

echo_bold "Installing git-delta via cargo"
cargo install git-delta

echo_bold "Installing dua-cli via cargo"
cargo install dua-cli

echo_bold "Installing zoxide via cargo"
cargo install --locked zoxide

echo_bold "Installing bat via cargo"
cargo install --locked bat

echo_bold "Installing mise via cargo"
cargo install --root ~/.local mise

mkdir -p ~/.local/bin
fzf_version=$(get_latest_tag "https://github.com/junegunn/fzf")
echo_bold "Downloading fzf@$fzf_version from GitHub"
curl -Lo- https://github.com/junegunn/fzf/releases/download/$fzf_version/fzf-$fzf_version-linux_amd64.tar.gz | tar -xvzf - -C ~/.local/bin

echo_bold "Installing docker via installation script"
curl -fsSL https://get.docker.com | sh

echo_bold "Installing lazydocker via installation script"
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

echo_bold "Installing thefuck via pip"
pip3 install --user thefuck

echo_bold "Downloading latest neovim from GitHub"
sudo rm -rf /opt/nvim
curl -Lo- https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz | sudo tar -xzf - -C /opt
ln -s /opt/nvim-linux64/bin/nvim ~/.local/bin/nvim

echo_bold "Downloading NerdFont"
fontdir=/usr/local/share/fonts
sudo mkdir -p $fontdir/jetbrains-mono
curl -Lo- https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz | sudo tar -Jxvf - -C $fontdir/jetbrains-mono
sudo fc-cache -fv

echo_bold "Cloning powerlevel10k from GitHub"
git clone --depth=1 https://github.com/romkatv/powerlevel10k ~/.local/powerlevel10k

echo_bold "Installing git-credential-manager"
gcm_version=$(get_latest_tag "https://github.com/git-ecosystem/git-credential-manager")
curl -Lo- https://github.com/git-ecosystem/git-credential-manager/releases/download/$gcm_version/gcm-linux_amd64.${gcm_version:1}.tar.gz | sudo tar -xvf - -C ~/.local/bin

############################
# set zsh as default shell #
############################

echo_bold "Setting zsh as default shell"
chsh -s $(which zsh)

