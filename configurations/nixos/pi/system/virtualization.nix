{ pkgs, ... }:
{
  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;

      # DNS disabled because:
      # 1. The only container (isponsorblocktv) uses --network=host
      # 2. AdGuard Home binds to 0.0.0.0:53, conflicting with aardvark-dns
      # 3. AdGuard Home already provides DNS for the host
      defaultNetwork.settings.dns_enabled = false;
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
