let poolname = "zshare";
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
    data1 = {
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
    data2 = {
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
    data3 = {
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

      # TODO: figure out these options
      #       - do we need encryption?
      #       - do we need auto-snapshots? probably?
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
      datasets = { };
    };
  };
}
