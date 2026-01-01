# navidrome is a self hosted music server
{ config, inputs, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "navidrome";

  # default = 4533
  Port = 4533;
  MusicFolder = "/zshare/media/music";
  environmentFile = config.sops.secrets."navidrome/environment".path;
in
{
  services.navidrome = {
    inherit environmentFile;
    enable = true;

    settings = {
      inherit Port MusicFolder;

      Address = "127.0.0.1";
      EnableInsightsCollector = false;
    };
  };

  users.users.navidrome.extraGroups = [ "samba" ];

  sops.secrets = {
    "navidrome/environment" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
  };

  services.nginx.virtualHosts = {
    "${serviceName}.${domain}" = {
      enableACME = true;
      forceSSL = true;
      acmeRoot = null;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString Port}";
      };

      serverAliases = [ "${serviceName}.${hostName}.${domain}" ];
    };
  };
}
