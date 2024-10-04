{
  # 1. sudo lshw -c display
  # 2. Under 'bus info', translate the bus ID hexidecimal to decimal and format:
  #    pci@0000:0e:00.0 -> PCI:14:0:0
  #    - Do this step for both the Nvidia/AMD and integrated GPU
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    # Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    # amdgpuBusId = "PCI:54:0:0"; For AMD GPU
  };
}
