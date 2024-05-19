{
  pkgs,
  ...
}: {
  config = {
    home.packages = [ pkgs.ripgrep ];

    home.shellAliases = {
      rg = "rg --hidden --glob '!.git'";
    };
  };
}