{ inputs, pkgs, ... }:
{
  environment.systemPackages =
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    [
      # add basic nixvim config
      inputs.nixvim-config.packages.${system}.minimal
    ];
}
