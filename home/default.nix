{
  config,
  pkgs,
  username,
  dotfilesPath,
  ...
}: {
  imports = [
    ./apps
    ./etc
    ./shell
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  home.file.".gitconfig" = {
    source = config.lib.file.mkOutOfStoreSymlink dotfilesPath + "/gitconfig";
  };                        

  home.file.".gitignore_global" = {
    source = config.lib.file.mkOutOfStoreSymlink dotfilesPath + "/gitignore_global";
  };                        

  home.sessionVariables = {
    LC_COLLATE = "C";
    LANG = "en_US.UTF-8";
    LC_ALL = "$LANG";
  };
  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # todo: break packages out to their own modules
  home.packages = with pkgs; [
    git

    dua
    gcc
    git-credential-manager
    httpie
    jq
    mise
    thefuck
    tldr
    tmux
    tree

    zsh-powerlevel10k
  ];

  programs.home-manager.enable = true;
}