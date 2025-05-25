{ inputs, ... }:
{
  imports = [ "${inputs.self}/modules/nixos/services" ];

  nixos.services = {
    avahi.enable = true;
  };
}
