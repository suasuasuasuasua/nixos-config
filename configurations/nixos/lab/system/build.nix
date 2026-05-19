{ config, infra, ... }:
{
  # nix-daemon will defer to other processes so CPU is not overwhelmed
  systemd.services.nix-daemon.serviceConfig = {
    CPUWeight = 20;
    IOWeight = 20;
  };
  # allow for cross platform builds
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nix = {
    distributedBuilds = true;
    settings.builders-use-substitutes = true;
    settings.secret-key-files = [ config.sops.secrets."harmonia/signing-key".path ];
    buildMachines = [
      {
        hostName = infra.hp-optiplex0.lanIP;
        systems = [
          "x86_64-linux"
          "aarch64-linux"
        ];
        protocol = "ssh-ng";
        sshUser = "admin";
        sshKey = "/root/.ssh/id_ed25519";
        maxJobs = 4;
        supportedFeatures = [
          "benchmark"
          "kvm"
          "nixos-test"
        ];
      }
    ];
  };
}
