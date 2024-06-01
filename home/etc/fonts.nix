{
  config,
  lib,
  pkgs,
  ...
}:

with lib;
{
  options = {
    etc.fonts.enable = mkEnableOption "Enable home-manager font management" // {
      default = true;
    };
  };

  config = mkIf config.etc.fonts.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      google-fonts
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };
}
