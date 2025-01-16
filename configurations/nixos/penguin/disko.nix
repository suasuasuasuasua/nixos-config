{ flake, ... }:
let
  inherit (flake) inputs;
in
{
  imports = [
    inputs.disko.nixosModules.disko
  ];

  disko.devices = {
    disk = {
      # Only 1 PCIE Gen 4 NVME SSD on this device (256GB for now...)
      disk1 = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-HFM256GD3JX016N_CY11N099310901V5O_1";
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
            # # Swap partition
            # plainSwap = {
            #   size = "8192M"; # 8.0GiB swap partition
            #   content = {
            #     type = "swap";
            #     discardPolicy = "both";
            #     resumeDevice = true; # resume from hiberation from this device
            #   };
            # };
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
        # TODO: do i need to define the topology here? or just leave empty?
        # According to (https://github.com/nix-community/disko/blob/master/lib/types/zpool.nix),
        # I can leave this empty?
        mode = "";

        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
        };
        # TODO: do i need to mount the pool itself?
        mountpoint = "/";
        postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot@blank$' || zfs snapshot zroot@blank";

        datasets = {
          # See examples/zfs.nix for more comprehensive usage.
          "root" = {
            # TODO: there are two types: zfs_fs (file system) and zfs_volume (block device)
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
