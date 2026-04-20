# VPS Disk configuration
# Hetzner VPS requires BIOS boot, not EFI
# Use GPT with BIOS Boot Partition
{
  disko.devices = {
    disk = {
      root-disk = {
        device = "/dev/sda";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            # BIOS Boot Partition for GPT + GRUB
            bios_boot = {
              type = "EF02";
              size = "1M";
            };
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}
