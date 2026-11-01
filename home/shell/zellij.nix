{ ... }:
{
  programs.zellij = {
    enable = true;
    # Launch explicitly with `zellij`; ordinary terminals stay ordinary shells.
    enableZshIntegration = false;
    extraConfig = builtins.readFile ./zellij.kdl;
  };
}
