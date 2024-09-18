{
  imports = [
    ## General System Configuration
    ./audio.nix
    ./boot.nix
    ./locale.nix
    ./networking.nix
    ./printing.nix
    ./productivity.nix
    ./users.nix
    ./virtualization.nix

    ## System Packages
    ./packages.nix
  ];
}
