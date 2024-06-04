{ pkgs, ... }:
{
  config = {
    home.packages = [ pkgs.yt-dlp ];

    home.shellAliases = {
      ytdl = "yt-dlp";
      ytdla = "ytdl -f 'ba[ext=m4a]'";
    };
  };
}
