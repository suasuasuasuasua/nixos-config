{ inputs, pkgs, ... }:
{
  environment.systemPackages =
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    [
      inputs.nvim-config.packages.${system}.nvim
      pkgs.btop
      pkgs.git
      pkgs.tmux
    ];
}
