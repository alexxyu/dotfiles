{
  config,
  lib,
  ...
}:

with lib;
{
  options = {
    apps.bettercmdtab.enable = mkEnableOption "bettercmdtab";
  };

  config = mkIf config.apps.bettercmdtab.enable {
    home.file."config/bettercmdtab/config.json" = {
      source = config.lib.file.mkOutOfStoreSymlink (
        config.home.homeDirectory + "/.dotfiles/home/apps/bettercmdtab/config.json"
      );
      force = true;
    };
  };
}