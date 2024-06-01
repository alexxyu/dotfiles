{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;

      viAlias = true;
      vimAlias = true;
    };

    home.file = {
      ".config/nvim" = {
        source =
          config.lib.file.mkOutOfStoreSymlink /. + "${config.home.homeDirectory}/.dotfiles/home/shell/nvim";
        recursive = true;
      };
    };
  };
}
