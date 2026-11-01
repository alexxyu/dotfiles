# Dotfiles

My dotfiles setup using [nix](https://nixos.org) and [home-manager](https://github.com/nix-community/home-manager).

## Current Progress

This has been primarily tested on the following:
* My personal M1 MacBook (via [nix-darwin](https://github.com/LnL7/nix-darwin)).
* A NixOS-arm64 VM running on said MacBook.

This repo replicates the configuration in my [original dotfiles](https://github.com/alexxyu/dotfiles/tree/stow) backed by GNU stow.

## How to Use

**Note:** In order to properly symlink some dotfiles, this setup expects this repo to be cloned to your home directory like so:
`git clone https://github.com/alexxyu/dotfiles ~/.dotfiles`.

The repo is structured in the following manner:

```
.
├── home
│   ├── apps        # GUI applications
│   ├── etc         # misc
│   ├── shell       # CLI utilities
│   ├── default.nix # entrypoint + home-manager setup
├── hosts
│   ├── ...         # each directory should be for a single host
│   ├── system      # common configurations (managed by nix)
└── flake.nix       # entrypoint
```

See `flake.nix` for existing configurations that also serve as examples for adding new setups.

### Linux

To apply changes to the NixOS system configuration, run `sudo nixos-rebuild switch --flake .#HOSTNAME`.

To apply changes to home-manager, run `nix run home-manager -- switch --flake .#USERNAME`.

### Darwin

For Darwin, run `sudo nix run nix-darwin -- switch --flake .#HOSTNAME`.

Both Mac configurations use [nix-homebrew](https://github.com/zhaofengli/nix-homebrew)
to install Homebrew automatically or migrate an existing installation. GUI apps
are listed in `hosts/darwin/casks.nix`. You can also install packages directly with
`brew`; rebuilds preserve manually installed packages and taps.

macOS preferences live in `hosts/darwin/defaults.nix` and apply to both Mac configurations.
This includes Dock appearance and Spaces behavior, Finder views and search, keyboard
and trackpad preferences. Some preferences
need an app restart or a logout/login after rebuilding.

To save another preference, inspect it with `defaults read DOMAIN KEY` (for example,
`defaults read com.apple.dock tilesize`), then add the corresponding `system.defaults`
option. Use `system.defaults.CustomUserPreferences` for keys without a built-in option.
Keep this list focused on preferences rather than recent files, window positions, or
other application state.

Stage new Nix files before rebuilding: Git-backed flakes only include tracked files.
