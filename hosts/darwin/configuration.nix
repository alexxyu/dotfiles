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
      "${username}" =
        { config, lib, ... }:
        {
          imports = [ ../../home ];

          home = {
            inherit username;
            homeDirectory = "/Users/${username}";

            file = {
              ".config/iterm2/com.googlecode.iterm2.plist" = {
                source = config.lib.file.mkOutOfStoreSymlink "/Users/${username}/.dotfiles/hosts/darwin/iterm/com.googlecode.iterm2.plist";
              };
              "Library/Application Support/Rectangle/RectangleConfig.json" = {
                source = config.lib.file.mkOutOfStoreSymlink "/Users/${username}/.dotfiles/hosts/darwin/rectangle/RectangleConfig.json";
              };
            };
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
    masApps = {
      # Install through Apple Store for browser integration
      "Bitwarden" = 1352778147;
    };
  };

  system.defaults = {
    dock.autohide = true;
    dock.show-recents = false;
    dock.wvous-br-corner = 12; # Bottom-left hot corner: Notification Center

    trackpad.Clicking = true;
  };

  system.defaults.NSGlobalDomain = {
    AppleInterfaceStyleSwitchesAutomatically = true;
    ApplePressAndHoldEnabled = false;
    AppleShowAllExtensions = true;
    InitialKeyRepeat = 25;
    KeyRepeat = 4;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = false;
    NSAutomaticQuoteSubstitutionEnabled = false;
    NSAutomaticSpellingCorrectionEnabled = false;
    NSDocumentSaveNewDocumentsToCloud = false;
    NSNavPanelExpandedStateForSaveMode = true;
    NSNavPanelExpandedStateForSaveMode2 = true;
  };

  system.defaults.CustomUserPreferences = {
    "com.apple.finder" = {
      FXPreferredViewStyle = "Nlsv";
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = false;
      ShowPathbar = true;
    };
    "com.apple.desktopservices" = {
      # Avoid creating .DS_Store files on network or USB volumes
      DSDontWriteNetworkStores = true;
      DSDontWriteUSBStores = true;
    };
    "com.googlecode.iterm2" = {
      PrefsCustomFolder = "~/.config/iterm2";
      LoadPrefsFromCustomFolder = true;
    };
  };
}
