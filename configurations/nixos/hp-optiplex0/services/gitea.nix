# gitea is a self hosted git repository
{
  config,
  infra,
  inputs,
  ...
}:
let
  inherit (config.networking) hostName domain;
  serviceName = "gitea";

  tokenFile = config.sops.secrets."gitea/token".path;
in
{
  sops.secrets = {
    "gitea/token" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
  };

  services.gitea-actions-runner.instances = {
    default = {
      inherit tokenFile;

      url = "https://${serviceName}.${domain}";
      name = hostName;
      enable = true;
      labels = [
        # provide a debian base with nodejs for actions
        "debian-latest:docker://node:24-trixie"
        # fake the ubuntu name, because node provides no ubuntu builds
        "ubuntu-latest:docker://node:24-trixie"
        # ephemeral nix container for nix/nixos workflows (pulled from local registry)
        "nix:docker://${infra.lab.wg1IP}:${toString infra.ports.dockerRegistry}/gitea-runner-nix:latest"
      ];
      settings = {
        runner.capacity = 4;
      };
    };
  };

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
    # Lab's registry is HTTP-only (no TLS) — reachable only over the WireGuard tunnel
    registries.insecure = [ "${infra.lab.wg1IP}:${toString infra.ports.dockerRegistry}" ];

    # Configure DNS servers for containers
    containersConf.settings = {
      network = {
        dns_servers = [
          "1.1.1.1" # cloudflare
          "8.8.8.8" # google
        ];
      };
    };
  };
}
