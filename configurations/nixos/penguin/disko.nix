{
  disko.devices = {
    disk = {
      # Only 1 PCIE Gen 4 NVME SSD on this device (256GB for now...)
      main = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-HFM256GD3JX016N_CY11N099310901V5O";
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
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            swap = {
              size = "16G"; # Use 16GB of swap for 8GB memory machine
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true; # resume from hiberation from this device
              };
            };
          };
        };
      };
    };
  };
}
