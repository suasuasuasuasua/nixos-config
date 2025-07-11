# https://wiki.nixos.org/wiki/Ollama
{
  pkgs,
  ...
}:
let
  acceleration = null;
  port = 11434;
in
{
  services.ollama = {
    inherit port acceleration;

    enable = true;
    package = pkgs.unstable.ollama;

    host = "127.0.0.1";
  };
}
