# See /modules/nixos/* for actual settings
# This file is just *top-level* configuration.
{
  inputs,
  pkgs,
  lib,
  userConfigs,
  ...
}:
{
  imports = [
    # disk setup
    inputs.disko.nixosModules.disko
    ./disko.nix

    # hardware setup
    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-hidpi
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    ./hardware-configuration.nix

    # config
    ./config.nix
    ./home.nix

    # system setup
    ./system
  ];

  nixpkgs = {
    config = {
      # enable builds with cuda support!
      cudaSupport = true;
    };
  };

  # Need to enable zsh before we can actually use it. Home manager configs it,
  # but cannot set the login shell because that's root level operation
  programs.zsh.enable = true;

  users.users =
    let
      helper =
        acc:
        { username, initialHashedPassword, ... }:
        {
          ${username} = {
            # If you do, you can skip setting a root password by passing
            # '--no-root-passwd' to nixos-install. Be sure to change it (using
            # passwd) after rebooting!
            inherit initialHashedPassword;

            isNormalUser = true;
            extraGroups = [
              "wheel"
              "docker"
              "libvirtd"
            ];
            shell = pkgs.zsh;
          };
        }
        // acc;
    in
    builtins.foldl' helper { } userConfigs;

  nixpkgs.overlays = [
    # https://github.com/NixOS/nixpkgs/issues/388681
    # TODO:remove when fixed for legion build (open-webui is broken i think)
    (_: prev: {
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (_: python-prev: {
          onnxruntime = python-prev.onnxruntime.overridePythonAttrs (oldAttrs: {
            buildInputs = lib.lists.remove pkgs.onnxruntime oldAttrs.buildInputs;
          });
        })
      ];
    })
  ];

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
  system.stateVersion = "24.11"; # Did you read the comment?

}
