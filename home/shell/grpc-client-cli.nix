{ pkgs, ... }:
{
  config = {
    home.packages = [ pkgs.grpc-client-cli ];

    home.shellAliases = {
      grpc = "grpc-client-cli";
    };
  };
}
