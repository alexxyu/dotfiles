{ pkgs, ... }:
{
  config = {
    programs.bat = {
      enable = true;

      themes = {
        Catppuccin-latte = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
            sha256 = "Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
          };
          file = "themes/Catppuccin Latte.tmTheme";
        };
        Catppuccin-macchiato = {
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "d714cc1d358ea51bfc02550dabab693f70cccea0";
            sha256 = "Q5B4NDrfCIK3UAMs94vdXnR42k4AXCqZz6sRn8bzmf4=";
          };
          file = "themes/Catppuccin Macchiato.tmTheme";
        };
      };
    };

    home.shellAliases = {
      cat = "bat -p";
      less = "bat";
    };

    home.sessionVariables = {
      LESS = "-IFSR --mouse";
    };
  };
}
