# dotfiles-nix

An experimental dotfiles setup using [nix](https://nixos.org) and
[home-manager](https://github.com/nix-community/home-manager).

## Current Progress

So far, this has been tested only on fresh guest VMs running on a M1 MacBook host:
* NixOS-arm64
* MacOS-arm64 (via [nix-darwin](https://github.com/LnL7/nix-darwin/tree/b658dbd85a1c70a15759b470d7b88c0c95f497be))

For the most part, this repo replicates the configuration in my [original dotfiles repo](https://github.com/alexxyu/dotfiles) backed by GNU stow.

I'm still learning how to use nix, but if all goes well, I should be able to use nix for my existing machines.

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

### Linux

To apply changes to the NixOS system configuration, run `sudo nixos-rebuild switch --flake .#HOSTNAME`.

To apply changes to home-manager, run `nix run home-manager -- switch --flake .#USERNAME`.

### Darwin

Note that the Darwin configuration also makes use of [nix-homebrew](https://github.com/zhaofengli/nix-homebrew) to manage installations that nix cannot.

For Darwin, run `nix run nix-darwin -- switch --flake .#HOSTNAME`.
