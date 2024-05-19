{
  pkgs,
  username,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
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

  fonts.fontDir.enable = true;
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  system.stateVersion = "23.11";

  nixpkgs.config.allowUnfree = true;
}
