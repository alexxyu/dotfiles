{
  pkgs,
  ...
}: {
  config = {
    home.packages = [ pkgs.dua ];
  };
}