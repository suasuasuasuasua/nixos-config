{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko

    ./hardware-configuration.nix
    ./system
    ./services

    ./config.nix
    ./disko.nix
    ./sops.nix
  ];

  system.stateVersion = "25.11";
}
