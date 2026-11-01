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
        default = pkgs.stdenv.hostPlatform.isLinux;
      };
    };
  };

  config =
    let
      linuxKeybinds = [
        "alt+`=toggle_quick_terminal"
        "ctrl+shift+r=reset"
        "ctrl+d=new_split:down"
        "ctrl+shift+d=new_split:right"
      ];

      macKeybinds = [
        "global:opt+`=toggle_quick_terminal"
        "cmd+shift+r=reset"
        "cmd+d=new_split:down"
        "cmd+shift+d=new_split:right"
      ];

      keybinds = if pkgs.stdenv.hostPlatform.isDarwin then macKeybinds else linuxKeybinds;
    in
    lib.mkIf config.apps.ghostty.enable {
      programs.ghostty = {
        enable = true;
        package = if config.apps.ghostty.enablePackage then pkgs.ghostty else null;

        # Load integration below only for shells talking directly to Ghostty.
        enableZshIntegration = false;

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
          theme = "dark:Catppuccin Macchiato,light:Catppuccin Latte";
          window-theme = "system";

          # Functionality
          clipboard-paste-protection = true;
          scrollback-limit = 2147483648;
          shell-integration = "zsh";
          shell-integration-features = "no-cursor";
          quick-terminal-position = "right";
          quit-after-last-window-closed = false;

          macos-option-as-alt = true;

          keybind = keybinds;
        };
      };

      programs.zsh.initContent = lib.mkAfter ''
        # Ghostty prompt markers conflict with Powerlevel10k inside tmux.
        if [[ "$TERM" == xterm-ghostty && -z "$TMUX" && -z "$STY" && -z "$ZELLIJ" && \
              -r "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration" ]]; then
          source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
        fi
      '';
    };
}
