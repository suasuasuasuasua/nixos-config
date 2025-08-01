{
  inputs,
  outputs,
  lib,
  pkgs,
  userConfig,
  ...
}:
{
  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
  };

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      # Be careful importing this file if you are using nixos modules because
      # nix.packages needs to be unique
      # This file is for stand-alone home-manager instances
      package = pkgs.nix;

      settings = {
        max-jobs = "auto";
        experimental-features = "nix-command flakes";
        # Nullify the registry for purity.
        flake-registry = "";
        trusted-users = [
          "root"
          "${userConfig.username}"
        ];

        # darwin specific extra platform builders
        extra-platforms = lib.mkIf pkgs.stdenv.isDarwin "aarch64-darwin x86_64-darwin";
      };

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
    };
}
