{ pkgs, ... }:
{
  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;

      # Required for podman-tui and other tools
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Rootless podman configuration
  # https://wiki.nixos.org/wiki/Podman#Rootless_Podman
  virtualisation.containers = {
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

  environment.systemPackages = with pkgs; [ podman-tui ];
}
