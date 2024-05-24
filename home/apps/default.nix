{ lib, ... }:

with lib;
{
  imports = [
    ./firefox.nix
    ./vscode.nix
  ];

  options = {
    apps.enable = mkEnableOption "apps";
  };
}
