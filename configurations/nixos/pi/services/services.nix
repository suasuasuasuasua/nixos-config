{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [
    # import the modules
    (self + /modules/nixos/services)
  ];

  # services
  config.nixos.services = {
    adguardhome.enable = true;
    dashy.enable = true;
    nginx.enable = true;
  };
}
