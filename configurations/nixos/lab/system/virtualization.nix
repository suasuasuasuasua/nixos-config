{ pkgs, ... }:
{
  virtualisation.oci-containers.backend = "podman";

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
}
