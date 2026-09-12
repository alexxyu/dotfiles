{ lib, ... }:

with lib;
{
  imports = [
    ./bettercmdtab.nix
    ./firefox.nix
    ./ghostty.nix
    ./vscode.nix
  ];

  options = {
    apps.enable = mkEnableOption "apps";
  };
}
