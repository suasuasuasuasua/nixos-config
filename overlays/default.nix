{ flake, ... }:
let
  inherit (flake) inputs;
in
final: prev: {
  unstable = import inputs.nixpkgs-unstable {
    inherit prev;
    inherit (prev) system;
    config.allowUnfree = true;
  };
}
