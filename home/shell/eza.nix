{ pkgs, ... }:
{
  config = {
    programs.eza = {
      enable = true;

      colors = "always";
      enableZshIntegration = true;
      icons = "always";

      extraOptions = [
        # This option is disabled until eza supports MAX_LUMINANCE value
        # https://github.com/eza-community/eza/pull/1380
        # "--color-scale=age,size"
        "--group-directories-first"
        "--long"
      ];
    };

    home.shellAliases = {
      ls = "eza";
      la = "ls -a";
    };

    home.sessionVariables = {
      EZA_COLORS = "ur=0:uw=0:ux=0:ue=0:gr=0:gw=0:gx=0:tr=0:tw=0:tx=0";
    };
  };
}
