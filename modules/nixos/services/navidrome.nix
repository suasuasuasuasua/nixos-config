{ config, ... }:
let
  # Use the hostname of the machine!
  #   previously was hardcoding *lab* but this should work for any machine
  hostName = config.networking.hostName;
  serviceName = "navidrome";
  port = 4533;
in
{
  services.navidrome = {
    enable = true;
    openFirewall = true;

    settings = {
      Port = port;
      Address = "127.0.0.1";
      EnableInsightsCollector = false;

      MusicFolder = "/zshare/media/music";
    };
  };

  services.nginx.virtualHosts = {
    # Media
    "${serviceName}.${hostName}.home" = {
      locations."/" = {
        # Music Streaming
        proxyPass = "http://localhost:${toString port}";
      };
    };
  };
}
