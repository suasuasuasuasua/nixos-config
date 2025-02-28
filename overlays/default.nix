{ flake, ... }:
let
  inherit (flake) inputs;
in
# deadnix: skip
final: prev: {
  unstable = import inputs.nixpkgs-unstable {
    inherit prev;
    inherit (prev) system;
    config.allowUnfree = true;
  };
}
