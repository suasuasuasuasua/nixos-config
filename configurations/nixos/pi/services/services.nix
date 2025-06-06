{ inputs, config, ... }:
let
  inherit (config.networking) hostName domain;
in
{
  imports = [
    # import the modules
    "${inputs.self}/modules/nixos/services"
  ];

  # services
  nixos.services = {
    acme.enable = true;
    adguardhome.enable = true;
    avahi.enable = true;
    dashy = {
      enable = true;
      settings = import ./dashy.nix {
        inherit hostName domain;
      };
    };
    glances.enable = true;
    nginx.enable = true;
  };
}
