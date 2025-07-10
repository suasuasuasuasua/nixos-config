# navidrome is a self hosted music server
{ inputs, config, ... }:
let
  inherit (config.networking) hostName domain;
  serviceName = "navidrome";

  # default = 4533
  Port = 4533;
  MusicFolder = "/zshare/media/music";
  environmentFile = config.sops.secrets."navidrome/environment".path;
in
{
  users.users.navidrome.extraGroups = [ "samba" ];

  sops.secrets = {
    "navidrome/environment" = {
      sopsFile = "${inputs.self}/secrets/secrets.yaml";
    };
  };

  services.navidrome = {
    inherit environmentFile;
    enable = true;

    settings = {
      inherit Port MusicFolder;

      Address = "127.0.0.1";
      EnableInsightsCollector = false;
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
