{ pkgs, username, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../system
  ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Allow nix to manage boot loaders.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable zsh.
  programs.zsh.enable = true;

  # Set up user.
  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "docker"
    ];
  };

  # Enable KDE plasma desktop manager.
  services.displayManager.sddm.enable = true;
  services.xserver = {
    enable = true;
    desktopManager.plasma5.enable = true;
  };

  system.stateVersion = "23.11";

  # Required for some apps.
  nixpkgs.config.allowUnfree = true;
}
