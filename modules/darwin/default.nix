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
        ;
      inherit (pkgs.lib.lists) unique;

      packages = map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = sort lessThan (unique packages);
      formatted = concatStringsSep "\n" sortedUnique;
    in
    formatted;

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;

    # allows us to install apps like vscode
    config.allowUnfree = true;
  };

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
        ] ++ map ({ username, ... }: username) userConfigs;

        # darwin specific extra platform builders
        extra-platforms = lib.mkIf pkgs.stdenv.isDarwin "aarch64-darwin x86_64-darwin";
      };

      # Opinionated: make flake registry and nix path match flake inputs
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
      # Opinionated: disable channels
      channel.enable = false;
    };
}
