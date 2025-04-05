{
  flake,
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (flake) self;
  inherit (self) inputs;
in
{
  # write a list of system packages to /etc/current-system-packages
  environment.etc."current-system-packages".text =
    let
      packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
      sortedUnique = builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
      formatted = builtins.concatStringsSep "\n" sortedUnique;
    in
    formatted;

  nixpkgs = {
    overlays = lib.attrValues self.overlays ++ [
      # TODO: should add to overlays/default.nix but doesn't work omg -- my
      # bandaid for now
      inputs.nur.overlays.default
    ];

    # allows us to install apps like vscode
    config.allowUnfree = true;
  };

  nix = {
    # Choose from https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=nix
    # package = pkgs.nixVersions.latest;

    nixPath = [ "nixpkgs=${flake.inputs.nixpkgs}" ]; # Enables use of `nix-shell -p ...` etc
    # TODO: figure out what this option even is
    # registry.nixpkgs.flake = flake.inputs.nixpkgs; # Make `nix shell` etc use pinned nixpkgs
    # Opinionated: disable channels

    channel.enable = false;

    settings = {
      max-jobs = "auto";
      experimental-features = "nix-command flakes";
      # I don't have an Intel mac.
      extra-platforms = lib.mkIf pkgs.stdenv.isDarwin "aarch64-darwin x86_64-darwin";
      # Nullify the registry for purity.
      flake-registry = builtins.toFile "empty-flake-registry.json" ''{"flakes":[],"version":2}'';
      trusted-users = [
        "root"
        "justinhoang" # TODO: make this dynamic
      ];
    };
  };
}
