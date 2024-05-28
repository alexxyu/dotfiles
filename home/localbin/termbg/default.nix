{ rustPlatform, ... }:

rustPlatform.buildRustPackage {
  pname = "termbg";
  version = "1.0.0";

  src = ./.;

  cargoHash = "sha256-mGdhZX/xLmZRoETJTrd19GOxjRKylMhT6ebX81hniHM=";
}
