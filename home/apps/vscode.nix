{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options = {
    apps.vscode.enable = mkEnableOption "vscode" // {
      default = config.apps.enable;
    };
  };

  config = mkIf config.apps.vscode.enable {
    home.packages = [ pkgs.vscode ];

    home.shellAliases = {
      code = "code -n";
    };
  };
}
