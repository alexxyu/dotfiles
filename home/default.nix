{
  config,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./apps
    ./etc
    ./localbin
    ./shell
  ];

  home.stateVersion = "23.11";

  home.sessionVariables = {
    LC_COLLATE = "C";
    LANG = "en_US.UTF-8";
    LC_ALL = "$LANG";
  };
  home.sessionPath = [ "$HOME/.local/bin" ];

  home.packages = with pkgs; [
    btop
    coreutils
    dua
    gcc
    httpie
    imagemagick
    img2pdf
    jq
    tldr
    tmux
    tree
    yt-dlp

    nixfmt-rfc-style
    nil

    gnumake

    rustup

    (pkgs.python311.withPackages (ppkgs: [ ppkgs.numpy ]))

    zsh-powerlevel10k
  ];

  programs.home-manager.enable = true;
}
