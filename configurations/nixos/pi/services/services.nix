{ inputs, config, ... }:
let
  inherit (config.networking) hostName;
in
{
  imports = [
    # import the modules
    "${inputs.self}/modules/nixos/services"
  ];

  # services
  config.nixos.services = {
    adguardhome.enable = true;
    dashy = {
      enable = true;
      settings = import ./dashy.nix {
        inherit hostName;
      };
    };
    nginx.enable = true;
  };
}
