{ lib, pkgs, ... }:

with lib;
{
  config = {
    home.packages = with pkgs; [ nixpkgs-fmt ];

    nix = {
      package = mkDefault pkgs.nix;

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        warn-dirty = false;
      };

      gc = {
        automatic = true;
        frequency = "daily";
        options = "--delete-older-than 3d";
      };
    };
  };
}
