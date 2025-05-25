{ inputs, ... }:
{
  imports = [ "${inputs.self}/modules/nixos/services" ];

  # services
  nixos.services = {
    avahi.enable = true;
    syncthing = {
      enable = true;
      # TODO: kind of hardcoded but only way I could figure out how to
      # synchronize the home directory
      dataDir = "/home/justinhoang";
      group = "users";
      user = "justinhoang";

      settings = import ./syncthing.nix;
    };
  };
}
