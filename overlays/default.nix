{ inputs, ... }:
{
  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.system}'
  flake-inputs = final: _: {
    inputs = builtins.mapAttrs (
      _: flake:
      let
        legacyPackages =
          (flake.legacyPackages or {
          }
          ).${final.stdenv.hostPlatform.system} or { };
        packages = (flake.packages or { }).${final.stdenv.hostPlatform.system} or { };
      in
      if legacyPackages != { } then legacyPackages else packages
    ) inputs;
  };

  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://wiki.nixos.org/wiki/Overlays
  modifications = _final: _prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
  };

  # Adds pkgs.unstable == inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}
  # unstable = inputs.nixpkgs-unstable.legacyPackages.${final.system};

  # nix user repository
  # NOTE: add it explicitly so i can set config options
  firefox-addons = inputs.firefox-addons.overlays.default;
}
