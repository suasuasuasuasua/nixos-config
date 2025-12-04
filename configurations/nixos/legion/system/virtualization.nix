{ pkgs, ... }:
{
  virtualisation.podman = {
    enable = true;

    # https://wiki.nixos.org/wiki/Podman
    # Use a Docker-compatible command line (alias docker=podman)
    dockerCompat = true;

    # Required for podman-tui and other tools
    defaultNetwork.settings.dns_enabled = true;
  };

  # Rootless podman configuration
  # https://wiki.nixos.org/wiki/Podman#Rootless_Podman
  virtualisation.containers.registries.search = [ "docker.io" ];

  environment.systemPackages = with pkgs; [ podman-tui ];

  # https://wiki.nixos.org/wiki/Category:Virtualization
  # Installing a hypervisor on the host system.
  virtualisation.libvirtd.enable = true;
  # if you use libvirtd on a desktop environment
  programs.virt-manager.enable = true; # can be used to manage non-local hosts as well
  # Installing the appropriate guest utilities on a virtualised system.
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
