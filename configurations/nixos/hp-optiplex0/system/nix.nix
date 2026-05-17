{
  # fallback for packages that cannot cross-compile (e.g. CGO-heavy Go packages)
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  nix = {
    nrBuildUsers = 64;
    settings = {
      trusted-users = [ "@users" ]; # allow for remote builds
      min-free = 10 * 1024 * 1024;
      max-free = 200 * 1024 * 1024;
      max-jobs = "auto";
      cores = 0;

      extra-platforms = [ "aarch64-linux" ];

      experimental-features = "nix-command flakes";
      substituters = [ "https://cache.sua.dev" ];
      trusted-public-keys = [ "cache.sua.dev:LAOD0dIC9Yp/IlZqv+OgJ0O3elYQAhlInOCI7x+75yE=" ];
    };
  };

  # https://nix.dev/tutorials/nixos/distributed-builds-setup.html
  systemd.services.nix-daemon.serviceConfig = {
    MemoryAccounting = true;
    MemoryMax = "90%";
    OOMScoreAdjust = 500;
  };
}
