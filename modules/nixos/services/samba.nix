{
  config,
  options,
  lib,
  pkgs,
  ...
}:
let
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/services/network-filesystems/samba.nix
  serviceName = "samba";

  cfg = config.nixos.services.${serviceName};
  opt = options.nixos.services.${serviceName};

  settingsFormat = pkgs.formats.ini {
    listToValue = lib.concatMapStringsSep " " (lib.generators.mkValueStringDefault { });
  };
  sambaType = lib.types.submodule {
    freeformType = settingsFormat.type;
    options = {
      global = {
        "security" = lib.mkOption {
          type = lib.types.enum [
            "auto"
            "user"
            "domain"
            "ads"
          ];
          default = "user";
          description = "Samba security type.";
        };
        "invalid users" = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "root" ];
          description = "List of users who are denied to login via Samba.";
        };
        "passwd program" = lib.mkOption {
          type = lib.types.str;
          default = "/run/wrappers/bin/passwd %u";
          description = "Path to a program that can be used to set UNIX user passwords.";
        };
      };
    };
  };

  settings = with lib; opt.settings.default // optionalAttrs (cfg.settings != { }) cfg.settings;
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Standard Windows interoperability suite of programs for Linux and Unix
    '';

    # TODO: add settings to samba as an argument
    settings = lib.mkOption {
      type = sambaType;
      default = {
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          # "use sendfile" = "yes";
          # "max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "192.168.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
      };
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
