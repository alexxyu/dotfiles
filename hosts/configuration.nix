{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./system    
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.zsh.enable = true;

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "docker" ];
  };

  services.displayManager.sddm.enable = true;
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
  };

  system.stateVersion = "23.11";

  nixpkgs.config.allowUnfree = true;
}
