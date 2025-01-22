{
  imports = [
    # Define the disko scheme for the root system
    ./zroot.nix

    # Define the disko scheme for the shared network disks
    ./zshare.nix
  ];
}
