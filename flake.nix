{
  description = "Flake for dotfiles";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs:
    let
      username = "alex";

      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      defaultPackage.${system} = home-manager.defaultPackage.${system};
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [ ./hosts/configuration.nix ];

        specialArgs = {
          username = username;
        };
      };

      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs { system = "${system}"; config = { allowUnfree = true; }; };
        modules = [ ./home ];

        extraSpecialArgs = {
          username = username;
          dotfilesPath = ./home/shell;
        };
      };
    };
}
