{
  pkgs,
  system,
  username,
  ...
}:
{
  imports = [ ./defaults.nix ];

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  # system.configurationRevision = self.rev or self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;

  security.pam.services.sudo_local.touchIdAuth = true;

  # Set up user environment through home-manager.
  home-manager = {
    users = {
      "${username}" =
        { config, lib, ... }:
        {
          imports = [ ../../home ];

          home = {
            inherit username;
            homeDirectory = "/Users/${username}";
          };

          apps.ghostty.enable = true;
          apps.bettercmdtab.enable = true;
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

  # Bootstrap Homebrew while keeping taps and packages usable outside Nix.
  nix-homebrew = {
    enable = true;
    user = username;
    autoMigrate = true;
    mutableTaps = true;
    # Leave official taps unpinned so Homebrew uses its current package API.
  };

  # Install a baseline without removing manually installed packages or taps.
  homebrew = {
    enable = true;
    onActivation.cleanup = "none";
    casks = import ./casks.nix;
    masApps = {
      # Install through Apple Store for browser integration
      "Bitwarden" = 1352778147;
    };
  };

  system.primaryUser = username;
}
