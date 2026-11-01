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
    home.file.".config/bettercmdtab/config.json" = {
      # Changes are live; restore the JSON through Git rather than a Nix rollback.
      source = config.lib.file.mkOutOfStoreSymlink (
        config.home.homeDirectory + "/.dotfiles/home/apps/bettercmdtab/config.json"
      );
      force = true;
    };
  };
}
