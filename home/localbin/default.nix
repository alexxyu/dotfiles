{ pkgs, ... }:
let
  termbg = pkgs.callPackage ./termbg { };
in
{
  home.packages = [ termbg ];

  home.file = {
    ".local/bin/vipe".source = ./vipe/vipe;
  };
}
