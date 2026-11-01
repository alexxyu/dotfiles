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
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      darwin,
      nix-homebrew,
      ...
    }@inputs:
    let
      username = "alex";

      isDarwin = system: (builtins.elem system inputs.nixpkgs.lib.platforms.darwin);
      homePrefix = system: if isDarwin system then "/Users" else "/home";

      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      mkDarwinConfig =
        {
          username,
          system ? "aarch64-darwin",
          nixpkgs ? inputs.nixpkgs,
          baseModules ? [
            home-manager.darwinModules.home-manager
            nix-homebrew.darwinModules.nix-homebrew
            ./hosts/darwin/configuration.nix
          ],
          extraModules ? [ ],
        }:
        darwin.lib.darwinSystem {
          inherit system;
          modules = baseModules ++ extraModules;
          specialArgs = {
            system = system;
            username = username;
          };
        };

      mkNixosConfig =
        {
          system ? "x86_64-linux",
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
            os = "linux";
          };
        };
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
      checks = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
          configurations = {
            darwin = self.darwinConfigurations.default.system.drvPath;
            nixos = self.nixosConfigurations.nixos.config.system.build.toplevel.drvPath;
          }
          // nixpkgs.lib.mapAttrs (_: home: home.activationPackage.drvPath) self.homeConfigurations;
        in
        {
          # Force evaluation of every profile, including custom homeConfigurations.
          # Drop dependency context so this check does not build foreign systems.
          configuration-evaluation = pkgs.writeText "configuration-evaluation.json" (
            builtins.unsafeDiscardStringContext (builtins.toJSON configurations)
          );
        }
      );

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
        default = mkDarwinConfig {
          system = "aarch64-darwin";
          username = "alexyu";
        };
      };
    };
}
