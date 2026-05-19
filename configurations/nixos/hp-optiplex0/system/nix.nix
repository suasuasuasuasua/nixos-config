{
  # fallback for packages that cannot cross-compile (e.g. CGO-heavy Go packages)
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nix = {
    nrBuildUsers = 64;
    settings = {
      min-free = 10 * 1024 * 1024;
      max-free = 200 * 1024 * 1024;
      cores = 0;

      extra-platforms = [ "aarch64-linux" ];
    };
  };

  # https://nix.dev/tutorials/nixos/distributed-builds-setup.html
  systemd.services.nix-daemon.serviceConfig = {
    MemoryAccounting = true;
    MemoryMax = "90%";
    OOMScoreAdjust = 500;
  };
}
