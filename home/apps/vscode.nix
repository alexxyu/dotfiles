{
  pkgs,
  ...
}: {
  config = {
    home.packages = [ pkgs.vscode ];

    home.shellAliases = {
      code = "code -n";
    };
  };
}