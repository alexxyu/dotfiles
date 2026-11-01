{ ... }:
{
  programs.btop = {
    enable = true;
    settings = {
      # Use the terminal palette, including Ghostty's light/dark themes.
      # Selecting the TTY theme does not force TTY mode or ASCII graphs.
      color_theme = "TTY";
      theme_background = false;
    };
  };
}
