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

  # home.file.".zshrc" = {
  #   source = config.lib.file.mkOutOfStoreSymlink dotfilesPath + "/zshrc";
  # };

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
}
