#################
# Initial setup #
#################
sudo chown -R $(whoami):admin /usr/local
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew update

#########################
# Install brew packages #
#########################
REPO_PATH=$(git rev-parse --show-toplevel)
brew bundle --file="$REPO_PATH/homebrew/Brewfile"

##################################
# Install any extra dependencies #
##################################

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# bpython
pip install bpython

# nvm
PROFILE=/dev/null bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash'

################################
# Set zsh as the default shell #
################################
chsh -s $(which zsh)

