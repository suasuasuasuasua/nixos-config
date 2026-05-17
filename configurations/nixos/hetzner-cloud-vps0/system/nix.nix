{ infra, ... }:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [ "http://${infra.lab.wg1IP}:${toString infra.ports.harmonia}" ];
    trusted-public-keys = [ "cache.sua.dev:LAOD0dIC9Yp/IlZqv+OgJ0O3elYQAhlInOCI7x+75yE=" ];
  };
}
