{ infra, ... }:
{
  # allow for cross platform builds
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nix = {
    distributedBuilds = true;
    settings.builders-use-substitutes = true;
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
          "big-parallel"
          "kvm"
          "nixos-test"
        ];
      }
    ];
  };
}
