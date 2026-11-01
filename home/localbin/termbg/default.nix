{ rustPlatform, ... }:

rustPlatform.buildRustPackage {
  pname = "termbg";
  version = "1.0.0";

  src = ./.;

  cargoHash = "sha256-wuyN/dyp6utyCxXt9h5q/ZBxOsd/clG1FTXYgzbomRY=";
}
