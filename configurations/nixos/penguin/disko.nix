{
  # If you see this...
  # status: Mismatch between pool hostid and system hostid on imported pool.
  #       This pool was previously imported into a system with a different hostid,
  #       and then was verbatim imported into this system.
  #
  # zpool set multihost=on zroot
  # zpool set multihost=off zroot
  #
  # I'm guessing it's because we set this up as the root user in the ISO image,
  # but we're using it now as the user

  disko.devices = {
    disk = {
      # Only 1 PCIE Gen 4 NVME SSD on this device (256GB for now...)
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-HFM256GD3JX016N_CY11N099310901V5O";
        content = {
          type = "gpt";
          partitions = {
            # TODO: something is 1 million percent wrong with the boot drive...
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
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };

    # https://nixos.wiki/wiki/ZFS
    zpool = {
      # Pool name is `zroot`
      zroot = {
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

            # Snapshot the user home!
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
    };
  };
}
