{ pkgs, ... }:
let
  termbg = pkgs.callPackage ./termbg { };
in
{
  home.packages = [ termbg ];
}
