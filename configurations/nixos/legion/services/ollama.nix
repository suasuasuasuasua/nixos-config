let
  acceleration = "cuda";
  port = 11434;
in
{
  services.ollama = {
    inherit port acceleration;

    enable = true;

    host = "127.0.0.1";
  };
}
