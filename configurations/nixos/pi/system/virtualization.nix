{ pkgs, ... }:
{
  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;

      # DNS enabled for inter-container communication
      # AdGuard Home binds only to the pi's host IP to avoid conflicts
      # with aardvark-dns on the podman bridge (10.88.0.1:53)
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
