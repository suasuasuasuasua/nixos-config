{
  disko.devices.disk = {
    #### ZROOT ####
    # nvme 0 will be one of the M.2. NVME SSDs
    nvme0 = {
      type = "disk";
      # TODO: replace
      device = "";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            size = "512M"; # 0.5GiB boot partition
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zroot";
            };
          };
        };
      };
    };

    # TODO: replace when i get one
    # #### ZSHARE ####
    # data0 = {
    #   type = "disk";
    #   # TODO: replace with the name
    #   device = "";
    #   content = {
    #     type = "gpt";
    #     partitions = {
    #       zfs = {
    #         size = "100%";
    #         content = {
    #           type = "zfs";
    #           pool = "zshare";
    #         };
    #       };
    #     };
    #   };
    # };
  };

  disko.devices.zpool = {
    # https://nixos.wiki/wiki/ZFS
    # General root
    zroot = {
      type = "zpool";
      mode = "mirror";
      mountpoint = null;

      rootFsOptions = {
        compression = "zstd";
        canmount = "off";
        xattr = "sa";
        acltype = "posixacl";

        "com.sun:auto-snapshot" = "false";
      };

      options = {
        ashift = "12";
        autotrim = "on";
      };

      datasets = {
        # See examples/zfs.nix for more comprehensive usage.
        "root" = {
          type = "zfs_fs";
          mountpoint = "/";
          options.mountpoint = "legacy";
        };
        "nix" = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options.mountpoint = "legacy";
        };
        "var" = {
          type = "zfs_fs";
          mountpoint = "/var";
          options.mountpoint = "legacy";
        };
        "home" = {
          type = "zfs_fs";
          mountpoint = "/home";
          options.mountpoint = "legacy";

          # Snapshot the user home!
          options."com.sun:auto-snapshot" = "true";
        };
      };
    };
  };
}
