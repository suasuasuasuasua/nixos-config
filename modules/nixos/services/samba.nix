{
  config,
  lib,
  ...
}:
let
  serviceName = "samba";

  cfg = config.nixos.services.${serviceName};
in
{
  options.nixos.services.${serviceName} = {
    enable = lib.mkEnableOption ''
      Standard Windows interoperability suite of programs for Linux and Unix
    '';

    # TODO: add settings to samba as an argument
  };

  config = lib.mkIf cfg.enable {
    services = {

      samba = {
        enable = true;
        openFirewall = true;
      };

      samba-wsdd = {
        enable = true;
        openFirewall = true;
      };

      samba.settings = {
        # Global
        global = {
          "workgroup" = "WORKGROUP";
          "server string" = "smbnix";
          "netbios name" = "smbnix";
          "security" = "user";
          #"use sendfile" = "yes";
          #"max protocol" = "smb2";
          # note: localhost is the ipv6 localhost ::1
          "hosts allow" = "192.168.0. 127.0.0.1 localhost";
          "hosts deny" = "0.0.0.0/0";
          "guest account" = "nobody";
          "map to guest" = "bad user";
        };
      };

      # Personal
      samba.settings = {
        # Music videos and audio!
        "personal" = {
          "path" = "/zshare/personal";
          "browseable" = "yes";
          "valid users" = "justinhoang";
          "public" = "no";
          "read only" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          # remember to create the samba group and add recursive permissions!
          "force group" = "samba";
        };
      };

      # Backups
      samba.settings = {
        "tm_share" = {
          "path" = "/zshare/backup/tm_share";
          "valid users" = "justinhoang";
          "public" = "no";
          "writeable" = "yes";
          "force group" = "samba";
          "fruit:aapl" = "yes";
          "fruit:time machine" = "yes";
          "vfs objects" = "catia fruit streams_xattr";
        };
      };

      # Productivity
      samba.settings = {
        # Projects
        "projects" = {
          "path" = "/zshare/projects";
          "valid users" = "justinhoang";
          "browseable" = "yes";
          "public" = "no";
          "read only" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          # remember to create the samba group and add recursive permissions!
          "force group" = "samba";
        };
        # Served content
        "srv" = {
          "path" = "/zshare/srv";
          "valid users" = "justinhoang";
          "browseable" = "yes";
          "public" = "no";
          "read only" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          # remember to create the samba group and add recursive permissions!
          "force group" = "samba";
        };
      };

      # Media!
      samba.settings = {
        # Music videos and audio!
        "media" = {
          "path" = "/zshare/media";
          "valid users" = "justinhoang";
          "browseable" = "yes";
          "public" = "no";
          "read only" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          # remember to create the samba group and add recursive permissions!
          "force group" = "samba";
        };
      };

      # Temp!
      samba.settings = {
        # Music videos and audio!
        "tmp" = {
          "path" = "/ztmp/tmp";
          "valid users" = "justinhoang";
          "browseable" = "yes";
          "public" = "no";
          "read only" = "no";
          "create mask" = "0644";
          "directory mask" = "0755";
          # remember to create the samba group and add recursive permissions!
          "force group" = "samba";
        };
      };
    };
  };
}
