{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  userConfigs,
  ...
}:
{
  # write a list of system packages to /etc/current-system-packages
  environment.etc."current-system-packages".text =
    let
      inherit (builtins)
        lessThan
        map
        sort
        concatStringsSep
        filter
        isAttrs
        hasAttr
        ;
      inherit (pkgs.lib.lists) unique;

      # Filter packages to only include derivations with a name attribute
      # This handles cases where strings (like store paths) are in systemPackages
      validPackages = filter (p: isAttrs p && hasAttr "name" p) config.environment.systemPackages;
      packages = map (p: "${p.name}") validPackages;
      sortedUnique = sort lessThan (unique packages);
      formatted = concatStringsSep "\n" sortedUnique;
    in
    formatted;

  nixpkgs.overlays = builtins.attrValues outputs.overlays;

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
      settings = {
        max-jobs = "auto";
        experimental-features = "nix-command flakes";
        # Nullify the registry for purity.
        flake-registry = "";
        trusted-users = [
          "root"
        ]
        ++ map ({ username, ... }: username) userConfigs;
      };

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      # Opinionated: disable channels
      channel.enable = false;
    };
}
