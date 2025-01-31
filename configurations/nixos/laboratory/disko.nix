{
  #### ZROOT ####
  disko.devices.disk = {
    # nvme 0 will be one of the M.2. NVME SSDs
    nvme0 = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_2TB_245268800136";
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

    # nvme 1 will be one of the M.2. NVME SSDs
    nvme1 = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-WD_BLACK_SN770_2TB_245268801871";
      content = {
        type = "gpt";
        partitions = {
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

    # main will be a *large* 2.5in SATA SSD
    sata0 = {
      type = "disk";
      device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_500GB_S4XANE0M746762J";
      content = {
        type = "gpt";
        partitions = {
          # Format the rest of the disk for root
          store = {
            size = "100%"; # Use everything *except* for the end
            content = {
              type = "zfs";
              pool = "zstore";
            };
          };
        };
      };
    };

  };

  disko.devices.zpool = {
    # https://nixos.wiki/wiki/ZFS
    # General root
    zroot = {
      type = "zpool";
      mode = "mirror";
      mountpoint = "/";

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

    # Nix Store
    zstore = {
      type = "zpool";

      rootFsOptions = {
        compression = "zstd";
        canmount = "off";
        xattr = "sa";
      };

      options = {
        ashift = "12";
        autotrim = "on";
      };

      datasets = {
        # See examples/zfs.nix for more comprehensive usage.
        "nix" = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options.mountpoint = "legacy";
        };
      };
    };
  };

  #### ZSHARE ####
  disko.devices.disk = {
    data0 = {
      type = "disk";
      device = "/dev/disk/by-id/ata-ST4000VN006-3CW104_ZW62YABN";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zshare";
            };
          };
        };
      };
    };
    data1 = {
      type = "disk";
      device = "/dev/disk/by-id/ata-ST4000VN006-3CW104_ZW62YARM";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zshare";
            };
          };
        };
      };
    };
    data2 = {
      type = "disk";
      device = "/dev/disk/by-id/ata-ST4000VN006-3CW104_ZW62YBMB";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = "zshare";
            };
          };
        };
      };
    };
  };

  disko.devices.zpool = {
    # https://nixos.wiki/wiki/ZFS
    zshare = {
      type = "zpool";
      mode = "raidz1"; # allow for one drive failure

      # TODO: figure out these options
      #       - do we need encryption?
      #       - do we need auto-snapshots? probably?
      rootFsOptions = {
        compression = "zstd";
        canmount = "on";
        xattr = "sa";
      };

      options = {
        ashift = "12";
        autotrim = "on";
      };

      datasets = {
        # Personal data like docs, notes, etc.
        "personal" = {
          type = "zfs_fs";
          options.mountpoint = "/zshare/personal";
          # mountpoint = "/zshare/personal";
          # options.mountpoint = "legacy";
        };
        # Videos, movies, etc.
        "media" = {
          type = "zfs_fs";
          options.mountpoint = "/zshare/media";
          # mountpoint = "/zshare/media";
          # options.mountpoint = "legacy";
        };
        # Project space -- video projects
        "projects" = {
          type = "zfs_fs";
          options.mountpoint = "/zshare/projects";
          # mountpoint = "/zshare/projects";
          # options.mountpoint = "legacy";
        };
        # Recordings, images, screenshots, etc.
        "captures" = {
          type = "zfs_fs";
          options.mountpoint = "/zshare/captures";
          # mountpoint = "/zshare/captures";
          # options.mountpoint = "legacy";
        };
        # Development files space -- isos and the like
        "dev" = {
          type = "zfs_fs";
          options.mountpoint = "/zshare/dev";
          # mountpoint = "/zshare/dev";
          # options.mountpoint = "legacy";
        };
        # macOS time machine share
        "tm_share" = {
          type = "zfs_fs";
          options.mountpoint = "/zshare/tm_share";
          # mountpoint = "/zshare/tm_share";
          # options.mountpoint = "legacy";
        };
      };
    };
  };
}
