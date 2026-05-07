{ self, pkgs, ... }:
let
  inherit (pkgs.stdenv.hostPlatform) system;
in
pkgs.mkShellNoCC {
  # enable the shell hooks
  inherit (self.checks.${system}.git-hooks-check) shellHook;

  # define the programs available when running `nix develop`
  # add the packages from the git-hooks list too
  buildInputs = self.checks.${system}.git-hooks-check.enabledPackages;
  packages = [
    pkgs.caligula
    pkgs.commitizen
    pkgs.fastfetch
    pkgs.git
    pkgs.home-manager
    pkgs.just
    pkgs.markdownlint-cli
    pkgs.marksman
    pkgs.nh
    pkgs.nil
    pkgs.nix-output-monitor
    pkgs.nixd
    pkgs.nixfmt
    pkgs.nvd
    pkgs.opentofu
    pkgs.sops
    pkgs.tokei
    pkgs.vim-startuptime
  ];
}
