{
  config,
  options,
  lib,
  ...
}:
let
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/services/network-filesystems/samba.nix
  serviceName = "samba";

  cfg = config.nixos.services.${serviceName};
  defaultOpts = options.services.${serviceName};
  opts = options.nixos.services.${serviceName};

  settings =
    with lib;
    lib.mergeAttrsList [
      defaultOpts.settings.default # default options from samba module
      opts.settings.default # my default options from samba module
      (optionalAttrs (cfg.settings != { }) cfg.settings) # any additional
    ];
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Standard Windows interoperability suite of programs for Linux and Unix
    '';

    settings = lib.mkOption {
      inherit (defaultOpts.settings) type;
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      samba = {
        inherit settings;

        enable = true;
        openFirewall = true;
      };

      samba-wsdd = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
