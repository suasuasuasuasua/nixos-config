{
  nix.settings = {
    experimental-features = "nix-command flakes";
    substituters = [ "https://cache.sua.dev" ];
    trusted-public-keys = [ "cache.sua.dev:LAOD0dIC9Yp/IlZqv+OgJ0O3elYQAhlInOCI7x+75yE=" ];
  };
}
