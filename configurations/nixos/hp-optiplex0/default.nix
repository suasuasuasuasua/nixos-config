{ inputs, ... }:
{
  imports = [
    inputs.disko.nixosModules.disko

    ./hardware-configuration.nix
    ./home
    ./system
    ./services

    ./config.nix
    ./disko.nix
    ./sops.nix
    ./stylix.nix
  ];

  system.stateVersion = "25.11";
}
