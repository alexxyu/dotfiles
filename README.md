# Dotfiles

My dotfiles setup using [nix](https://nixos.org) and [home-manager](https://github.com/nix-community/home-manager).

## Current Progress

This has been primarily tested on the following:
* My personal M1 MacBook (via [nix-darwin](https://github.com/LnL7/nix-darwin)).
* A NixOS-arm64 VM running on said MacBook.

This repo replicates the configuration in my [original dotfiles](https://github.com/alexxyu/dotfiles/tree/stow) backed by GNU stow.

## How to Use

Install Nix using the [official installation instructions](https://nixos.org/download/),
then open a new terminal.

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

To apply changes to home-manager, run:

```sh
NIX_CONFIG='extra-experimental-features = nix-command flakes' \
nix build --out-link result-home '.#homeConfigurations.USERNAME.activationPackage'
./result-home/activate
```

### Darwin

On a new Mac, run from the repository root to bootstrap nix-darwin and apply this configuration:

```sh
sudo env NIX_CONFIG='extra-experimental-features = nix-command flakes' \
  nix run github:nix-darwin/nix-darwin#darwin-rebuild -- switch --flake .#default
```

This installs nix-darwin; no separate setup is needed.
The system configuration enables these features permanently.
Afterward, open a new terminal and apply changes from the repository root with:

```sh
sudo darwin-rebuild switch --flake .#default
```

The Mac configuration uses [nix-homebrew](https://github.com/zhaofengli/nix-homebrew)
to install Homebrew automatically or migrate an existing installation. GUI apps
are listed in `hosts/darwin/casks.nix`. You can also install packages directly with
`brew`; rebuilds preserve manually installed packages and taps.

macOS preferences live in `hosts/darwin/defaults.nix`. Rebuild after editing;
some preferences need an app restart or a logout/login.

To save another preference, inspect it with `defaults read DOMAIN KEY`, then add
the corresponding `system.defaults` option. Use
`system.defaults.CustomUserPreferences` for keys without a built-in option.
Keep this list focused on preferences rather than recent files, window positions, or
other application state.

Stage new Nix files before rebuilding: Git-backed flakes only include tracked files.

### Development and validation

Run these commands locally from the repository root:

| Command | Purpose |
| --- | --- |
| `nix flake check --all-systems --no-build` | Evaluate all system and Home Manager configurations. |
| `nix fmt` | Format Nix files using the formatter pinned by `flake.lock`. |
| `nix flake update` | Update all flake inputs. Run the checks afterward. |
| `nix flake update nixpkgs` | Update only nixpkgs. |
| `python3 -m unittest discover -s tests -v` | Run shell-helper regression tests; requires Python, Bash, and Zsh. |

To build without activating, use `nix build .#darwinConfigurations.default.system`
on macOS or `nix build .#nixosConfigurations.nixos.config.system.build.toplevel`
on the Linux VM. For Home Manager, use the build command in the Linux section
without running the activation script. Build on the target platform or use an
appropriately configured remote builder. Evaluation checks do not build complete
systems or test activation.

### Recovery

Build and validate before switching, especially after updating `flake.lock`.
Keep the previous lockfile revision in Git so you can restore it and rebuild.

- **macOS:** run `sudo darwin-rebuild switch --rollback` to return to the
  preceding system generation.
- **NixOS:** run `sudo nixos-rebuild switch --rollback`, or choose a previous
  generation from the boot menu if the system cannot start normally.
- **Standalone Home Manager:** run `home-manager generations`, then execute the
  `activate` script in the desired generation's store path.

Rollback requires the previous generation to still exist. Restore this checkout
through Git when reverting files managed directly from the repository. Software
installed outside Nix generations must be managed separately.

See [the Neovim README](home/shell/nvim/README.md) for editor configuration details.
