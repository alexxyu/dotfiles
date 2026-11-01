{
  # Selected preferences shared by the Mac configurations.
  # Apply with darwin-rebuild switch; some changes require logging out and back in.
  system.defaults = {
    dock = {
      autohide = true;
      show-recents = false;
      wvous-br-corner = 12; # Bottom-right hot corner: Notification Center

      # Preserve the current Dock appearance and Mission Control behavior.
      tilesize = 56;
      magnification = false;
      mineffect = "scale";
      show-process-indicators = true;
      showhidden = true;
      mru-spaces = false; # Keep Spaces in a fixed order.
      expose-group-apps = false;
    };

    finder = {
      FXPreferredViewStyle = "Nlsv"; # List view
      FXDefaultSearchScope = "SCcf"; # Search the current folder.
      NewWindowTarget = "Home";
      _FXSortFoldersFirst = true;
      ShowExternalHardDrivesOnDesktop = true;
      ShowHardDrivesOnDesktop = false;
      ShowPathbar = true;
    };

    trackpad.Clicking = true;

    NSGlobalDomain = {
      AppleInterfaceStyleSwitchesAutomatically = true;
      ApplePressAndHoldEnabled = false;
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 25;
      KeyRepeat = 4;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
    };

    CustomUserPreferences = {
      "com.apple.finder" = {
        ShowRecentTags = false; # Hide recent tags in the sidebar.
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes.
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.googlecode.iterm2" = {
        PrefsCustomFolder = "~/.config/iterm2";
        LoadPrefsFromCustomFolder = true;
      };
    };
  };
}
