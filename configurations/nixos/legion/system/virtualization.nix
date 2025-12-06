{ pkgs, ... }:
{
  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;

      autoPrune.enable = true;

      # Required for podman-tui and other tools
      defaultNetwork.settings.dns_enabled = true;

      # Create an alias mapping docker -> podman
      dockerCompat = true;
      # Enable podman/kdocker socket
      dockerSocket.enable = true;
    };

    # Rootless podman configuration
    # https://wiki.nixos.org/wiki/Podman#Rootless_Podman
    containers = {
      registries.search = [ "docker.io" ];

      # Configure DNS servers for containers
      containersConf.settings = {
        network = {
          dns_servers = [
            "192.168.0.250" # local dns
            "1.1.1.1" # cloudflare
            "8.8.8.8" # google
          ];
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    lazydocker
    podman-tui
  ];

  # https://wiki.nixos.org/wiki/Category:Virtualization
  # Installing a hypervisor on the host system.
  virtualisation.libvirtd.enable = true;
  # if you use libvirtd on a desktop environment
  programs.virt-manager.enable = true; # can be used to manage non-local hosts as well
  # Installing the appropriate guest utilities on a virtualised system.
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
