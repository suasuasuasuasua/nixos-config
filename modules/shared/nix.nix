{ lib, inputs, ... }:
let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
{
  nix = {
    settings = {
      max-jobs = "auto";
      experimental-features = "nix-command flakes";
      flake-registry = "";
      extra-substituters = [ "https://cache.sua.dev" ];
      extra-trusted-public-keys = [ "cache.sua.dev:LAOD0dIC9Yp/IlZqv+OgJ0O3elYQAhlInOCI7x+75yE=" ];
    };

    registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };
}
