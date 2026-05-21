# Custom OCI images built with Nix and pushed to Gitea's container registry.
# The push is skipped on dirty working trees — commit your changes first.
{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (config.networking) domain;
  serviceName = "gitea";

  registryTokenFile = config.sops.secrets."gitea/registry-token".path;

  runnerImage = pkgs.dockerTools.buildLayeredImage {
    name = "gitea-runner-nix";
    tag = "latest";
    contents = [
      pkgs.bash
      pkgs.cacert
      pkgs.coreutils
      pkgs.curl
      pkgs.dockerTools.fakeNss
      pkgs.git
      pkgs.gnutar
      pkgs.gzip
      pkgs.jq
      pkgs.nix
      pkgs.nodejs
      pkgs.xz
    ];
    config.Labels = {
      "org.opencontainers.image.source" = "https://${serviceName}.${domain}/sua/nixos-config";
      "org.opencontainers.image.revision" = inputs.self.shortRev or "dirty";
      "org.opencontainers.image.url" = "https://${serviceName}.${domain}/sua/nixos-config/src/commit/${
        inputs.self.shortRev or "dirty"
      }";
    };
    config.Env = [
      "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      "GIT_SSL_CAINFO=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      "NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
      "NIX_CONFIG=${''
        experimental-features = nix-command flakes
        build-users-group =
        accept-flake-config = true
        extra-substituters = https://cache.sua.dev?priority=50 https://nix-community.cachix.org
        extra-trusted-public-keys = cache.sua.dev:LAOD0dIC9Yp/IlZqv+OgJ0O3elYQAhlInOCI7x+75yE= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
      ''}"
    ];
  };
in
{
  sops.secrets."gitea/registry-token".sopsFile = "${inputs.self}/secrets/secrets.yaml";

  # Load the runner image into podman and push it to Gitea's container registry.
  # Runs before the runner starts and re-runs whenever the image derivation changes.
  systemd.services.load-gitea-runner-image = {
    description = "Load and publish gitea runner OCI image";
    wantedBy = [ "gitea-runner-default.service" ];
    after = [ "network-online.target" ];
    requires = [ "network-online.target" ];
    before = [ "gitea-runner-default.service" ];
    restartTriggers = [ runnerImage ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "load-gitea-runner-image" ''
        ${pkgs.podman}/bin/podman load -i ${runnerImage}
        ${
          if inputs.self ? shortRev then
            ''
              ${pkgs.podman}/bin/podman login ${serviceName}.${domain} --username sua --password-stdin < ${registryTokenFile}
              ${pkgs.podman}/bin/podman push gitea-runner-nix:latest ${serviceName}.${domain}/sua/nixos-config/gitea-runner-nix:latest
              ${pkgs.podman}/bin/podman push gitea-runner-nix:latest ${serviceName}.${domain}/sua/nixos-config/gitea-runner-nix:${inputs.self.shortRev}
            ''
          else
            ''
              echo "Working tree is dirty — skipping push to Gitea registry. Commit your changes first."
            ''
        }
      '';
    };
  };
}
