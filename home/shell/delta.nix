{ pkgs, ... }:
{
  config = {
    home.packages = [ pkgs.delta ];

    home.shellAliases = {
      diff = "delta";
      diffy = "delta --side-by-side";
    };
  };
}
