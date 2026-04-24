{ pkgs, infra, ... }:
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
  };

  # Rootless podman configuration
  # https://wiki.nixos.org/wiki/Podman#Rootless_Podman
  virtualisation.containers = {
    registries.search = [
      "docker.io"
      "podman.io"
      "quay.io"
    ];
    # Local registry is HTTP-only
    registries.insecure = [ "localhost:5002" ];

    # Configure DNS servers for containers
    containersConf.settings = {
      network = {
        dns_servers = [
          infra.pi.lanIp # local dns
          "1.1.1.1" # cloudflare
          "8.8.8.8" # google
        ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    lazydocker
    podman-tui
  ];
}
