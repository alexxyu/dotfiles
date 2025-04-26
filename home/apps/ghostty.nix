{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    apps.ghostty = {
      enable = lib.mkEnableOption "ghostty";
      enablePackage = lib.mkEnableOption "ghostty-package" // {
        default = pkgs.stdenv.isLinux;
      };
    };
  };

  config =
    let
      linuxKeybinds = [ ];

      macKeybinds = [
        "global:cmd+shift+`=toggle_quick_terminal"
      ];

      keybinds = if pkgs.stdenv.isDarwin then macKeybinds else linuxKeybinds;
    in
    lib.mkIf config.apps.ghostty.enable {
      programs.ghostty = {
        enable = true;
        package = if config.apps.ghostty.enablePackage then pkgs.ghostty else null;

        settings = {
          # Display
          cursor-style = "bar";
          cursor-style-blink = false;
          cursor-click-to-move = true;
          macos-titlebar-style = "native";
          window-height = 40;
          window-width = 150;
          window-padding-x = 10;
          window-padding-y = 5;
          window-subtitle = "working-directory";

          # Font / Theme
          adjust-cell-width = "-10%";
          font-family = "JetBrainsMono Nerd Font Mono";
          font-size = 12;
          theme = "dark:catppuccin-macchiato,light:catppuccin-latte";
          window-theme = "system";

          # Functionality
          clipboard-paste-protection = true;
          scrollback-limit = 2147483648;
          shell-integration = "zsh";
          shell-integration-features = "no-cursor";
          quick-terminal-position = "right";
          quit-after-last-window-closed = true;

          macos-option-as-alt = true;

          keybind = keybinds;
        };
      };
    };
}
