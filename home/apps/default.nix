{ lib, ... }:

with lib;
{
  imports = [
    ./firefox.nix
    ./ghostty.nix
    ./vscode.nix
  ];

  options = {
    apps.enable = mkEnableOption "apps";
  };
}
