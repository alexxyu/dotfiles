{
  config,
  pkgs,
  username,
  dotfilesPath,
  ...
}: {
  imports = [
    ./home
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  home.file.".zshrc" = {
    source = config.lib.file.mkOutOfStoreSymlink dotfilesPath + "/zshrc";
  };

  home.file.".gitconfig" = {
    source = config.lib.file.mkOutOfStoreSymlink dotfilesPath + "/gitconfig";
  };                        

  home.file.".gitignore_global" = {
    source = config.lib.file.mkOutOfStoreSymlink dotfilesPath + "/gitignore_global";
  };                        

  home.file.".config" = {
    source = ./config;
    recursive = true;
    executable = true;
  };

  # todo: break packages out to their own modules
  home.packages = with pkgs; [
    git
    neovim
    zsh

    bat
    delta
    fzf
    git-credential-manager
    httpie
    jq
    libgcc
    mise
    ripgrep
    thefuck
    tmux
    tree
    zoxide

    zsh-powerlevel10k

    firefox
    vscode
  ];

  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    initExtraFirst = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
    '';
    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.8.0";
          sha256 = "iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
        };
      }
      {
        name = "zsh-powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
  };
}
