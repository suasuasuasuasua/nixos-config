{ inputs, ... }:
{
  imports = [ "${inputs.self}/modules/nixos/services" ];

  # services
  config.nixos.services = {
    syncthing = {
      enable = true;
      settings = import ./syncthing.nix;
    };
  };
}
