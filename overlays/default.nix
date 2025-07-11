{ inputs, ... }:
{
  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.system}'
  flake-inputs = final: _: {
    inputs = builtins.mapAttrs (
      _: flake:
      let
        legacyPackages = (flake.legacyPackages or { }).${final.system} or { };
        packages = (flake.packages or { }).${final.system} or { };
      in
      if legacyPackages != { } then legacyPackages else packages
    ) inputs;
  };

  # Adds pkgs.unstable == inputs.nixpkgs-unstable.legacyPackages.${pkgs.system}
  # unstable = inputs.nixpkgs-unstable.legacyPackages.${final.system};
  unstable = final: _: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (final) system;

      config.allowUnfree = true; # for unstable packages and extensions
    };
  };

  # nix user repository
  # NOTE: add it explicitly so i can set config options
  firefox-addons = inputs.firefox-addons.overlays.default;
}
