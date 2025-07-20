{ pkgs, ... }:
let
  # default = 8080
  port = 8080;
in
{
  services.open-webui = {
    # Enable the web interface
    inherit port;

    # TODO: remove a patched version when stable hits
    #   https://github.com/NixOS/nixpkgs/pull/425382
    package = pkgs.nixpkgs-open-webui.open-webui;

    enable = true;
    host = "127.0.0.1";
  };
}
