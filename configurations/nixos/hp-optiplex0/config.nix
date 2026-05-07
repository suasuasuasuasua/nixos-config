{ inputs, pkgs, ... }:
{
  imports = [
    "${inputs.self}/modules/nixos"
    "${inputs.self}/modules/nixos/development"
  ];

  environment.variables.EDITOR = "nvim";

  environment.systemPackages = [
    pkgs.direnv
    pkgs.fzf
    pkgs.git
    pkgs.neovim
    pkgs.tmux
  ];

  custom.nixos.development = {
    cli.enable = true;
    nh.enable = true;
  };
}
