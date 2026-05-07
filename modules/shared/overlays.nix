{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.self.overlays.additions
    inputs.self.overlays.modifications
    inputs.self.overlays.flake-inputs
    inputs.self.overlays.firefox-addons
  ];
}
