{
  flake,
  config,
  ...
}:
let
  inherit (flake) inputs;

  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  serviceName = "actual";
  port = 3001;
in
{
  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/web-apps/actual.nix"
  ];

  # TODO: need to setup HTTPS to continue using...
  services.actual = {
    enable = true;
    package = flake.inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.actual-server;
    # flake.inputs.nixpkgs-unstable.legacyPackages.${system}.actual-server;
    openFirewall = true;
    settings = {
      # default port is 3000
      port = port;
    };
  };
  services.nginx.virtualHosts = {
    "${serviceName}.${hostName}.home" = {
      locations."/" = {
        # Actual finance planner
        proxyPass = "http://localhost:${toString port}";
      };
    };
  };
}
