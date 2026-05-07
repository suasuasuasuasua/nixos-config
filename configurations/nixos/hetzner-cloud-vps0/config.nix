# Top-level VPS configuration
{ inputs, ... }:
{
  imports = [
    "${inputs.self}/modules/nixos"
    "${inputs.self}/modules/nixos/development"
  ];

  environment.variables.EDITOR = "nvim";

  custom.nixos.development = {
    cli.enable = true;
    nh.enable = true;
  };
}
