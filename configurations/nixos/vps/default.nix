# VPS configuration - acts as WireGuard server and nginx reverse proxy to home lab
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

  # Disko only runs during initial deployment, not at runtime
  disko.enableNew = false;

  system.stateVersion = "25.11";
}
