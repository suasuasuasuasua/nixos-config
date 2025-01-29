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
              type = "filesystem";
              format = "ext4";
              mountpoint = "/nix";
            };
          };
        };
      };
    };

  };

  disko.devices.zpool = {
    # https://nixos.wiki/wiki/ZFS
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

  boot.zfs.extraPools = [ "zshare" ];
  disko.devices.zpool = {
    # https://nixos.wiki/wiki/ZFS
    zshare = {
      type = "zpool";
      mode = "raidz1"; # allow for one drive failure
      mountpoint = "/zshare";

      # TODO: figure out these options
      #       - do we need encryption?
      #       - do we need auto-snapshots? probably?
      rootFsOptions = {
        compression = "zstd";
        canmount = "on";
        xattr = "sa";
        acltype = "posixacl";

        "com.sun:auto-snapshot" = "false";
      };

      options = {
        ashift = "12";
        autotrim = "on";
      };

      # TODO: figure out which datasets i want (in order of priority?)
      #       1. apple time machine (seen on wiki)
      #          - can i set a quota on this here? or only through macOS time
      #          machine?
      #       2. general data bucket for *captures* (public?)
      #          - screenshots, screen recordings, files
      #          - raw recordings
      #          - games, vlogs, demos
      #          - nextcloud would be interesting here
      #       3. project space (private?)
      #          - place to assemble the videos and whatnot
      #          - have a safe space for the intermediate and final product
      #       4. vms or services
      datasets = {
        "media" = {
          type = "zfs_fs";
          mountpoint = "/zshare/media";
          options.mountpoint = "legacy";
        };
      };
    };
  };
}
