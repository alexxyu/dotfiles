# Dotfiles

My dotfiles setup using [nix](https://nixos.org) and [home-manager](https://github.com/nix-community/home-manager).

## Current Progress

This has been primarily tested on the following:
* My personal M1 MacBook (via [nix-darwin](https://github.com/LnL7/nix-darwin)).
* A NixOS-arm64 VM running on said MacBook.

This repo replicates the configuration in my [original dotfiles](https://github.com/alexxyu/dotfiles/tree/d917afa4823b1d8b432ef1477f10a12695286e6f) backed by GNU stow.

## How to Use

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

Note that the Darwin configuration also makes use of [nix-homebrew](https://github.com/zhaofengli/nix-homebrew) to manage installations that nix cannot, particular GUI apps.

It expects for this repo to be cloned at `/Users/${username}/.dotfiles`.

For Darwin, run `nix run nix-darwin -- switch --flake .#HOSTNAME`.
