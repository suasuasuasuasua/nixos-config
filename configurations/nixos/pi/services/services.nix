{ flake, ... }:

let
  inherit (flake) inputs;
  inherit (inputs) self;
in
{
  imports = [ self.nixosModules.default ];

  # services
  config.nixos.services = {
    adguard.enable = true;
    dashy.enable = true;
    nginx.enable = true;
  };
}
