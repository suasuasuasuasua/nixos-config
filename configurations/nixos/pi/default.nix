# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{ flake, pkgs, ... }:

let
  inherit (flake) inputs;
in
{
  imports = [
    # pi setup
    inputs.rpi-nix.nixosModules.sd-image
    inputs.rpi-nix.nixosModules.raspberry-pi

    # hardware
    ./hardware-configuration.nix

    # config
    ./config.nix
    ./home.nix

    # system setup
    ./system

    # services setup
    ./services
  ];

  # Need to enable zsh before we can actually use it. Home manager configs it,
  # but cannot set the login shell because that's root level operation
  programs.zsh.enable = true;

  users.users = {
    justinhoang = {
      # If you do, you can skip setting a root password by passing
      # '--no-root-passwd' to nixos-install. Be sure to change it (using passwd)
      # after rebooting!
      initialPassword = "password";
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  hardware.enableRedistributableFirmware = true;
  system.stateVersion = "24.11"; # Did you read the comment?
}
