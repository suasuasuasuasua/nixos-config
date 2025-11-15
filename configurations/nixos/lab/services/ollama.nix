# https://wiki.nixos.org/wiki/Ollama
let
  acceleration = null;
  port = 11434;
in
{
  services.ollama = {
    inherit port acceleration;

    enable = true;

    host = "127.0.0.1";
  };
}
