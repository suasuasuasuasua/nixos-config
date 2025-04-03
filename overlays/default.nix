{ flake, ... }:
let
  inherit (flake) inputs;
in
# deadnix: skip
final: prev: {
  # pkgs.unstable.X
  unstable = import inputs.nixpkgs-unstable {
    inherit prev;
    inherit (prev) system;
    config.allowUnfree = true;
  };
}
