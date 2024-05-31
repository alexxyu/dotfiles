{
  pkgs,
  system,
  username,
  ...
}:
{
  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;

  security.pam.enableSudoTouchIdAuth = true;

  # Set up user environment through home-manager.
  home-manager = {
    users = {
      "${username}" = {
        imports = [ ../../home ];

        home = {
          inherit username;
          homeDirectory = "/Users/${username}";
        };

        apps.enable = false;
      };
    };
    extraSpecialArgs = {
      username = username;
    };
  };

  # Set home directory for home-manager.
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  environment.systemPackages = with pkgs; [
    # Add system-level packages here.
  ];

  # Enable and install homebrew packages.
  homebrew = {
    enable = true;
    casks = import ./casks.nix;
  };
}
