{
  pkgs,
  ...
}: {
  config = {
    fonts.fontDir.enable = true;
    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];
  };
}