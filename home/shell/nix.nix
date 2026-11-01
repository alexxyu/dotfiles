{ lib, pkgs, ... }:

with lib;
{
  config = {
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
        dates = "daily";
        options = "--delete-older-than 30d";
      };
    };
  };
}
