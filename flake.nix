{
  description = "Flake for dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      homebrew-bundle,
      ...
    }@inputs:
    let
      username = "alex";
      # pkgs = nixpkgs.legacyPackages.${system};

      isDarwin = system: (builtins.elem system inputs.nixpkgs.lib.platforms.darwin);
      homePrefix = system: if isDarwin system then "/Users" else "/home";

      mkDarwinConfig =
        {
          system ? "aarch64-darwin",
          nixpkgs ? inputs.nixpkgs,
          baseModules ? [
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                user = username;
                enable = true;
                taps = {
                  "homebrew/homebrew-core" = homebrew-core;
                  "homebrew/homebrew-cask" = homebrew-cask;
                  "homebrew/homebrew-bundle" = homebrew-bundle;
                };
                mutableTaps = false;
                autoMigrate = true;
              };
            }
            ./hosts/darwin/configuration.nix
          ],
          extraModules ? [ ],
          hostname ? "",
        }:
        darwin.lib.darwinSystem {
          inherit system;
          modules = [
            {
              networking = {
                hostName = hostname;
                localHostName = hostname;
                computerName = hostname;
              };
            }
          ] ++ baseModules ++ extraModules;
          specialArgs = {
            username = username;
          };
        };

      mkNixosConfig =
        {
          system ? "aarch64-darwin",
          nixpkgs ? inputs.nixpkgs,
          baseModules ? [ ./hosts/nixos/configuration.nix ],
          extraModules ? [ ],
          hostname ? "",
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ { networking.hostName = hostname; } ] ++ baseModules ++ extraModules;
          specialArgs = {
            username = username;
          };
        };

      mkHomeConfig =
        {
          username,
          system ? "x86_64-linux",
          nixpkgs ? inputs.nixpkgs,
          baseModules ? [
            {
              home = {
                inherit username;
                homeDirectory = "${homePrefix system}/${username}";
              };

              apps.enable = true;
            }
            ./home
          ],
          extraModules ? [ ],
        }:
        home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [ ] ++ baseModules ++ extraModules;

          extraSpecialArgs = {
            username = username;
          };
        };
    in
    {
      nixosConfigurations = {
        nixos = mkNixosConfig {
          system = "aarch64-linux";
          hostname = "nixos";
        };
      };

      homeConfigurations = {
        alex = mkHomeConfig {
          username = "alex";
          system = "aarch64-linux";

          extraModules = [
            {
              shell.git.credentialStore = "libsecret";
              shell.git.useDeviceOauth = false;
            }
          ];
        };

        alexyu = mkHomeConfig {
          username = "alexyu";
          system = "x86_64-linux";

          extraModules = [
            {
              shell.git.credentialStore = "cache";
              shell.git.cacheTimeout = 604800;
              shell.git.useDeviceOauth = true;
            }
          ];
        };
      };

      darwinConfigurations = {
        aarch64-darwin = mkDarwinConfig {
          system = "aarch64-darwin";
          hostname = "aarch64-darwin";
        };
      };
    };
}
