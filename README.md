# Dotfiles

My dotfiles, slowly being curated over time working on Mac and Linux machines.

## Structure of this repo

Dotfiles are organized by application, so `.zshrc` lives in the `zsh` directory, etc. There is an
`apps` directory for configs that aren't explicitly dotfiles and likely need to be imported to
whatever application.

## How to use

Clone the repo, and run the install script located at `setup.sh`. This will setup all necessary
packages for whatever OS you are currently running (Linux and MacOS supported). This script will
additionally link the dotfiles to this repo using GNU `stow` and change the default shell to `zsh`.
