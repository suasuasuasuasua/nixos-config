# Top-level VPS configuration
{ inputs, ... }:
{
  imports = [
    inputs.self.nixosModules.base
    inputs.self.nixosModules.development
  ];

  environment.variables.EDITOR = "nvim";

  custom.nixos.development = {
    cli.enable = true;
    nh.enable = true;
  };
}
