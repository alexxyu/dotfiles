{ config, lib, ... }:

with lib;
{
  options = {
    apps.firefox.enable = mkEnableOption "firefox" // {
      default = config.apps.enable;
    };
  };

  config = mkIf config.apps.firefox.enable {
    programs.firefox = {
      enable = true;
    };

    home.sessionVariables = {
      BROWSER = "firefox";
    };
  };
}
