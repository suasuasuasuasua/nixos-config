{ pkgs, ... }:
let
  # default = 8080
  port = 8082;
in
{
  services.open-webui = {
    # Enable the web interface
    inherit port;

    package = pkgs.unstable.open-webui;

    enable = true;
    host = "127.0.0.1";
  };
}
