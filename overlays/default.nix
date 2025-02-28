{ flake, ... }:
let
  inherit (flake) inputs;
in
final: prev: {
  unstable = import inputs.nixpkgs-unstable {
    inherit prev;
    system = prev.system;
    config.allowUnfree = true;
  };
}
