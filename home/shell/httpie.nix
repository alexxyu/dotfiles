{ pkgs, ... }:
{
  config = {
    home.packages = [ pkgs.httpie ];

    programs.zsh.initExtra = ''
      function httpi () {
        http -v $@ --raw "$(vipe -e=json)"
      }
    '';

    home.shellAliases = {
      post = "httpi post";
    };
  };
}
