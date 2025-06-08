{ pkgs, ... }:
{
  config = {
    home.packages = [ pkgs.yt-dlp ];

    home.shellAliases = {
      ytdl = "yt-dlp";
      ytdla = "ytdl -x --audio-format mp3";
    };
  };
}
