# Dotfiles

My dotfiles, slowly being curated over time working on Mac and Linux machines.

## Structure of this repo

Dotfiles are organized by application, so `.zshrc` lives in the `zsh` directory, etc. There is an
`apps` directory for configs that aren't explicitly dotfiles and likely need to be imported to
whatever application.

## How to use

Clone the repo, and run the install script located at `install/setup.sh`. This will setup all
necessary packages for whatever OS you are currently running. This script will additionally
link the dotfiles to this repo using GNU `stow` and change the shell default to `zsh`.

