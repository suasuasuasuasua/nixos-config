let poolname = "zroot";
in
{
  disko.devices.disk = {
    # Current plan is to:
    # 1. create a first pool for zfs on root -- i've done before on penguin so
    # this *should* be easy
    #    - use a 2.5 inch SATA SSD for boot drive and 2 mirrored NVME SSDs
    #      - i have a 512GB SATA SSD and a 256 NVME Gen 3 SSD laying
    #      around but i could upgrade the SATA SSD to 2TB or 4TB and the
    #      NVME SSDs to 1TB or 2TB *thinking*
    #    - my computer case (the Jonsbo N2) can store up to 5 3.5in HDDs
    #      and 1 2.5in SSD. That 1 2.5in SSD might as well be the drive
    #      holding the less critical or huge files (nix store *cough*)
    #      - /nix, /home
    #    - the other two mirrored SSDs can hold the more *critical* data in
    #    the context of home-labbing
    #      - /, /var
    #
    # 2. create a second pool for the data share -- this could be more tricky
    # to figure out the topology, but it does seem like the example on disko
    # about "zfs with vdevs" is straight forward

    # main will be a *large* 2.5in SATA SSD
    main = {
      type = "disk";
      # TODO: fill in the correct ID
      device = "/dev/disk/by-id/...";
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
          # Format the rest of the disk for root
          zfs = {
            size = "100%"; # Use everything *except* for the end
            content = {
              type = "zfs";
              pool = poolname;
            };
          };
        };
      };
    };

    # nvme 1 will be one of the M.2. NVME SSDs
    nvme1 = {
      type = "disk";
      # TODO: fill in the correct ID
      device = "/dev/disk/by-id/...";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = poolname;
            };
          };
        };
      };
    };
    # nvme 2 will be one of the M.2. NVME SSDs
    nvme2 = {
      type = "disk";
      # TODO: fill in the correct ID
      device = "/dev/disk/by-id/...";
      content = {
        type = "gpt";
        partitions = {
          zfs = {
            size = "100%";
            content = {
              type = "zfs";
              pool = poolname;
            };
          };
        };
      };
    };
  };

  disko.devices.zpool = {
    # https://nixos.wiki/wiki/ZFS
    ${poolname} = {
      type = "zpool";

      rootFsOptions = {
        encryption = "aes-256-gcm";
        keyformat = "passphrase";
        keylocation = "prompt";

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
