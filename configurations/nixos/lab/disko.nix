{
  disko.devices.disk = {
    #### ZROOT ####
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
              pool = "ztmp";
            };
          };
        };
      };
    };

    #### ZSHARE ####
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

          # Snapshot the services data dir!
          options."com.sun:auto-snapshot" = "true";
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
    # https://nixos.wiki/wiki/ZFS
    zshare = {
      type = "zpool";
      mode = "raidz1"; # allow for one drive failure
      mountpoint = null;

      # TODO: figure out these options
      #       - do we need encryption?
      #       - do we need auto-snapshots? probably?
      rootFsOptions = {
        compression = "zstd";
        canmount = "off";
        xattr = "sa";
      };

      options = {
        ashift = "12";
        autotrim = "on";
      };

      # Personal data
      datasets = {
        "personal" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/personal";
          mountpoint = "/zshare/personal";
          options.mountpoint = "legacy";
        };
        # Important documents
        "personal/docs" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/personal/docs";
          mountpoint = "/zshare/personal/docs";
          options.mountpoint = "legacy";
        };
        # Images AND video
        "personal/images" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/personal/images";
          mountpoint = "/zshare/personal/images";
          options.mountpoint = "legacy";
        };
        # Notes
        "personal/notes" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/personal/notes";
          mountpoint = "/zshare/personal/notes";
          options.mountpoint = "legacy";
        };
      };

      # Backups
      datasets = {
        # macOS time machine share
        "backup" = {
          type = "zfs_fs";
          mountpoint = null;
          options.mountpoint = "legacy";
        };
        # macOS time machine share
        "backup/tm_share" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/backup/tm_share";
          mountpoint = "/zshare/backup/tm_share";
          options.mountpoint = "legacy";
        };
      };

      # Productivity
      datasets = {
        # App data from various services -- split between hdds and sata probably
        "app" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/app";
          mountpoint = "/zshare/app";
          options.mountpoint = "legacy";
        };
        # Project space -- video projects and dev
        "projects" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/projects";
          mountpoint = "/zshare/projects";
          options.mountpoint = "legacy";
        };
        # VM data
        "projects/vm" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/projects/vm";
          mountpoint = "/zshare/projects/vm";
          options.mountpoint = "legacy";
        };
        # General served content
        "srv" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/srv";
          mountpoint = "/zshare/srv";
          options.mountpoint = "legacy";
        };
        # Git repos to serve
        "srv/git" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/srv/git";
          mountpoint = "/zshare/srv/git";
          options.mountpoint = "legacy";
        };
        # Linux ISOs
        "srv/iso" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/srv/iso";
          mountpoint = "/zshare/srv/iso";
          options.mountpoint = "legacy";
        };
      };

      # Mixed Media
      datasets = {
        "media" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/media";
          mountpoint = "/zshare/media";
          options.mountpoint = "legacy";
        };
        # Books -- audio and ebooks
        "media/books" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/media/books";
          mountpoint = "/zshare/media/books";
          options.mountpoint = "legacy";
        };
        # Recordings, images, screenshots, etc.
        "media/captures" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/media/captures";
          mountpoint = "/zshare/media/captures";
          options.mountpoint = "legacy";
        };
        # Images, etc.
        "media/captures/images" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/media/captures/images";
          mountpoint = "/zshare/media/captures/images";
          options.mountpoint = "legacy";
        };
        # Recordings, etc.
        "media/captures/recordings" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/media/captures/recordings";
          mountpoint = "/zshare/media/captures/recordings";
          options.mountpoint = "legacy";
        };
        # Screenshots, etc.
        "media/captures/screenshots" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/media/captures/screenshots";
          mountpoint = "/zshare/media/captures/screenshots";
          options.mountpoint = "legacy";
        };
        # Movies
        "media/movies" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/media/movies";
          mountpoint = "/zshare/media/movies";
          options.mountpoint = "legacy";
        };
        # Music
        "media/music" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/media/music";
          mountpoint = "/zshare/media/music";
          options.mountpoint = "legacy";
        };
        # TV Shows
        "media/shows" = {
          type = "zfs_fs";
          # options.mountpoint = "/zshare/media/shows";
          mountpoint = "/zshare/media/shows";
          options.mountpoint = "legacy";
        };
      };
    };
    # Additional *whatever* pool for whatever
    ztmp = {
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
        "tmp" = {
          type = "zfs_fs";
          mountpoint = "/ztmp/tmp";
          options.mountpoint = "legacy";
        };
      };
    };
  };
}
