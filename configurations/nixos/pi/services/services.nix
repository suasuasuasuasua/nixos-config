{ inputs, ... }:
{
  imports = [
    # import the modules
    "${inputs.self}/modules/nixos/services"
  ];

  # services
  config.nixos.services = {
    adguardhome.enable = true;
    dashy.enable = true;
    nginx.enable = true;
  };
}
