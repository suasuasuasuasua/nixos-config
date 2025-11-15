let
  # default = 8080
  port = 8080;
in
{
  services.open-webui = {
    # Enable the web interface
    inherit port;

    enable = true;
    host = "127.0.0.1";
  };
}
