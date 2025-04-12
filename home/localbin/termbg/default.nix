{ rustPlatform, ... }:

rustPlatform.buildRustPackage {
  pname = "termbg";
  version = "1.0.0";

  src = ./.;

  cargoHash = "sha256-k8SXqV5G6+mpjnS8sSRQK//o33dC5/t0mTZWvo74gUg=";
}
