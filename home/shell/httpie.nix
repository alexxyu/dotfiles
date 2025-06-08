{ pkgs, ... }:
{
  config = {
    home.packages = [ pkgs.httpie ];

    programs.zsh.initContent = ''
      function httpi () {
        http -v $@ --raw "$(vipe -e=json)"
      }
    '';

    home.shellAliases = {
      post = "httpi post";
    };
  };
}
