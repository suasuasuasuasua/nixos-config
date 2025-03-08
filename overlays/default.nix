{ flake, ... }:
let
  inherit (flake) inputs;
in
_: prev: {
  # pkgs.unstable.X
  unstable = import inputs.nixpkgs-unstable {
    inherit prev;
    inherit (prev) system;
    config.allowUnfree = true;
  };

  nur = import inputs.nur.overlays;

  # # TODO: add as an overlay
  # firefox-addons = import inputs.firefox-addons {
  #   inherit prev;
  #   inherit (prev) system;
  #   config.allowUnfree = true;
  # };
}
