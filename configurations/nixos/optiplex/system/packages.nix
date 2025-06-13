{ inputs, pkgs, ... }:
{
  environment.systemPackages =
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    with pkgs;
    [
      # add basic nixvim config
      inputs.nixvim-config.packages.${system}.minimal
      btop
      git
      tmux
    ];
}
