# https://wiki.nixos.org/wiki/Ollama
{ infra, ... }:
let
  acceleration = null;
in
{
  services.ollama = {
    inherit acceleration;

    enable = true;

    host = "127.0.0.1";
    port = infra.ports.ollama;
  };
}
